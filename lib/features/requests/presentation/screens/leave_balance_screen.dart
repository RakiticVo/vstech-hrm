import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

class LeaveBalanceItem {
  const new({
    required this.typeKey,
    required this.name,
    required this.entitled,
    required this.used,
    required this.pending,
    required this.available,
    required this.iconName,
  });

  final String typeKey;
  final String name;
  final double entitled;
  final double used;
  final double pending;
  final double available;
  final String iconName;
}

/// Screen D1: Leave Balance by Type (6 types including Comp-off).
class LeaveBalanceScreen extends StatelessWidget {
  const new({super.key});

  List<LeaveBalanceItem> _buildLeaveBalances(BuildContext context) {
    final l10n = context.l10n;
    return [
      LeaveBalanceItem(
        typeKey: 'annual',
        name: l10n.requestTypeLeave,
        entitled: 12,
        used: 4.5,
        pending: 1,
        available: 6.5,
        iconName: AppIcons.leave,
      ),
      LeaveBalanceItem(
        typeKey: 'compoff',
        name: l10n.leaveTypeCompOff,
        entitled: 3,
        used: 1,
        pending: 0,
        available: 2,
        iconName: AppIcons.overtime,
      ),
      LeaveBalanceItem(
        typeKey: 'sick',
        name: l10n.leaveTypeSick,
        entitled: 30,
        used: 2,
        pending: 0,
        available: 28,
        iconName: AppIcons.attendance,
      ),
      LeaveBalanceItem(
        typeKey: 'personal',
        name: l10n.leaveTypePaidPersonal,
        entitled: 3,
        used: 0,
        pending: 0,
        available: 3,
        iconName: AppIcons.profile,
      ),
      LeaveBalanceItem(
        typeKey: 'unpaid',
        name: l10n.leaveTypeUnpaid,
        entitled: 10,
        used: 1,
        pending: 0,
        available: 9,
        iconName: AppIcons.calendar,
      ),
      LeaveBalanceItem(
        typeKey: 'maternity',
        name: l10n.leaveTypeMaternity,
        entitled: 180,
        used: 0,
        pending: 0,
        available: 180,
        iconName: AppIcons.dependants,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final balances = _buildLeaveBalances(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.leaveBalanceBreakdownTitle,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.back, color: colors.textPrimary, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Top Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.pineGreen.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: AppIcon(AppIcons.leave, color: colors.pineGreen, size: 20),
                      ),
                      10.gapW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.annualLeaveRemaining(6.5.toString()),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              l10n.leaveExcludeWeekendHint,
                              style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  14.gapH,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primaryIndigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size.fromHeight(42),
                    ),
                    onPressed: () => context.push(AppRoutes.leaveCreate),
                    child: Text(
                      l10n.createNewRequestTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            16.gapH,
            ...balances.map((b) => _buildBalanceCard(context, b, colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    LeaveBalanceItem item,
    AppColorsExtension colors,
  ) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primaryIndigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppIcon(item.iconName, color: colors.primaryIndigo, size: 18),
              ),
              10.gapW,
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.availableDays(item.available.toString()),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colors.pineGreen,
                  ),
                ),
              ),
            ],
          ),
          12.gapH,
          Divider(height: 1, color: colors.border),
          10.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(l10n.leaveBalanceEntitlement, '${item.entitled}', colors.textPrimary, colors),
              _buildStat(l10n.leaveBalanceUsed, '${item.used}', colors.textSecondary, colors),
              _buildStat(l10n.leaveBalancePending, '${item.pending}', colors.accentAmber, colors),
              _buildStat(l10n.leaveBalanceAvailable, '${item.available}', colors.pineGreen, colors),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color valColor, AppColorsExtension colors) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: valColor)),
        2.gapH,
        Text(label, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
      ],
    );
  }
}
