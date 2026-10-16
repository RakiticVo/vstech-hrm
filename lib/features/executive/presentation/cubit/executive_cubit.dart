import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/features/executive/domain/usecases/executive_usecases.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/executive_state.dart';

class ExecutiveCubit extends Cubit<ExecutiveState> {
  new({required this.getExecutiveOverviewUseCase}) : super(const ExecutiveState());

  final GetExecutiveOverviewUseCase getExecutiveOverviewUseCase;

  Future<void> loadOverview() async {
    emit(state.copyWith(status: ExecutiveStatus.loading));
    final result = await getExecutiveOverviewUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExecutiveStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (stats) => emit(
        state.copyWith(
          status: ExecutiveStatus.success,
          stats: stats,
        ),
      ),
    );
  }
}
