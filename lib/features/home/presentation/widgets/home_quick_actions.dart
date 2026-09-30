import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// 5 circular action buttons in a row as defined in DESIGN.md §6 and Phone.dc.html.
/// 4 white buttons with border + 1 deep teal button for "Tất cả".
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final actions = [
      _ActionItem(
        label: l10n.quickActionLeave,
        iconName: AppIcons.leave,
        onTap: () => context.push(AppRoutes.leaveCreate),
      ),
      _ActionItem(
        label: l10n.quickActionOvertime,
        iconName: AppIcons.overtime,
        onTap: () => context.push(AppRoutes.overtimeCreate),
      ),
      _ActionItem(
        label: l10n.quickActionCorrection,
        iconName: AppIcons.correction,
        badge: '1',
        onTap: () => context.push(AppRoutes.attendanceCorrection),
      ),
      _ActionItem(
        label: l10n.quickActionPayroll,
        iconName: AppIcons.payslip,
        onTap: () => context.push(AppRoutes.payslipDetail),
      ),
      _ActionItem(
        label: l10n.quickActionAll,
        iconName: AppIcons.more,
        isAllButton: true,
        onTap: () => context.push(AppRoutes.services),
      ),
    ];

    final labelFontSize = context.custom(compact: 9.5, normal: 10.5, expanded: 11.5);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions
          .map((act) => Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: act.onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        _buildCircleButton(context, act, colors),
                        7.gapH,
                        Text(
                          act.label,
                          style: TextStyle(
                            fontSize: labelFontSize,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            height: 1.25,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCircleButton(BuildContext context, _ActionItem act, AppColorsExtension colors) {
    final size = context.custom(compact: 44, normal: 52, expanded: 58).toDouble();
    final iconSize = context.custom(compact: 19, normal: 22, expanded: 24).toDouble();

    if (act.isAllButton) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.tileDark,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AppIcon(
            AppIcons.more,
            size: iconSize + 2,
            color: const Color(0xFFFFF8EC),
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.border,
            ),
          ),
          child: Center(
            child: AppIcon(
              act.iconName,
              size: iconSize,
              color: colors.tealPrimary,
            ),
          ),
        ),
        if (act.badge != null)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colors.error,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  act.badge!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.label,
    required this.iconName,
    required this.onTap,
    this.badge,
    this.isAllButton = false,
  });

  final String label;
  final String iconName;
  final VoidCallback onTap;
  final String? badge;
  final bool isAllButton;
}

