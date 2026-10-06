import 'package:equatable/equatable.dart';

/// Pure domain entity for timesheet correction / regularization item.
class CorrectionItemEntity extends Equatable {
  const new({
    required this.id,
    this.employeeCode,
    this.workDate,
    this.worktime,
    this.reasonTypeName,
    this.note,
    this.isReject = false,
    this.confirmLevel = 0,
  });

  final int id;
  final String? employeeCode;
  final String? workDate;
  final double? worktime;
  final String? reasonTypeName;
  final String? note;
  final bool isReject;
  final int confirmLevel;

  bool get isApproved => confirmLevel > 0 && !isReject;
  bool get isPending => confirmLevel == 0 && !isReject;

  @override
  List<Object?> get props => [
        id,
        employeeCode,
        workDate,
        worktime,
        reasonTypeName,
        note,
        isReject,
        confirmLevel,
      ];
}
