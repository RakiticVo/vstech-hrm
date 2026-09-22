import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';

enum AttendanceProcessStatus {
  initial,
  loading,
  readyToScan,
  submitting,
  success,
  failure,
}

/// State holding attendance session, location verification, and punch outcomes.
class AttendanceState extends Equatable {
  const new({
    this.status = AttendanceProcessStatus.initial,
    this.todayAttendance,
    this.lastRecord,
    this.locationName = 'Trụ sở chính VSTech • Bán kính 50m',
    this.lat = 10.7769,
    this.lng = 106.7009,
    this.bssid = 'vstech-office-5g',
    this.isWithinGeofence = true,
    this.isWifiValid = true,
    this.isCameraReady = false,
    this.isSimulator = false,
    this.errorMessage,
  });

  final AttendanceProcessStatus status;
  final AttendanceTodayEntity? todayAttendance;
  final AttendanceRecordEntity? lastRecord;
  final String locationName;
  final double lat;
  final double lng;
  final String bssid;
  final bool isWithinGeofence;
  final bool isWifiValid;
  final bool isCameraReady;
  final bool isSimulator;
  final String? errorMessage;

  AttendanceState copyWith({
    AttendanceProcessStatus? status,
    AttendanceTodayEntity? todayAttendance,
    AttendanceRecordEntity? lastRecord,
    String? locationName,
    double? lat,
    double? lng,
    String? bssid,
    bool? isWithinGeofence,
    bool? isWifiValid,
    bool? isCameraReady,
    bool? isSimulator,
    String? errorMessage,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      todayAttendance: todayAttendance ?? this.todayAttendance,
      lastRecord: lastRecord ?? this.lastRecord,
      locationName: locationName ?? this.locationName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      bssid: bssid ?? this.bssid,
      isWithinGeofence: isWithinGeofence ?? this.isWithinGeofence,
      isWifiValid: isWifiValid ?? this.isWifiValid,
      isCameraReady: isCameraReady ?? this.isCameraReady,
      isSimulator: isSimulator ?? this.isSimulator,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todayAttendance,
        lastRecord,
        locationName,
        lat,
        lng,
        bssid,
        isWithinGeofence,
        isWifiValid,
        isCameraReady,
        isSimulator,
        errorMessage,
      ];
}
