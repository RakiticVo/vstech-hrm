import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_verify_result_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/face_auth_repository.dart';

/// UseCase performing AI face anti-spoofing and match verification with Face API (/live_verify/).
class LiveVerifyFaceUseCase {
  const new({required FaceAuthRepository repository})
      : _repository = repository;

  final FaceAuthRepository _repository;

  Future<Either<Failure, FaceVerifyResultEntity>> call({
    required String code,
    required String imagePath,
    String? appCode,
  }) {
    return _repository.liveVerifyFace(code, imagePath, appCode: appCode);
  }
}
