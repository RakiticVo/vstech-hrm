import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';

/// Interceptor that attaches the Bearer JWT token to outbound requests.
class AuthInterceptor extends Interceptor {
  new({
    required this._secureStorage,
    this._onAuthExpired,
  });

  final FlutterSecureStorage _secureStorage;
  final void Function()? _onAuthExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If request already has Authorization header, skip
    if (!options.headers.containsKey('Authorization')) {
      final token = await _secureStorage.read(key: AppConstants.tokenStorageKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final path = err.requestOptions.path;
    final isAuthPath = path.contains('/Account') || path.contains('/login');
    if (!isAuthPath) {
      final statusCode = err.response?.statusCode;
      if (statusCode == 401) {
        _onAuthExpired?.call();
      } else if (statusCode == 400 || statusCode == 403) {
        final message = ApiErrorHandler.extractErrorMessage(err).toLowerCase();
        if (message.contains('phiên đăng nhập') ||
            message.contains('hết hạn') ||
            message.contains('đăng nhập lại') ||
            message.contains('đăng xuất ra') ||
            message.contains('token expired') ||
            message.contains('session expired')) {
          _onAuthExpired?.call();
        }
      }
    }
    return handler.next(err);
  }
}
