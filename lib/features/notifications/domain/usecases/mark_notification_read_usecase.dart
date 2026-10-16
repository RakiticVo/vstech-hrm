import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  const new(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, bool>> call(int id) {
    return _repository.markAsRead(id);
  }
}
