import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/features/labor_profile/data/datasources/labor_profile_mock_datasource.dart';
import 'package:vstech_hrm/features/labor_profile/data/repositories/labor_profile_repository_impl.dart';
import 'package:vstech_hrm/features/labor_profile/domain/repositories/labor_profile_repository.dart';
import 'package:vstech_hrm/features/labor_profile/domain/usecases/get_labor_profile_usecase.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_cubit.dart';

void initLaborProfileDependencies(GetIt sl) {
  // 1. Data Source
  sl.registerLazySingleton<LaborProfileDataSource>(
    LaborProfileMockDataSource.new,
  );

  // 2. Repository
  sl.registerLazySingleton<LaborProfileRepository>(
    () => LaborProfileRepositoryImpl(sl<LaborProfileDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetLaborProfileUseCase>(
    () => GetLaborProfileUseCase(sl<LaborProfileRepository>()),
  );

  // 4. Cubit
  sl.registerFactory<LaborProfileCubit>(
    () => LaborProfileCubit(
      getLaborProfileUseCase: sl<GetLaborProfileUseCase>(),
    ),
  );
}
