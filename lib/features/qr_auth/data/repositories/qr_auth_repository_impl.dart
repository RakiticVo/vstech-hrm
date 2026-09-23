import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/qr_auth/data/datasources/qr_auth_mock_datasource.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';
import 'package:vstech_hrm/features/qr_auth/domain/repositories/qr_auth_repository.dart';

class QrAuthRepositoryImpl implements QrAuthRepository {
  const new(this._dataSource);

  final QrAuthDataSource _dataSource;

  @override
  Future<Either<Failure, QrLoginRequestEntity>> parseQrPayload(String rawPayload) async {
    try {
      final model = await _dataSource.parseQrPayload(rawPayload);
      return Right(model.toEntity());
    } on FormatException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: 'Không thể giải mã QR: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> approveLogin(String sessionId, {required String authMethod}) async {
    try {
      final result = await _dataSource.approveLogin(sessionId, authMethod: authMethod);
      return Right(result);
    } on Object catch (e) {
      return Left(ServerFailure(message: 'Phê duyệt thất bại: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectLogin(String sessionId) async {
    try {
      final result = await _dataSource.rejectLogin(sessionId);
      return Right(result);
    } on Object catch (e) {
      return Left(ServerFailure(message: 'Từ chối thất bại: $e'));
    }
  }
}
