import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/domain/repositories/announcement_repository.dart';

/// UseCase to retrieve announcements targeted to employee scope.
class GetAnnouncementsUseCase {
  const new(this._repository);

  final AnnouncementRepository _repository;

  Future<Either<Failure, List<AnnouncementEntity>>> call({
    AnnouncementScope? scope,
  }) {
    return _repository.getAnnouncements(scope: scope);
  }
}
