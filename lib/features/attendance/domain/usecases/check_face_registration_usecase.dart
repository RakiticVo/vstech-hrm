import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_check_reg_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/face_auth_repository.dart';

class CheckFaceRegistrationUseCase {
  const new({required FaceAuthRepository repository}) : _repository = repository;

  final FaceAuthRepository _repository;

  Future<Either<Failure, FaceCheckRegEntity>> call({
    required String code,
    String? appCode,
  }) {
    return _repository.checkRegistration(code, appCode: appCode);
  }
}
