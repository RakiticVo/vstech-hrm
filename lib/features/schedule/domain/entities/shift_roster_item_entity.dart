import 'package:equatable/equatable.dart';

/// Domain entity representing a subordinate employee's daily shift status
/// in the Manager's Daily Roster view.
class ShiftRosterItemEntity extends Equatable {
  const ShiftRosterItemEntity({
    required this.employeeCode,
    required this.employeeName,
    required this.date,
    this.departmentCode,
    this.departmentName,
    this.shiftCode,
    this.shiftName,
    this.startHour,
    this.endHour,
    this.isOvernight = false,
    this.source = 'DEFAULT',
    this.assignedBy,
    this.assignedAt,
  });

  /// Subordinate employee code.
  final String employeeCode;

  /// Full employee name.
  final String employeeName;

  /// Roster date.
  final DateTime date;

  /// Department code.
  final String? departmentCode;

  /// Department name.
  final String? departmentName;

  /// Shift identifier code (null or empty if off).
  final String? shiftCode;

  /// Shift display name.
  final String? shiftName;

  /// Start time in HH:mm.
  final String? startHour;

  /// End time in HH:mm.
  final String? endHour;

  /// True if overnight shift.
  final bool isOvernight;

  /// 'SCHEDULE' (manually assigned by manager), 'DEFAULT' (contract shift), or 'OFF'.
  final String source;

  /// Manager employee code who assigned this shift (if source == 'SCHEDULE').
  final String? assignedBy;

  /// Time when shift was assigned.
  final String? assignedAt;

  bool get hasShift => shiftCode != null && shiftCode!.trim().isNotEmpty;
  bool get isScheduled => source.toUpperCase() == 'SCHEDULE';
  bool get isDefault => source.toUpperCase() == 'DEFAULT';
  bool get isDayOff => !hasShift || source.toUpperCase() == 'OFF';

  String get timeRange =>
      hasShift ? '${startHour ?? '—'} - ${endHour ?? '—'}' : 'Nghỉ';

  @override
  List<Object?> get props => [
        employeeCode,
        employeeName,
        date,
        departmentCode,
        departmentName,
        shiftCode,
        shiftName,
        startHour,
        endHour,
        isOvernight,
        source,
        assignedBy,
        assignedAt,
      ];
}
