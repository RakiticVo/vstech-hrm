import 'package:equatable/equatable.dart';

enum AttendanceType {
  checkIn,
  checkOut;

  bool get isCheckIn => this == AttendanceType.checkIn;
  bool get isCheckOut => this == AttendanceType.checkOut;

  static AttendanceType fromString(String? type) {
    if (type?.toLowerCase().contains('out') ?? false) {
      return AttendanceType.checkOut;
    }
    return AttendanceType.checkIn;
  }
}

enum AttendanceClassification {
  onTime,
  late,
  earlyLeave;

  String get displayName {
    switch (this) {
      case AttendanceClassification.onTime:
        return 'Đúng giờ';
      case AttendanceClassification.late:
        return 'Đi muộn';
      case AttendanceClassification.earlyLeave:
        return 'Về sớm';
    }
  }

  static AttendanceClassification fromString(String? val) {
    final v = val?.toLowerCase() ?? '';
    if (v.contains('late') || v.contains('muộn')) {
      return AttendanceClassification.late;
    }
    if (v.contains('early') || v.contains('sớm')) {
      return AttendanceClassification.earlyLeave;
    }
    return AttendanceClassification.onTime;
  }
}

/// Domain entity representing a single check-in or check-out event.
class AttendanceRecordEntity extends Equatable {
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

  final String id;
  final DateTime timestamp;
  final AttendanceType type;
  final AttendanceClassification classification;
  final String locationName;
  final double? lat;
  final double? lng;
  final String? bssid;
  final String? imagePath;
  final String? note;

  @override
  List<Object?> get props => [
        id,
        timestamp,
        type,
        classification,
        locationName,
        lat,
        lng,
        bssid,
        imagePath,
        note,
      ];
}
