import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/notifications/domain/repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase {
  const new(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, bool>> call() {
    return _repository.markAllAsRead();
  }
}
