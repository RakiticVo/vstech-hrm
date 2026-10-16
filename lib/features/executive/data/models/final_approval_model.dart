import 'package:vstech_hrm/features/executive/domain/entities/final_approval_entity.dart';

class FinalApprovalItemModel {
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

  factory fromJson(Map<String, dynamic> json) {
    final chainRaw = json['approvalChain'] as List<dynamic>? ?? [];
    return FinalApprovalItemModel(
      id: json['id'] as String,
      employeeName: json['employeeName'] as String,
      employeeRole: json['employeeRole'] as String,
      department: json['department'] as String,
      categoryTag: json['categoryTag'] as String,
      financialImpact: json['financialImpact'] as String,
      contingencyBudget: json['contingencyBudget'] as String,
      hrNotes: json['hrNotes'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isApproved: json['isApproved'] as bool? ?? false,
      isRejected: json['isRejected'] as bool? ?? false,
      approvalChain: chainRaw.map((c) {
        final cMap = c as Map<String, dynamic>;
        final st = (cMap['status'] as String?)?.toLowerCase();
        final status = switch (st) {
          'done' => ApprovalStepStatus.done,
          'rejected' => ApprovalStepStatus.rejected,
          _ => ApprovalStepStatus.pending,
        };
        return ApprovalChainStep(
          roleTitle: cMap['roleTitle'] as String,
          actorName: cMap['actorName'] as String,
          status: status,
          timestampText: cMap['timestampText'] as String,
        );
      }).toList(),
    );
  }

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

  FinalApprovalItemEntity toEntity() => FinalApprovalItemEntity(
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
        isApproved: isApproved,
        isRejected: isRejected,
      );
}
