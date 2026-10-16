import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';

void main() {
  group('ApiErrorHandler.extractErrorMessage', () {
    test('extracts message from json map with "message" key', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/leave'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/leave'),
          statusCode: 400,
          data: <String, dynamic>{
            'message': 'Đơn xin phép tại cho ngày này đã tồn tại',
            'isLogout': false,
          },
        ),
      );

      final msg = ApiErrorHandler.extractErrorMessage(dioException);
      expect(msg, 'Đơn xin phép tại cho ngày này đã tồn tại');
    });

    test('extracts message from json map with "error" key', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 400,
          data: <String, dynamic>{'error': 'Dữ liệu không hợp lệ'},
        ),
      );

      final msg = ApiErrorHandler.extractErrorMessage(dioException);
      expect(msg, 'Dữ liệu không hợp lệ');
    });

    test('extracts message from validation errors dictionary', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 400,
          data: <String, dynamic>{
            'errors': <String, dynamic>{
              'Date': ['Ngày không đúng định dạng'],
            },
          },
        ),
      );

      final msg = ApiErrorHandler.extractErrorMessage(dioException);
      expect(msg, 'Ngày không đúng định dạng');
    });

    test('extracts message from stringified JSON response', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 400,
          data: '{"message":"Tài khoản chưa được kích hoạt"}',
        ),
      );

      final msg = ApiErrorHandler.extractErrorMessage(dioException);
      expect(msg, 'Tài khoản chưa được kích hoạt');
    });

    test('falls back to connection timeout Vietnamese message', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final msg = ApiErrorHandler.extractErrorMessage(dioException);
      expect(msg, 'Kết nối máy chủ quá thời gian. Vui lòng thử lại.');
    });

    test('falls back to HTTP status 401 expiration message', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 401,
        ),
      );

      final msg = ApiErrorHandler.extractErrorMessage(dioException);
      expect(msg, 'Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.');
    });

    test('returns AppException message when AppException is passed', () {
      const exception = ServerException(message: 'Lỗi nghiệp vụ');
      final msg = ApiErrorHandler.extractErrorMessage(exception);
      expect(msg, 'Lỗi nghiệp vụ');
    });

    test('uses fallback message when error data is null and no special status', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
      );

      final msg = ApiErrorHandler.extractErrorMessage(dioException, 'Fallback lỗi');
      expect(msg, 'Fallback lỗi');
    });
  });

  group('ApiErrorHandler.toServerException', () {
    test('creates ServerException with message and status code', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/leave'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/leave'),
          statusCode: 400,
          data: <String, dynamic>{
            'message': 'Đơn xin phép tại cho ngày này đã tồn tại',
          },
        ),
      );

      final serverException = ApiErrorHandler.toServerException(dioException);
      expect(serverException.message, 'Đơn xin phép tại cho ngày này đã tồn tại');
      expect(serverException.statusCode, 400);
    });
  });
}
