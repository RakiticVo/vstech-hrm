import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/constants/environment.dart';
import 'package:vstech_hrm/core/network/auth_interceptor.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/core/network/mock_dio_interceptor.dart';

/// Configured Dio HTTP client adhering to Clean Architecture networking layer.
class DioClient {
  new({
    required FlutterSecureStorage secureStorage,
    Dio? dio,
    void Function()? onAuthExpired,
  }) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.apiTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConstants.apiTimeoutMs),
      headers: const <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Mock Interceptor intercepts requests before network if USE_MOCK_DATA is true
    if (EnvConfig.useMockData) {
      _dio.interceptors.add(MockDioInterceptor());
    }

    // Auth Bearer token injection & expiration handler
    _dio.interceptors.add(
      AuthInterceptor(
        secureStorage: secureStorage,
        onAuthExpired: onAuthExpired,
      ),
    );

    // Logging only in dev/debug mode
    if (EnvConfig.isDev || kDebugMode) {
      _dio.interceptors.add(createLoggingInterceptor());
    }
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
