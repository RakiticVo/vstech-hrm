import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class RosterKpiRow extends StatelessWidget {
  const RosterKpiRow({
    required this.total,
    required this.onDuty,
    required this.offDuty,
    super.key,
  });

  final int total;
  final int onDuty;
  final int offDuty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _buildKpiBox(
            l10n.rosterFilterAll,
            '$total',
            colors.tealPrimary,
            colors.tealPrimary.withValues(alpha: 0.1),
          ),
        ),
        8.gapW,
        Expanded(
          child: _buildKpiBox(
            l10n.rosterOnDutyCount(onDuty).split(' ').last,
            '$onDuty',
            const Color(0xFF0F766E),
            const Color(0xFF0F766E).withValues(alpha: 0.1),
          ),
        ),
        8.gapW,
        Expanded(
          child: _buildKpiBox(
            l10n.rosterOffDutyCount(offDuty).split(' ').last,
            '$offDuty',
            colors.textSecondary,
            colors.border.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiBox(String title, String count, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          2.gapH,
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
