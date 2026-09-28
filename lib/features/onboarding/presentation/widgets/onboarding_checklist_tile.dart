import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Checklist step status in the onboarding journey.
enum OnboardingStepStatus {
  completed,
  inProgress,
  notStarted;

  AppStatusType toAppStatus() {
    switch (this) {
      case OnboardingStepStatus.completed:
        return AppStatusType.approved;
      case OnboardingStepStatus.inProgress:
        return AppStatusType.inProgress;
      case OnboardingStepStatus.notStarted:
        return AppStatusType.pending;
    }
  }

  String get labelVi {
    switch (this) {
      case OnboardingStepStatus.completed:
        return 'Hoàn thành';
      case OnboardingStepStatus.inProgress:
        return 'Đang làm';
      case OnboardingStepStatus.notStarted:
        return 'Chưa làm';
    }
  }
}

/// Item model for a step in the candidate onboarding journey.
class OnboardingStepItem {
  const OnboardingStepItem({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.status = OnboardingStepStatus.notStarted,
  });

  final int stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final OnboardingStepStatus status;
}

/// Interactive card tile for an onboarding step.
class OnboardingChecklistTile extends StatelessWidget {
  const OnboardingChecklistTile({
    required this.item,
    required this.onTap,
    super.key,
  });

  final OnboardingStepItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDone = item.status == OnboardingStepStatus.completed;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.status == OnboardingStepStatus.inProgress
              ? colors.primaryIndigo
              : colors.border,
          width: item.status == OnboardingStepStatus.inProgress ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Step Number or Check Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDone
                        ? colors.pineGreen
                        : item.status == OnboardingStepStatus.inProgress
                            ? colors.primaryIndigo
                            : colors.cardSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Symbols.check, size: 20, color: Colors.white)
                        : Text(
                            '${item.stepNumber}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: item.status == OnboardingStepStatus.inProgress
                                  ? Colors.white
                                  : colors.textSecondary,
                            ),
                          ),
                  ),
                ),
                14.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          8.gapW,
                          StatusChip(
                            label: item.status.labelVi,
                            type: item.status.toAppStatus(),
                          ),
                        ],
                      ),
                      4.gapH,
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                8.gapW,
                Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
