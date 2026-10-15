import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Screen 04: All Services grid hub categorized into 4 departments.
class AllServicesScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;
    final isManager = authState is Authenticated &&
        (authState.user.role.isManager ||
            authState.user.role.isAdmin ||
            authState.user.claims.contains('manager.approve') ||
            authState.user.claims.contains('hr:admin'));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.allServicesTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildCategory(
            title: context.l10n.categoryAttendanceTime,
            items: [
              _ServiceItem(context.l10n.serviceCheckInOut, AppIcons.checkIn, () => context.go(AppRoutes.attendance)),
              _ServiceItem(context.l10n.calendarScreenTitle, AppIcons.calendar, () => context.push(AppRoutes.shiftSchedule)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryRequests,
            items: [
              _ServiceItem(context.l10n.leaveManageTitle, AppIcons.leave, () => context.push(AppRoutes.leaveManage)),
              _ServiceItem(context.l10n.overtimeManageTitle, AppIcons.overtime, () => context.push(AppRoutes.overtimeManage)),
              _ServiceItem(context.l10n.correctionManageTitle, AppIcons.correction, () => context.push(AppRoutes.correctionManage)),
              if (isManager)
                _ServiceItem(
                  context.l10n.approvalsCenterTitle,
                  AppIcons.approvals,
                  () => context.go(AppRoutes.approvals),
                ),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryPayrollRewards,
            items: [
              _ServiceItem(context.l10n.serviceSalaryTable, AppIcons.payroll, () => context.go(AppRoutes.payroll)),
              _ServiceItem(context.l10n.disputeManageTitle, AppIcons.dispute, () => context.push(AppRoutes.salaryDisputes)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.profile,
            items: [
              _ServiceItem(context.l10n.serviceProfile, AppIcons.profile, () => context.go(AppRoutes.profile)),
              _ServiceItem(context.l10n.serviceSettings, AppIcons.settings, () => context.push(AppRoutes.settings)),
            ],
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildCategory({
    required String title,
    required List<_ServiceItem> items,
    required AppColorsExtension colors,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 14,
            crossAxisSpacing: 8,
            childAspectRatio: 0.72,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: item.onTap,
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Center(
                      child: AppIcon(
                        item.iconName,
                        color: colors.primaryIndigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ServiceItem {
  const new(
    this.label,
    this.iconName,
    this.onTap,
  );

  final String label;
  final String iconName;
  final VoidCallback? onTap;
}
