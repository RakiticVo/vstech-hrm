import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// App-wide custom Logger with distinct levels, emojis, colors, and timestamps.
class AppLogger {
  // Private constructor prevents instantiation.
  // ignore: unnecessary_type_name_in_constructor
  const AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      lineLength: 90,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static final Logger _errorLogger = Logger(
    printer: PrettyPrinter(
      methodCount: 3,
      lineLength: 90,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Debug log (Development inspection, data state)
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d('🔍 [DEBUG] $message', error: error, stackTrace: stackTrace);
  }

  /// Info log (General operational info, screen navigation)
  static void i(dynamic message) {
    _logger.i('💡 [INFO] $message');
  }

  /// Warning log (Recoverable warnings, fallbacks)
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w('⚠️ [WARN] $message', error: error, stackTrace: stackTrace);
  }

  /// Error log (Exceptions with structured trace)
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _errorLogger.e('⛔ [ERROR] $message', error: error, stackTrace: stackTrace);
  }

  /// Network / API high-level summary
  static void api(String message) {
    _logger.i('🌐 [API] $message');
  }

  /// Authentication & Security events (Login, tokens, biometrics)
  static void auth(String message) {
    _logger.i('🔐 [AUTH] $message');
  }

  /// BLoC / State Management transitions
  static void bloc(String blocName, String eventOrState) {
    _logger.d('⚡ [BLOC] $blocName -> $eventOrState');
  }

  /// Cache & SecureStorage operations
  static void db(String message) {
    _logger.d('💾 [CACHE] $message');
  }
}

/// Legacy app-wide Logger instance using PrettyPrinter (for backwards compatibility).
final Logger appLogger = AppLogger._logger;

/// Custom Dio logging interceptor with vibrant colors, single-box layout,
/// round-trip latency calculation, and sensitive data protection.
class CustomApiLogInterceptor extends Interceptor {
  new() {
    _reqLogger = _createLogger(const AnsiColor.fg(14)); // Cyan
    _successLogger = _createLogger(const AnsiColor.fg(40)); // Vibrant Green
    _redirectLogger = _createLogger(const AnsiColor.fg(226)); // Yellow
    _clientErrLogger = _createLogger(const AnsiColor.fg(208)); // Orange
    _authErrLogger = _createLogger(const AnsiColor.fg(201)); // Magenta/Purple
    _serverErrLogger = _createLogger(const AnsiColor.fg(196)); // Bright Red
  }

  late final Logger _reqLogger;
  late final Logger _successLogger;
  late final Logger _redirectLogger;
  late final Logger _clientErrLogger;
  late final Logger _authErrLogger;
  late final Logger _serverErrLogger;

