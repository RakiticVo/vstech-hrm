import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 4 Metric Tiles on the Attendance Screen (Giờ vào, Muộn, Giờ ra, Tăng ca).
class AttendanceMetricTiles extends StatelessWidget {
  const AttendanceMetricTiles({
    required this.inTime,
    required this.outTime,
    this.lateMinutesText,
    this.overtimeText,
    super.key,
  });

  final String inTime;
  final String outTime;
  final String? lateMinutesText;
  final String? overtimeText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTile(l10n.timeIn, inTime, colors.textPrimary, colors),
              10.gapH,
              _buildTile(
                l10n.lateMinutes,
                lateMinutesText ?? l10n.zeroMinutes,
                lateMinutesText != null && lateMinutesText != l10n.zeroMinutes
                    ? colors.error
                    : colors.pineGreen,
                colors,
              ),
            ],
          ),
        ),
        10.gapW,
        Expanded(
          child: Column(
            children: [
              _buildTile(l10n.timeOut, outTime, colors.textPrimary, colors),
              10.gapH,
              _buildTile(
                l10n.overtimeLabel,
                overtimeText ?? '—',
                colors.textSecondary,
                colors,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String label, String value, Color valueColor, AppColorsExtension colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.5, color: colors.textSecondary)),
          4.gapH,
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: valueColor),
          ),
        ],
      ),
    );
  }
}
