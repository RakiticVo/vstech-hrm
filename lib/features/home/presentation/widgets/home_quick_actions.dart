import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 5 circular action buttons in a row as defined in DESIGN.md §6 and Phone.dc.html.
/// 4 white buttons with border + 1 deep teal button for "Tất cả".
class HomeQuickActions extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final actions = [
      _ActionItem(
        label: l10n.quickActionLeave,
        icon: Symbols.calendar_today,
        onTap: () => context.push(AppRoutes.leaveCreate),
      ),
      _ActionItem(
        label: l10n.quickActionOvertime,
        icon: Symbols.schedule,
        onTap: () => context.push(AppRoutes.overtimeCreate),
      ),
      _ActionItem(
        label: l10n.quickActionCorrection,
        icon: Symbols.edit_note,
        badge: '1',
        onTap: () => context.push(AppRoutes.attendanceCorrection),
      ),
      _ActionItem(
        label: l10n.quickActionPayroll,
        icon: Symbols.receipt_long,
        onTap: () => context.push(AppRoutes.payslipDetail),
      ),
      _ActionItem(
        label: l10n.quickActionAll,
        icon: Symbols.more_horiz,
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
          color: colors.primaryIndigo,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Symbols.more_horiz,
            size: iconSize + 2,
            color: const Color(0xFFFFF8EC),
          ),
        ),
      );
    }

    final isBadgeItem = act.badge != null;

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
              color: isBadgeItem ? colors.error : colors.border,
            ),
          ),
          child: Center(
            child: Icon(
              act.icon,
              size: iconSize,
              color: isBadgeItem ? colors.error : colors.primaryIndigo,
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
  const new({
    required this.label,
    required this.icon,
    required this.onTap,
    this.badge,
    this.isAllButton = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;
  final bool isAllButton;
}
