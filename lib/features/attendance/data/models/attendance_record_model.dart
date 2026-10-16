import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// DTO Data Model for an attendance check-in/out record.
class AttendanceRecordModel {
  const new({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.classification,
    required this.locationName,
    this.shiftName,
    this.checkinTime,
    this.checkoutTime,
    this.actualHours = 0.0,
    this.lateHours = 0.0,
    this.earlyHours = 0.0,
    this.isConfirmed = false,
    this.validHours = 0.0,
    this.lat,
    this.lng,
    this.bssid,
    this.imagePath,
    this.note,
    this.lateWarning,
    this.earlyWarning,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      type: json['type']?.toString() ?? 'checkIn',
      classification: json['classification']?.toString() ?? 'onTime',
      locationName: json['locationName']?.toString() ?? '',
      shiftName: json['shiftName']?.toString(),
      checkinTime: json['checkinTime']?.toString(),
      checkoutTime: json['checkoutTime']?.toString(),
      actualHours: (json['actualHours'] as num?)?.toDouble() ?? 0.0,
      lateHours: (json['lateHours'] as num?)?.toDouble() ?? 0.0,
      earlyHours: (json['earlyHours'] as num?)?.toDouble() ?? 0.0,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      bssid: json['bssid']?.toString(),
      imagePath: json['imagePath']?.toString(),
      note: json['note']?.toString(),
      lateWarning: json['lateWarning'] as bool?,
      earlyWarning: json['earlyWarning'] as bool?,
    );
  }

  final String id;
  final DateTime timestamp;
  final String type;
  final String classification;
  final String locationName;
  final String? shiftName;
  final String? checkinTime;
  final String? checkoutTime;
  final double actualHours;
  final double lateHours;
  final double earlyHours;
  final bool isConfirmed;
  final double validHours;
  final double? lat;
  final double? lng;
  final String? bssid;
  final String? imagePath;
  final String? note;
  final bool? lateWarning;
  final bool? earlyWarning;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'type': type,
        'classification': classification,
        'locationName': locationName,
        'shiftName': shiftName,
        'checkinTime': checkinTime,
        'checkoutTime': checkoutTime,
        'actualHours': actualHours,
        'lateHours': lateHours,
        'earlyHours': earlyHours,
        'isConfirmed': isConfirmed,
        'validHours': validHours,
        'lat': lat,
        'lng': lng,
        'bssid': bssid,
        'imagePath': imagePath,
        'note': note,
        'lateWarning': lateWarning,
        'earlyWarning': earlyWarning,
      };

  AttendanceRecordEntity toEntity() {
    return AttendanceRecordEntity(
      id: id,
      timestamp: timestamp,
      type: AttendanceType.fromString(type),
      classification: AttendanceClassification.fromString(classification),
      locationName: locationName,
      shiftName: shiftName,
      checkinTime: checkinTime,
      checkoutTime: checkoutTime,
      actualHours: actualHours,
      lateHours: lateHours,
      earlyHours: earlyHours,
      isConfirmed: isConfirmed,
      validHours: validHours,
      lat: lat,
      lng: lng,
      bssid: bssid,
      imagePath: imagePath,
      note: note,
      lateWarning: lateWarning,
      earlyWarning: earlyWarning,
    );
  }
}
