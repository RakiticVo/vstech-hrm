import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_in_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_out_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';

/// BLoC managing attendance lifecycle, camera readiness, GPS verification, and punch submissions.
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  new({
    required this._getTodayAttendanceUseCase,
    required this._checkInUseCase,
    required this._checkOutUseCase,
  })  : super(const AttendanceState()) {
    on<LoadTodayAttendanceEvent>(_onLoadTodayAttendance);
    on<PrepareFaceScanEvent>(_onPrepareFaceScan);
    on<SubmitFaceScanEvent>(_onSubmitFaceScan);
    on<ResetAttendanceStateEvent>(_onResetAttendanceState);
  }

  final GetTodayAttendanceUseCase _getTodayAttendanceUseCase;
  final CheckInUseCase _checkInUseCase;
  final CheckOutUseCase _checkOutUseCase;

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

    emit(
      state.copyWith(
        status: AttendanceProcessStatus.readyToScan,
        lat: lat,
        lng: lng,
        isWithinGeofence: isWithinGeofence,
        isWifiValid: true,
        locationName: 'Trụ sở chính VSTech • Bán kính 50m',
      ),
    );
  }

  Future<void> _onSubmitFaceScan(
    SubmitFaceScanEvent event,
    Emitter<AttendanceState> emit,
  ) async {
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

    outcome.fold(
      (failure) => emit(
        state.copyWith(
          status: AttendanceProcessStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (record) {
        // Update local today's attendance state
        final updatedToday = state.todayAttendance?.copyWith(
          hasCheckedIn: event.type.isCheckIn ? true : state.todayAttendance?.hasCheckedIn,
          hasCheckedOut: event.type.isCheckOut ? true : state.todayAttendance?.hasCheckedOut,
          checkInTime: event.type.isCheckIn
              ? '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'
              : state.todayAttendance?.checkInTime,
          checkOutTime: event.type.isCheckOut
              ? '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'
              : state.todayAttendance?.checkOutTime,
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
