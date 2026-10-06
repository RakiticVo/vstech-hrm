import 'package:equatable/equatable.dart';

/// Pure domain entity for department payroll summary.
class PayrollSummaryEntity extends Equatable {
  const new({
    this.departmentCode,
    this.departmentName,
    this.sumPayAmount = 0,
    this.sumSalaryCost = 0,
    this.staffNum = 0,
  });

  final String? departmentCode;
  final String? departmentName;
  final double sumPayAmount;
  final double sumSalaryCost;
  final int staffNum;

  @override
  List<Object?> get props => [
        departmentCode,
        departmentName,
        sumPayAmount,
        sumSalaryCost,
        staffNum,
      ];
}
