import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Clean empty state placeholder for ApprovalsScreen.
class ApprovalsEmptyView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return ListView(
      children: [
        120.gapH,
        Center(
          child: Column(
            children: [
              AppIcon(AppIcons.approvals, size: 48, color: colors.pineGreen),
              12.gapH,
              Text(
                l10n.noPendingApprovals,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
