import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Top summary hero card for overtime statistics with rate breakdown badges.
class OvertimeSummaryCard extends StatelessWidget {
  const OvertimeSummaryCard({
    this.totalHours = '10.0h',
    this.rate150Hours = '6.0h',
    this.rate200Hours = '4.0h',
    this.rate300Hours = '0.0h',
    super.key,
  });

  final String totalHours;
  final String rate150Hours;
  final String rate200Hours;
  final String rate300Hours;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primaryIndigo, const Color(0xFF0A544E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalOvertimeHours,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFF8EC),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Max 40h/tháng',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          6.gapH,
          Text(
            totalHours,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          12.gapH,
          // 3 Breakdown badges (no ellipsis clipping on first badge)
          Row(
            children: [
              Expanded(
                child: _buildBreakdownItem(
                  l10n.rateNormal150,
                  rate150Hours,
                  Colors.white.withValues(alpha: 0.15),
                ),
              ),
              8.gapW,
              Expanded(
                child: _buildBreakdownItem(
                  l10n.rateWeekend200,
                  rate200Hours,
                  Colors.white.withValues(alpha: 0.15),
                ),
              ),
              8.gapW,
              Expanded(
                child: _buildBreakdownItem(
                  l10n.rateHoliday300,
                  rate300Hours,
                  Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, String hours, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          4.gapH,
          Text(
            hours,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
