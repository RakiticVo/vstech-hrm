import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// DTO Data Model for an attendance check-in/out record.
class AttendanceRecordModel {
  const new({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.classification,
    required this.locationName,
    this.lat,
    this.lng,
    this.bssid,
    this.imagePath,
    this.note,
  });

  factory fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      type: json['type']?.toString() ?? 'checkIn',
      classification: json['classification']?.toString() ?? 'onTime',
      locationName: json['locationName']?.toString() ?? 'Trụ sở chính VSTech',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      bssid: json['bssid']?.toString(),
      imagePath: json['imagePath']?.toString(),
      note: json['note']?.toString(),
    );
  }

  final String id;
  final DateTime timestamp;
  final String type;
  final String classification;
  final String locationName;
  final double? lat;
  final double? lng;
  final String? bssid;
  final String? imagePath;
  final String? note;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'type': type,
        'classification': classification,
        'locationName': locationName,
        'lat': lat,
        'lng': lng,
        'bssid': bssid,
        'imagePath': imagePath,
        'note': note,
      };

  AttendanceRecordEntity toEntity() {
    return AttendanceRecordEntity(
      id: id,
      timestamp: timestamp,
      type: AttendanceType.fromString(type),
      classification: AttendanceClassification.fromString(classification),
      locationName: locationName,
      lat: lat,
      lng: lng,
      bssid: bssid,
      imagePath: imagePath,
      note: note,
    );
  }
}
