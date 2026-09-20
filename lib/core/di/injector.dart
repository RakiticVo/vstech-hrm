import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';

final GetIt sl = GetIt.instance;

/// Registers all core services, storage, networking, and global cubits.
Future<void> initDependencies() async {
  // 1. External & Platform Services
  const secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // 2. Logging
  sl.registerLazySingleton(() => appLogger);

  // 3. Network Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      secureStorage: sl<FlutterSecureStorage>(),
      onAuthExpired: () {
        unawaited(sl<AuthCubit>().logout());
      },
    ),
  );

  // 4. Global Session & Auth Cubit
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(secureStorage: sl<FlutterSecureStorage>()),
  );
}
