import 'package:equatable/equatable.dart';

class DelegatePersonEntity extends Equatable {
  const new({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.initials,
  });

  final String id;
  final String name;
  final String role;
  final String department;
  final String initials;

  @override
  List<Object?> get props => [id, name, role, department, initials];
}

class DelegationEntity extends Equatable {
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

  final String id;
  final DelegatePersonEntity delegatePerson;
  final DateTime fromDate;
  final DateTime toDate;
  final String scopeDescription;
  final String financialLimitText;
  final bool isActive;
  final DateTime createdAt;

  int get totalDays => toDate.difference(fromDate).inDays + 1;

  DelegationEntity copyWith({bool? isActive}) {
    return DelegationEntity(
      id: id,
      delegatePerson: delegatePerson,
      fromDate: fromDate,
      toDate: toDate,
      scopeDescription: scopeDescription,
      financialLimitText: financialLimitText,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        delegatePerson,
        fromDate,
        toDate,
        scopeDescription,
        financialLimitText,
        isActive,
        createdAt,
      ];
}
