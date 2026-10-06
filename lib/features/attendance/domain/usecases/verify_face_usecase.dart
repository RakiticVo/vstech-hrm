import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_verify_result_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/face_auth_repository.dart';

class VerifyFaceUseCase {
  const new({required FaceAuthRepository repository}) : _repository = repository;

  final FaceAuthRepository _repository;

  Future<Either<Failure, FaceVerifyResultEntity>> call({
    required String code,
    required String imagePath,
    String? appCode,
  }) {
    return _repository.verifyFace(code, imagePath, appCode: appCode);
  }
}
