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

  static Environment get current =>
      Environment.fromString(dotenv.env['ENVIRONMENT']);

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.dev.vstech-hrm.example.com';

  static bool get useMockData =>
      (dotenv.env['USE_MOCK_DATA'] ?? 'false').toLowerCase() == 'true';

  static bool get isDev => current == Environment.dev;
  static bool get isProd => current == Environment.prod;
}
