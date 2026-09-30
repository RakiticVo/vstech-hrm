import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/leave_hero_balance_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';

/// Screen 11: Dedicated Leave Management Screen (`leave` in mockup & flow).
class LeaveManageScreen extends StatefulWidget {
  const LeaveManageScreen({super.key});

  @override
  State<LeaveManageScreen> createState() => _LeaveManageScreenState();
}

class _LeaveManageScreenState extends State<LeaveManageScreen> {
  String _selectedMonth = 'Tháng 9, 2026';
  String _selectedStatus = 'all';

  final _leaveRequests = const [
    RequestData(
      mark: 'P',
      type: 'Nghỉ phép năm · 1 ngày',
      dates: '24/09/2026',
      status: 'Chờ duyệt',
      statusCode: 1,
      stage: 'Chờ quản lý',
      completedSteps: 1,
      requestTypeKey: 'leave',
    ),
    RequestData(
      mark: 'P',
      type: 'Nghỉ việc riêng có lương · 0.5 ngày',
      dates: '18/09/2026 (Buổi chiều)',
      status: 'Đã duyệt',
      statusCode: 2,
      stage: 'Hoàn tất',
      completedSteps: 2,
      requestTypeKey: 'leave',
    ),
    RequestData(
      mark: 'P',
      type: 'Nghỉ không lương · 1 ngày',
      dates: '10/09/2026',
      status: 'Từ chối',
      statusCode: 3,
      stage: 'Từ chối',
      completedSteps: 1,
      requestTypeKey: 'leave',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final filterOptions = [
      ('all', l10n.leaveStatusFilterAll),
      ('pending', l10n.leaveStatusFilterPending),
      ('approved', l10n.leaveStatusFilterApproved),
      ('rejected', l10n.leaveStatusFilterRejected),
    ];

    final filtered = _leaveRequests.where((item) {
      if (_selectedStatus == 'pending') return item.statusCode == 1;
      if (_selectedStatus == 'approved') return item.statusCode == 2;
      if (_selectedStatus == 'rejected') return item.statusCode == 3;
      return true;
    }).toList();

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
          l10n.leaveManageTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: AppIcon(AppIcons.leave, color: colors.primaryIndigo, size: 20),
            onPressed: () => context.push(AppRoutes.leaveBalance),
          ),
        ],
      ),
      body: Column(
        children: [
          // Hero Balance Card
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: LeaveHeroBalanceCard(),
          ),

          // 1. Month Picker Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MonthPickerButton(
                  selectedMonth: _selectedMonth,
                  onMonthChanged: (m) => setState(() => _selectedMonth = m),
                ),
                Text(
                  '${filtered.length} ${l10n.requests.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          10.gapH,

          // 2. Status Filter Chips Row (Scrollable horizontally)
          SizedBox(
            height: 34,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: filterOptions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final opt = filterOptions[index];
                final isSelected = _selectedStatus == opt.$1;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedStatus = opt.$1),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primaryIndigo : colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? colors.primaryIndigo : colors.border,
                      ),
                    ),
                    child: Text(
                      opt.$2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : colors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          12.gapH,

          // List of Leave Requests
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      l10n.noRequestsInMonth(_selectedMonth),
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => 10.gapH,
                    itemBuilder: (ctx, index) {
                      final req = filtered[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          unawaited(
                            context.push(
                              AppRoutes.requestDetail,
                              extra: {
                                'code': 'RQ-2026-0934',
                                'title': req.type,
                                'category': 'leave',
                                'requesterName': 'Nguyễn Minh Tuấn (NV-04821)',
                                'initialStatus': req.statusCode == 2
                                    ? 'approved'
                                    : req.statusCode == 3
                                        ? 'rejected'
                                        : 'pending',
                                'isApprover': false,
                              },
                            ),
                          );
                        },
                        child: RequestCard(item: req),
                      );
                    },
                  ),
          ),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: PrimaryButton(
              text: l10n.createLeaveBtn,
              iconName: AppIcons.plus,
              onPressed: () => context.push(AppRoutes.leaveCreate),
            ),
          ),
        ],
      ),
    );
  }
}
