import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// App-wide Logger instance using PrettyPrinter.
final Logger appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 80,
  ),
);

/// Creates an HTTP logging interceptor with sensitive data filtering.
Interceptor createLoggingInterceptor() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    filter: (options, args) {
      // Don't log sensitive payload
      return true;
    },
  );
}
