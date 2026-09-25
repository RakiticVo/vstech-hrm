import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_legend_row.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_summary_card.dart';

class CalDayItem {
  const new({
    required this.day,
    this.textColor = Colors.black,
    this.bgColor = Colors.transparent,
    this.dotColor = Colors.transparent,
    this.isBlank = false,
    this.isToday = false,
    this.isRedDay = false,
    this.label,
  });

  final String day;
  final Color textColor;
  final Color bgColor;
  final Color dotColor;
  final bool isBlank;
  final bool isToday;
  final bool isRedDay;
  final String? label;
}

/// Screen C1: Standardized 5-Color Monthly Timesheet Calendar with Red-day Correction shortcut.
class CalendarScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: l10n.calendarScreenTitle,
            subtitle: l10n.calendarSubtitle,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                _buildCalendarCard(context, colors),
                14.gapH,
                const CalendarLegendRow(),
                20.gapH,
                Text(
                  l10n.monthSummaryTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: colors.textPrimary,
                  ),
                ),
                11.gapH,
                const CalendarSummaryCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(BuildContext context, AppColorsExtension colors) {
    final l10n = context.l10n;
    final dows = [l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu, l10n.dayFri, l10n.daySat, l10n.daySun];

    final calDays = <CalDayItem>[
      const CalDayItem(day: '', isBlank: true),
      for (var d = 1; d <= 30; d++) _getDayData(d, colors),
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
              Icon(Symbols.chevron_left, size: 20, color: colors.textSecondary),
              Text('Tháng 9 2026', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colors.textPrimary)),
              Icon(Symbols.chevron_right, size: 20, color: colors.textSecondary),
            ],
          ),
          14.gapH,
          Row(
            children: dows.map((w) => Expanded(
              child: Center(
                child: Text(w, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
              ),
            )).toList(),
          ),
          8.gapH,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: calDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (ctx, index) {
              final item = calDays[index];
              if (item.isBlank) return const SizedBox.shrink();

              return InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: item.isRedDay ? () => context.push(AppRoutes.attendanceCorrection) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(11),
                    border: item.isToday
                        ? Border.all(color: colors.primaryIndigo, width: 1.5)
                        : (item.isRedDay ? Border.all(color: colors.error, width: 1.2) : null),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.day,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: item.textColor,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (item.label != null)
                        Text(item.label!, style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: colors.pineGreen))
                      else
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(color: item.dotColor, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  CalDayItem _getDayData(int d, AppColorsExtension colors) {
    const purpleLeave = Color(0xFF8B5CF6);
    final dow = d % 7;
    final isWeekend = dow == 5 || dow == 6;

    if (isWeekend) {
      return CalDayItem(day: '$d', textColor: colors.textTertiary, bgColor: colors.border.withValues(alpha: 0.2));
    }
    if (d == 2) {
      // Holiday 02/09 -> Grey per Spec C1
      return CalDayItem(day: '$d', textColor: colors.textTertiary, bgColor: colors.border.withValues(alpha: 0.35));
    }
    if (d == 7 || d == 8 || d == 24) {
      // Purple: Approved leave
      return CalDayItem(
        day: '$d',
        textColor: purpleLeave,
        bgColor: purpleLeave.withValues(alpha: 0.14),
        dotColor: purpleLeave,
      );
    }
    if (d == 15) {
      // Red: Missing punch (Opens Attendance Correction on tap)
      return CalDayItem(
        day: '$d',
        textColor: colors.error,
        bgColor: colors.error.withValues(alpha: 0.15),
        dotColor: colors.error,
        isRedDay: true,
      );
    }
    if (d == 11) {
      // Yellow/Orange: Late punch
      return CalDayItem(
        day: '$d',
        textColor: colors.accentAmber,
        bgColor: colors.accentAmber.withValues(alpha: 0.15),
        dotColor: colors.accentAmber,
      );
    }
    if (d == 25 || d == 28 || d == 29) {
      // Approved Off-site work (On Duty / Business Trip)
      return CalDayItem(
        day: '$d',
        textColor: colors.pineGreen,
        bgColor: colors.pineGreen.withValues(alpha: 0.12),
        label: 'Off-site',
      );
    }
    if (d <= 22) {
      // Green: Full workday
      return CalDayItem(
        day: '$d',
        textColor: colors.pineGreen,
        bgColor: colors.pineGreen.withValues(alpha: 0.12),
        dotColor: colors.pineGreen,
        isToday: d == 22,
      );
    }
    return CalDayItem(day: '$d', textColor: colors.textPrimary, bgColor: colors.cardSecondary);
  }
}
