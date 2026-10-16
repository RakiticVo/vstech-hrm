import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/usecases/compliance_usecases.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/delegation_state.dart';

class DelegationCubit extends Cubit<DelegationState> {
  new({
    required this.getEligibleDelegatesUseCase,
    required this.getActiveDelegationsUseCase,
    required this.createDelegationUseCase,
    required this.revokeDelegationUseCase,
  }) : super(const DelegationInitial());

  final GetEligibleDelegatesUseCase getEligibleDelegatesUseCase;
  final GetActiveDelegationsUseCase getActiveDelegationsUseCase;
  final CreateDelegationUseCase createDelegationUseCase;
  final RevokeDelegationUseCase revokeDelegationUseCase;

  Future<void> loadInitialData() async {
    emit(const DelegationLoading());
    final delegatesRes = await getEligibleDelegatesUseCase();
    final activeRes = await getActiveDelegationsUseCase();

    delegatesRes.fold(
      (f) => emit(DelegationError(f.message)),
      (delegates) {
        activeRes.fold(
          (f) => emit(DelegationError(f.message)),
          (active) {
            final now = DateTime.now();
            emit(DelegationLoaded(
              eligibleDelegates: delegates,
              activeDelegations: active,
              selectedPerson: delegates.isNotEmpty ? delegates.first : null,
              fromDate: now,
              toDate: now.add(const Duration(days: 7)),
            ));
          },
        );
      },
    );
  }

  void selectPerson(DelegatePersonEntity person) {
    final cur = state;
    if (cur is DelegationLoaded) {
      emit(cur.copyWith(selectedPerson: person, clearSuccessMessage: true));
    }
  }

  void setDateRange(DateTime from, DateTime to) {
    final cur = state;
    if (cur is DelegationLoaded) {
      emit(cur.copyWith(
        fromDate: from,
        toDate: to,
        clearSuccessMessage: true,
      ));
    }
  }

  void setScope({required bool isAllScope}) {
    final cur = state;
    if (cur is DelegationLoaded) {
      emit(cur.copyWith(isAllScope: isAllScope, clearSuccessMessage: true));
    }
  }

  void setFinancialLimit(String limit) {
    final cur = state;
    if (cur is DelegationLoaded) {
      emit(cur.copyWith(selectedLimit: limit, clearSuccessMessage: true));
    }
  }

  Future<void> submitDelegation() async {
    final cur = state;
    if (cur is! DelegationLoaded || cur.selectedPerson == null) return;

    emit(cur.copyWith(isSubmitting: true));
    final scopeDesc = cur.isAllScope
        ? 'Tất cả các loại đơn · Hạn mức: ${cur.selectedLimit}'
        : 'Theo từng loại đơn chọn lọc · Hạn mức: ${cur.selectedLimit}';

    final result = await createDelegationUseCase(
      delegatePerson: cur.selectedPerson!,
      fromDate: cur.fromDate,
      toDate: cur.toDate,
      scopeDescription: scopeDesc,
      financialLimitText: cur.selectedLimit,
    );

    result.fold(
      (f) => emit(DelegationError(f.message)),
      (newDelegation) {
        final updatedActive = [newDelegation, ...cur.activeDelegations];
        emit(cur.copyWith(
          activeDelegations: updatedActive,
          isSubmitting: false,
          successMessage: 'created',
        ));
      },
    );
  }

  Future<void> revoke(String delegationId) async {
    final cur = state;
    if (cur is! DelegationLoaded) return;

    emit(cur.copyWith(isSubmitting: true));
    final result = await revokeDelegationUseCase(delegationId);

    result.fold(
      (f) => emit(DelegationError(f.message)),
      (_) {
        final updatedActive = cur.activeDelegations
            .where((d) => d.id != delegationId)
            .toList();
        emit(cur.copyWith(
          activeDelegations: updatedActive,
          isSubmitting: false,
          successMessage: 'revoked',
        ));
      },
    );
  }
}
