import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';

class CalendarMonthGridCard extends StatelessWidget {
  const CalendarMonthGridCard({
    required this.selectedMonth,
    required this.isLoading,
    required this.hasError,
    required this.dayMap,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDayTap,
    this.overtimeMap = const {},
    this.correctionMap = const {},
    this.onRetry,
    super.key,
  });

  final DateTime selectedMonth;
  final bool isLoading;
  final bool hasError;
  final Map<int, AccountTimesheetEntity> dayMap;
  final Map<int, List<dynamic>> overtimeMap;
  final Map<int, List<dynamic>> correctionMap;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime date, AccountTimesheetEntity? timesheet) onDayTap;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dows = [
      l10n.dayMon,
      l10n.dayTue,
      l10n.dayWed,
      l10n.dayThu,
      l10n.dayFri,
      l10n.daySat,
      l10n.daySun,
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: RotatedBox(
                  quarterTurns: 2,
                  child: AppIcon(AppIcons.chevronRight, size: 18, color: colors.textSecondary),
                ),
                onPressed: onPreviousMonth,
                tooltip: l10n.back,
              ),
              Text(
                l10n.timesheetMonthDisplay(selectedMonth.month, selectedMonth.year),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              IconButton(
                icon: AppIcon(AppIcons.chevronRight, size: 18, color: colors.textSecondary),
                onPressed: onNextMonth,
              ),
            ],
          ),
          12.gapH,
          Row(
            children: dows.map((w) {
              return Expanded(
                child: Center(
                  child: Text(
                    w,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          8.gapH,
          if (isLoading)
            const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
            )
          else if (hasError)
            SizedBox(
              height: 180,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.errorOccurred,
                      style: TextStyle(fontSize: 13, color: colors.error),
                    ),
                    8.gapH,
                    TextButton(
                      onPressed: onRetry,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            )
          else
            _buildDaysGrid(context, colors),
        ],
      ),
    );
  }

  Widget _buildDaysGrid(BuildContext context, AppColorsExtension colors) {
    final firstDayWeekday = DateTime(selectedMonth.year, selectedMonth.month).weekday;
    final blankCount = firstDayWeekday - 1;
    final daysInMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final totalCells = blankCount + daysInMonth;
    final now = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (ctx, index) {
        if (index < blankCount) return const SizedBox.shrink();

        final day = index - blankCount + 1;
        final date = DateTime(selectedMonth.year, selectedMonth.month, day);
        final item = dayMap[day];

        final isToday = now.year == date.year && now.month == date.month && now.day == date.day;
        final isWeekend = date.weekday == 6 || date.weekday == 7;
        final isPast = date.isBefore(DateTime(now.year, now.month, now.day));

        var textColor = colors.textPrimary;
        var bgColor = colors.surface;
        var dotColor = Colors.transparent;
        var isRedDay = false;

        const purpleLeave = Color(0xFF8B5CF6);

        if (item != null) {
          if (item.isRejected) {
            bgColor = colors.error.withValues(alpha: 0.12);
            dotColor = colors.error;
            isRedDay = true;
          } else if (item.isConfirmed && (item.validActualTime >= 8.0 || item.actualWorkTime >= 8.0)) {
            bgColor = colors.pineGreen.withValues(alpha: 0.12);
            dotColor = colors.pineGreen;
          } else if (item.validActualTime > 0 || item.actualWorkTime > 0) {
            bgColor = colors.accentAmber.withValues(alpha: 0.15);
            dotColor = colors.accentAmber;
          } else if (item.leaveTime > 0) {
            bgColor = purpleLeave.withValues(alpha: 0.14);
            dotColor = purpleLeave;
          } else if (isPast && !isWeekend) {
            bgColor = colors.error.withValues(alpha: 0.12);
            dotColor = colors.error;
            isRedDay = true;
          }
        } else if (isWeekend) {
          textColor = colors.textTertiary;
          bgColor = colors.border.withValues(alpha: 0.2);
        } else if (isPast) {
          bgColor = colors.error.withValues(alpha: 0.08);
          dotColor = colors.error;
          isRedDay = true;
        }

        final hasOt = (item != null && item.overtime > 0) || (overtimeMap[day]?.isNotEmpty ?? false);
        final hasCorr = correctionMap[day]?.isNotEmpty ?? false;

        return InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: () => onDayTap(date, item),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(11),
              border: isToday
                  ? Border.all(color: colors.primaryIndigo, width: 1.6)
                  : (isRedDay ? Border.all(color: colors.error.withValues(alpha: 0.6)) : null),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dotColor != Colors.transparent)
                      Container(
                        width: 4.5,
                        height: 4.5,
                        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      ),
                    if (hasOt) ...[
                      const SizedBox(width: 2),
                      Container(
                        width: 4.5,
                        height: 4.5,
                        decoration: const BoxDecoration(color: Color(0xFFEA580C), shape: BoxShape.circle),
                      ),
                    ],
                    if (hasCorr) ...[
                      const SizedBox(width: 2),
                      Container(
                        width: 4.5,
                        height: 4.5,
                        decoration: const BoxDecoration(color: Color(0xFF0284C7), shape: BoxShape.circle),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
