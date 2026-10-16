import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';

enum AttendanceProcessStatus {
  initial,
  loading,
  readyToScan,
  faceNotRegistered,
  faceVerifying,
  faceVerifyFailed,
  submitting,
  success,
  failure,
}

/// State holding attendance session, location verification, and punch outcomes.
class AttendanceState extends Equatable {
  const AttendanceState({
    this.status = AttendanceProcessStatus.initial,
    this.todayAttendance,
    this.lastRecord,
    this.locationName = 'Đang xác định vị trí...',
    this.lat = 0.0,
    this.lng = 0.0,
    this.bssid = 'vstech-office-5g',
    this.isWithinGeofence = false,
    this.isWifiValid = true,
    this.isCameraReady = false,
    this.isLocationReady = false,
    this.isSimulator = false,
    this.isFaceRegistered,
    this.faceVerifyMessage,
    this.faceSimilarity,
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
  final bool isLocationReady;
  final bool isSimulator;
  final bool? isFaceRegistered;
  final String? faceVerifyMessage;
  final double? faceSimilarity;
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
    bool? isLocationReady,
    bool? isSimulator,
    bool? isFaceRegistered,
    String? faceVerifyMessage,
    double? faceSimilarity,
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
      isLocationReady: isLocationReady ?? this.isLocationReady,
      isSimulator: isSimulator ?? this.isSimulator,
      isFaceRegistered: isFaceRegistered ?? this.isFaceRegistered,
      faceVerifyMessage: faceVerifyMessage ?? this.faceVerifyMessage,
      faceSimilarity: faceSimilarity ?? this.faceSimilarity,
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
        isLocationReady,
        isSimulator,
        isFaceRegistered,
        faceVerifyMessage,
        faceSimilarity,
        errorMessage,
      ];
}
