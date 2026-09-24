import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';

class ExecutiveKpiGrid extends StatelessWidget {
  const new({required this.stats, super.key});

  final ExecutiveStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final items = [
      (
        l10n.execHeadcount,
        '${stats.totalHeadcount}',
        '${stats.todayAttendanceRate}% ${l10n.execAttendanceRate.toLowerCase()}',
        colors.primaryIndigo,
      ),
      (
        l10n.execMonthlyPayroll,
        '${(stats.monthlyPayrollVnd / 1000000000).toStringAsFixed(1)} Tỷ',
        '+${stats.payrollGrowthPercentage}% so với kỳ trước',
        const Color(0xFF0F766E),
      ),
      (
        l10n.execOvertimeHours,
        '${stats.monthlyOvertimeHours.toStringAsFixed(0)}h',
        'TB ${stats.avgOvertimePerWorker}h / người',
        const Color(0xFFD97706),
      ),
      (
        l10n.execTurnoverRate,
        '${stats.turnoverRate}%',
        'Ngưỡng an toàn < 2%',
        const Color(0xFF16A34A),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.45,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final (title, value, sub, inkColor) = items[index];
        return Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.textSecondary,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: inkColor,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
