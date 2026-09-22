class AppConstants {
  const new _();

  static const String appName = 'VSTech HRM';
  static const String appVersion = '1.0.0';

  // Secure Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String tokenStorageKey = keyAccessToken;
  static const String refreshTokenStorageKey = keyRefreshToken;
  static const String keyUserRole = 'user_role';
  static const String keyUserId = 'user_id';
  static const String keyDeviceFingerprint = 'device_fingerprint';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyPinHash = 'user_pin_hash';

  // Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';

  // Network timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const int apiTimeoutMs = 15000;
}
