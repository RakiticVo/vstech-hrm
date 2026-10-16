import 'package:equatable/equatable.dart';

/// Pure domain entity for Payslip.
class PayslipEntity extends Equatable {
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
