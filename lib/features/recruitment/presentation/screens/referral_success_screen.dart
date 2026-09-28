import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/secondary_button.dart';

/// Screen 19 / F13: Referral Success Confirmation (`refer-sent`).
class ReferralSuccessScreen extends StatelessWidget {
  const ReferralSuccessScreen({
    this.trackingCode = 'REF-2026-0812',
    this.candidateName = 'Trần Anh Khoa',
    this.position = 'Quản lý cửa hàng',
    super.key,
  });

  final String trackingCode;
  final String candidateName;
  final String position;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success badge
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Symbols.check_circle,
                    size: 48,
                    color: colors.pineGreen,
                  ),
                ),
              ),
              20.gapH,
              Text(
                l10n.referralSuccessTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              10.gapH,
              Text(
                l10n.referralSuccessMsg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: colors.textSecondary, height: 1.4),
              ),
              24.gapH,

              // Code & Candidate Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.referralCodeLabel,
                          style: TextStyle(fontSize: 12, color: colors.textSecondary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.primaryIndigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            trackingCode,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: colors.primaryIndigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.gapH,
                    Divider(height: 1, color: colors.border),
                    12.gapH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ứng viên:', style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
                        Text(candidateName, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                      ],
                    ),
                    8.gapH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Vị trí:', style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
                        Text(position, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              16.gapH,

              // Bonus promise alert card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.accentAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.accentAmber),
                ),
                child: Row(
                  children: [
                    Icon(Symbols.stars, color: colors.accentAmber, size: 24),
                    12.gapW,
                    Expanded(
                      child: Text(
                        l10n.referralBonusNotice,
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Action buttons
              PrimaryButton(
                text: l10n.viewMyReferralsBtn,
                onPressed: () => context.push(AppRoutes.myReferrals),
              ),
              12.gapH,
              SecondaryButton(
                text: 'Về trang tuyển dụng',
                onPressed: () => context.go(AppRoutes.jobRecruitment),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
