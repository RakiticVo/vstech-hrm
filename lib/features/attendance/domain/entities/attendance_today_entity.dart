import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// Domain entity representing today's attendance summary for home dashboard.
class AttendanceTodayEntity extends Equatable {
  const AttendanceTodayEntity({
    required this.hasCheckedIn,
    required this.hasCheckedOut,
    required this.shiftName,
    required this.shiftStart,
    required this.shiftEnd,
    required this.classification,
    required this.todayDate,
    this.checkInTime,
    this.checkOutTime,
    this.lateMinutes = 0,
  });

  final bool hasCheckedIn;
  final bool hasCheckedOut;
  final String shiftName;
  final String shiftStart;
  final String shiftEnd;
  final AttendanceClassification classification;
  final String todayDate;
  final String? checkInTime;
  final String? checkOutTime;
  final int lateMinutes;

  AttendanceTodayEntity copyWith({
    bool? hasCheckedIn,
    bool? hasCheckedOut,
    String? shiftName,
    String? shiftStart,
    String? shiftEnd,
    AttendanceClassification? classification,
    String? todayDate,
    String? checkInTime,
    String? checkOutTime,
    int? lateMinutes,
  }) {
    return AttendanceTodayEntity(
      hasCheckedIn: hasCheckedIn ?? this.hasCheckedIn,
      hasCheckedOut: hasCheckedOut ?? this.hasCheckedOut,
      shiftName: shiftName ?? this.shiftName,
      shiftStart: shiftStart ?? this.shiftStart,
      shiftEnd: shiftEnd ?? this.shiftEnd,
      classification: classification ?? this.classification,
      todayDate: todayDate ?? this.todayDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      lateMinutes: lateMinutes ?? this.lateMinutes,
    );
  }

  @override
  List<Object?> get props => [
        hasCheckedIn,
        hasCheckedOut,
        shiftName,
        shiftStart,
        shiftEnd,
        classification,
        todayDate,
        checkInTime,
        checkOutTime,
        lateMinutes,
      ];
}
