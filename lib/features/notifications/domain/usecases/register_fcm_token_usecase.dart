import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/notifications/domain/repositories/notifications_repository.dart';

class RegisterFcmTokenUseCase {
  const new(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, String>> call({required String token, String? userName}) {
    return _repository.registerFcmToken(token: token, userName: userName);
  }
}
