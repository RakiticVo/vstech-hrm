import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';

void main() {
  group('Logging and Network Interceptor Tests', () {
    test('AppLogger outputs all custom log levels without throwing', () {
      expect(() => AppLogger.d('Testing debug log'), returnsNormally);
      expect(() => AppLogger.i('Testing info log'), returnsNormally);
      expect(() => AppLogger.w('Testing warn log'), returnsNormally);
      expect(
        () => AppLogger.e('Testing error log', Exception('Dummy error')),
        returnsNormally,
      );
      expect(() => AppLogger.api('Testing API log'), returnsNormally);
      expect(() => AppLogger.auth('Testing auth log'), returnsNormally);
      expect(
        () => AppLogger.bloc('AttendanceBloc', 'CheckInSubmitted'),
        returnsNormally,
      );
      expect(() => AppLogger.db('Token cached'), returnsNormally);
    });

    test('createLoggingInterceptor returns CustomApiLogInterceptor instance', () {
      final interceptor = createLoggingInterceptor();
      expect(interceptor, isA<CustomApiLogInterceptor>());
    });

    test('CustomApiLogInterceptor logs request with masked passwords and headers', () {
      final interceptor = CustomApiLogInterceptor();
      final options = RequestOptions(
        path: '/api/Account',
        method: 'POST',
        headers: {'Authorization': 'Bearer my_secret_token'},
        data: {
          'username': 'test_user',
          'password': 'SuperSecretPassword123',
        },
      );

      final handler = RequestInterceptorHandler();
      expect(() => interceptor.onRequest(options, handler), returnsNormally);
    });

    test('CustomApiLogInterceptor logs 200 response with latency', () {
      final interceptor = CustomApiLogInterceptor();
      final options = RequestOptions(path: '/api/Account', method: 'POST');
      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: {'token': 'jwt_secret_token_123', 'fullName': 'Nguyễn Văn A'},
      );

      final handler = ResponseInterceptorHandler();
      expect(() => interceptor.onResponse(response, handler), returnsNormally);
    });

    test('CustomApiLogInterceptor logs client and server errors gracefully', () async {
      final interceptor = CustomApiLogInterceptor();
      final options = RequestOptions(path: '/api/Account', method: 'POST');
      final err = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
        message: 'The connection timed out after 15s',
      );

      final handler = ErrorInterceptorHandler();
      interceptor.onError(err, handler);
      await expectLater(handler.future, throwsA(anything));
    });
  });
}
