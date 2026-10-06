import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:vstech_hrm/features/auth/data/models/login_request_model.dart';
import 'package:vstech_hrm/features/auth/domain/entities/auth_result_entity.dart';
import 'package:vstech_hrm/features/auth/domain/entities/login_params.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const new({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AuthResultEntity>> login(LoginParams params) async {
    try {
      final requestModel = LoginRequestModel(
        username: params.username,
        password: params.password,
        deviceId: params.deviceId,
        model: params.model,
        brand: params.brand,
        platform: params.platform,
        versionRelease: params.versionRelease,
        versionApp: params.versionApp,
        checkMobile: params.checkMobile,
        root: params.root,
        tsAppVerSion: params.tsAppVerSion,
        isJsc: params.isJsc,
      );

      final result = await remoteDataSource.login(requestModel);
      final user = result.user;
      final entity = AuthResultEntity(
        token: result.token,
        validTo: result.validTo,
        employeeName: user?.employeeName.isNotEmpty == true
            ? user!.employeeName
            : params.username,
        employeeCode: user?.employeeCode.isNotEmpty == true
            ? user!.employeeCode
            : params.username,
        userName: user?.userName.isNotEmpty == true
            ? user!.userName
            : params.username,
        userId: user?.id,
        email: user?.email,
        avatar: user?.avatar,
        claims: user?.claims ?? const <String>[],
      );
      return Right(entity);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on Object catch (e) {
      return Left(UnknownFailure(message: 'Lỗi đăng nhập: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuth() async {
    try {
      final isValid = await remoteDataSource.checkAuth();
      return Right(isValid);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on Object catch (e) {
      return Left(UnknownFailure(message: 'Lỗi kiểm tra phiên: $e'));
    }
  }
}
