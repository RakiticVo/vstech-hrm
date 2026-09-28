import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Top role indicator banner in Requests Screen.
class RequestsRoleIndicator extends StatelessWidget {
  const RequestsRoleIndicator({
    required this.isManager,
    super.key,
  });

  final bool isManager;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    if (!isManager) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: colors.cardSecondary,
        child: Row(
          children: [
            Icon(Symbols.info, size: 16, color: colors.textSecondary),
            8.gapW,
            Expanded(
              child: Text(
                l10n.roleIndicatorEmployee,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await context.read<AuthCubit>().loginAsDemo(UserRole.manager);
                if (context.mounted) context.go(AppRoutes.approvals);
              },
              child: Text(
                l10n.roleIndicatorSwitchToManager,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colors.accentAmber,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colors.accentAmber.withValues(alpha: 0.15),
      child: Row(
        children: [
          Icon(Symbols.fact_check, size: 16, color: colors.accentAmber),
          8.gapW,
          Expanded(
            child: Text(
              l10n.managerPendingApprovalsBanner(9),
              style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.go(AppRoutes.approvals),
            child: Text(
              l10n.openApprovalsLink,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: colors.primaryIndigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
