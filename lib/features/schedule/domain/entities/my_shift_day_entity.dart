import 'package:equatable/equatable.dart';

/// Domain entity representing a personal shift day item
/// from GET /api/ShiftSchedules/me (MyShiftDayDoc).
class MyShiftDayEntity extends Equatable {
  const MyShiftDayEntity({
    required this.date,
    this.shiftCode,
    this.shiftName,
    this.startHour,
    this.endHour,
    this.isOvernight = false,
    this.source,
  });

  /// The scheduled calendar date.
  final DateTime date;

  /// Shift identifier code (null or empty if day off).
  final String? shiftCode;

  /// Display name of the shift.
  final String? shiftName;

  /// Start time in HH:mm.
  final String? startHour;

  /// End time in HH:mm.
  final String? endHour;

  /// True if shift spans past midnight.
  final bool isOvernight;

  /// 'SCHEDULE' if assigned by manager, 'DEFAULT' if company default.
  final String? source;

  bool get hasShift => shiftCode != null && shiftCode!.trim().isNotEmpty;
  bool get isScheduled => source?.toUpperCase() == 'SCHEDULE';
  bool get isDefault => source?.toUpperCase() == 'DEFAULT';
  bool get isDayOff => !hasShift;

  @override
  List<Object?> get props => [
        date,
        shiftCode,
        shiftName,
        startHour,
        endHour,
        isOvernight,
        source,
      ];
}
