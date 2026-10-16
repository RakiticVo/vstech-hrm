import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:vstech_hrm/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:vstech_hrm/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const new({required NotificationsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<AppNotificationEntity>>> getNotifications({
    int size = 2000,
    int isRead = 0,
  }) async {
    try {
      final models = await _remoteDataSource.getNotifications(size: size, isRead: isRead);
      final entities = models.map((m) => AppNotificationEntity(
            id: m.id,
            title: m.title,
            body: m.body,
            image: m.image,
            userCode: m.userCode,
            departmentCode: m.departmentCode,
            keyPage: m.keyPage,
            status: m.status,
            dateSent: m.dateSent,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead(int id) async {
    try {
      final res = await _remoteDataSource.markAsRead(id);
      return Right(res);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllAsRead() async {
    try {
      final res = await _remoteDataSource.markAllAsRead();
      return Right(res);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> registerFcmToken({
    required String token,
    String? userName,
  }) async {
    try {
      final res = await _remoteDataSource.setFcmToken(token: token, userName: userName);
      return Right(res);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
