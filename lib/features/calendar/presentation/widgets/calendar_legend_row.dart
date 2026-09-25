import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 5-color Standardized Timesheet Legend per Phase 0 Spec C1.
class CalendarLegendRow extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final legends = [
      (l10n.legendFullWork, colors.pineGreen),
      (l10n.legendLateEarly, colors.accentAmber),
      (l10n.legendMissingTime, colors.error),
      (l10n.legendLeave, const Color(0xFF8B5CF6)), // Purple for approved leave
      (l10n.legendHoliday, colors.textTertiary),   // Grey for weekly off / holiday
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: legends.map((item) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
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
              decoration: BoxDecoration(color: item.$2, shape: BoxShape.circle),
            ),
            6.gapW,
            Text(
              item.$1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
