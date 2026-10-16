import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/features/executive/data/datasources/executive_mock_datasource.dart';
import 'package:vstech_hrm/features/executive/data/repositories/executive_repository_impl.dart';
import 'package:vstech_hrm/features/executive/domain/repositories/executive_repository.dart';
import 'package:vstech_hrm/features/executive/domain/usecases/executive_usecases.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/executive_cubit.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/final_approval_cubit.dart';

void initExecutiveInjection(GetIt sl) {
  // 1. Data Source
  sl.registerLazySingleton<ExecutiveMockDataSource>(ExecutiveMockDataSource.new);

  // 2. Repository
  sl.registerLazySingleton<ExecutiveRepository>(
    () => ExecutiveRepositoryImpl(sl<ExecutiveMockDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetExecutiveOverviewUseCase>(
    () => GetExecutiveOverviewUseCase(sl<ExecutiveRepository>()),
  );
  sl.registerLazySingleton<GetFinalApprovalQueueUseCase>(
    () => GetFinalApprovalQueueUseCase(sl<ExecutiveRepository>()),
  );
  sl.registerLazySingleton<ApproveFinalRequestUseCase>(
    () => ApproveFinalRequestUseCase(sl<ExecutiveRepository>()),
  );
  sl.registerLazySingleton<RejectFinalRequestUseCase>(
    () => RejectFinalRequestUseCase(sl<ExecutiveRepository>()),
  );
  sl.registerLazySingleton<ApproveAllFinalRequestsUseCase>(
    () => ApproveAllFinalRequestsUseCase(sl<ExecutiveRepository>()),
  );

  // 4. Cubits
  sl.registerFactory<ExecutiveCubit>(
    () => ExecutiveCubit(
      getExecutiveOverviewUseCase: sl<GetExecutiveOverviewUseCase>(),
    ),
  );
  sl.registerFactory<FinalApprovalCubit>(
    () => FinalApprovalCubit(
      getFinalApprovalQueueUseCase: sl<GetFinalApprovalQueueUseCase>(),
      approveFinalRequestUseCase: sl<ApproveFinalRequestUseCase>(),
      rejectFinalRequestUseCase: sl<RejectFinalRequestUseCase>(),
      approveAllFinalRequestsUseCase: sl<ApproveAllFinalRequestsUseCase>(),
    ),
  );
}
