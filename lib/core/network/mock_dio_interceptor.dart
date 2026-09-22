import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';

/// Interceptor that returns local mock JSON fixtures instead of calling live backend APIs.
class MockDioInterceptor extends Interceptor {
  new({this.simulatedDelay = const Duration(milliseconds: 250)});

  final Duration simulatedDelay;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(simulatedDelay);

    try {
      final path = options.path;

      if (path.contains(ApiEndpoints.login)) {
        return handler.resolve(await _handleLogin(options));
      } else if (path.contains(ApiEndpoints.profile)) {
        return handler.resolve(await _handleProfile(options));
      } else if (path.contains(ApiEndpoints.attendanceToday)) {
        return handler.resolve(
          await _loadFixtureResponse(options, 'assets/mock/attendance_today.json'),
        );
      } else if (path.contains(ApiEndpoints.leaveBalance)) {
        return handler.resolve(
          await _loadFixtureResponse(options, 'assets/mock/leave_balance.json'),
        );
      } else if (path.contains(ApiEndpoints.payrollOverview)) {
        return handler.resolve(
          await _loadFixtureResponse(options, 'assets/mock/payroll_overview.json'),
        );
      } else if (path.contains(ApiEndpoints.attendanceCheckIn) ||
          path.contains(ApiEndpoints.attendanceCheckOut)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'code': 0,
              'message': 'Ghi nhận chấm công thành công',
              'data': <String, dynamic>{
                'id': 'att_${DateTime.now().millisecondsSinceEpoch}',
                'timestamp': DateTime.now().toIso8601String(),
                'type': path.contains('check-out') ? 'checkOut' : 'checkIn',
                'status': 'APPROVED',
                'classification': 'onTime',
                'locationName': 'Trụ sở chính VSTech',
                'lat': 10.7769,
                'lng': 106.7009,
                'bssid': 'vstech-office-5g',
              },
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.leaveRequests) ||
          path.contains(ApiEndpoints.overtimeRequests)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'code': 0,
              'message': 'Thành công',
              'data': <dynamic>[],
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.pendingApprovals)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'code': 0,
              'message': 'Thành công',
              'data': <dynamic>[],
              'meta': <String, dynamic>{'totalPending': 0},
            },
          ),
        );
      }

      // Default fallback mock response
      return handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
          data: <String, dynamic>{
            'code': 0,
            'message': 'Thành công (Mock)',
            'data': <String, dynamic>{},
          },
        ),
      );
    } on Object catch (e) {
      return handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
          data: <String, dynamic>{
            'code': 0,
            'message': 'Mock fallback: $e',
            'data': <String, dynamic>{},
          },
        ),
      );
    }
  }

  Future<Response<dynamic>> _handleLogin(RequestOptions options) async {
    final body = options.data;
    var isManager = false;
    if (body is Map<String, dynamic>) {
      final username = body['username']?.toString().toLowerCase() ?? '';
      if (username.contains('manager') || username.contains('ql')) {
        isManager = true;
      }
    }

    final fixture = isManager
        ? 'assets/mock/user_manager.json'
        : 'assets/mock/user_employee.json';
    final jsonStr = await rootBundle.loadString(fixture);
    final userJson = jsonDecode(jsonStr) as Map<String, dynamic>;

    return Response<dynamic>(
      requestOptions: options,
      statusCode: 200,
      data: <String, dynamic>{
        'code': 0,
        'message': 'Đăng nhập thành công',
        'data': <String, dynamic>{
          'accessToken': 'mock_jwt_access_token_${DateTime.now().millisecondsSinceEpoch}',
          'refreshToken': 'mock_jwt_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
          'expiresIn': 86400,
          'user': userJson['data'],
        },
      },
    );
  }

  Future<Response<dynamic>> _handleProfile(RequestOptions options) async {
    final authHeader = options.headers['Authorization']?.toString() ?? '';
    final isManager = authHeader.contains('manager');
    final fixture = isManager
        ? 'assets/mock/user_manager.json'
        : 'assets/mock/user_employee.json';
    return await _loadFixtureResponse(options, fixture);
  }

  Future<Response<dynamic>> _loadFixtureResponse(
    RequestOptions options,
    String assetPath,
  ) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final dynamic data = jsonDecode(jsonStr);
    return Response<dynamic>(
      requestOptions: options,
      statusCode: 200,
      data: data,
    );
  }
}
