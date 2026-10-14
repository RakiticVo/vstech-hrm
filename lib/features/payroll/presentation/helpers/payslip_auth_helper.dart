import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/features/auth/domain/entities/login_params.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';

/// Helper for biometric and password verification in payslip authentication.
class PayslipAuthHelper {
  const new _();

  /// Checks if biometrics is both enabled in settings and supported by the device.
  static Future<bool> isBiometricsAvailable(LocalAuthentication localAuth) async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final bioEnabledStr = await storage.read(key: AppConstants.keyBiometricEnabled);
      if (bioEnabledStr != 'true') return false;

      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;
      return isSupported || canCheck;
    } on Object {
      return false;
    }
  }

  /// Verifies password against cached credentials or backend API.
  static Future<bool> verifyPassword({
    required String password,
    required bool isDemo,
    required String? employeeCode,
  }) async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final savedPass = await storage.read(key: AppConstants.keySavedPassword);

      if (savedPass != null && savedPass.isNotEmpty) {
        if (savedPass == password) return true;
        if (isDemo) return false;
      }

      if (isDemo) {
        final isMatch = password == '123456' || password == 'admin' || password == 'password';
        if (isMatch) {
          await storage.write(key: AppConstants.keySavedPassword, value: password);
          return true;
        }
        return false;
      }

      final savedUser = await storage.read(key: AppConstants.keySavedUsername);
      final username = (savedUser?.isNotEmpty == true)
          ? savedUser!
          : (employeeCode?.isNotEmpty == true ? employeeCode! : 'nv0142');

      final res = await sl<AuthRepository>().login(
        LoginParams(username: username, password: password),
      );

      return await res.fold(
        (_) => false,
        (_) async {
          await storage.write(key: AppConstants.keySavedPassword, value: password);
          return true;
        },
      );
    } on Object {
      return false;
    }
  }
}
