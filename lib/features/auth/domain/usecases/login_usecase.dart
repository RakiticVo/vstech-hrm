import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/auth/domain/entities/auth_result_entity.dart';
import 'package:vstech_hrm/features/auth/domain/entities/login_params.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';

/// Single responsibility UseCase for user login.
class LoginUseCase {
  const new(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthResultEntity>> call(LoginParams params) {
    return _repository.login(params);
  }
}
