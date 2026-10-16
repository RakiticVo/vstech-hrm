import 'package:equatable/equatable.dart';

enum ApprovalStepStatus { done, pending, rejected }

class ApprovalChainStep extends Equatable {
  const new({
    required this.roleTitle,
    required this.actorName,
    required this.status,
    required this.timestampText,
  });

  final String roleTitle;
  final String actorName;
  final ApprovalStepStatus status;
  final String timestampText;

  @override
  List<Object?> get props => [roleTitle, actorName, status, timestampText];
}

class FinalApprovalItemEntity extends Equatable {
  const new({
    required this.id,
    required this.employeeName,
    required this.employeeRole,
    required this.department,
    required this.categoryTag,
    required this.financialImpact,
    required this.contingencyBudget,
    required this.hrNotes,
    required this.approvalChain,
    required this.createdAt,
    this.isApproved = false,
    this.isRejected = false,
  });

  final String id;
  final String employeeName;
  final String employeeRole;
  final String department;
  final String categoryTag;
  final String financialImpact;
  final String contingencyBudget;
  final String hrNotes;
  final List<ApprovalChainStep> approvalChain;
  final DateTime createdAt;
  final bool isApproved;
  final bool isRejected;

  FinalApprovalItemEntity copyWith({
    bool? isApproved,
    bool? isRejected,
  }) {
    return FinalApprovalItemEntity(
      id: id,
      employeeName: employeeName,
      employeeRole: employeeRole,
      department: department,
      categoryTag: categoryTag,
      financialImpact: financialImpact,
      contingencyBudget: contingencyBudget,
      hrNotes: hrNotes,
      approvalChain: approvalChain,
      createdAt: createdAt,
      isApproved: isApproved ?? this.isApproved,
      isRejected: isRejected ?? this.isRejected,
    );
  }

  @override
  List<Object?> get props => [
        id,
        employeeName,
        employeeRole,
        department,
        categoryTag,
        financialImpact,
        contingencyBudget,
        hrNotes,
        approvalChain,
        createdAt,
        isApproved,
        isRejected,
      ];
}
