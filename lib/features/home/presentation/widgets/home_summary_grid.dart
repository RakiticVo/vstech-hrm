import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 2x2 Summary Metrics Grid (Ngày công, Phép còn, Tăng ca, Muộn/sớm)
/// Follows DESIGN.md §7 & Phone.dc.html lines 180–196.
class HomeSummaryGrid extends StatelessWidget {
  const new({
    this.workedDays = '18',
    this.standardDays = '22',
    this.leaveLeft = '6',
    this.overtimeHours = '12',
    this.lateEarlyCount = '1 / 0',
    super.key,
  });

  final String workedDays;
  final String standardDays;
  final String leaveLeft;
  final String overtimeHours;
  final String lateEarlyCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricWorkdays.toUpperCase(),
                mainValue: workedDays,
                subValue: ' / $standardDays',
                colors: colors,
              ),
            ),
            10.gapW,
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricLeaveBalance.toUpperCase(),
                mainValue: leaveLeft,
                subValue: ' ${l10n.daysUnit}',
                colors: colors,
                mainColor: colors.primaryIndigo,
              ),
            ),
          ],
        ),
        10.gapH,
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricOvertime.toUpperCase(),
                mainValue: overtimeHours,
                subValue: l10n.hoursUnit,
                colors: colors,
              ),
            ),
            10.gapW,
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricLateEarly,
                mainValue: lateEarlyCount,
                subValue: '',
                colors: colors,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String label,
    required String mainValue,
    required String subValue,
    required AppColorsExtension colors,
    Color? mainColor,
  }) {
    final horizontalPadding = context.custom(compact: 11, normal: 14, expanded: 16).toDouble();
    final verticalPadding = context.custom(compact: 10, normal: 13, expanded: 15).toDouble();
    final mainFontSize = context.custom(compact: 18, normal: 21, expanded: 24).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: context.custom(compact: 9.5, normal: 10.5, expanded: 11.5),
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: colors.textSecondary,
            ),
          ),
          4.gapH,
          RichText(
            text: TextSpan(
              text: mainValue,
              style: TextStyle(
                fontSize: mainFontSize,
                fontWeight: FontWeight.w800,
                color: mainColor ?? colors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              children: [
                if (subValue.isNotEmpty)
                  TextSpan(
                    text: subValue,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
