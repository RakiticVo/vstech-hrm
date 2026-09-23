import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/features/qr_auth/data/datasources/qr_auth_mock_datasource.dart';
import 'package:vstech_hrm/features/qr_auth/data/repositories/qr_auth_repository_impl.dart';
import 'package:vstech_hrm/features/qr_auth/domain/repositories/qr_auth_repository.dart';
import 'package:vstech_hrm/features/qr_auth/domain/usecases/qr_auth_usecases.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/cubit/qr_scanner_cubit.dart';

void initQrAuthDependencies(GetIt sl) {
  // 1. Data Source
  sl.registerLazySingleton<QrAuthDataSource>(
    QrAuthMockDataSource.new,
  );

  // 2. Repository
  sl.registerLazySingleton<QrAuthRepository>(
    () => QrAuthRepositoryImpl(sl<QrAuthDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<ParseQrPayloadUseCase>(
    () => ParseQrPayloadUseCase(sl<QrAuthRepository>()),
  );
  sl.registerLazySingleton<ApproveQrLoginUseCase>(
    () => ApproveQrLoginUseCase(sl<QrAuthRepository>()),
  );
  sl.registerLazySingleton<RejectQrLoginUseCase>(
    () => RejectQrLoginUseCase(sl<QrAuthRepository>()),
  );

  // 4. Cubit
  sl.registerFactory<QrScannerCubit>(
    () => QrScannerCubit(
      parseQrPayloadUseCase: sl<ParseQrPayloadUseCase>(),
      approveQrLoginUseCase: sl<ApproveQrLoginUseCase>(),
      rejectQrLoginUseCase: sl<RejectQrLoginUseCase>(),
    ),
  );
}
