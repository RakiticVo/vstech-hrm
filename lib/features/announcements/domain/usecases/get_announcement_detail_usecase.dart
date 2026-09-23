import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/domain/repositories/announcement_repository.dart';

/// UseCase to retrieve full announcement details and article body.
class GetAnnouncementDetailUseCase {
  const new(this._repository);

  final AnnouncementRepository _repository;

  Future<Either<Failure, AnnouncementEntity>> call(String id) {
    return _repository.getAnnouncementDetail(id);
  }
}
