import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';

enum AnnouncementsStatus { initial, loading, success, failure }

class AnnouncementsState extends Equatable {
  const new({
    this.status = AnnouncementsStatus.initial,
    this.allAnnouncements = const [],
    this.filteredAnnouncements = const [],
    this.selectedScope = AnnouncementScope.all,
    this.searchQuery = '',
    this.errorMessage,
  });

  final AnnouncementsStatus status;
  final List<AnnouncementEntity> allAnnouncements;
  final List<AnnouncementEntity> filteredAnnouncements;
  final AnnouncementScope selectedScope;
  final String searchQuery;
  final String? errorMessage;

  int get unreadCount => allAnnouncements.where((a) => !a.isRead).length;

  AnnouncementsState copyWith({
    AnnouncementsStatus? status,
    List<AnnouncementEntity>? allAnnouncements,
    List<AnnouncementEntity>? filteredAnnouncements,
    AnnouncementScope? selectedScope,
    String? searchQuery,
    String? errorMessage,
  }) {
    return AnnouncementsState(
      status: status ?? this.status,
      allAnnouncements: allAnnouncements ?? this.allAnnouncements,
      filteredAnnouncements: filteredAnnouncements ?? this.filteredAnnouncements,
      selectedScope: selectedScope ?? this.selectedScope,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allAnnouncements,
        filteredAnnouncements,
        selectedScope,
        searchQuery,
        errorMessage,
      ];
}
