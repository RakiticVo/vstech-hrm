import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class TimelineStep {
  const TimelineStep({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isCompleted,
    this.isRejected = false,
    this.comment,
  });

  final String title;
  final String subtitle;
  final String timestamp;
  final bool isCompleted;
  final bool isRejected;
  final String? comment;
}

/// 4-tier visual timeline for request approval lifecycle.
class RequestDetailTimeline extends StatelessWidget {
  const RequestDetailTimeline({
    required this.steps,
    super.key,
  });

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.timeline, size: 20, color: colors.primaryIndigo),
              8.gapW,
              Text(
                l10n.approvalTimelineTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          14.gapH,
          for (int i = 0; i < steps.length; i++) ...[
            _buildTimelineItem(
              step: steps[i],
              isLast: i == steps.length - 1,
              colors: colors,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required TimelineStep step,
    required bool isLast,
    required AppColorsExtension colors,
  }) {
    final dotColor = step.isRejected
        ? colors.error
        : step.isCompleted
            ? colors.pineGreen
            : colors.border;

    final icon = step.isRejected
        ? Symbols.close
        : step.isCompleted
            ? Symbols.check
            : Symbols.schedule;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: dotColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: 2),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 13,
                  color: dotColor,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: step.isCompleted
                    ? colors.pineGreen.withValues(alpha: 0.4)
                    : colors.borderSubtle,
              ),
          ],
        ),
        12.gapW,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    height: 1.3,
                  ),
                ),
                2.gapH,
                Text(
                  step.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
                4.gapH,
                Row(
                  children: [
                    Icon(
                      step.isRejected
                          ? Symbols.cancel
                          : step.isCompleted
                              ? Symbols.check_circle
                              : Symbols.schedule,
                      size: 13,
                      color: step.isRejected
                          ? colors.error
                          : step.isCompleted
                              ? colors.pineGreen
                              : colors.textTertiary,
                    ),
                    4.gapW,
                    Text(
                      step.timestamp,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: step.isRejected
                            ? colors.error
                            : step.isCompleted
                                ? colors.pineGreen
                                : colors.textTertiary,
                      ),
                    ),
                  ],
                ),
                if (step.comment != null) ...[
                  4.gapH,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.cardSecondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '“${step.comment}”',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
