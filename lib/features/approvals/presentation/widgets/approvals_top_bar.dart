import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Top bar for the Approvals Center with back button, badge, and quick action.
class ApprovalsTopBar extends StatelessWidget {
  const new({
    required this.pendingCount,
    this.onCreateOvertime,
    super.key,
  });

  final int pendingCount;
  final VoidCallback? onCreateOvertime;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Center(
                child: AppIcon(AppIcons.back, size: 20, color: colors.textPrimary),
              ),
            ),
          ),
          10.gapW,
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    l10n.approvalsCenterTitle,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                8.gapW,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.accentAmber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$pendingCount',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1C1408),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onCreateOvertime != null) ...[
            8.gapW,
            Tooltip(
              message: l10n.createOvertimeForSubordinate,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onCreateOvertime,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.pineGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.pineGreen.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Icon(Icons.more_time_rounded, size: 20, color: colors.pineGreen),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
