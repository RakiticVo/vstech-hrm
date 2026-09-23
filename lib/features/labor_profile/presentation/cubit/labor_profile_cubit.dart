import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/features/labor_profile/domain/usecases/get_labor_profile_usecase.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_state.dart';

class LaborProfileCubit extends Cubit<LaborProfileState> {
  new({required this.getLaborProfileUseCase})
      : super(const LaborProfileState());

  final GetLaborProfileUseCase getLaborProfileUseCase;

  Future<void> loadProfile() async {
    emit(state.copyWith(status: LaborProfileStatus.loading));
    final result = await getLaborProfileUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LaborProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: LaborProfileStatus.success,
          profile: profile,
        ),
      ),
    );
  }
}
