import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:vstech_hrm/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/login_usecase.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/logout_usecase.dart';

/// Dependency injection bindings for Auth feature.
void initAuthInjection(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // UseCases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<CheckAuthUseCase>(
    () => CheckAuthUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
}
