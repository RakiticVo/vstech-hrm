import 'package:equatable/equatable.dart';

/// Represents a downloadable or previewable contract attachment.
class LaborContractAttachment extends Equatable {
  const new({
    required this.id,
    required this.name,
    required this.size,
    required this.uploadedAt,
    this.url,
  });

  final String id;
  final String name;
  final String size;
  final DateTime uploadedAt;
  final String? url;

  @override
  List<Object?> get props => [id, name, size, uploadedAt, url];
}

/// Domain entity containing employment, contract, salary, and social insurance details.
class LaborProfileEntity extends Equatable {
  const new({
    required this.employeeCode,
    required this.fullName,
    required this.department,
    required this.jobTitle,
    required this.contractType,
    required this.contractNumber,
    required this.signingDate,
    required this.effectiveDate,
    required this.expirationDate,
    required this.contractStatus,
    required this.agreedBaseSalary,
    required this.responsibilityAllowance,
    required this.mealAllowance,
    required this.socialInsuranceNumber,
    required this.hospitalRegistered,
    required this.insuranceSalaryLevel,
    required this.insuranceStatus,
    this.attachments = const [],
  });

  final String employeeCode;
  final String fullName;
  final String department;
  final String jobTitle;

  // Contract terms
  final String contractType;
  final String contractNumber;
  final DateTime signingDate;
  final DateTime effectiveDate;
  final DateTime? expirationDate;
  final String contractStatus;

  // Agreed Salary & Benefits
  final double agreedBaseSalary;
  final double responsibilityAllowance;
  final double mealAllowance;

  // Social & Health Insurance
  final String socialInsuranceNumber;
  final String hospitalRegistered;
  final double insuranceSalaryLevel;
  final String insuranceStatus;

  // Attachments
  final List<LaborContractAttachment> attachments;

  @override
  List<Object?> get props => [
        employeeCode,
        fullName,
        department,
        jobTitle,
        contractType,
        contractNumber,
        signingDate,
        effectiveDate,
        expirationDate,
        contractStatus,
        agreedBaseSalary,
        responsibilityAllowance,
        mealAllowance,
        socialInsuranceNumber,
        hospitalRegistered,
        insuranceSalaryLevel,
        insuranceStatus,
        attachments,
      ];
}
