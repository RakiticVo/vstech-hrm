import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';

sealed class DelegationState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

final class DelegationInitial extends DelegationState {
  const new();
}

final class DelegationLoading extends DelegationState {
  const new();
}

final class DelegationLoaded extends DelegationState {
  const new({
    required this.eligibleDelegates,
    required this.activeDelegations,
    required this.selectedPerson,
    required this.fromDate,
    required this.toDate,
    this.isAllScope = true,
    this.selectedLimit = '≤ 50.000.000 VNĐ',
    this.isSubmitting = false,
    this.successMessage,
  });

  final List<DelegatePersonEntity> eligibleDelegates;
  final List<DelegationEntity> activeDelegations;
  final DelegatePersonEntity? selectedPerson;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isAllScope;
  final String selectedLimit;
  final bool isSubmitting;
  final String? successMessage;

  int get totalDays => toDate.difference(fromDate).inDays + 1;

  DelegationLoaded copyWith({
    List<DelegatePersonEntity>? eligibleDelegates,
    List<DelegationEntity>? activeDelegations,
    DelegatePersonEntity? selectedPerson,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isAllScope,
    String? selectedLimit,
    bool? isSubmitting,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return DelegationLoaded(
      eligibleDelegates: eligibleDelegates ?? this.eligibleDelegates,
      activeDelegations: activeDelegations ?? this.activeDelegations,
      selectedPerson: selectedPerson ?? this.selectedPerson,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      isAllScope: isAllScope ?? this.isAllScope,
      selectedLimit: selectedLimit ?? this.selectedLimit,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        eligibleDelegates,
        activeDelegations,
        selectedPerson,
        fromDate,
        toDate,
        isAllScope,
        selectedLimit,
        isSubmitting,
        successMessage,
      ];
}

final class DelegationError extends DelegationState {
  const new(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
