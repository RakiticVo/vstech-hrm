import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/app_toast.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/features/approvals/presentation/helpers/approvals_action_handler.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_card.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/cancel_leave_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/cancel_overtime_request_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/cancel_request_dialog.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_detail_approver_bar.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_detail_header_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_detail_submitted_card.dart';

/// Screen 10 / G3: Universal Request Detail Screen (Employee view & Approver view).
class RequestDetailScreen extends StatefulWidget {
  const new({
    this.requestCode = 'RQ-2026-0934',
    this.title = 'Nghỉ phép năm · 1 ngày',
    this.category = 'leave',
    this.requesterName = '',
    this.department,
    this.initialStatus = 'pending',
    this.isApprover = false,
    this.fields = const [
      ('Loại phép', 'Nghỉ phép năm (Phép hưởng 100% lương)'),
      ('Thời gian', '24/09/2026 (08:00 — 17:00)'),
      ('Số ngày nghỉ', '1.0 ngày'),
    ],
    this.swapComparison,
    this.attendanceSnippet,
    this.disputePayslipValue,
    this.disputeExpectedValue,
    this.disputeDifference,
    this.rawItem,
    super.key,
  });

  final String requestCode;
  final String title;
  final String category;
  final String requesterName;
  final String? department;
  final String initialStatus;
  final bool isApprover;
  final List<(String, String)> fields;
  final String? swapComparison;
  final String? attendanceSnippet;
  final String? disputePayslipValue;
  final String? disputeExpectedValue;
  final String? disputeDifference;
  final ApprovalItem? rawItem;

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  late String _status;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
  }

  Future<void> _handleCancel() async {
    final l10n = context.l10n;
    final confirmed = await CancelRequestDialog.show(context);
    if (confirmed != true || !mounted) return;

    setState(() => _isSubmitting = true);
    Either<Failure, bool>? result;
    if (widget.category == 'leave' && sl.isRegistered<CancelLeaveRequestUseCase>()) {
      result = await sl<CancelLeaveRequestUseCase>()(widget.requestCode);
    } else if (widget.category == 'ot' && sl.isRegistered<CancelOvertimeRequestUseCase>()) {
      result = await sl<CancelOvertimeRequestUseCase>()(widget.requestCode);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      result.fold(
        (f) => context.showErrorToast(f.message),
        (_) {
          setState(() => _status = 'cancelled');
          context.showSuccessToast(l10n.requestCancelledSuccess);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop('cancelled');
            }
          });
        },
      );
      return;
    }

    setState(() => _status = 'cancelled');
    context.showSuccessToast(l10n.requestCancelledSuccess);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop('cancelled');
      }
    });
  }

  Future<void> _handleApprove(String internalNote) async {
    final item = widget.rawItem;
    if (item != null) {
      setState(() => _isSubmitting = true);
      final res = await ApprovalsActionHandler.approve(
        item,
        hours: item.worktime,
        note: internalNote.isNotEmpty ? internalNote : null,
      );
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      res.fold(
        (f) => context.showErrorToast(f.message),
        (msg) {
          setState(() => _status = 'approved');
          context.showSuccessToast(
            msg.isNotEmpty
                ? msg
                : context.l10n.requestApprovedSuccess(widget.requesterName),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop('approved');
            }
          });
        },
      );
      return;
    }

    setState(() => _status = 'approved');
    context.showSuccessToast(
      context.l10n.requestApprovedSuccess(widget.requesterName),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop(true);
    });
  }

  Future<void> _handleReject(String reason, String internalNote) async {
    final item = widget.rawItem;
    if (item != null) {
      setState(() => _isSubmitting = true);
      final res = await ApprovalsActionHandler.reject(
        item,
        reason: reason,
      );
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      res.fold(
        (f) => context.showErrorToast(f.message),
        (msg) {
          setState(() => _status = 'rejected');
          context.showSuccessToast(
            msg.isNotEmpty
                ? msg
                : context.l10n.requestRejectedSuccess(widget.requesterName),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop('rejected');
            }
          });
        },
      );
      return;
    }

    setState(() => _status = 'rejected');
    context.showSuccessToast(
      context.l10n.requestRejectedSuccess(widget.requesterName),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final isPending = _status == 'pending';
    final currentSessionUser = sl.isRegistered<AuthCubit>() && sl<AuthCubit>().state is Authenticated
        ? (sl<AuthCubit>().state as Authenticated).user.name
        : null;
    final displayRequester = (widget.requesterName.isNotEmpty && widget.requesterName != 'Nhân viên')
        ? widget.requesterName
        : (currentSessionUser ?? 'Nhân viên');

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
        bottom: _isSubmitting
            ? const PreferredSize(
                preferredSize: Size.fromHeight(3),
                child: LinearProgressIndicator(),
              )
            : null,
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
            requesterName: displayRequester,
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
