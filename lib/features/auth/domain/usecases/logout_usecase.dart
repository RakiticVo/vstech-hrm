import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';

/// Pure domain usecase to invalidate current session on backend and log out.
class LogoutUseCase {
  const new(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call() => _repository.logout();
}
