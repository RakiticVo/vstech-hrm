import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment {
  dev,
  prod;

  static Environment fromString(String? value) {
    if (value?.toLowerCase() == 'prod' || value?.toLowerCase() == 'production') {
      return Environment.prod;
    }
    return Environment.dev;
  }
}

class EnvConfig {
  const new _();

  static String? _getEnv(String key) {
    return dotenv.isInitialized ? dotenv.env[key] : null;
  }

  static Environment get current =>
      Environment.fromString(_getEnv('ENVIRONMENT'));

  static String get apiBaseUrl =>
      _getEnv('API_BASE_URL') ?? 'https://api.dev.vstech-hrm.example.com';

  static String get faceApiBaseUrl =>
      _getEnv('FACE_API_BASE_URL') ?? 'https://face.vitinhkimhung.com';

  static String get faceAppCode =>
      _getEnv('FACE_APP_CODE') ?? 'HRM';

  static bool get useMockData =>
      (_getEnv('USE_MOCK_DATA') ?? 'false').toLowerCase() == 'true';

  static bool get isDev => current == Environment.dev;
  static bool get isProd => current == Environment.prod;
}
