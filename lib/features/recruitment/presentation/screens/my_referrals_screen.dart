import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/features/recruitment/presentation/widgets/referral_link_hero_card.dart';
import 'package:vstech_hrm/features/recruitment/presentation/widgets/referred_candidate_card.dart';

/// Screen 20 / F13: My Referred Candidates & 4-Stage Pipeline Tracking (`referrals`).
class MyReferralsScreen extends StatefulWidget {
  const MyReferralsScreen({super.key});

  @override
  State<MyReferralsScreen> createState() => _MyReferralsScreenState();
}

class _MyReferralsScreenState extends State<MyReferralsScreen> {
  int _selectedFilterIndex = 0;

  final List<ReferredCandidateItem> _candidates = [];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final inProgressCount = _candidates.where((c) => c.statusType == AppStatusType.inProgress || c.statusType == AppStatusType.pending).length;
    final approvedCount = _candidates.where((c) => c.statusType == AppStatusType.approved).length;
    final rejectedCount = _candidates.where((c) => c.statusType == AppStatusType.rejected).length;

    final filterTabs = [
      'Tất cả (${_candidates.length})',
      'Đang xử lý ($inProgressCount)',
      'Đã nhận thưởng ($approvedCount)',
      'Không phù hợp ($rejectedCount)',
    ];

    final filtered = _candidates.where((c) {
      if (_selectedFilterIndex == 1) {
        return c.statusType == AppStatusType.inProgress ||
            c.statusType == AppStatusType.pending;
      }
      if (_selectedFilterIndex == 2) {
        return c.statusType == AppStatusType.approved;
      }
      if (_selectedFilterIndex == 3) {
        return c.statusType == AppStatusType.rejected;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.arrowLeft, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.myReferralsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Referral Link Sharing Hero Card
          const ReferralLinkHeroCard(),

          // Filter Tab Chips
          Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(filterTabs.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filterTabs[index]),
                      selected: isSelected,
                      selectedColor: colors.primaryIndigo,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : colors.textSecondary,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedFilterIndex = index),
                    ),
                  );
                }),
              ),
            ),
          ),
          Divider(height: 1, color: colors.border),

          // Candidates List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      l10n.noReferralsFound,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => 12.gapH,
                    itemBuilder: (ctx, index) {
                      final item = filtered[index];
                      return ReferredCandidateCard(item: item);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: PrimaryButton(
              text: l10n.referCandidateBtn,
              onPressed: () => context.push(AppRoutes.referralForm),
            ),
          ),
        ],
      ),
    );
  }
}
