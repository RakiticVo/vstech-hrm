import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';

/// Single responsibility UseCase for checking session token validity.
class CheckAuthUseCase {
  const new(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, bool>> call() {
    return _repository.checkAuth();
  }
}
