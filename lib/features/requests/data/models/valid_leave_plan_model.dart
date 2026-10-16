import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_leave_plan_entity.dart';

/// DTO Data Model for LeavePlanAvailableDoc from OpenAPI 3.0.1 (GET /api/LeavePlans/valid-leave-plan2).
class ValidLeavePlanModel extends Equatable {
  const new({
    required this.leaveCode,
    required this.leaveName,
    this.employeeCode,
    this.amount = 0.0,
    this.validFrom,
    this.validTo,
    this.hasAmount = true,
  });

  factory fromJson(Map<String, dynamic> json) {
    return ValidLeavePlanModel(
      leaveCode: json['leaveCode']?.toString() ?? '',
      leaveName: json['leaveName']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      validFrom: json['validFrom']?.toString(),
      validTo: json['validTo']?.toString(),
      hasAmount: json['hasAmount'] == true,
    );
  }

  final String leaveCode;
  final String leaveName;
  final String? employeeCode;
  final double amount;
  final String? validFrom;
  final String? validTo;
  final bool hasAmount;

  ValidLeavePlanEntity toEntity() => ValidLeavePlanEntity(
        leaveCode: leaveCode,
        leaveName: leaveName,
        employeeCode: employeeCode,
        amount: amount,
        validFrom: validFrom,
        validTo: validTo,
        hasAmount: hasAmount,
      );

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
