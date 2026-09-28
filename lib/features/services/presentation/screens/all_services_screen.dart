import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 04: All Services grid hub categorized into 4 departments.
class AllServicesScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
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
              _ServiceItem(context.l10n.serviceCheckInOut, Symbols.power_settings_new, () => context.go(AppRoutes.attendance)),
              _ServiceItem(context.l10n.serviceShiftSchedule, Symbols.schedule, () => context.push(AppRoutes.shiftSchedule)),
              _ServiceItem(context.l10n.shiftSwapsManageTitle, Symbols.sync_alt, () => context.push(AppRoutes.shiftSwaps)),
              _ServiceItem(context.l10n.serviceMonthlyTimesheet, Symbols.calendar_month, () => context.push(AppRoutes.calendar)),
              _ServiceItem(context.l10n.serviceHolidays, Symbols.flag, () => context.push(AppRoutes.holidays)),
              _ServiceItem(context.l10n.registeredDeviceTitle, Symbols.smartphone, () => context.push(AppRoutes.registeredDevice)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryRequests,
            items: [
              _ServiceItem(context.l10n.leaveManageTitle, Symbols.beach_access, () => context.push(AppRoutes.leaveManage)),
              _ServiceItem(context.l10n.overtimeManageTitle, Symbols.schedule, () => context.push(AppRoutes.overtimeManage)),
              _ServiceItem(context.l10n.correctionManageTitle, Symbols.edit_calendar, () => context.push(AppRoutes.correctionManage)),
              _ServiceItem(context.l10n.shiftSwapsManageTitle, Symbols.swap_horiz, () => context.push(AppRoutes.shiftSwaps)),
              _ServiceItem(context.l10n.serviceTrackRequests, Symbols.list_alt, () => context.go(AppRoutes.requests)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryPayrollRewards,
            items: [
              _ServiceItem(context.l10n.serviceSalaryTable, Symbols.account_balance_wallet, () => context.go(AppRoutes.payroll)),
              _ServiceItem(context.l10n.servicePayslip, Symbols.receipt_long, () => context.push(AppRoutes.payslipDetail)),
              _ServiceItem(context.l10n.serviceRewards, Symbols.star, () => context.push(AppRoutes.rewards)),
              _ServiceItem(context.l10n.disputeManageTitle, Symbols.rate_review, () => context.push(AppRoutes.salaryDisputes)),
              _ServiceItem(context.l10n.serviceAllowance, Symbols.payments, () => context.go(AppRoutes.payroll)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryCareerProfile,
            items: [
              _ServiceItem(context.l10n.serviceInternalJobs, Symbols.work, () => context.push(AppRoutes.jobRecruitment)),
              _ServiceItem(context.l10n.myReferralsTitle, Symbols.group_add, () => context.push(AppRoutes.myReferrals)),
              _ServiceItem(context.l10n.onboardingHomeTitle, Symbols.flight_takeoff, () => context.push(AppRoutes.onboardingHome)),
              _ServiceItem(context.l10n.documentManagementTitle, Symbols.folder_shared, () => context.push(AppRoutes.documentManagement)),
              _ServiceItem(context.l10n.dependantsManageTitle, Symbols.family_restroom, () => context.push(AppRoutes.dependants)),
              _ServiceItem(context.l10n.serviceProfile, Symbols.person, () => context.go(AppRoutes.profile)),
              _ServiceItem(context.l10n.serviceSettings, Symbols.settings, () => context.push(AppRoutes.settings)),
              _ServiceItem(context.l10n.serviceApprovals, Symbols.fact_check, () => context.push(AppRoutes.approvals)),
            ],
            colors: colors,
          ),
          22.gapH,
          _buildCategory(
            title: context.l10n.categoryGovernance,
            items: [
              _ServiceItem(context.l10n.execDashboardTitle, Symbols.dashboard, () => context.push(AppRoutes.executiveDashboard)),
              _ServiceItem(context.l10n.finalApprovalTitle, Symbols.verified, () => context.push(AppRoutes.finalApproval)),
              _ServiceItem(context.l10n.riskTitle, Symbols.warning, () => context.push(AppRoutes.riskCompliance)),
              _ServiceItem(context.l10n.delTitle, Symbols.assignment_ind, () => context.push(AppRoutes.delegationCenter)),
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
                      child: Icon(
                        item.icon,
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
  const new(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}
