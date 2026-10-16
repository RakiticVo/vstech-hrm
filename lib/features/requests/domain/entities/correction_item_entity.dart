import 'package:equatable/equatable.dart';

/// Pure domain entity for timesheet correction / regularization item.
class CorrectionItemEntity extends Equatable {
  const new({
    required this.id,
    this.employeeCode,
    this.employeeName,
    this.workDate,
    this.worktime,
    this.confirmedWorktime,
    this.reasonTypeName,
    this.note,
    this.isReject = false,
    this.confirmLevel = 0,
    this.isLock = false,
    this.confirmerName,
    this.shiftCode,
    this.shiftName,
    this.shiftStart,
    this.shiftEnd,
  });

  final int id;
  final String? employeeCode;
  final String? employeeName;
  final String? workDate;
  final double? worktime;
  final double? confirmedWorktime;
  final String? reasonTypeName;
  final String? note;
  final bool isReject;
  final int confirmLevel;
  final bool isLock;
  final String? confirmerName;
  final String? shiftCode;
  final String? shiftName;
  final String? shiftStart;
  final String? shiftEnd;

  bool get isApproved => confirmLevel > 0 && !isReject;
  bool get isPending => confirmLevel == 0 && !isReject;
  bool get isCompleted => confirmLevel >= 3 && !isReject;

  @override
  List<Object?> get props => [
        id,
        employeeCode,
        employeeName,
        workDate,
        worktime,
        confirmedWorktime,
        reasonTypeName,
        note,
        isReject,
        confirmLevel,
        isLock,
        confirmerName,
        shiftCode,
        shiftName,
        shiftStart,
        shiftEnd,
      ];
}
