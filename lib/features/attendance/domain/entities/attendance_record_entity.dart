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

  final String id;
  final DateTime timestamp;
  final AttendanceType type;
  final AttendanceClassification classification;
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

  /// True if checkin was late (respects backend lateWarning flag when present).
  bool get isLate => lateWarning ?? (lateHours > 0 || classification == AttendanceClassification.late);

  /// True if checkout was early (respects backend earlyWarning flag when present).
  bool get isEarly => earlyWarning ?? (earlyHours > 0 || classification == AttendanceClassification.earlyLeave);

  AttendanceRecordEntity copyWith({
    String? id,
    DateTime? timestamp,
    AttendanceType? type,
    AttendanceClassification? classification,
    String? locationName,
    String? shiftName,
    String? checkinTime,
    String? checkoutTime,
    double? actualHours,
    double? lateHours,
    double? earlyHours,
    bool? isConfirmed,
    double? validHours,
    double? lat,
    double? lng,
    String? bssid,
    String? imagePath,
    String? note,
    bool? lateWarning,
    bool? earlyWarning,
  }) {
    return AttendanceRecordEntity(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      classification: classification ?? this.classification,
      locationName: locationName ?? this.locationName,
      shiftName: shiftName ?? this.shiftName,
      checkinTime: checkinTime ?? this.checkinTime,
      checkoutTime: checkoutTime ?? this.checkoutTime,
      actualHours: actualHours ?? this.actualHours,
      lateHours: lateHours ?? this.lateHours,
      earlyHours: earlyHours ?? this.earlyHours,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      validHours: validHours ?? this.validHours,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      bssid: bssid ?? this.bssid,
      imagePath: imagePath ?? this.imagePath,
      note: note ?? this.note,
      lateWarning: lateWarning ?? this.lateWarning,
      earlyWarning: earlyWarning ?? this.earlyWarning,
    );
  }

  @override
  List<Object?> get props => [
        id,
        timestamp,
        type,
        classification,
        locationName,
        shiftName,
        checkinTime,
        checkoutTime,
        actualHours,
        lateHours,
        earlyHours,
        isConfirmed,
        validHours,
        lat,
        lng,
        bssid,
        imagePath,
        note,
        lateWarning,
        earlyWarning,
      ];
}
