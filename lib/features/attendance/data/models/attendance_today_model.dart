import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';

/// DTO Data Model for today's attendance status.
class AttendanceTodayModel {
  const new({
    required this.date,
    required this.shiftName,
    required this.shiftTime,
    required this.status,
    required this.isLate,
    this.checkInTime,
    this.checkOutTime,
  });

  factory fromJson(Map<String, dynamic> json) {
    return AttendanceTodayModel(
      date: json['date']?.toString() ?? '',
      shiftName: json['shiftName']?.toString() ?? 'Ca Hành chính',
      shiftTime: json['shiftTime']?.toString() ?? '08:30 - 17:30',
      status: json['status']?.toString() ?? 'not_started',
      isLate: json['isLate'] == true,
      checkInTime: json['checkInTime']?.toString(),
      checkOutTime: json['checkOutTime']?.toString(),
    );
  }

  final String date;
  final String shiftName;
  final String shiftTime;
  final String status;
  final bool isLate;
  final String? checkInTime;
  final String? checkOutTime;

  Map<String, dynamic> toJson() => {
        'date': date,
        'shiftName': shiftName,
        'shiftTime': shiftTime,
        'status': status,
        'isLate': isLate,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
      };

  AttendanceTodayEntity toEntity() {
    final times = shiftTime.split('-');
    final start = times.isNotEmpty ? times[0].trim() : '08:30';
    final end = times.length > 1 ? times[1].trim() : '17:30';

    return AttendanceTodayEntity(
      hasCheckedIn: checkInTime != null && checkInTime!.isNotEmpty,
      hasCheckedOut: checkOutTime != null && checkOutTime!.isNotEmpty,
      shiftName: shiftName,
      shiftStart: start,
      shiftEnd: end,
      classification: isLate
          ? AttendanceClassification.late
          : AttendanceClassification.onTime,
      todayDate: date,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
    );
  }
}
