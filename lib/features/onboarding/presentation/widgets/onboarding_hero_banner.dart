import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Hero header banner with Day One countdown and onboarding progress.
class OnboardingHeroBanner extends StatelessWidget {
  const OnboardingHeroBanner({
    required this.candidateName,
    required this.position,
    this.daysLeft = 3,
    this.startDate = '01/10/2026',
    this.completedSteps = 2,
    this.totalSteps = 7,
    super.key,
  });

  final String candidateName;
  final String position;
  final int daysLeft;
  final String startDate;
  final int completedSteps;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final progress = completedSteps / totalSteps;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.primaryIndigo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.accentAmber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Symbols.schedule, size: 14, color: Color(0xFF1C1408)),
                    4.gapW,
                    Text(
                      'Còn $daysLeft ngày nữa',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1C1408),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Ngày 1: $startDate',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFF8EC),
                ),
              ),
            ],
          ),
          14.gapH,
          Text(
            l10n.onboardingWelcomeMsg,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFFF8EC),
            ),
          ),
          4.gapH,
          Text(
            candidateName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          Text(
            'Vị trí: $position',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          16.gapH,

          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.onboardingProgressSummary(completedSteps, totalSteps),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFFFF8EC)),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFFFF8EC)),
              ),
            ],
          ),
          6.gapH,
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation<Color>(colors.accentAmber),
            ),
          ),
        ],
      ),
    );
  }
}
