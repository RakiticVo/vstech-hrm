import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';

abstract class QrAuthRepository {
  Future<Either<Failure, QrLoginRequestEntity>> parseQrPayload(String rawPayload);
  Future<Either<Failure, bool>> approveLogin(String sessionId, {required String authMethod});
  Future<Either<Failure, bool>> rejectLogin(String sessionId);
}
