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
  AttendanceBloc({
    required GetTodayAttendanceUseCase getTodayAttendanceUseCase,
    required CheckInUseCase checkInUseCase,
    required CheckOutUseCase checkOutUseCase,
    required CheckFaceRegistrationUseCase checkFaceRegistrationUseCase,
    required VerifyFaceUseCase verifyFaceUseCase,
  })  : _getTodayAttendanceUseCase = getTodayAttendanceUseCase,
        _checkInUseCase = checkInUseCase,
        _checkOutUseCase = checkOutUseCase,
        _checkFaceRegistrationUseCase = checkFaceRegistrationUseCase,
        _verifyFaceUseCase = verifyFaceUseCase,
        super(const AttendanceState()) {
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

  Future<Position?> _getRealPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        appLogger.w('Location service is disabled');
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );
      } on Object catch (_) {
        return await Geolocator.getLastKnownPosition();
      }
    } on Object catch (e) {
      appLogger.w('Geolocator position retrieval failed: $e');
    }
    return null;
  }

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
    emit(
      state.copyWith(
        status: AttendanceProcessStatus.loading,
        isLocationReady: false,
        locationName: 'Đang xác định vị trí GPS...',
      ),
    );

    final pos = await _getRealPosition();
    final double lat;
    final double lng;
    final String locationLabel;
    final bool isLocReady;

    if (pos != null) {
      lat = pos.latitude;
      lng = pos.longitude;
      isLocReady = true;
      final dist = Geolocator.distanceBetween(lat, lng, 10.7769, 106.7009);
      if (dist <= 200) {
        locationLabel = 'Trụ sở chính VSTech • ${dist.round()}m';
      } else {
        locationLabel = 'GPS thực tế: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
      }
    } else {
      lat = 0.0;
      lng = 0.0;
      isLocReady = false;
      locationLabel = 'Chưa lấy được toạ độ GPS';
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
        isWithinGeofence: isLocReady,
        isWifiValid: true,
        isFaceRegistered: isRegistered,
        isLocationReady: isLocReady,
        locationName: locationLabel,
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

    final freshPos = await _getRealPosition();
    final actualLat = freshPos?.latitude ?? state.lat;
    final actualLng = freshPos?.longitude ?? state.lng;

    final now = DateTime.now();
    final params = CheckInParams(
      imagePath: event.imagePath,
      lat: actualLat,
      lng: actualLng,
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
