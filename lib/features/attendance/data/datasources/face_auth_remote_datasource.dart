import 'package:dio/dio.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/constants/environment.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/face_dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/models/face_action_response_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/face_check_reg_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/face_verify_response_model.dart';

abstract class FaceAuthRemoteDataSource {
  Future<FaceCheckRegModel> checkRegistration(String code, {String? appCode});

  Future<FaceActionResponseModel> registerFace(
    String code,
    String imagePath, {
    String? appCode,
  });

  Future<FaceActionResponseModel> updateFace(
    String code,
    String imagePath, {
    String? appCode,
  });

  Future<FaceActionResponseModel> deleteFace(String code, {String? appCode});

  Future<FaceVerifyResponseModel> verifyFace(
    String code,
    String imagePath, {
    String? appCode,
  });

  Future<FaceVerifyResponseModel> liveVerifyFace(
    String code,
    String imagePath, {
    String? appCode,
  });
}

class FaceAuthRemoteDataSourceImpl implements FaceAuthRemoteDataSource {
  const new({required FaceDioClient faceDioClient}) : _client = faceDioClient;

  final FaceDioClient _client;

  String _resolveAppCode(String? appCode) =>
      appCode?.isNotEmpty == true ? appCode! : EnvConfig.faceAppCode;

  String _parseErrorMessage(Object error, String fallback) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        if (data['detail'] is String && (data['detail'] as String).isNotEmpty) {
          return data['detail'] as String;
        }
        if (data['detail'] is List) {
          final list = data['detail'] as List;
          final msgs = list
              .whereType<Map<String, dynamic>>()
              .map((m) => m['msg']?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList();
          if (msgs.isNotEmpty) return msgs.join(', ');
        }
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          return data['message'].toString();
        }
      }
      if (error.message != null && error.message!.isNotEmpty) {
        return error.message!;
      }
    }
    return '$fallback: $error';
  }

  @override
  Future<FaceCheckRegModel> checkRegistration(String code, {String? appCode}) async {
    try {
      final response = await _client.get<dynamic>(
        FaceApiEndpoints.checkReg,
        queryParameters: {
          'Code': code,
          'AppCode': _resolveAppCode(appCode),
        },
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return FaceCheckRegModel.fromJson(body);
      }
      throw const ServerException(message: 'Phản hồi kiểm tra đăng ký không hợp lệ');
    } on Object catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: _parseErrorMessage(e, 'Lỗi kiểm tra đăng ký khuôn mặt'));
    }
  }

  @override
  Future<FaceActionResponseModel> registerFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: 'register_face.jpg',
      );
      final formData = FormData.fromMap({
        'Code': code,
        'AppCode': _resolveAppCode(appCode),
        'files': [multipartFile],
      });

      final response = await _client.post<dynamic>(
        FaceApiEndpoints.register,
        data: formData,
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return FaceActionResponseModel.fromJson(body);
      }
      throw const ServerException(message: 'Phản hồi đăng ký khuôn mặt không hợp lệ');
    } on Object catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: _parseErrorMessage(e, 'Lỗi đăng ký khuôn mặt'));
    }
  }

  @override
  Future<FaceActionResponseModel> updateFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: 'update_face.jpg',
      );
      final formData = FormData.fromMap({
        'Code': code,
        'AppCode': _resolveAppCode(appCode),
        'file': multipartFile,
      });

      final response = await _client.post<dynamic>(
        FaceApiEndpoints.update,
        data: formData,
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return FaceActionResponseModel.fromJson(body);
      }
      throw const ServerException(message: 'Phản hồi cập nhật khuôn mặt không hợp lệ');
    } on Object catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: _parseErrorMessage(e, 'Lỗi cập nhật khuôn mặt'));
    }
  }

  @override
  Future<FaceActionResponseModel> deleteFace(String code, {String? appCode}) async {
    try {
      final response = await _client.delete<dynamic>(
        FaceApiEndpoints.delete,
        queryParameters: {
          'Code': code,
          'AppCode': _resolveAppCode(appCode),
        },
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return FaceActionResponseModel.fromJson(body);
      }
      throw const ServerException(message: 'Phản hồi xóa khuôn mặt không hợp lệ');
    } on Object catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: _parseErrorMessage(e, 'Lỗi xóa khuôn mặt'));
    }
  }

  @override
  Future<FaceVerifyResponseModel> verifyFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: 'verify_face.jpg',
      );
      final formData = FormData.fromMap({
        'Code': code,
        'AppCode': _resolveAppCode(appCode),
        'file': multipartFile,
      });

      final response = await _client.post<dynamic>(
        FaceApiEndpoints.verify,
        data: formData,
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return FaceVerifyResponseModel.fromJson(body);
      }
      throw const ServerException(message: 'Phản hồi xác thực khuôn mặt không hợp lệ');
    } on Object catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: _parseErrorMessage(e, 'Lỗi xác thực khuôn mặt'));
    }
  }

  @override
  Future<FaceVerifyResponseModel> liveVerifyFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: 'live_verify_face.jpg',
      );
      final formData = FormData.fromMap({
        'Code': code,
        'AppCode': _resolveAppCode(appCode),
        'file': multipartFile,
      });

      final response = await _client.post<dynamic>(
        FaceApiEndpoints.liveVerify,
        data: formData,
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return FaceVerifyResponseModel.fromJson(body);
      }
      throw const ServerException(message: 'Phản hồi xác thực liveness không hợp lệ');
    } on Object catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: _parseErrorMessage(e, 'Lỗi xác thực khuôn mặt liveness'));
    }
  }
}
