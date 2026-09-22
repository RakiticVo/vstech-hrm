import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_summary_card.dart';

/// Screen displaying monthly timesheet calendar, day status dots, legend, and summary rows.
/// Follows DESIGN.md §6 & Phone.dc.html lines 322–365.
class CalendarScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          const TileHeaderBanner(
            title: 'Lịch & Ca làm việc',
            subtitle: 'Tháng 09/2026 · 22 ngày công chuẩn',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                // Calendar Card
                _buildCalendarCard(colors),
                const SizedBox(height: 14),

                // Legend Chips
                _buildLegendRow(colors),
                const SizedBox(height: 20),

                // Month Summary title
                Text(
                  'Tổng hợp tháng 9',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 11),

                // Month Summary rows
                const CalendarSummaryCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(AppColorsExtension colors) {
    const dows = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    // 1 Sep 2026 is Tuesday -> 1 leading blank
    final calDays = <_CalDay>[
      const _CalDay(day: '', isBlank: true),
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
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Symbols.chevron_left, size: 20, color: colors.textSecondary),
              Text(
                'Tháng 9 2026',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              Icon(Symbols.chevron_right, size: 20, color: colors.textSecondary),
            ],
          ),
          const SizedBox(height: 14),

          // Day of week labels
          Row(
            children: dows
                .map((w) => Expanded(
                      child: Center(
                        child: Text(
                          w,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // 7-col Calendar grid
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

              return Container(
                decoration: BoxDecoration(
                  color: item.bgColor,
                  borderRadius: BorderRadius.circular(11),
                  border: item.isToday
                      ? Border.all(color: colors.primaryIndigo, width: 1.5)
                      : null,
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
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: item.dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _CalDay _getDayData(int d, AppColorsExtension colors) {
    final dow = d % 7;
    final isWeekend = dow == 5 || dow == 6; // Sat or Sun

    if (isWeekend) {
      return _CalDay(
        day: '$d',
        textColor: colors.textTertiary,
      );
    }
    if (d == 2) {
      // Quốc khánh Holiday
      return _CalDay(
        day: '$d',
        textColor: colors.primaryIndigo,
        bgColor: colors.primaryIndigo.withValues(alpha: 0.12),
        dotColor: colors.primaryIndigo,
      );
    }
    if (d == 7 || d == 8) {
      // Phép
      return _CalDay(
        day: '$d',
        textColor: colors.accentAmber,
        bgColor: colors.accentAmber.withValues(alpha: 0.15),
        dotColor: colors.accentAmber,
      );
    }
    if (d == 15) {
      // Thiếu giờ ra
      return _CalDay(
        day: '$d',
        textColor: colors.error,
        bgColor: colors.error.withValues(alpha: 0.14),
        dotColor: colors.error,
      );
    }
    if (d == 11) {
      // Muộn
      return _CalDay(
        day: '$d',
        textColor: colors.textPrimary,
        bgColor: colors.cardSecondary,
        dotColor: colors.accentAmber,
      );
    }
    if (d <= 20) {
      // Đủ công
      return _CalDay(
        day: '$d',
        textColor: colors.pineGreen,
        bgColor: colors.pineGreen.withValues(alpha: 0.12),
        dotColor: colors.pineGreen,
        isToday: d == 20,
      );
    }
    // Future days
    return _CalDay(
      day: '$d',
      textColor: colors.textPrimary,
      bgColor: colors.cardSecondary,
    );
  }

  Widget _buildLegendRow(AppColorsExtension colors) {
    final legends = [
      ('Đủ công', colors.pineGreen),
      ('Nghỉ phép', colors.accentAmber),
      ('Thiếu giờ', colors.error),
      ('Ngày lễ', colors.primaryIndigo),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: legends
          .map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: item.$2,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.$1,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _CalDay {
  const new({
    required this.day,
    this.textColor = Colors.black,
    this.bgColor = Colors.transparent,
    this.dotColor = Colors.transparent,
    this.isBlank = false,
    this.isToday = false,
  });

  final String day;
  final Color textColor;
  final Color bgColor;
  final Color dotColor;
  final bool isBlank;
  final bool isToday;
}
