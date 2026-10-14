import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/roster_filter_chips.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/roster_kpi_row.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

/// Header card displaying date navigation, KPI stats, department dropdown, quick filters, and search.
class RosterSummaryCard extends StatelessWidget {
  const RosterSummaryCard({
    required this.selectedDate,
    required this.rosterItems,
    required this.selectedFilter,
    required this.searchQuery,
    required this.onDateSelected,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.onRefresh,
    this.availableDepartments = const {},
    this.selectedDepartmentCode,
    this.onDepartmentChanged,
    super.key,
  });

  final DateTime selectedDate;
  final List<ShiftRosterItemEntity> rosterItems;
  final String selectedFilter;
  final String searchQuery;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;
  final Map<String, String> availableDepartments;
  final String? selectedDepartmentCode;
  final ValueChanged<String>? onDepartmentChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final total = rosterItems.length;
    final onDuty = rosterItems.where((i) => !i.isDayOff).length;
    final offDuty = rosterItems.where((i) => i.isDayOff).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateNavigator(context, colors, l10n),
          14.gapH,
          RosterKpiRow(total: total, onDuty: onDuty, offDuty: offDuty),
          if (availableDepartments.length > 1) ...[
            12.gapH,
            _buildDepartmentSelector(colors, l10n),
          ],
          12.gapH,
          _buildSearchBar(colors, l10n),
          12.gapH,
          RosterFilterChips(
            rosterItems: rosterItems,
            selectedFilter: selectedFilter,
            onFilterChanged: onFilterChanged,
            total: total,
            offDuty: offDuty,
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentSelector(AppColorsExtension colors, AppLocalizations l10n) {
    final effectiveValue = (selectedDepartmentCode != null &&
            availableDepartments.containsKey(selectedDepartmentCode))
        ? selectedDepartmentCode!
        : 'ALL';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppIcon(AppIcons.idCard, size: 15, color: colors.tealPrimary),
            6.gapW,
            Text(
              l10n.rosterDepartmentLabel,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        6.gapH,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.border.withValues(alpha: 0.8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: effectiveValue,
              isDense: true,
              isExpanded: true,
              items: [
                DropdownMenuItem<String>(
                  value: 'ALL',
                  child: Text(
                    l10n.rosterAllDepartments,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                ...availableDepartments.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: (val) {
                if (val != null) onDepartmentChanged?.call(val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateNavigator(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    final dateDisplay = DateFormat('EEEE, dd/MM/yyyy', 'vi').format(selectedDate);

    return Row(
      children: [
        IconButton(
          icon: AppIcon(AppIcons.chevronLeft, size: 20, color: colors.tealPrimary),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: () => onDateSelected(selectedDate.subtract(const Duration(days: 1))),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 90)),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (picked != null) onDateSelected(picked);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(AppIcons.calendar, size: 16, color: colors.tealPrimary),
                  6.gapW,
                  Text(
                    dateDisplay,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          icon: AppIcon(AppIcons.chevronRight, size: 20, color: colors.tealPrimary),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: () => onDateSelected(selectedDate.add(const Duration(days: 1))),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppColorsExtension colors, AppLocalizations l10n) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          AppIcon(AppIcons.search, size: 16, color: colors.textSecondary),
          8.gapW,
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.rosterSearchHint,
                hintStyle: TextStyle(fontSize: 12, color: colors.textSecondary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
            ),
          ),
          if (searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () => onSearchChanged(''),
              child: AppIcon(AppIcons.close, size: 14, color: colors.textSecondary),
            ),
        ],
      ),
    );
  }
}
