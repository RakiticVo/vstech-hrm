import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/announcements/domain/repositories/announcement_repository.dart';

/// UseCase to update read status for a specified announcement.
class MarkAnnouncementReadUseCase {
  const new(this._repository);

  final AnnouncementRepository _repository;

  Future<Either<Failure, void>> call(String id) {
    return _repository.markAsRead(id);
  }
}
