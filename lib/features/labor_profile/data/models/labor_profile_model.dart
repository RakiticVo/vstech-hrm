import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';

class LaborContractAttachmentModel {
  const new({
    required this.id,
    required this.name,
    required this.size,
    required this.uploadedAt,
    this.url,
  });

  factory fromJson(Map<String, dynamic> json) {
    return LaborContractAttachmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      url: json['url'] as String?,
    );
  }

  final String id;
  final String name;
  final String size;
  final DateTime uploadedAt;
  final String? url;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'size': size,
        'uploadedAt': uploadedAt.toIso8601String(),
        'url': url,
      };

  LaborContractAttachment toEntity() => LaborContractAttachment(
        id: id,
        name: name,
        size: size,
        uploadedAt: uploadedAt,
        url: url,
      );
}

class LaborProfileModel {
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

  factory fromJson(Map<String, dynamic> json) {
    return LaborProfileModel(
      employeeCode: json['employeeCode'] as String,
      fullName: json['fullName'] as String,
      department: json['department'] as String,
      jobTitle: json['jobTitle'] as String,
      contractType: json['contractType'] as String,
      contractNumber: json['contractNumber'] as String,
      signingDate: DateTime.parse(json['signingDate'] as String),
      effectiveDate: DateTime.parse(json['effectiveDate'] as String),
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'] as String)
          : null,
      contractStatus: json['contractStatus'] as String,
      agreedBaseSalary: (json['agreedBaseSalary'] as num).toDouble(),
      responsibilityAllowance: (json['responsibilityAllowance'] as num).toDouble(),
      mealAllowance: (json['mealAllowance'] as num).toDouble(),
      socialInsuranceNumber: json['socialInsuranceNumber'] as String,
      hospitalRegistered: json['hospitalRegistered'] as String,
      insuranceSalaryLevel: (json['insuranceSalaryLevel'] as num).toDouble(),
      insuranceStatus: json['insuranceStatus'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => LaborContractAttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final String employeeCode;
  final String fullName;
  final String department;
  final String jobTitle;
  final String contractType;
  final String contractNumber;
  final DateTime signingDate;
  final DateTime effectiveDate;
  final DateTime? expirationDate;
  final String contractStatus;
  final double agreedBaseSalary;
  final double responsibilityAllowance;
  final double mealAllowance;
  final String socialInsuranceNumber;
  final String hospitalRegistered;
  final double insuranceSalaryLevel;
  final String insuranceStatus;
  final List<LaborContractAttachmentModel> attachments;

  LaborProfileEntity toEntity() => LaborProfileEntity(
        employeeCode: employeeCode,
        fullName: fullName,
        department: department,
        jobTitle: jobTitle,
        contractType: contractType,
        contractNumber: contractNumber,
        signingDate: signingDate,
        effectiveDate: effectiveDate,
        expirationDate: expirationDate,
        contractStatus: contractStatus,
        agreedBaseSalary: agreedBaseSalary,
        responsibilityAllowance: responsibilityAllowance,
        mealAllowance: mealAllowance,
        socialInsuranceNumber: socialInsuranceNumber,
        hospitalRegistered: hospitalRegistered,
        insuranceSalaryLevel: insuranceSalaryLevel,
        insuranceStatus: insuranceStatus,
        attachments: attachments.map((a) => a.toEntity()).toList(),
      );
}
