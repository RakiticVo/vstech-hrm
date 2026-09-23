import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_cubit.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_state.dart';
import 'package:vstech_hrm/features/announcements/presentation/widgets/announcement_card.dart';

/// Screen listing internal announcements with filter tabs by scope and search bar.
class AnnouncementsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(context.read<AnnouncementsCubit>().loadAnnouncements());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.announcementsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Symbols.refresh, color: colors.textPrimary),
            onPressed: () => context.read<AnnouncementsCubit>().loadAnnouncements(),
          ),
          4.gapW,
        ],
      ),
      body: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
        builder: (context, state) {
          if (state.status == AnnouncementsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AnnouncementsStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.error, size: 48, color: colors.error),
                  12.gapH,
                  Text(
                    state.errorMessage ?? l10n.errorOccurredMessage,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  16.gapH,
                  ElevatedButton(
                    onPressed: () => context.read<AnnouncementsCubit>().loadAnnouncements(),
                    child: Text(l10n.syncRetryButton),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Search input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => context.read<AnnouncementsCubit>().setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm thông báo, nội dung, ban hành...',
                    prefixIcon: const Icon(Symbols.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.border),
                    ),
                  ),
                ),
              ),

              // Filter scope pills
              _buildScopeFilterPills(context, state),

              // Announcements list
              Expanded(
                child: state.filteredAnnouncements.isEmpty
                    ? Center(
                        child: Text(
                          l10n.announcementEmpty,
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => context.read<AnnouncementsCubit>().loadAnnouncements(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: state.filteredAnnouncements.length,
                          itemBuilder: (context, index) {
                            final item = state.filteredAnnouncements[index];
                            return AnnouncementCard(
                              announcement: item,
                              onTap: () {
                                unawaited(
                                  context.push(
                                    AppRoutes.announcementDetail,
                                    extra: item,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScopeFilterPills(BuildContext context, AnnouncementsState state) {
    final l10n = context.l10n;
    final scopes = [
      (AnnouncementScope.all, l10n.announcementScopeAll),
      (AnnouncementScope.company, l10n.announcementScopeCompany),
      (AnnouncementScope.factory, l10n.announcementScopeFactory),
      (AnnouncementScope.office, l10n.announcementScopeOffice),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: scopes.map((tuple) {
          final isSelected = state.selectedScope == tuple.$1;
          final colors = context.colors;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                tuple.$2,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : colors.textSecondary,
                ),
              ),
              selected: isSelected,
              selectedColor: colors.primaryIndigo,
              backgroundColor: colors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onSelected: (_) => context.read<AnnouncementsCubit>().setScopeFilter(tuple.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
