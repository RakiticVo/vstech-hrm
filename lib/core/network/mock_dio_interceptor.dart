import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/mock_approval_data.dart';

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

      if (path.endsWith(ApiEndpoints.login)) {
        return handler.resolve(await _handleLogin(options));
      } else if (path.endsWith(ApiEndpoints.checkAuth)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: '',
          ),
        );
      } else if (path.endsWith(ApiEndpoints.accountBasic)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'message': '',
              'data': <String, dynamic>{
                'id': 1,
                'employeeCode': 'NV0142',
                'employeeName': 'Nguyễn Văn An',
                'departmentName': 'Bộ phận Phát triển Mobile',
                'positionName': 'Kỹ sư phần mềm',
              },
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.accountProfile)) {
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
              'message': path.contains('Checkin')
                  ? 'Ghi nhận chấm công vào ca thành công'
                  : 'Ghi nhận chấm công ra ca thành công',
              if (path.contains('Checkin')) 'checkin': true,
              if (path.contains('Checkout')) 'checkout': true,
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.leaveRequestsAdminMobile)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'message': '',
              'data': MockApprovalData.leaveRequests,
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.overtimeRequestsAdminMobile)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'items': MockApprovalData.overtimeRequests,
            },
          ),
        );
      } else if (path.contains('/confirm/') ||
          path.contains('/reject/') ||
          path.contains('/accept/') ||
          path.contains('/deny/') ||
          path.contains('/Deny/')) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'code': 0,
              'message': 'Phê duyệt phiếu thành công',
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.timesheetsMobile)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'items': MockApprovalData.timesheetMobileItems,
              'depts': <dynamic>[],
              'statuses': <dynamic>[],
              'employees': <dynamic>[],
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.timesheetAdminConfirm)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'code': 0,
              'message': 'Xác nhận giờ công thành công',
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.timesheetReject)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'code': 0,
              'message': 'Từ chối giờ công thành công',
            },
          ),
        );
      } else if (path.contains(ApiEndpoints.timesheetConfirmRequests)) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: <String, dynamic>{
              'message': '',
              'data': MockApprovalData.timesheetConfirmRequests,
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
              'results': <dynamic>[],
              'total': 0,
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
    final dynamic body = options.data;
    var isManager = false;
    var isHrAdmin = false;
    var username = 'NV0142';
    if (body is Map<String, dynamic>) {
      username = body['username']?.toString() ?? 'NV0142';
      final lower = username.toLowerCase();
      if (lower.contains('admin') || lower.contains('hr')) {
        isHrAdmin = true;
        isManager = true;
      } else if (lower.contains('manager') || lower.contains('ql')) {
        isManager = true;
      }
    }

    final now = DateTime.now();
    final validTo = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 23:59';

    final userJson = isManager
        ? <String, dynamic>{
            'id': isHrAdmin ? 3 : 2,
            'userCode': isHrAdmin ? 'HR0001' : 'NV0089',
            'userName': isHrAdmin ? 'le.hoang' : 'tran.mai',
            'employeeName': isHrAdmin ? 'Lê Hoàng HR' : 'Trần Thị Mai',
            'employeeCode': isHrAdmin ? 'HR0001' : 'NV0089',
            'email': isHrAdmin ? 'hr.admin@vstech.vn' : 'tran.mai@vstech.vn',
            'avatar': isHrAdmin ? 'avatars/hr0001.png' : 'avatars/nv0089.png',
            'claims': isHrAdmin
                ? <String>['attendance.checkin', 'leave.create', 'overtime.create', 'hr:admin']
                : <String>['attendance.checkin', 'leave.create', 'overtime.create', 'manager.approve'],
            'allowFaceRegisterTo': '2026-12-31',
            'isFaceRegistered': true,
            'allowFaceEnroll': true,
          }
        : <String, dynamic>{
            'id': 1,
            'userCode': username,
            'userName': username.toLowerCase(),
            'employeeName': 'Nguyễn Văn An',
            'employeeCode': username,
            'email': 'nguyen.an@vstech.vn',
            'avatar': 'avatars/nv0142.png',
            'claims': <String>['attendance.checkin', 'leave.create', 'overtime.create'],
            'allowFaceRegisterTo': '2026-12-31',
            'isFaceRegistered': true,
            'allowFaceEnroll': true,
          };

    return Response<dynamic>(
      requestOptions: options,
      statusCode: 200,
      data: <String, dynamic>{
        'token': 'mock_jwt_${isManager ? 'manager' : 'employee'}_${DateTime.now().millisecondsSinceEpoch}',
        'validTo': validTo,
        'webAllowed': 'NV0142,NV0089',
        'user': userJson,
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
