import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class CalendarSummaryCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rows = [
      ('Ngày công tính lương', '18.0 / 22 ngày', colors.textPrimary),
      ('Tổng giờ làm việc', '144.5 giờ', colors.textPrimary),
      ('Tăng ca lũy kế', '12.0 giờ', colors.textPrimary),
      ('Nghỉ phép có hưởng lương', '2.0 ngày', colors.primaryIndigo),
      ('Đi muộn / Về sớm', '1 lần (12 phút)', colors.accentAmber),
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
