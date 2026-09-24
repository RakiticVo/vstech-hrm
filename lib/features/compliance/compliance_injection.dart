import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/features/compliance/data/datasources/compliance_mock_datasource.dart';
import 'package:vstech_hrm/features/compliance/data/repositories/compliance_repository_impl.dart';
import 'package:vstech_hrm/features/compliance/domain/repositories/compliance_repository.dart';
import 'package:vstech_hrm/features/compliance/domain/usecases/compliance_usecases.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/delegation_cubit.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/risk_alerts_cubit.dart';

void initComplianceInjection(GetIt sl) {
  // Datasource
  sl.registerLazySingleton<ComplianceMockDatasource>(
    ComplianceMockDatasourceImpl.new,
  );

  // Repository
  sl.registerLazySingleton<ComplianceRepository>(
    () => ComplianceRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRiskAlertsUseCase(sl()));
  sl.registerLazySingleton(() => AssignRiskToHrUseCase(sl()));
  sl.registerLazySingleton(() => GetEligibleDelegatesUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveDelegationsUseCase(sl()));
  sl.registerLazySingleton(() => CreateDelegationUseCase(sl()));
  sl.registerLazySingleton(() => RevokeDelegationUseCase(sl()));

  // Cubits (factory)
  sl.registerFactory(
    () => RiskAlertsCubit(
      getRiskAlertsUseCase: sl(),
      assignRiskToHrUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => DelegationCubit(
      getEligibleDelegatesUseCase: sl(),
      getActiveDelegationsUseCase: sl(),
      createDelegationUseCase: sl(),
      revokeDelegationUseCase: sl(),
    ),
  );
}
