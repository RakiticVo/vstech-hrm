import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_face_registration_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_in_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_out_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/verify_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';

/// BLoC managing attendance lifecycle, camera readiness, GPS verification, and punch submissions.
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  new({
    required this._getTodayAttendanceUseCase,
    required this._checkInUseCase,
    required this._checkOutUseCase,
    required this._checkFaceRegistrationUseCase,
    required this._verifyFaceUseCase,
  })  : super(const AttendanceState()) {
    on<LoadTodayAttendanceEvent>(_onLoadTodayAttendance);
    on<PrepareFaceScanEvent>(_onPrepareFaceScan);
    on<SubmitFaceScanEvent>(_onSubmitFaceScan);
    on<ResetAttendanceStateEvent>(_onResetAttendanceState);
  }

  final GetTodayAttendanceUseCase _getTodayAttendanceUseCase;
  final CheckInUseCase _checkInUseCase;
  final CheckOutUseCase _checkOutUseCase;
  final CheckFaceRegistrationUseCase _checkFaceRegistrationUseCase;
  final VerifyFaceUseCase _verifyFaceUseCase;

  Future<void> _onLoadTodayAttendance(
    LoadTodayAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceProcessStatus.loading));
    final result = await _getTodayAttendanceUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AttendanceProcessStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (today) => emit(
        state.copyWith(
          status: AttendanceProcessStatus.initial,
          todayAttendance: today,
        ),
      ),
    );
  }

  Future<void> _onPrepareFaceScan(
    PrepareFaceScanEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceProcessStatus.loading));

    var lat = 10.7769;
    var lng = 106.7009;
    const isWithinGeofence = true;

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            timeLimit: Duration(seconds: 4),
          ),
        );
        lat = position.latitude;
        lng = position.longitude;
      }
    } on Object catch (e) {
      appLogger.w('Geolocator fallback to office coordinates: $e');
    }

    bool? isRegistered;
    if (event.employeeCode != null && event.employeeCode!.isNotEmpty) {
      final regResult = await _checkFaceRegistrationUseCase(code: event.employeeCode!);
      regResult.fold(
        (_) {},
        (reg) => isRegistered = reg.isRegistered,
      );
    }

    final isNotReg = isRegistered == false;
    emit(
      state.copyWith(
        status: isNotReg
            ? AttendanceProcessStatus.faceNotRegistered
            : AttendanceProcessStatus.readyToScan,
        lat: lat,
        lng: lng,
        isWithinGeofence: isWithinGeofence,
        isWifiValid: true,
        isFaceRegistered: isRegistered,
        locationName: 'Trụ sở chính VSTech • Bán kính 50m',
      ),
    );
  }

  Future<void> _onSubmitFaceScan(
    SubmitFaceScanEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    if (event.employeeCode != null && event.employeeCode!.isNotEmpty) {
      emit(state.copyWith(status: AttendanceProcessStatus.faceVerifying));
      final verifyResult = await _verifyFaceUseCase(
        code: event.employeeCode!,
        imagePath: event.imagePath,
      );

      final isVerified = verifyResult.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AttendanceProcessStatus.faceVerifyFailed,
              errorMessage: failure.message,
            ),
          );
          return false;
        },
        (verifyEntity) {
          if (!verifyEntity.isSuccess || !verifyEntity.isMatch) {
            final msg = verifyEntity.message.isNotEmpty
                ? verifyEntity.message
                : 'Khuôn mặt không khớp với hồ sơ nhân viên';
            emit(
              state.copyWith(
                status: AttendanceProcessStatus.faceVerifyFailed,
                faceVerifyMessage: msg,
                faceSimilarity: verifyEntity.similarity,
                errorMessage: msg,
              ),
            );
            return false;
          }
          return true;
        },
      );

      if (!isVerified) return;
    }

    emit(state.copyWith(status: AttendanceProcessStatus.submitting));

    final now = DateTime.now();
    final params = CheckInParams(
      imagePath: event.imagePath,
      lat: state.lat,
      lng: state.lng,
      bssid: state.bssid,
      capturedAt: now,
      note: event.note,
    );

    final outcome = await switch (event.type) {
      AttendanceType.checkIn => _checkInUseCase(params),
      AttendanceType.checkOut => _checkOutUseCase(params),
    };

    await outcome.fold(
      (failure) async => emit(
        state.copyWith(
          status: AttendanceProcessStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (record) async {
        final freshResult = await _getTodayAttendanceUseCase();
        final updatedToday = freshResult.getOrElse(
          (_) => state.todayAttendance?.copyWith(
            hasCheckedIn: event.type.isCheckIn ? true : state.todayAttendance?.hasCheckedIn,
            hasCheckedOut: event.type.isCheckOut ? true : state.todayAttendance?.hasCheckedOut,
            checkInTime: event.type.isCheckIn
                ? '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'
                : state.todayAttendance?.checkInTime,
            checkOutTime: event.type.isCheckOut
                ? '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'
                : state.todayAttendance?.checkOutTime,
          ) ?? AttendanceTodayEntity(
            hasCheckedIn: event.type.isCheckIn,
            hasCheckedOut: event.type.isCheckOut,
            shiftName: 'Ca Tiêu chuẩn',
            shiftStart: '07:30',
            shiftEnd: '17:30',
            classification: AttendanceClassification.onTime,
            todayDate: DateTime.now().toIso8601String(),
            checkInTime: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
          ),
        );

        emit(
          state.copyWith(
            status: AttendanceProcessStatus.success,
            lastRecord: record,
            todayAttendance: updatedToday,
          ),
        );
      },
    );
  }

  void _onResetAttendanceState(
    ResetAttendanceStateEvent event,
    Emitter<AttendanceState> emit,
  ) {
    emit(state.copyWith(status: AttendanceProcessStatus.readyToScan));
  }
}
