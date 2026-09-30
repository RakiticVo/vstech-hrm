import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Screen 04: All Services grid hub categorized into 4 departments.
class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
              _ServiceItem(context.l10n.serviceShiftSchedule, AppIcons.shift, () => context.push(AppRoutes.shiftSchedule)),
              _ServiceItem(context.l10n.shiftSwapsManageTitle, AppIcons.shiftSwap, () => context.push(AppRoutes.shiftSwaps)),
              _ServiceItem(context.l10n.serviceMonthlyTimesheet, AppIcons.calendar, () => context.push(AppRoutes.calendar)),
              _ServiceItem(context.l10n.serviceHolidays, AppIcons.holiday, () => context.push(AppRoutes.holidays)),
              _ServiceItem(context.l10n.registeredDeviceTitle, AppIcons.device, () => context.push(AppRoutes.registeredDevice)),
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
              _ServiceItem(context.l10n.shiftSwapsManageTitle, AppIcons.shiftSwap, () => context.push(AppRoutes.shiftSwaps)),
              _ServiceItem(context.l10n.serviceTrackRequests, AppIcons.requests, () => context.go(AppRoutes.requests)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryPayrollRewards,
            items: [
              _ServiceItem(context.l10n.serviceSalaryTable, AppIcons.payroll, () => context.go(AppRoutes.payroll)),
              _ServiceItem(context.l10n.servicePayslip, AppIcons.payslip, () => context.push(AppRoutes.payslipDetail)),
              _ServiceItem(context.l10n.serviceRewards, AppIcons.bonus, () => context.push(AppRoutes.rewards)),
              _ServiceItem(context.l10n.disputeManageTitle, AppIcons.dispute, () => context.push(AppRoutes.salaryDisputes)),
              _ServiceItem(context.l10n.serviceAllowance, AppIcons.coin, () => context.go(AppRoutes.payroll)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryCareerProfile,
            items: [
              _ServiceItem(context.l10n.serviceInternalJobs, AppIcons.jobs, () => context.push(AppRoutes.jobRecruitment)),
              _ServiceItem(context.l10n.myReferralsTitle, AppIcons.refer, () => context.push(AppRoutes.myReferrals)),
              _ServiceItem(context.l10n.onboardingHomeTitle, AppIcons.onboarding, () => context.push(AppRoutes.onboardingHome)),
              _ServiceItem(context.l10n.documentManagementTitle, AppIcons.documents, () => context.push(AppRoutes.documentManagement)),
              _ServiceItem(context.l10n.dependantsManageTitle, AppIcons.dependants, () => context.push(AppRoutes.dependants)),
              _ServiceItem(context.l10n.serviceProfile, AppIcons.profile, () => context.go(AppRoutes.profile)),
              _ServiceItem(context.l10n.serviceSettings, AppIcons.settings, () => context.push(AppRoutes.settings)),
              _ServiceItem(context.l10n.serviceApprovals, AppIcons.approvals, () => context.push(AppRoutes.approvals)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryGovernance,
            items: [
              _ServiceItem(context.l10n.execDashboardTitle, AppIcons.target, () => context.push(AppRoutes.executiveDashboard)),
              _ServiceItem(context.l10n.finalApprovalTitle, AppIcons.approve, () => context.push(AppRoutes.finalApproval)),
              _ServiceItem(context.l10n.riskTitle, AppIcons.warning, () => context.push(AppRoutes.riskCompliance)),
              _ServiceItem(context.l10n.delTitle, AppIcons.orgChart, () => context.push(AppRoutes.delegationCenter)),
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
                        size: 24,
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
  const _ServiceItem(this.label, this.iconName, this.onTap);

  final String label;
  final String iconName;
  final VoidCallback onTap;
}

