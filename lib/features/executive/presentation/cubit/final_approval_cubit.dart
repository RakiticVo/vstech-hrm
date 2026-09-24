import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/features/executive/domain/usecases/executive_usecases.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/final_approval_state.dart';

class FinalApprovalCubit extends Cubit<FinalApprovalState> {
  new({
    required this.getFinalApprovalQueueUseCase,
    required this.approveFinalRequestUseCase,
    required this.rejectFinalRequestUseCase,
    required this.approveAllFinalRequestsUseCase,
  }) : super(const FinalApprovalState());

  final GetFinalApprovalQueueUseCase getFinalApprovalQueueUseCase;
  final ApproveFinalRequestUseCase approveFinalRequestUseCase;
  final RejectFinalRequestUseCase rejectFinalRequestUseCase;
  final ApproveAllFinalRequestsUseCase approveAllFinalRequestsUseCase;

  Future<void> loadQueue() async {
    emit(state.copyWith(status: FinalApprovalStatus.loading));
    final result = await getFinalApprovalQueueUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FinalApprovalStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (queue) => emit(
        state.copyWith(
          status: FinalApprovalStatus.success,
          queue: queue,
        ),
      ),
    );
  }

  Future<void> approveItem(String id) async {
    emit(state.copyWith(isActionLoading: true));
    final result = await approveFinalRequestUseCase(id);
    result.fold(
      (failure) => emit(
        state.copyWith(isActionLoading: false, errorMessage: failure.message),
      ),
      (_) {
        final updated = state.queue.where((item) => item.id != id).toList();
        emit(
          state.copyWith(
            isActionLoading: false,
            queue: updated,
            userMessage: 'Đã phê duyệt cuối thành công.',
          ),
        );
      },
    );
  }

  Future<void> rejectItem(String id, {String? reason}) async {
    emit(state.copyWith(isActionLoading: true));
    final result = await rejectFinalRequestUseCase(id, reason: reason);
    result.fold(
      (failure) => emit(
        state.copyWith(isActionLoading: false, errorMessage: failure.message),
      ),
      (_) {
        final updated = state.queue.where((item) => item.id != id).toList();
        emit(
          state.copyWith(
            isActionLoading: false,
            queue: updated,
            userMessage: 'Đã từ chối đơn đề xuất.',
          ),
        );
      },
    );
  }

  Future<void> approveAll() async {
    emit(state.copyWith(isActionLoading: true));
    final result = await approveAllFinalRequestsUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(isActionLoading: false, errorMessage: failure.message),
      ),
      (_) {
        emit(
          state.copyWith(
            isActionLoading: false,
            queue: const [],
            userMessage: 'Đã phê duyệt toàn bộ các đơn trong hàng đợi!',
          ),
        );
      },
    );
  }
}
