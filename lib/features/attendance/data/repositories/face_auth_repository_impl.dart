import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/face_auth_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_check_reg_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_verify_result_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/face_auth_repository.dart';

/// Implementation of FaceAuthRepository translating DataSource exceptions to Domain Failures.
class FaceAuthRepositoryImpl implements FaceAuthRepository {
  const new({required FaceAuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final FaceAuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, FaceCheckRegEntity>> checkRegistration(
    String code, {
    String? appCode,
  }) async {
    try {
      final model = await _remoteDataSource.checkRegistration(code, appCode: appCode);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> registerFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final model = await _remoteDataSource.registerFace(code, imagePath, appCode: appCode);
      if (model.status) {
        return Right(model.message.isNotEmpty ? model.message : 'Đăng ký khuôn mặt thành công');
      }
      return Left(ServerFailure(message: model.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final model = await _remoteDataSource.updateFace(code, imagePath, appCode: appCode);
      if (model.status) {
        return Right(model.message.isNotEmpty ? model.message : 'Cập nhật khuôn mặt thành công');
      }
      return Left(ServerFailure(message: model.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteFace(
    String code, {
    String? appCode,
  }) async {
    try {
      final model = await _remoteDataSource.deleteFace(code, appCode: appCode);
      if (model.status) {
        return Right(model.message.isNotEmpty ? model.message : 'Xóa khuôn mặt thành công');
      }
      return Left(ServerFailure(message: model.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FaceVerifyResultEntity>> verifyFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final model = await _remoteDataSource.verifyFace(code, imagePath, appCode: appCode);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FaceVerifyResultEntity>> liveVerifyFace(
    String code,
    String imagePath, {
    String? appCode,
  }) async {
    try {
      final model = await _remoteDataSource.liveVerifyFace(code, imagePath, appCode: appCode);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
