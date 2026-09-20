import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';

/// Screen displaying monthly shift schedules and attendance calendar.
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
            subtitle: 'Tháng 09/2026 • 22 ngày công chuẩn',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSummaryStats(colors),
                const SizedBox(height: 16),
                Text(
                  'LỊCH TRÌNH TRONG TUẦN NÀY',
                  style: AppTextStyles.labelMicro(color: colors.textTertiary),
                ),
                const SizedBox(height: 10),
                _buildDayRow('Hôm nay (20/09)', '08:30 - 17:30', 'Đã check-in 08:24', colors, isToday: true),
                const SizedBox(height: 8),
                _buildDayRow('Thứ Tư (21/09)', '08:30 - 17:30', 'Ca Hành chính', colors),
                const SizedBox(height: 8),
                _buildDayRow('Thứ Năm (22/09)', '08:30 - 17:30', 'Ca Hành chính', colors),
                const SizedBox(height: 8),
                _buildDayRow('Thứ Sáu (23/09)', '08:30 - 17:30', 'Ca Hành chính', colors),
                const SizedBox(height: 8),
                _buildDayRow('Thứ Bảy (24/09)', 'Nghỉ tuần', 'Cuối tuần', colors, isOffDay: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(AppColorsExtension colors) {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('Công chuẩn', '22', colors.primaryIndigo, colors),
          Container(width: 1, height: 36, color: colors.border),
          _buildStat('Đã hoàn thành', '14.5', colors.pineGreen, colors),
          Container(width: 1, height: 36, color: colors.border),
          _buildStat('Nghỉ phép', '1.0', colors.accentAmber, colors),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color, AppColorsExtension colors) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelMicro(color: colors.textTertiary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium(color: color).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildDayRow(
    String date,
    String time,
    String subtitle,
    AppColorsExtension colors, {
    bool isToday = false,
    bool isOffDay = false,
  }) {
    final borderColor = isToday ? colors.accentAmber : colors.border;
    final icon = isOffDay ? Symbols.weekend : Symbols.schedule;
    final iconColor = isOffDay
        ? colors.textTertiary
        : (isToday ? colors.accentAmber : colors.primaryIndigo);

    return AppCard(
      borderColor: borderColor,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: AppTextStyles.bodyMedium(color: colors.textPrimary).copyWith(
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.labelMedium(
              color: isOffDay ? colors.textTertiary : colors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
