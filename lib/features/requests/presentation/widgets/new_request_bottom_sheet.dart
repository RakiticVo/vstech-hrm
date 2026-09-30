import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Modal bottom sheet for choosing which request type to create.
class NewRequestBottomSheet extends StatelessWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const NewRequestBottomSheet(),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String iconName,
    required String title,
    required String subtitle,
    required String route,
    required AppColorsExtension colors,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.primaryIndigo.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AppIcon(iconName, color: colors.primaryIndigo, size: 22),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: colors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11.5,
          color: colors.textSecondary,
        ),
      ),
      trailing: AppIcon(AppIcons.chevronRight, size: 20, color: colors.textSecondary),
      onTap: () {
        Navigator.pop(context);
        unawaited(context.push(route));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            12.gapH,
            Text(
              l10n.createNewRequestTitle,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            12.gapH,
            _buildOptionTile(
              context: context,
              iconName: AppIcons.leave,
              title: l10n.requestTypeLeave,
              subtitle: l10n.leaveBalanceBreakdownTitle,
              route: AppRoutes.leaveCreate,
              colors: colors,
            ),
            _buildOptionTile(
              context: context,
              iconName: AppIcons.overtime,
              title: l10n.requestTypeOvertime,
              subtitle: l10n.extraHoursBalanceTitle,
              route: AppRoutes.overtimeCreate,
              colors: colors,
            ),
            _buildOptionTile(
              context: context,
              iconName: AppIcons.correction,
              title: l10n.requestTypeCorrection,
              subtitle: l10n.attendanceTitle,
              route: AppRoutes.attendanceCorrection,
              colors: colors,
            ),
            _buildOptionTile(
              context: context,
              iconName: AppIcons.shiftSwap,
              title: l10n.requestTypeShiftSwap,
              subtitle: l10n.shiftSwapEligibilityCheck,
              route: AppRoutes.shiftSchedule,
              colors: colors,
            ),
            _buildOptionTile(
              context: context,
              iconName: AppIcons.location,
              title: l10n.requestTypeOnDuty,
              subtitle: l10n.onDutySubtitle,
              route: AppRoutes.onDutyCreate,
              colors: colors,
            ),
            _buildOptionTile(
              context: context,
              iconName: AppIcons.services,
              title: l10n.requestTypeBusinessTrip,
              subtitle: l10n.businessTripSubtitle,
              route: AppRoutes.businessTripCreate,
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }
}
