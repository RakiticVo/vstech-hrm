import 'package:equatable/equatable.dart';

/// DTO for Payslip Detail matching EmployeeSalaryPayrollDetailData from OpenAPI 3.0.1.
class PayslipDetailModel extends Equatable {
  const new({
    required this.id,
    required this.month,
    this.employeeCode,
    this.actualBaseSalary = 0,
    this.actualIncomeTotal = 0,
    this.actualAllowance = 0,
    this.actualLunchFee = 0,
    this.actualPhoneFee = 0,
    this.actualOvertimeSalary = 0,
    this.actualKpiSalary = 0,
    this.taxAddition = 0,
    this.taxReturn = 0,
    this.subtractionFund = 0,
    this.sumPayAmount = 0,
    this.note,
  });

  factory fromJson(Map<String, dynamic> json) {
    final item = (json['data'] is Map<String, dynamic> &&
            (json['data'] as Map<String, dynamic>)['item'] is Map<String, dynamic>)
        ? (json['data'] as Map<String, dynamic>)['item'] as Map<String, dynamic>
        : (json['item'] is Map<String, dynamic> ? json['item'] as Map<String, dynamic> : json);

    return PayslipDetailModel(
      id: item['id'] is num ? (item['id'] as num).toInt() : 0,
      month: item['month']?.toString() ?? '',
      employeeCode: item['employeeCode']?.toString(),
      actualBaseSalary: (item['actualBaseSalary'] as num?)?.toDouble() ?? 0,
      actualIncomeTotal: (item['actualIncomeTotal'] as num?)?.toDouble() ?? 0,
      actualAllowance: (item['actualAllowance'] as num?)?.toDouble() ?? 0,
      actualLunchFee: (item['actualLunchFee'] as num?)?.toDouble() ?? 0,
      actualPhoneFee: (item['actualPhoneFee'] as num?)?.toDouble() ?? 0,
      actualOvertimeSalary: (item['actualOvertimeSalary'] as num?)?.toDouble() ?? 0,
      actualKpiSalary: (item['actualKpiSalary'] as num?)?.toDouble() ?? 0,
      taxAddition: (item['taxAddition'] as num?)?.toDouble() ?? 0,
      taxReturn: (item['taxReturn'] as num?)?.toDouble() ?? 0,
      subtractionFund: (item['subtractionFund'] as num?)?.toDouble() ?? 0,
      sumPayAmount: (item['sumPayAmount'] as num?)?.toDouble() ?? 0,
      note: item['note']?.toString(),
    );
  }

  final int id;
  final String month;
  final String? employeeCode;
  final double actualBaseSalary;
  final double actualIncomeTotal;
  final double actualAllowance;
  final double actualLunchFee;
  final double actualPhoneFee;
  final double actualOvertimeSalary;
  final double actualKpiSalary;
  final double taxAddition;
  final double taxReturn;
  final double subtractionFund;
  final double sumPayAmount;
  final String? note;

  @override
  List<Object?> get props => [
        id,
        month,
        employeeCode,
        actualBaseSalary,
        actualIncomeTotal,
        actualAllowance,
        actualLunchFee,
        actualPhoneFee,
        actualOvertimeSalary,
        actualKpiSalary,
        taxAddition,
        taxReturn,
        subtractionFund,
        sumPayAmount,
        note,
      ];
}
