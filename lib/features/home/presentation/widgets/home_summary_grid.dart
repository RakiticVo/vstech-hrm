import 'package:flutter/material.dart';
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

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCard(
                label: 'NGÀY CÔNG',
                mainValue: workedDays,
                subValue: ' / $standardDays',
                colors: colors,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCard(
                label: 'PHÉP CÒN LẠI',
                mainValue: leaveLeft,
                subValue: ' ngày',
                colors: colors,
                mainColor: colors.primaryIndigo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                label: 'TĂNG CA',
                mainValue: overtimeHours,
                subValue: 'h',
                colors: colors,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCard(
                label: 'MUỘN / SỚM',
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
    required String label,
    required String mainValue,
    required String subValue,
    required AppColorsExtension colors,
    Color? mainColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              text: mainValue,
              style: TextStyle(
                fontSize: 21,
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
