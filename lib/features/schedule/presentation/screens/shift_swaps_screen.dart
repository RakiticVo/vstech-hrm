import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Screen for managing Shift Swap requests (`swaps` in mockup & flow).
class ShiftSwapsScreen extends StatefulWidget {
  const ShiftSwapsScreen({super.key});

  @override
  State<ShiftSwapsScreen> createState() => _ShiftSwapsScreenState();
}

class _ShiftSwapsScreenState extends State<ShiftSwapsScreen> {
  int _selectedTab = 0;

  final List<_SwapItemData> _sentSwaps = [];
  final List<_SwapItemData> _receivedSwaps = [];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final items = _selectedTab == 0 ? _sentSwaps : _receivedSwaps;

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
          l10n.shiftSwapsManageTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // 2 Tabs (Sent / Received)
          Container(
            color: colors.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: colors.cardSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? colors.surface : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedTab == 0
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                              : null,
                        ),
                        child: Text(
                          l10n.swapsSentTab,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _selectedTab == 0 ? colors.primaryIndigo : colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? colors.surface : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedTab == 1
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                              : null,
                        ),
                        child: Text(
                          l10n.swapsReceivedTab,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _selectedTab == 1 ? colors.primaryIndigo : colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          12.gapH,

          // List of swap items
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Chưa có yêu cầu đổi ca nào.',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: items.length,
              separatorBuilder: (_, _) => 12.gapH,
              itemBuilder: (ctx, index) {
                final item = items[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    unawaited(
                      context.push(
                        AppRoutes.requestDetail,
                        extra: {
                          'code': item.code,
                          'title': 'Đổi ca làm việc · ${item.dates}',
                          'category': 'swap',
                          'requesterName': _selectedTab == 0
                              ? 'Nguyễn Minh Tuấn (NV-04821)'
                              : item.colleague,
                          'initialStatus': item.statusCode == 2 ? 'approved' : 'pending',
                          'isApprover': false,
                          'swapComparison': item.shiftDetail,
                          'fields': [
                            ('Ngày đổi ca', item.dates),
                            ('Đồng nghiệp đổi', item.colleague),
                            ('Lý do đổi ca', item.reason),
                            ('Điều 109 BLLĐ', 'Hợp lệ (Nghỉ 14h giữa 2 ca)'),
                          ],
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.dates,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            StatusChip(
                              label: item.status,
                              type: item.statusCode == 2
                                  ? AppStatusType.approved
                                  : AppStatusType.pending,
                            ),
                          ],
                        ),
                        8.gapH,
                        Row(
                          children: [
                            AppIcon(AppIcons.profile, size: 16, color: colors.primaryIndigo),
                            6.gapW,
                            Text(
                              item.colleague,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: colors.primaryIndigo,
                              ),
                            ),
                          ],
                        ),
                        6.gapH,
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.cardSecondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.shiftDetail,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        8.gapH,
                        Text(
                          '“${item.reason}”',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapItemData {
  const _SwapItemData({
    required this.code,
    required this.colleague,
    required this.dates,
    required this.shiftDetail,
    required this.reason,
    required this.status,
    required this.statusCode,
  });

  final String code;
  final String colleague;
  final String dates;
  final String shiftDetail;
  final String reason;
  final String status;
  final int statusCode;
}
