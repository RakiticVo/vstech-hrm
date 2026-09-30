import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Data model representing a referred candidate in the 4-stage pipeline.
class ReferredCandidateItem {
  const ReferredCandidateItem({
    required this.code,
    required this.name,
    required this.position,
    required this.branch,
    required this.appliedDate,
    required this.currentStageIndex,
    required this.stageLabel,
    required this.bonusAmount,
    required this.statusType,
  });

  final String code;
  final String name;
  final String position;
  final String branch;
  final String appliedDate;
  final int currentStageIndex;
  final String stageLabel;
  final String bonusAmount;
  final AppStatusType statusType;
}

/// Card displaying candidate referral details and 4-stage hiring pipeline.
class ReferredCandidateCard extends StatelessWidget {
  const ReferredCandidateCard({
    required this.item,
    super.key,
  });

  final ReferredCandidateItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final stages = ['Tiếp nhận', 'Phỏng vấn', 'Thử việc', 'Nhận việc'];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.code,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: colors.primaryIndigo,
                ),
              ),
              StatusChip(label: item.stageLabel, type: item.statusType),
            ],
          ),
          8.gapH,
          Text(
            item.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          4.gapH,
          Text(
            '${item.position} · ${item.branch}',
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
          12.gapH,

          // 4-Stage Progress Line
          Row(
            children: List.generate(stages.length, (sIndex) {
              final isPassed = sIndex <= item.currentStageIndex &&
                  item.statusType != AppStatusType.rejected;
              final isCurrent = sIndex == item.currentStageIndex &&
                  item.statusType != AppStatusType.rejected;
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPassed ? colors.pineGreen : colors.border,
                        border: isCurrent
                            ? Border.all(color: colors.primaryIndigo, width: 2)
                            : null,
                      ),
                      child: isPassed
                          ? const AppIcon(AppIcons.check, size: 9, color: Colors.white)
                          : null,
                    ),
                    if (sIndex < stages.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: sIndex < item.currentStageIndex &&
                                  item.statusType != AppStatusType.rejected
                              ? colors.pineGreen
                              : colors.border,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          6.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày nộp: ${item.appliedDate}',
                style: TextStyle(fontSize: 11, color: colors.textTertiary),
              ),
              if (item.bonusAmount != '0 ₫')
                Text(
                  'Thưởng: ${item.bonusAmount}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colors.pineGreen,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
