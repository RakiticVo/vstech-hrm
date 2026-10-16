import 'package:equatable/equatable.dart';

/// Domain entity representing an assigned shift entry for an employee
/// within a department from GET /api/ShiftSchedules (DepartmentShiftDayDoc).
class DepartmentShiftDayEntity extends Equatable {
  const DepartmentShiftDayEntity({
    required this.employeeCode,
    required this.employeeName,
    required this.date,
    this.shiftCode,
    this.shiftName,
    this.createdBy,
    this.createdAt,
    this.color,
    this.textColor,
  });

  /// Subordinate employee code.
  final String employeeCode;

  /// Full employee name.
  final String employeeName;

  /// Assigned shift date.
  final DateTime date;

  /// Shift identifier code.
  final String? shiftCode;

  /// Shift display name.
  final String? shiftName;

  /// Employee code of the manager who assigned this shift.
  final String? createdBy;

  /// Creation timestamp (yyyy-MM-dd HH:mm).
  final String? createdAt;

  /// Background color hex ({#RRGGBB}).
  final String? color;

  /// Text color hex ({#RRGGBB}).
  final String? textColor;

  @override
  List<Object?> get props => [
        employeeCode,
        employeeName,
        date,
        shiftCode,
        shiftName,
        createdBy,
        createdAt,
        color,
        textColor,
      ];
}
