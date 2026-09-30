import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_card.dart';

/// Screen G3: Direct Manager Approval Center with type filters & detail insights.
class ApprovalsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  String _selectedCategory = 'all';

  final List<ApprovalItem> _approvals = [
    const ApprovalItem(
      initials: 'LT',
      name: 'Lê Văn Tùng (NV0142)',
      type: 'Đổi ca · 18/09/2026',
      dates: '18/09',
      reason: 'Đổi ca chiều để đi khám sức khỏe định kỳ. Đã thỏa thuận với Hương.',
      category: 'swap',
      swapBothSchedules: 'Tùng: Ca Sáng (08:00–17:00) ↔ Hương: Ca Chiều (13:00–21:00)',
    ),
    const ApprovalItem(
      initials: 'TN',
      name: 'Trần Văn Nam (NV0089)',
      type: 'Đi việc ngoài · 25/09/2026',
      dates: '25/09 (09:00 — 11:30)',
      reason: 'Làm việc tại Sở Kế hoạch & Đầu tư TP.HCM nộp hồ sơ dự án.',
      category: 'offSite',
      attendanceSnippet: 'Check-in tại xưởng lúc 07:55',
    ),
    const ApprovalItem(
      initials: 'PH',
      name: 'Phạm Thu Hương (NV0091)',
      type: 'Sửa công · thiếu giờ vào',
      dates: '14/09',
      reason: 'Máy chấm công cửa sau lỗi, bảo vệ xác nhận vào lúc 07:52.',
      category: 'correction',
      attendanceSnippet: 'Vào 07:52 (bảo vệ ghi sổ), Ra 17:05',
    ),
    const ApprovalItem(
      initials: 'LD',
      name: 'Lý Quốc Dũng (NV0054)',
      type: 'Tăng ca · 4 giờ (Hệ số 1.5)',
      dates: '18/09 (17:00 — 21:00)',
      reason: 'Kiểm kê cuối tháng, cần thêm người đóng gói ca đêm.',
      category: 'ot',
      attendanceSnippet: 'Quẹt thẻ ra về lúc 21:08',
    ),
    const ApprovalItem(
      initials: 'NM',
      name: 'Nguyễn Thị Mai (NV0077)',
      type: 'Nghỉ phép năm · 2 ngày',
      dates: '22–23/09',
      reason: 'Việc gia đình ở quê. Đã bàn giao tài liệu.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final filterOptions = [
      ('all', l10n.approvalTypeFilterAll),
      ('swap', l10n.approvalTypeFilterSwap),
      ('offSite', l10n.approvalTypeFilterOffSite),
      ('correction', l10n.approvalTypeFilterCorrection),
      ('ot', l10n.approvalTypeFilterOT),
      ('leave', l10n.approvalTypeFilterLeave),
    ];

    final filtered = _approvals.where((item) {
      if (_selectedCategory == 'all') return true;
      return item.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.border),
                      ),
                      child: Center(
                        child: AppIcon(AppIcons.back, size: 20, color: colors.textPrimary),
                      ),
                    ),
                  ),
                  12.gapW,
                  Expanded(
                    child: Text(
                      l10n.approvalsCenterTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.accentAmber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_approvals.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1C1408),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Filter Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: filterOptions.length,
                separatorBuilder: (_, _) => 8.gapW,
                itemBuilder: (ctx, idx) {
                  final opt = filterOptions[idx];
                  final isSelected = _selectedCategory == opt.$1;
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _selectedCategory = opt.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primaryIndigo : colors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? colors.primaryIndigo : colors.border),
                      ),
                      child: Text(
                        opt.$2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            10.gapH,

            // List of Approvals
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcon(AppIcons.approvals, size: 48, color: colors.pineGreen),
                          12.gapH,
                          Text(
                            l10n.noPendingApprovals,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, idx) {
                        final item = filtered[idx];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              context.push(
                                AppRoutes.requestDetail,
                                extra: {
                                  'code': 'RQ-2026-09${30 + idx}',
                                  'title': item.type,
                                  'category': item.category,
                                  'requesterName': item.name,
                                  'initialStatus': 'pending',
                                  'isApprover': true,
                                  'swapComparison': item.swapBothSchedules,
                                  'attendanceSnippet': item.attendanceSnippet,
                                  'fields': [
                                    ('Loại yêu cầu', item.type),
                                    ('Thời gian', item.dates),
                                    ('Lý do đề xuất', item.reason),
                                  ],
                                },
                              );
                            },
                            child: ApprovalCard(
                              item: item,
                              onApprove: () {
                                setState(() => _approvals.remove(item));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.requestApprovedSuccess(item.name))),
                                );
                              },
                              onReject: (reason) {
                                setState(() => _approvals.remove(item));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.requestRejectedSuccess(item.name))),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
