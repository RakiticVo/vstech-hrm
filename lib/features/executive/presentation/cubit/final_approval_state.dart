import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/executive/domain/entities/final_approval_entity.dart';

enum FinalApprovalStatus { initial, loading, success, failure }

class FinalApprovalState extends Equatable {
  const new({
    this.status = FinalApprovalStatus.initial,
    this.queue = const [],
    this.isActionLoading = false,
    this.userMessage,
    this.errorMessage,
  });

  final FinalApprovalStatus status;
  final List<FinalApprovalItemEntity> queue;
  final bool isActionLoading;
  final String? userMessage;
  final String? errorMessage;

  bool get isLoading => status == FinalApprovalStatus.loading;

  FinalApprovalState copyWith({
    FinalApprovalStatus? status,
    List<FinalApprovalItemEntity>? queue,
    bool? isActionLoading,
    String? userMessage,
    String? errorMessage,
  }) {
    return FinalApprovalState(
      status: status ?? this.status,
      queue: queue ?? this.queue,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      userMessage: userMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        queue,
        isActionLoading,
        userMessage,
        errorMessage,
      ];
}
