import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/rewards/presentation/widgets/rewards_bonus_tab.dart';
import 'package:vstech_hrm/features/rewards/presentation/widgets/rewards_commission_tab.dart';
import 'package:vstech_hrm/features/rewards/presentation/widgets/rewards_targets_tab.dart';

/// Screen 15: Rewards, Commission, and KPI Target Tracking with 3 tabs (`bonus`).
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const AppIcon(AppIcons.back, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.rewardsTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          bottom: TabBar(
            indicatorColor: colors.primaryIndigo,
            indicatorWeight: 3,
            labelColor: colors.primaryIndigo,
            unselectedLabelColor: colors.textSecondary,
            labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            tabs: [
              Tab(
                icon: const AppIcon(AppIcons.bonus, size: 20),
                text: l10n.rewardsTabBonus,
              ),
              Tab(
                icon: const AppIcon(AppIcons.commission, size: 20),
                text: l10n.rewardsTabCommission,
              ),
              Tab(
                icon: const AppIcon(AppIcons.target, size: 20),
                text: l10n.rewardsTabTargets,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RewardsBonusTab(),
            RewardsCommissionTab(),
            RewardsTargetsTab(),
          ],
        ),
      ),
    );
  }
}
