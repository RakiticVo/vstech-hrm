import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Tab 3: KPI and Sales Targets tracking with milestone tier bonuses.
class RewardsTargetsTab extends StatelessWidget {
  const RewardsTargetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // Personal Target Card
        _buildTargetCard(
          context,
          title: l10n.targetPersonalTitle,
          currentValue: '180.000.000 ₫',
          targetValue: '200.000.000 ₫',
          progress: 0.90,
          percentText: '90%',
          color: colors.primaryIndigo,
          iconName: AppIcons.profile,
        ),
        16.gapH,

        // Team Target Card
        _buildTargetCard(
          context,
          title: l10n.targetTeamTitle,
          currentValue: '850.000.000 ₫',
          targetValue: '1.000.000.000 ₫',
          progress: 0.85,
          percentText: '85%',
          color: colors.pineGreen,
          iconName: AppIcons.refer,
        ),
        22.gapH,

        // Milestone Bonus Tiers Section
        Text(
          l10n.targetTiersTitle,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
        ),
        10.gapH,
        _buildTierItem(
          context,
          tierName: 'Mốc 1 (80% chỉ tiêu — 160.000.000 ₫)',
          reward: 'Thưởng 2.000.000 ₫ tiền mặt',
          status: l10n.targetTierAchieved,
          statusColor: colors.pineGreen,
          isCompleted: true,
        ),
        10.gapH,
        _buildTierItem(
          context,
          tierName: 'Mốc 2 (100% chỉ tiêu — 200.000.000 ₫)',
          reward: 'Thưởng 5.000.000 ₫ tiền mặt',
          status: l10n.targetTierRemaining('20.000.000 ₫'),
          statusColor: colors.accentAmber,
          isCompleted: false,
        ),
        10.gapH,
        _buildTierItem(
          context,
          tierName: 'Mốc 3 (120% chỉ tiêu — 240.000.000 ₫)',
          reward: 'Thưởng 10.000.000 ₫ + Voucher du lịch',
          status: l10n.targetTierNext,
          statusColor: colors.primaryIndigo,
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _buildTargetCard(
    BuildContext context, {
    required String title,
    required String currentValue,
    required String targetValue,
    required double progress,
    required String percentText,
    required Color color,
    required String iconName,
  }) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: AppIcon(iconName, size: 18, color: color)),
              ),
              10.gapW,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
              ),
              Text(
                percentText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
          14.gapH,

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: colors.border.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          12.gapH,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thực tế: $currentValue',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              Text(
                'Mục tiêu: $targetValue',
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierItem(
    BuildContext context, {
    required String tierName,
    required String reward,
    required String status,
    required Color statusColor,
    required bool isCompleted,
  }) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCompleted ? statusColor.withValues(alpha: 0.4) : colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                isCompleted ? AppIcons.check : AppIcons.target,
                size: 20,
                color: statusColor,
                filled: isCompleted,
              ),
            ),
          ),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tierName,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                4.gapH,
                Text(
                  reward,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.accentAmber),
                ),
                6.gapH,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
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
