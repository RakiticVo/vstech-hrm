import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:vstech_hrm/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  const new(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, List<AppNotificationEntity>>> call({
    int size = 2000,
    int isRead = 0,
  }) {
    return _repository.getNotifications(size: size, isRead: isRead);
  }
}
