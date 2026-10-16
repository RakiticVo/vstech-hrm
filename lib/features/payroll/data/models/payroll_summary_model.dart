import 'package:equatable/equatable.dart';

/// DTO for EmployeeSalaryPayrollSummary from OpenAPI 3.0.1.
class PayrollSummaryModel extends Equatable {
  const new({
    this.departmentCode,
    this.departmentName,
    this.sumPayAmount = 0,
    this.sumSalaryCost = 0,
    this.staffNum = 0,
  });

  factory fromJson(Map<String, dynamic> json) {
    return PayrollSummaryModel(
      departmentCode: json['departmentCode']?.toString(),
      departmentName: json['departmentName']?.toString(),
      sumPayAmount: (json['sumPayAmount'] as num?)?.toDouble() ?? 0,
      sumSalaryCost: (json['sumSalaryCost'] as num?)?.toDouble() ?? 0,
      staffNum: json['staffNum'] is num ? (json['staffNum'] as num).toInt() : 0,
    );
  }

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
