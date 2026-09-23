import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';
import 'package:vstech_hrm/features/qr_auth/domain/repositories/qr_auth_repository.dart';

class ParseQrPayloadUseCase {
  const new(this._repository);

  final QrAuthRepository _repository;

  Future<Either<Failure, QrLoginRequestEntity>> call(String rawPayload) {
    return _repository.parseQrPayload(rawPayload);
  }
}

class ApproveQrLoginUseCase {
  const new(this._repository);

  final QrAuthRepository _repository;

  Future<Either<Failure, bool>> call(String sessionId, {required String authMethod}) {
    return _repository.approveLogin(sessionId, authMethod: authMethod);
  }
}

class RejectQrLoginUseCase {
  const new(this._repository);

  final QrAuthRepository _repository;

  Future<Either<Failure, bool>> call(String sessionId) {
    return _repository.rejectLogin(sessionId);
  }
}
