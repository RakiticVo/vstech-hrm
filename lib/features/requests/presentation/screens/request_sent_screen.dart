import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/secondary_button.dart';

/// Screen displaying submission confirmation for any request (Leave, OT, Fix, Swap).
class RequestSentScreen extends StatelessWidget {
  const RequestSentScreen({
    this.requestCode = 'RQ-2026-0935',
    this.requestTitle = 'Nghỉ phép năm · 1 ngày',
    this.assignedTo = 'Lê Minh Quân (Quản lý trực tiếp)',
    super.key,
  });

  final String requestCode;
  final String requestTitle;
  final String assignedTo;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated checkmark badge
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.pineGreen.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: colors.pineGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AppIcon(
                        AppIcons.check,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ),
              24.gapH,
              Text(
                l10n.requestSentTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              8.gapH,
              Text(
                l10n.requestSentSuccess,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                  height: 1.45,
                ),
              ),
              24.gapH,
              // Summary card
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
                          l10n.requestCodeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primaryIndigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            requestCode,
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
                    Divider(color: colors.borderSubtle, height: 1),
                    12.gapH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          requestTitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    8.gapH,
                    Row(
                      children: [
                        AppIcon(
                          AppIcons.profile,
                          size: 16,
                          color: colors.textSecondary,
                        ),
                        6.gapW,
                        Expanded(
                          child: Text(
                            l10n.requestAssignedTo(assignedTo),
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: l10n.backToListBtn,
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go(AppRoutes.requests);
                  }
                },
              ),
              12.gapH,
              SecondaryButton(
                text: l10n.viewRequestDetailBtn,
                onPressed: () {
                  unawaited(
                    context.push(
                      AppRoutes.requestDetail,
                      extra: {
                        'code': requestCode,
                        'title': requestTitle,
                        'assignedTo': assignedTo,
                        'isApprover': false,
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
