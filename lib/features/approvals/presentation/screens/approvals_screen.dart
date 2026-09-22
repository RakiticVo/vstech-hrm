import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_card.dart';

/// Screen 20: Direct Manager Approval Center (Phê duyệt quản lý).
/// Matches Image 20 reference and Phone.dc.html lines 820–858.
class ApprovalsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  final _approvals = [
    const ApprovalItem(
      initials: 'TN',
      name: 'Trần Văn Nam',
      type: 'Nghỉ phép năm · 2 ngày',
      dates: '22–23/09',
      reason: 'Về quê dự cưới em trai. Đã đổi ca với Hương.',
    ),
    const ApprovalItem(
      initials: 'PH',
      name: 'Phạm Thu Hương',
      type: 'Sửa công · thiếu giờ vào',
      dates: '14/09',
      reason: 'Máy chấm công cửa sau lỗi, bảo vệ xác nhận vào lúc 07:52.',
    ),
    const ApprovalItem(
      initials: 'LD',
      name: 'Lý Quốc Dũng',
      type: 'Tăng ca · 4 giờ',
      dates: '18/09',
      reason: 'Kiểm kê cuối tháng, cần thêm người buổi tối.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header matching Phone.dc.html line 822 & Image 20:
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                        child: Icon(
                          Symbols.chevron_left,
                          size: 20,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  12.gapW,
                  Expanded(
                    child: Text(
                      l10n.approvalsCenterTitle,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // Section Title: "Chờ bạn xử lý"
                  Text(
                    l10n.awaitingYourAction,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: colors.textPrimary,
                    ),
                  ),
                  11.gapH,

                  // Approvals Cards List
                  if (_approvals.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          l10n.noPendingApprovals,
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._approvals.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ApprovalCard(
                          item: item,
                          onApprove: () {
                            setState(() => _approvals.remove(item));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.requestApprovedSuccess(item.name)),
                              ),
                            );
                          },
                          onReject: () {
                            setState(() => _approvals.remove(item));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.requestRejectedSuccess(item.name)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
