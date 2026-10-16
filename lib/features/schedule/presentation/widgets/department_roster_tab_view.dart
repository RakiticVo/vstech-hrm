import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_cubit.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_state.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/roster_employee_tile.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/roster_summary_card.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

/// Tab view for Managers to view and search their subordinates' daily shift roster.
class DepartmentRosterTabView extends StatelessWidget {
  const DepartmentRosterTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocBuilder<ShiftScheduleCubit, ShiftScheduleState>(
      builder: (context, state) {
        final cubit = context.read<ShiftScheduleCubit>();

        return RefreshIndicator(
          onRefresh: () => cubit.loadDepartmentRoster(date: state.selectedDate),
          color: colors.tealPrimary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: RosterSummaryCard(
                  selectedDate: state.selectedDate,
                  rosterItems: state.rosterItems,
                  selectedFilter: state.selectedShiftFilter,
                  searchQuery: state.searchQuery,
                  availableDepartments: state.availableDepartments,
                  selectedDepartmentCode: state.selectedDepartmentCode,
                  onDepartmentChanged: cubit.selectDepartment,
                  onDateSelected: (newDate) => cubit.selectDate(newDate, isManager: true),
                  onFilterChanged: cubit.setShiftFilter,
                  onSearchChanged: cubit.setSearchQuery,
                  onRefresh: () => unawaited(cubit.loadDepartmentRoster(date: state.selectedDate)),
                ),
              ),
              if (state.rosterStatus == ScheduleLoadingStatus.loading && state.rosterItems.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: colors.tealPrimary),
                  ),
                )
              else if (state.rosterStatus == ScheduleLoadingStatus.failure && state.rosterItems.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildErrorState(context, colors, l10n, state.errorMessage, () {
                    unawaited(cubit.loadDepartmentRoster(date: state.selectedDate));
                  }),
                )
              else if (state.filteredRosterItems.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context, colors, l10n),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.filteredRosterItems[index];
                      return RosterEmployeeTile(key: ValueKey(item.employeeCode), item: item);
                    },
                    childCount: state.filteredRosterItems.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.tealPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: AppIcon(AppIcons.shift, size: 40, color: colors.tealPrimary),
            ),
            16.gapH,
            Text(
              l10n.rosterEmptyTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            6.gapH,
            Text(
              l10n.rosterEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
    String? error,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon(AppIcons.alertTriangle, size: 40, color: Colors.red),
            16.gapH,
            Text(
              error ?? l10n.errorOccurred,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
            16.gapH,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const AppIcon(AppIcons.refreshCw, size: 16, color: Colors.white),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.tealPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
