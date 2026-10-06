import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/face_auth_repository.dart';

class DeleteFaceUseCase {
  const new({required FaceAuthRepository repository}) : _repository = repository;

  final FaceAuthRepository _repository;

  Future<Either<Failure, String>> call({
    required String code,
    String? appCode,
  }) {
    return _repository.deleteFace(code, appCode: appCode);
  }
}
