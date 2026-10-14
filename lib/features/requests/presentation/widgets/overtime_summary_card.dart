import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

/// Top summary hero card for overtime statistics.
class OvertimeSummaryCard extends StatelessWidget {
  const new({
    this.totalHours = '0.0h',
    super.key,
  });

  /// Factory creating an OvertimeSummaryCard by calculating hours from API entities.
  factory fromEntities({
    required List<OvertimeItemEntity> entities,
    Key? key,
  }) {
    double total = 0;

    for (final e in entities) {
      if (e.status == 2) continue; // Exclude rejected requests
      final h = e.length ?? 0.0;
      total += h;
    }

    String fmt(double val) => '${val % 1 == 0 ? val.toInt() : val.toStringAsFixed(1)}h';

    return OvertimeSummaryCard(
      key: key,
      totalHours: fmt(total),
    );
  }

  final String totalHours;

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
        ],
      ),
    );
  }
}
