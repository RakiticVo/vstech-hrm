import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_check_reg_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_verify_result_entity.dart';

/// Contract for Face Authentication operations.
abstract class FaceAuthRepository {
  Future<Either<Failure, FaceCheckRegEntity>> checkRegistration(
    String code, {
    String? appCode,
  });

  Future<Either<Failure, String>> registerFace(
    String code,
    String imagePath, {
    String? appCode,
  });

  Future<Either<Failure, String>> updateFace(
    String code,
    String imagePath, {
    String? appCode,
  });

  Future<Either<Failure, String>> deleteFace(
    String code, {
    String? appCode,
  });

  Future<Either<Failure, FaceVerifyResultEntity>> verifyFace(
    String code,
    String imagePath, {
    String? appCode,
  });

  Future<Either<Failure, FaceVerifyResultEntity>> liveVerifyFace(
    String code,
    String imagePath, {
    String? appCode,
  });
}
