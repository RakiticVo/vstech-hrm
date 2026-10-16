import 'package:equatable/equatable.dart';

/// Pure domain entity representing an available leave plan for an employee.
/// Mapped from GET /api/LeavePlans/valid-leave-plan2.
class ValidLeavePlanEntity extends Equatable {
  const new({
    required this.leaveCode,
    required this.leaveName,
    this.employeeCode,
    this.amount = 0.0,
    this.validFrom,
    this.validTo,
    this.hasAmount = true,
  });

  final String leaveCode;
  final String leaveName;
  final String? employeeCode;
  final double amount;
  final String? validFrom;
  final String? validTo;
  final bool hasAmount;

  @override
  List<Object?> get props => [
        leaveCode,
        leaveName,
        employeeCode,
        amount,
        validFrom,
        validTo,
        hasAmount,
      ];
}
