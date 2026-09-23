import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:vstech_hrm/features/announcements/domain/usecases/mark_announcement_read_usecase.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_state.dart';

/// Cubit managing announcements list, filter scopes, and read status.
class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  new({
    required this.getAnnouncementsUseCase,
    required this.markAnnouncementReadUseCase,
  }) : super(const AnnouncementsState());

  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  final MarkAnnouncementReadUseCase markAnnouncementReadUseCase;

  Future<void> loadAnnouncements() async {
    emit(state.copyWith(status: AnnouncementsStatus.loading));
    final result = await getAnnouncementsUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AnnouncementsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (list) {
        final filtered = _applyFilter(list, state.selectedScope, state.searchQuery);
        emit(
          state.copyWith(
            status: AnnouncementsStatus.success,
            allAnnouncements: list,
            filteredAnnouncements: filtered,
          ),
        );
      },
    );
  }

  void setScopeFilter(AnnouncementScope scope) {
    final filtered = _applyFilter(state.allAnnouncements, scope, state.searchQuery);
    emit(state.copyWith(selectedScope: scope, filteredAnnouncements: filtered));
  }

  void setSearchQuery(String query) {
    final filtered = _applyFilter(state.allAnnouncements, state.selectedScope, query);
    emit(state.copyWith(searchQuery: query, filteredAnnouncements: filtered));
  }

  Future<void> markAsRead(String id) async {
    await markAnnouncementReadUseCase(id);
    final updatedAll = state.allAnnouncements.map((a) {
      if (a.id == id) {
        return a.copyWith(isRead: true);
      }
      return a;
    }).toList();
    final updatedFiltered = _applyFilter(
      updatedAll,
      state.selectedScope,
      state.searchQuery,
    );
    emit(
      state.copyWith(
        allAnnouncements: updatedAll,
        filteredAnnouncements: updatedFiltered,
      ),
    );
  }

  List<AnnouncementEntity> _applyFilter(
    List<AnnouncementEntity> list,
    AnnouncementScope scope,
    String query,
  ) {
    var result = list;
    if (scope != AnnouncementScope.all) {
      result = result.where((a) => a.scope == scope).toList();
    }
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((a) {
        return a.title.toLowerCase().contains(q) ||
            a.content.toLowerCase().contains(q) ||
            a.authorName.toLowerCase().contains(q);
      }).toList();
    }
    return result;
  }
}
