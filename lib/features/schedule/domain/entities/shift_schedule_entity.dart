import 'package:flutter/material.dart';

/// Shift working status of an individual schedule item.
enum ShiftStatus {
  active,
  completed,
  upcoming,
  dayOff,
}

/// Domain entity representing an employee's shift schedule.
/// Aligned strictly with OpenAPI 3.0.1 (GET /api/ShiftSchedules/me).
class ShiftScheduleEntity {
  const new({
    required this.id,
    required this.date,
    required this.dayOfWeek,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.color,
    this.textColor,
    this.shiftCode,
    this.source,
    this.isOvernight = false,
  });

  final String id;
  final DateTime date;
  final String dayOfWeek;
  final String shiftName;
  final String startTime;
  final String endTime;
  final ShiftStatus status;
  final Color color;
  final Color? textColor;
  final String? shiftCode;
  final String? source;
  final bool isOvernight;

  bool get isDayOff =>
      status == ShiftStatus.dayOff ||
      shiftName == 'Nghỉ tuần' ||
      (shiftCode == null && startTime == '—');
  bool get isScheduled => source?.toUpperCase() == 'SCHEDULE';
  bool get isDefault => source?.toUpperCase() == 'DEFAULT';
  String get formattedTime => isDayOff ? 'Nghỉ tuần' : '$startTime — $endTime';
}
