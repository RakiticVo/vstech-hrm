import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/cancel_request_dialog.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_detail_approver_bar.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_detail_header_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_detail_submitted_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_detail_timeline.dart';

/// Screen 10 / G3: Universal Request Detail Screen (Employee view & Approver view).
class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({
    this.requestCode = 'RQ-2026-0934',
    this.title = 'Nghỉ phép năm · 1 ngày',
    this.category = 'leave',
    this.requesterName = 'Nguyễn Minh Tuấn (NV-04821)',
    this.department = 'Vận hành · Chi nhánh 01 (Quận 1)',
    this.initialStatus = 'pending',
    this.isApprover = false,
    this.fields = const [
      ('Loại phép', 'Nghỉ phép năm (Phép hưởng 100% lương)'),
      ('Thời gian', '24/09/2026 (08:00 — 17:00)'),
      ('Số ngày nghỉ', '1.0 ngày'),
      ('Người bàn giao', 'Lê Văn Tùng (NV-0142)'),
      ('Lý do', 'Việc cá nhân giải quyết thủ tục hành chính tại phường.'),
    ],
    this.swapComparison,
    this.attendanceSnippet,
    this.disputePayslipValue,
    this.disputeExpectedValue,
    this.disputeDifference,
    super.key,
  });

  final String requestCode;
  final String title;
  final String category;
  final String requesterName;
  final String department;
  final String initialStatus;
  final bool isApprover;
  final List<(String, String)> fields;
  final String? swapComparison;
  final String? attendanceSnippet;
  final String? disputePayslipValue;
  final String? disputeExpectedValue;
  final String? disputeDifference;

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
  }

  void _handleCancel() {
    final l10n = context.l10n;
    unawaited(
      CancelRequestDialog.show(context).then((confirmed) {
        if (confirmed == true && mounted) {
          setState(() => _status = 'cancelled');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.requestCancelledSuccess)),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            }
          });
        }
      }),
    );
  }

  void _handleApprove(String internalNote) {
    setState(() => _status = 'approved');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.requestApprovedSuccess(widget.requesterName))),
    );
    unawaited(Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop(true);
    }));
  }

  void _handleReject(String reason, String internalNote) {
    setState(() => _status = 'rejected');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.requestRejectedSuccess(widget.requesterName))),
    );
    unawaited(Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop(true);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final isPending = _status == 'pending';

    final timelineSteps = [
      TimelineStep(
        title: 'Nhân viên gửi yêu cầu',
        subtitle: widget.requesterName,
        timestamp: '16/09/2026 09:15',
        isCompleted: true,
      ),
      TimelineStep(
        title: 'Quản lý trực tiếp phê duyệt',
        subtitle: 'Lê Minh Quân (Giám đốc Vận hành)',
        timestamp: _status == 'approved' ? '16/09/2026 10:30' : 'Đang chờ',
        isCompleted: _status == 'approved',
        isRejected: _status == 'rejected',
        comment: _status == 'approved' ? 'Đồng ý phân công Tùng phụ trách ca' : null,
      ),
      const TimelineStep(
        title: 'Nhân sự đối soát quỹ phép & bảng công',
        subtitle: 'Phạm Thu Trang (HR Admin)',
        timestamp: 'Chờ bước trước',
        isCompleted: false,
      ),
      const TimelineStep(
        title: 'Phê duyệt cấp cuối (nếu vượt ngưỡng)',
        subtitle: 'Ban Giám đốc',
        timestamp: 'Chỉ đơn > 10 ngày',
        isCompleted: false,
      ),
    ];

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
          l10n.requestDetailTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: StatusChip(
                label: _status == 'approved'
                    ? l10n.leaveStatusFilterApproved
                    : _status == 'rejected'
                        ? l10n.leaveStatusFilterRejected
                        : _status == 'cancelled'
                            ? l10n.cancel
                            : l10n.leaveStatusFilterPending,
                type: _status == 'approved'
                    ? AppStatusType.approved
                    : _status == 'rejected'
                        ? AppStatusType.rejected
                        : AppStatusType.pending,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          RequestDetailHeaderCard(
            requestCode: widget.requestCode,
            department: widget.department,
            title: widget.title,
            requesterName: widget.requesterName,
          ),
          14.gapH,

          // Submitted Fields Card
          RequestDetailSubmittedCard(
            category: widget.category,
            fields: widget.fields,
            swapComparison: widget.swapComparison,
            attendanceSnippet: widget.attendanceSnippet,
            disputePayslipValue: widget.disputePayslipValue,
            disputeExpectedValue: widget.disputeExpectedValue,
            disputeDifference: widget.disputeDifference,
          ),
          14.gapH,

          // 4-Tier Approval Timeline
          RequestDetailTimeline(steps: timelineSteps),
        ],
      ),
      bottomNavigationBar: RequestDetailApproverBar(
        isApprover: widget.isApprover,
        isPending: isPending,
        onCancel: _handleCancel,
        onApprove: _handleApprove,
        onReject: _handleReject,
      ),
    );
  }
}
