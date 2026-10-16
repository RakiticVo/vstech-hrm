import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/notifications/data/models/app_notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications({int size = 2000, int isRead = 0});
  Future<bool> markAsRead(int id);
  Future<bool> markAllAsRead();
  Future<String> setFcmToken({required String token, String? userName});
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const new({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<AppNotificationModel>> getNotifications({
    int size = 2000,
    int isRead = 0,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.notifications,
        queryParameters: <String, dynamic>{
          'size': size,
          'isRead': isRead,
        },
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['data'] is List) {
        final list = body['data'] as List;
        return list
            .map((dynamic e) => AppNotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <AppNotificationModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi tải danh sách thông báo: $e');
    }
  }

  @override
  Future<bool> markAsRead(int id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.notificationRead(id));
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi đánh dấu đã đọc: $e');
    }
  }

  @override
  Future<bool> markAllAsRead() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.notificationsReadAll);
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi đánh dấu tất cả đã đọc: $e');
    }
  }

  @override
  Future<String> setFcmToken({required String token, String? userName}) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.fcmSetToken,
        queryParameters: <String, dynamic>{
          'token': token,
          if (userName != null) 'userName': userName,
        },
      );
      return response.data?.toString() ?? 'token saved';
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi đăng ký FCM token: $e');
    }
  }
}
