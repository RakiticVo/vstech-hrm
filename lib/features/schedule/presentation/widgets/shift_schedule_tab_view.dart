import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_detail_card.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_week_selector.dart';

/// Renders the weekly shift schedule view and selected shift details.
class ShiftScheduleTabView extends StatelessWidget {
  const new({
    required this.weekShifts,
    required this.selectedDate,
    required this.selectedShift,
    required this.onDateSelected,
    required this.onOpenMonthGrid,
    super.key,
  });

  final List<ShiftScheduleEntity> weekShifts;
  final DateTime selectedDate;
  final ShiftScheduleEntity selectedShift;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onOpenMonthGrid;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dateStr = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeeklyStatsCard(context, colors),
          8.gapH,
          ShiftWeekSelector(
            weekShifts: weekShifts,
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                AppIcon(AppIcons.shift, size: 18, color: colors.tealPrimary),
                6.gapW,
                Expanded(
                  child: Text(
                    l10n.shiftDetailHeader(selectedShift.dayOfWeek, dateStr),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: colors.textPrimary,
                    ),
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          ShiftDetailCard(shift: selectedShift),
          24.gapH,
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsCard(BuildContext context, AppColorsExtension colors) {
    final l10n = context.l10n;
    final firstDate = weekShifts.isNotEmpty ? weekShifts.first.date : selectedDate;
    final lastDate = weekShifts.isNotEmpty ? weekShifts.last.date : selectedDate;
    final weekRange = '${firstDate.day}/${firstDate.month} — ${lastDate.day}/${lastDate.month}';
    final weekNum = ((firstDate.difference(DateTime(firstDate.year)).inDays) / 7).ceil();
    final shiftsCount = weekShifts.where((s) => !s.isDayOff).length;
    final daysOffCount = weekShifts.where((s) => s.isDayOff).length;
    final hoursCount = shiftsCount * 8;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.tealPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.tealPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: colors.tealPrimary,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const AppIcon(AppIcons.shift, color: Colors.white, size: 14),
              ),
              8.gapW,
              Expanded(
                child: Text(
                  l10n.weekStatsTitle('$weekNum', weekRange),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              8.gapW,
              InkWell(
                onTap: onOpenMonthGrid,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.tealPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.viewMonth,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.tealPrimary,
                        ),
                      ),
                      3.gapW,
                      AppIcon(AppIcons.chevronRight, size: 12, color: colors.tealPrimary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          8.gapH,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.weekStatsSummary(shiftsCount, hoursCount, daysOffCount),
              style: TextStyle(
                fontSize: 12,
                color: colors.tealPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
