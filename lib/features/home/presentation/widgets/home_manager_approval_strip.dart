import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Manager pending approval strip widget displayed on HomeScreen for Manager role.
class HomeManagerApprovalStrip extends StatelessWidget {
  const HomeManagerApprovalStrip({
    required this.pendingCount,
    super.key,
  });

  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final stripSize = context.custom(normal: 38, compact: 32).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.accentAmber, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(AppRoutes.approvals),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: stripSize,
                  height: stripSize,
                  decoration: BoxDecoration(
                    color: colors.accentAmber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: AppIcon(
                      AppIcons.approvals,
                      color: Color(0xFF1C1408),
                      size: 20,
                    ),
                  ),
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.managerPendingApprovalTitle,
                        style: TextStyle(
                          fontSize: context.custom(normal: 14, compact: 13),
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        l10n.managerApprovalPending,
                        style: TextStyle(
                          fontSize: context.custom(normal: 12, compact: 11),
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$pendingCount',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: colors.accentAmber,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                4.gapW,
                AppIcon(
                  AppIcons.chevronRight,
                  color: colors.accentAmber,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
