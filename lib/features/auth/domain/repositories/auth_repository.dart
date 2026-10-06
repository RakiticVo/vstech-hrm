import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/auth/domain/entities/auth_result_entity.dart';
import 'package:vstech_hrm/features/auth/domain/entities/login_params.dart';

/// Pure domain repository contract for authentication.
abstract class AuthRepository {
  Future<Either<Failure, AuthResultEntity>> login(LoginParams params);
  Future<Either<Failure, bool>> checkAuth();
}
