import 'package:flutter/material.dart';

/// Shift working status of an individual schedule item.
enum ShiftStatus {
  active,
  completed,
  upcoming,
  dayOff,
}

/// Domain entity representing an employee's shift schedule.
class ShiftScheduleEntity {
  const new({
    required this.id,
    required this.date,
    required this.dayOfWeek,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.breakTime,
    required this.branchName,
    required this.managerName,
    required this.status,
    required this.color,
    this.notes,
  });

  final String id;
  final DateTime date;
  final String dayOfWeek;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String breakTime;
  final String branchName;
  final String managerName;
  final ShiftStatus status;
  final Color color;
  final String? notes;

  bool get isDayOff => status == ShiftStatus.dayOff;
  String get formattedTime => isDayOff ? 'Nghỉ tuần' : '$startTime — $endTime';
}
