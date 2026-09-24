import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/locale_cubit.dart';
import 'package:vstech_hrm/core/session/theme_cubit.dart';
import 'package:vstech_hrm/features/announcements/announcements_injection.dart';
import 'package:vstech_hrm/features/attendance/attendance_injection.dart';
import 'package:vstech_hrm/features/compliance/compliance_injection.dart';
import 'package:vstech_hrm/features/executive/executive_injection.dart';
import 'package:vstech_hrm/features/labor_profile/labor_profile_injection.dart';
import 'package:vstech_hrm/features/qr_auth/qr_auth_injection.dart';

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

  // 4. Global Session, Theme & Locale Cubits
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(secureStorage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(secureStorage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(secureStorage: sl<FlutterSecureStorage>()),
  );

  // 5. Feature Modules
  initAttendanceDependencies(sl);
  initAnnouncementsDependencies(sl);
  initLaborProfileDependencies(sl);
  initQrAuthDependencies(sl);
  initExecutiveInjection(sl);
  initComplianceInjection(sl);
}