  static const String _startTimeKey = '_vstech_req_start_time_';
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static Logger _createLogger(AnsiColor color) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        lineLength: 85,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        levelColors: {
          Level.debug: color,
          Level.info: color,
          Level.warning: color,
          Level.error: color,
        },
      ),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startTimeKey] = DateTime.now().millisecondsSinceEpoch;

    final method = options.method.toUpperCase();
    final url = options.uri.toString();
    final buffer = StringBuffer('🚀 [API REQUEST] >> $method $url\n');

    // Headers (excluding internal and masking authorization)
    if (options.headers.isNotEmpty) {
      final safeHeaders = Map<String, dynamic>.from(options.headers);
      if (safeHeaders.containsKey('Authorization')) {
        safeHeaders['Authorization'] = 'Bearer ••••••••';
      }
      buffer.writeln('Headers: $safeHeaders');
    }

    // Query parameters
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('Query: ${options.queryParameters}');
    }

    // Body with sensitive masking
    if (options.data != null) {
      final masked = _maskSensitive(options.data);
      buffer.writeln('Body:\n${_formatBody(masked)}');
    }

    _reqLogger.d(buffer.toString().trimRight());
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final start = response.requestOptions.extra[_startTimeKey] as int?;
    final duration = start != null
        ? '${DateTime.now().millisecondsSinceEpoch - start}ms'
        : '--ms';

    final statusCode = response.statusCode ?? 200;
    final method = response.requestOptions.method.toUpperCase();
    final path = response.requestOptions.uri.path;
    final buffer = StringBuffer();

    if (statusCode >= 200 && statusCode < 300) {
      buffer.writeln('🟢 [API RESPONSE: $statusCode OK] ($duration) >> $method $path');
      if (response.data != null) {
        final masked = _maskSensitive(response.data);
        buffer.writeln('Body:\n${_formatBody(masked)}');
      }
      _successLogger.i(buffer.toString().trimRight());
    } else if (statusCode >= 300 && statusCode < 400) {
      buffer.writeln('🟡 [API REDIRECT: $statusCode] ($duration) >> $method $path');
      _redirectLogger.w(buffer.toString().trimRight());
    } else if (statusCode == 401 || statusCode == 403) {
      buffer.writeln('🔒 [API AUTH ERROR: $statusCode] ($duration) >> $method $path');
      if (response.data != null) {
        final masked = _maskSensitive(response.data);
        buffer.writeln('Body:\n${_formatBody(masked)}');
      }
      _authErrLogger.w(buffer.toString().trimRight());
    } else {
      buffer.writeln('🟠 [API CLIENT ERROR: $statusCode] ($duration) >> $method $path');
      if (response.data != null) {
        final masked = _maskSensitive(response.data);
        buffer.writeln('Body:\n${_formatBody(masked)}');
      }
      _clientErrLogger.w(buffer.toString().trimRight());
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final start = err.requestOptions.extra[_startTimeKey] as int?;
    final duration = start != null
        ? '${DateTime.now().millisecondsSinceEpoch - start}ms'
        : '--ms';

    final statusCode = err.response?.statusCode;
    final method = err.requestOptions.method.toUpperCase();
    final url = err.requestOptions.uri.toString();
    final statusText = statusCode != null ? '$statusCode' : err.type.name;

    final buffer = StringBuffer('🔴 [API ERROR: $statusText] ($duration) >> $method $url\n');

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      buffer.writeln('Reason: Kết nối máy chủ quá thời gian (Timeout). Kiểm tra IP ${err.requestOptions.uri.host}:${err.requestOptions.uri.port}');
    } else if (err.message != null && err.message!.isNotEmpty) {
      buffer.writeln('Message: ${err.message}');
    }

    if (err.response?.data != null) {
      final masked = _maskSensitive(err.response!.data);
      buffer.writeln('Response:\n${_formatBody(masked)}');
    }

    _serverErrLogger.e(buffer.toString().trimRight());
    handler.next(err);
  }

  static dynamic _maskSensitive(dynamic data) {
    if (data is Map<String, dynamic>) {
      final result = <String, dynamic>{};
      for (final entry in data.entries) {
        final key = entry.key.toLowerCase();
        if (key.contains('password') ||
            key.contains('pin') ||
            key.contains('token') ||
            key.contains('secret') ||
            key.contains('vector') ||
            key.contains('fingerprint')) {
          result[entry.key] = '••••••••';
        } else if (entry.value is Map<String, dynamic> || entry.value is List) {
          result[entry.key] = _maskSensitive(entry.value);
        } else {
          result[entry.key] = entry.value;
        }
      }
      return result;
    } else if (data is List) {
      return data.map(_maskSensitive).toList();
    }
    return data;
  }

  static String _formatBody(dynamic data) {
    try {
      if (data is String) {
        final parsed = jsonDecode(data);
        return _encoder.convert(parsed);
      }
      return _encoder.convert(data);
    } on Object catch (_) {
      return data.toString();
    }
  }
}

/// Factory function to create the custom HTTP logging interceptor.
Interceptor createLoggingInterceptor() {
  return CustomApiLogInterceptor();
}
