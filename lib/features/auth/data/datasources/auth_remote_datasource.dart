import 'package:dio/dio.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/auth/data/models/employee_basic_info_model.dart';
import 'package:vstech_hrm/features/auth/data/models/login_request_model.dart';
import 'package:vstech_hrm/features/auth/data/models/login_result_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResultModel> login(LoginRequestModel request);
  Future<EmployeeBasicInfoModel> getBasicInfo();
  Future<Map<String, dynamic>> getFullProfile();
  Future<bool> checkAuth();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const new({required this._dioClient});

  final DioClient _dioClient;

  @override
  Future<LoginResultModel> login(LoginRequestModel request) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return LoginResultModel.fromJson(data);
      }
      throw const ServerException(message: 'Phản hồi đăng nhập không hợp lệ');
    } on DioException catch (e) {
      final dynamic errorData = e.response?.data;
      final statusCode = e.response?.statusCode;
      if (errorData is String && errorData.isNotEmpty) {
        throw ServerException(message: errorData, statusCode: statusCode);
      } else if (errorData is Map<String, dynamic>) {
        final msg = errorData['message']?.toString() ??
            errorData['error']?.toString() ??
            'Đăng nhập không thành công';
        throw ServerException(message: msg, statusCode: statusCode);
      }
      if (statusCode == 401) {
        throw const AuthException(message: 'Tài khoản hoặc mật khẩu không chính xác');
      }
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ khi đăng nhập',
        statusCode: statusCode,
      );
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi không xác định khi đăng nhập: $e');
    }
  }

  @override
  Future<EmployeeBasicInfoModel> getBasicInfo() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.accountBasic);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return EmployeeBasicInfoModel.fromJson(data);
      }
      return const EmployeeBasicInfoModel();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải thông tin tài khoản: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getFullProfile() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.accountProfile);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      return <String, dynamic>{};
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải hồ sơ nhân viên: $e');
    }
  }

  @override
  Future<bool> checkAuth() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.checkAuth);
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }
      throw ServerException(
        message: 'Lỗi kiểm tra phiên: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi kiểm tra phiên: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post<dynamic>(ApiEndpoints.logout);
    } on Object {
      // Ignore network or token expiration errors on logout to allow local cleanup
    }
  }
}
