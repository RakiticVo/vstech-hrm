import 'package:equatable/equatable.dart';

/// Domain entity representing a subordinate employee under manager's scope
/// (GET /api/TimeSheets/mobile-employees).
class ManagedEmployeeEntity extends Equatable {
  const new({
    required this.code,
    required this.name,
    this.departmentCode,
    this.department,
    this.shiftCode,
    this.shiftName,
    this.shiftStart,
    this.shiftEnd,
  });

  /// Employee code (e.g. NV0123).
  final String code;

  /// Full employee name.
  final String name;

  /// Current department code (CurrentDepartmentCode).
  final String? departmentCode;

  /// Department display name.
  final String? department;

  /// Default shift code.
  final String? shiftCode;

  /// Default shift name.
  final String? shiftName;

  /// Default shift start (HH:mm).
  final String? shiftStart;

  /// Default shift end (HH:mm).
  final String? shiftEnd;

  @override
  List<Object?> get props => [
        code,
        name,
        departmentCode,
        department,
        shiftCode,
        shiftName,
        shiftStart,
        shiftEnd,
      ];
}
