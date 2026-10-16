import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';

class ExecutiveDeptProgressCard extends StatelessWidget {
  const new({required this.departments, super.key});

  final List<DepartmentAttendanceRate> departments;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < departments.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          departments[i].name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${departments[i].presentCount}/${departments[i].totalCount}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: colors.textSecondary,
                        ),
                      ),
                      12.gapW,
                      SizedBox(
                        width: 48,
                        child: Text(
                          '${departments[i].percentage}%',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            color: departments[i].percentage >= 98
                                ? const Color(0xFF0F766E)
                                : colors.primaryIndigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.gapH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: departments[i].percentage / 100,
                      minHeight: 5,
                      backgroundColor: colors.cardSecondary,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        departments[i].percentage >= 98
                            ? const Color(0xFF0F766E)
                            : colors.primaryIndigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < departments.length - 1)
              Divider(height: 1, color: colors.border),
          ],
        ],
      ),
    );
  }
}
