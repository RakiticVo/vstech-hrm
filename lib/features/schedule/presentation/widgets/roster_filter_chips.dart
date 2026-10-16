import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';

/// Horizontal list of filter chips for team daily roster.
class RosterFilterChips extends StatelessWidget {
  const new({
    required this.rosterItems,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.total,
    required this.offDuty,
    super.key,
  });

  final List<ShiftRosterItemEntity> rosterItems;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final int total;
  final int offDuty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final distinctShifts = <String, ({String name, String? color})>{};
    for (final item in rosterItems) {
      if (!item.isDayOff && item.shiftCode != null) {
        distinctShifts[item.shiftCode!] = (
          name: item.shiftName ?? item.shiftCode!,
          color: item.shiftColor,
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            label: '${l10n.rosterFilterAll} ($total)',
            isSelected: selectedFilter == 'ALL',
            onTap: () => onFilterChanged('ALL'),
            colors: colors,
          ),
          ...distinctShifts.entries.map((entry) {
            final count = rosterItems.where((i) => i.shiftCode == entry.key).length;
            final dotColor = !AppColorUtils.isDefaultOrWhite(entry.value.color)
                ? AppColorUtils.parseHex(entry.value.color)
                : null;
            return Padding(
              padding: const EdgeInsets.only(left: 6),
              child: _buildChip(
                label: '${entry.value.name} ($count)',
                isSelected: selectedFilter == entry.key,
                onTap: () => onFilterChanged(entry.key),
                colors: colors,
                dotColor: dotColor,
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: _buildChip(
              label: '${l10n.shiftSourceOff} ($offDuty)',
              isSelected: selectedFilter == 'OFF',
              onTap: () => onFilterChanged('OFF'),
              colors: colors,
              dotColor: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorsExtension colors,
    Color? dotColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.tealPrimary : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.tealPrimary : colors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
