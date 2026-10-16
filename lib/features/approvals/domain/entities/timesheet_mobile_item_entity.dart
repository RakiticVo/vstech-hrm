import 'package:equatable/equatable.dart';

/// Pure domain entity representing an employee's daily timesheet row in Manager view (GET /api/TimeSheets/mobile).
class TimesheetMobileItemEntity extends Equatable {
  const new({
    this.code,
    this.employeeCode,
    this.employeeName,
    this.department,
    this.actualWorkTime,
    this.validActualTime,
    this.overtime,
    this.leaveTime,
    this.shiftHour,
    this.staticSymbol,
    this.isConfirmed = false,
    this.isConfirmText,
    this.workDate,
    this.workDateRaw,
    this.note,
  });

  final String? code;
  final String? employeeCode;
  final String? employeeName;
  final String? department;
  final double? actualWorkTime;
  final double? validActualTime;
  final double? overtime;
  final double? leaveTime;
  final double? shiftHour;
  final String? staticSymbol;
  final bool isConfirmed;
  final String? isConfirmText;
  final String? workDate;
  final String? workDateRaw;
  final String? note;

  @override
  List<Object?> get props => [
        code,
        employeeCode,
        employeeName,
        department,
        actualWorkTime,
        validActualTime,
        overtime,
        leaveTime,
        shiftHour,
        staticSymbol,
        isConfirmed,
        isConfirmText,
        workDate,
        workDateRaw,
        note,
      ];
}
