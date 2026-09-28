import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Screen for managing salary discrepancy disputes (`dispute` in mockup & flow).
class SalaryDisputeScreen extends StatefulWidget {
  const SalaryDisputeScreen({super.key});

  @override
  State<SalaryDisputeScreen> createState() => _SalaryDisputeScreenState();
}

class _SalaryDisputeScreenState extends State<SalaryDisputeScreen> {
  int _selectedTabIndex = 0;

  final _allDisputes = [
    _DisputeItem(
      code: 'KN-2026-0418',
      period: '09/2026',
      itemName: 'Lương tăng ca 150%',
      payslipAmount: '1.800.000 ₫',
      expectedAmount: '2.450.000 ₫',
      difference: '+650.000 ₫',
      status: 'pending',
      date: '28/09/2026',
      reason: 'Thiếu 4h tăng ca ngày thứ 7 tuần trước tại cơ sở 1.',
    ),
    _DisputeItem(
      code: 'KN-2026-0390',
      period: '08/2026',
      itemName: 'Phụ cấp ăn trưa & đi lại',
      payslipAmount: '1.000.000 ₫',
      expectedAmount: '1.200.000 ₫',
      difference: '+200.000 ₫',
      status: 'approved',
      date: '06/09/2026',
      reason: 'Bổ sung 4 ngày đi công tác ngoại tỉnh.',
    ),
    _DisputeItem(
      code: 'KN-2026-0312',
      period: '07/2026',
      itemName: 'Trừ vi phạm quẹt thẻ',
      payslipAmount: '-300.000 ₫',
      expectedAmount: '0 ₫',
      difference: '+300.000 ₫',
      status: 'rejected',
      date: '07/08/2026',
      reason: 'Quên chấm công ra ca tối nhưng có camera ghi nhận.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final tabs = [
      l10n.leaveStatusFilterAll,
      l10n.disputeStatusPending,
      l10n.disputeStatusApproved,
      l10n.leaveStatusFilterRejected,
    ];

    final filtered = _allDisputes.where((item) {
      if (_selectedTabIndex == 1) return item.status == 'pending';
      if (_selectedTabIndex == 2) return item.status == 'approved';
      if (_selectedTabIndex == 3) return item.status == 'rejected';
      return true;
    }).toList();

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
          l10n.disputeManageTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = _selectedTabIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tabs[index]),
                      selected: isSelected,
                      selectedColor: colors.primaryIndigo,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : colors.textSecondary,
                      ),
                      onSelected: (_) => setState(() => _selectedTabIndex = index),
                    ),
                  );
                }),
              ),
            ),
          ),
          Divider(height: 1, color: colors.border),

          // Disputes List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      l10n.noDisputesFound,
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => 12.gapH,
                    itemBuilder: (ctx, index) {
                      final item = filtered[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          unawaited(
                            context.push(
                              AppRoutes.requestDetail,
                              extra: {
                                'code': item.code,
                                'title': 'Khiếu nại: ${item.itemName} (${item.period})',
                                'category': 'dispute',
                                'requesterName': 'Nguyễn Minh Tuấn (NV-04821)',
                                'initialStatus': item.status,
                                'isApprover': false,
                                'disputePayslipValue': item.payslipAmount,
                                'disputeExpectedValue': item.expectedAmount,
                                'disputeDifference': item.difference,
                                'fields': [
                                  ('Kỳ lương', 'Tháng ${item.period}'),
                                  ('Khoản mục', item.itemName),
                                  ('Số tiền phiếu', item.payslipAmount),
                                  ('Số tiền đúng', item.expectedAmount),
                                  ('Chênh lệch', item.difference),
                                  ('Lý do', item.reason),
                                ],
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colors.border),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.code,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: colors.primaryIndigo,
                                    ),
                                  ),
                                  StatusChip(
                                    label: item.status == 'approved'
                                        ? l10n.disputeStatusApproved
                                        : item.status == 'rejected'
                                            ? l10n.leaveStatusFilterRejected
                                            : l10n.disputeStatusPending,
                                    type: item.status == 'approved'
                                        ? AppStatusType.approved
                                        : item.status == 'rejected'
                                            ? AppStatusType.rejected
                                            : AppStatusType.pending,
                                  ),
                                ],
                              ),
                              8.gapH,
                              Text(
                                item.itemName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                              4.gapH,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kỳ lương: Tháng ${item.period}',
                                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                                  ),
                                  Text(
                                    item.difference,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: item.difference.startsWith('+') ? colors.pineGreen : colors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: PrimaryButton(
              text: l10n.disputeNewTitle,
              onPressed: () => context.push(AppRoutes.salaryDisputeNew),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisputeItem {
  const _DisputeItem({
    required this.code,
    required this.period,
    required this.itemName,
    required this.payslipAmount,
    required this.expectedAmount,
    required this.difference,
    required this.status,
    required this.date,
    required this.reason,
  });

  final String code;
  final String period;
  final String itemName;
  final String payslipAmount;
  final String expectedAmount;
  final String difference;
  final String status;
  final String date;
  final String reason;
}
