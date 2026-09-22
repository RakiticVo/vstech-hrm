import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';

/// Hero tile pattern card displaying leave balance (Screen 10).
class LeaveHeroBalanceCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: ColoredBox(
        color: colors.primaryIndigo,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: TilePatternPainter(
                  backgroundColor: colors.primaryIndigo,
                  patternColor: const Color(0xFFFFF8EC).withValues(alpha: 0.14),
                  tileSize: 38,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.annualLeaveCardTitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFF8EC),
                    ),
                  ),
                  6.gapH,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '6',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFFF8EC),
                          height: 1,
                        ),
                      ),
                      Text(
                        ' / 12 ${l10n.daysUnit}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFF8EC),
                        ),
                      ),
                    ],
                  ),
                  12.gapH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 5,
                      backgroundColor: Colors.black26,
                      valueColor: AlwaysStoppedAnimation(Color(0xFFF59E0B)),
                    ),
                  ),
                  8.gapH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.usedDaysCount('6'),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFFFF8EC)),
                      ),
                      Text(
                        l10n.remainingDaysCount('6'),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFFFF8EC)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
