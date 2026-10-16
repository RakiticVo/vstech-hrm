import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';

class DelegatePersonModel {
  const new({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.initials,
  });

  factory fromJson(Map<String, dynamic> json) => DelegatePersonModel(
        id: json['id'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        department: json['department'] as String,
        initials: json['initials'] as String,
      );

  final String id;
  final String name;
  final String role;
  final String department;
  final String initials;

  DelegatePersonEntity toEntity() => DelegatePersonEntity(
        id: id,
        name: name,
        role: role,
        department: department,
        initials: initials,
      );
}

class DelegationModel {
  const new({
    required this.id,
    required this.delegatePerson,
    required this.fromDate,
    required this.toDate,
    required this.scopeDescription,
    required this.financialLimitText,
    required this.isActive,
    required this.createdAt,
  });

  factory fromJson(Map<String, dynamic> json) => DelegationModel(
        id: json['id'] as String,
        delegatePerson: DelegatePersonModel.fromJson(
          json['delegatePerson'] as Map<String, dynamic>,
        ).toEntity(),
        fromDate: DateTime.parse(json['fromDate'] as String),
        toDate: DateTime.parse(json['toDate'] as String),
        scopeDescription: json['scopeDescription'] as String,
        financialLimitText: json['financialLimitText'] as String,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final String id;
  final DelegatePersonEntity delegatePerson;
  final DateTime fromDate;
  final DateTime toDate;
  final String scopeDescription;
  final String financialLimitText;
  final bool isActive;
  final DateTime createdAt;

  DelegationEntity toEntity() => DelegationEntity(
        id: id,
        delegatePerson: delegatePerson,
        fromDate: fromDate,
        toDate: toDate,
        scopeDescription: scopeDescription,
        financialLimitText: financialLimitText,
        isActive: isActive,
        createdAt: createdAt,
      );
}
