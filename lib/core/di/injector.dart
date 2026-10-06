import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/core/network/face_dio_client.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/locale_cubit.dart';
import 'package:vstech_hrm/core/session/theme_cubit.dart';
import 'package:vstech_hrm/features/announcements/announcements_injection.dart';
import 'package:vstech_hrm/features/attendance/attendance_injection.dart';
import 'package:vstech_hrm/features/auth/auth_injection.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/login_usecase.dart';
import 'package:vstech_hrm/features/compliance/compliance_injection.dart';
import 'package:vstech_hrm/features/executive/executive_injection.dart';
import 'package:vstech_hrm/features/approvals/approvals_injection.dart';
import 'package:vstech_hrm/features/holidays/holidays_injection.dart';
import 'package:vstech_hrm/features/labor_profile/labor_profile_injection.dart';
import 'package:vstech_hrm/features/notifications/notifications_injection.dart';
import 'package:vstech_hrm/features/payroll/payroll_injection.dart';
import 'package:vstech_hrm/features/qr_auth/qr_auth_injection.dart';
import 'package:vstech_hrm/features/requests/requests_injection.dart';

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

  // 3. Network Clients
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      secureStorage: sl<FlutterSecureStorage>(),
      onAuthExpired: () {
        unawaited(sl<AuthCubit>().logout());
      },
    ),
  );
  sl.registerLazySingleton<FaceDioClient>(() => FaceDioClient());

  // 4. Feature Modules
  initAuthInjection(sl);
  initAttendanceDependencies(sl);
  initAnnouncementsDependencies(sl);
  initLaborProfileDependencies(sl);
  initQrAuthDependencies(sl);
  initRequestsDependencies(sl);
  initApprovalsDependencies(sl);
  initPayrollDependencies(sl);
  initHolidaysDependencies(sl);
  initNotificationsDependencies(sl);
  initExecutiveInjection(sl);
  initComplianceInjection(sl);

  // 5. Global Session, Theme & Locale Cubits
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      secureStorage: sl<FlutterSecureStorage>(),
      loginUseCase: sl<LoginUseCase>(),
      checkAuthUseCase: sl<CheckAuthUseCase>(),
    ),
  );
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(secureStorage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(secureStorage: sl<FlutterSecureStorage>()),
  );
}

