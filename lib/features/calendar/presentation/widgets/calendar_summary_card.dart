import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class CalendarSummaryCard extends StatelessWidget {
  const CalendarSummaryCard({
    super.key,
    this.payableWorkdaysText,
    this.totalWorkHoursText,
    this.cumulativeOvertimeText,
    this.paidLeaveDaysText,
    this.lateEarlyArrivalsText,
    this.correctionSummaryText,
  });

  final String? payableWorkdaysText;
  final String? totalWorkHoursText;
  final String? cumulativeOvertimeText;
  final String? paidLeaveDaysText;
  final String? lateEarlyArrivalsText;
  final String? correctionSummaryText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rows = [
      (context.l10n.payableWorkdays, payableWorkdaysText ?? '--', colors.textPrimary),
      (context.l10n.totalWorkHours, totalWorkHoursText ?? '--', colors.textPrimary),
      (context.l10n.cumulativeOvertime, cumulativeOvertimeText ?? '--', const Color(0xFFEA580C)),
      (context.l10n.paidLeaveDays, paidLeaveDaysText ?? '--', const Color(0xFF8B5CF6)),
      if (correctionSummaryText != null)
        (context.l10n.timesheetCorrectionSummary, correctionSummaryText!, const Color(0xFF0284C7)),
      (context.l10n.lateEarlyArrivals, lateEarlyArrivalsText ?? '--', colors.accentAmber),
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
                  Expanded(
                    child: Text(
                      rows[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
