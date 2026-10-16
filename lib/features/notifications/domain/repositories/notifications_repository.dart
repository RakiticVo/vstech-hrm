import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/notifications/domain/entities/app_notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<AppNotificationEntity>>> getNotifications({
    int size = 2000,
    int isRead = 0,
  });

  Future<Either<Failure, bool>> markAsRead(int id);
  Future<Either<Failure, bool>> markAllAsRead();
  Future<Either<Failure, String>> registerFcmToken({required String token, String? userName});
}
