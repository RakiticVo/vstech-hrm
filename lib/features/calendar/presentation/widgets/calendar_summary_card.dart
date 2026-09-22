import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class CalendarSummaryCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rows = [
      (context.l10n.payableWorkdays, '18.0 / 22 ngày', colors.textPrimary),
      (context.l10n.totalWorkHours, '144.5 giờ', colors.textPrimary),
      (context.l10n.cumulativeOvertime, '12.0 giờ', colors.textPrimary),
      (context.l10n.paidLeaveDays, '2.0 ngày', colors.primaryIndigo),
      (context.l10n.lateEarlyArrivals, '1 lần (12 phút)', colors.accentAmber),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rows[i].$1,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    rows[i].$2,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: rows[i].$3,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            if (i < rows.length - 1)
              Divider(height: 1, color: colors.border.withValues(alpha: 0.6)),
          ],
        ],
      ),
    );
  }
}
