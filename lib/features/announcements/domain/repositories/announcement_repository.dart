import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';

/// Contract for fetching and interacting with internal announcements.
abstract class AnnouncementRepository {
  /// Fetches a list of announcements, optionally filtered by scope.
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements({
    AnnouncementScope? scope,
  });

  /// Fetches full announcement detail by ID.
  Future<Either<Failure, AnnouncementEntity>> getAnnouncementDetail(String id);

  /// Marks an announcement as read.
  Future<Either<Failure, void>> markAsRead(String id);
}
