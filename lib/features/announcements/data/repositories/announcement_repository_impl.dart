import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/announcements/data/datasources/announcement_mock_datasource.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/domain/repositories/announcement_repository.dart';

/// Implementation of AnnouncementRepository converting datasource models to domain entities.
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const new(this._dataSource);

  final AnnouncementDataSource _dataSource;

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements({
    AnnouncementScope? scope,
  }) async {
    try {
      final models = await _dataSource.getAnnouncements(scope: scope);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Object catch (e) {
      return Left(ServerFailure(message: 'Failed to load announcements: $e'));
    }
  }

  @override
  Future<Either<Failure, AnnouncementEntity>> getAnnouncementDetail(String id) async {
    try {
      final model = await _dataSource.getAnnouncementDetail(id);
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(ServerFailure(message: 'Failed to load announcement detail: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _dataSource.markAsRead(id);
      return const Right(null);
    } on Object catch (e) {
      return Left(ServerFailure(message: 'Failed to mark announcement as read: $e'));
    }
  }
}
