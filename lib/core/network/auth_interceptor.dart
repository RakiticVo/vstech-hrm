import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';

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
    if (err.response?.statusCode == 401) {
      _onAuthExpired?.call();
    }
    return handler.next(err);
  }
}
