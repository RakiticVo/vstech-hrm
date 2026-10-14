import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/app_toast.dart';
import 'package:vstech_hrm/features/approvals/presentation/helpers/approvals_action_handler.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_card.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approvals_empty_view.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approvals_filter_chips.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approvals_status_tabs.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approvals_top_bar.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/confirm_timesheet_dialog.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_overtime_request_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_request_modal.dart';

/// Screen G3: Direct Manager Approval Center with type filters & detail insights.
class ApprovalsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  String _selectedCategory = 'all';
  int _statusTab = 0;
  bool _isLoading = false;
  List<ApprovalItem> _approvals = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadApprovals());
  }

  Future<void> _loadApprovals({bool forceRefresh = false}) async {
    setState(() => _isLoading = true);
    final items = await ApprovalsActionHandler.loadAllPendingApprovals(forceRefresh: forceRefresh);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _approvals = items;
    });
  }

  Future<void> _handleApprove(ApprovalItem item) async {
    if (item.category == 'timesheet' || item.category == 'correction') {
      await ConfirmTimesheetDialog.show(
        context,
        item: item,
        onConfirm: (hours, note) => _executeApprove(item, hours: hours, note: note),
      );
      return;
    }

    await _executeApprove(item);
  }

  Future<void> _executeApprove(ApprovalItem item, {double? hours, String? note}) async {
    final res = await ApprovalsActionHandler.approve(item, hours: hours, note: note);
    if (!mounted) return;
    res.fold(
      (f) => context.showErrorToast(f.message),
      (msg) {
        final idx = _approvals.indexWhere((a) => a.id == item.id && a.category == item.category);
        if (idx != -1) {
          setState(() {
            _approvals[idx] = item.copyWith(status: 1, statusText: 'Đã duyệt');
          });
        }
        context.showSuccessToast(
          msg.isNotEmpty ? msg : context.l10n.confirmTimesheetSuccess(item.name),
        );
      },
    );
  }

  Future<void> _handleReject(ApprovalItem item, String reason) async {
    final res = await ApprovalsActionHandler.reject(item, reason: reason);
    if (!mounted) return;
    res.fold(
      (f) => context.showErrorToast(f.message),
      (msg) {
        final idx = _approvals.indexWhere((a) => a.id == item.id && a.category == item.category);
        if (idx != -1) {
          setState(() {
            _approvals[idx] = item.copyWith(status: 2, statusText: 'Từ chối');
          });
        }
        context.showSuccessToast(
          msg.isNotEmpty ? msg : context.l10n.requestRejectedSuccess(item.name),
        );
      },
    );
  }

  Future<void> _openCreateOvertimeModal() async {
    await OvertimeRequestModal.show(
      context,
      initialDate: DateTime.now(),
      isManager: true,
      onConfirm: (type, date, start, end, length, reason, {employeeCode, employeeName, accept}) async {
        final auth = context.read<AuthCubit>().state;
        final curEmp = auth is Authenticated ? auth.user.employeeCode : 'NV001';
        final empCode = employeeCode ?? curEmp;
        final isSub = employeeCode != null && employeeCode != curEmp;
        final ymd = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final sH = start.hour.toString().padLeft(2, '0');
        final sM = start.minute.toString().padLeft(2, '0');
        final eH = end.hour.toString().padLeft(2, '0');
        final eM = end.minute.toString().padLeft(2, '0');

        final params = CreateOvertimeParams(
          employeeCode: empCode,
          adminEmployeeCode: isSub ? empCode : null,
          accept: accept,
          date: ymd,
          length: length,
          overtimeTypeCode: type.code,
          startOvertime: '${ymd}T$sH:$sM:00',
          endOvertime: '${ymd}T$eH:$eM:00',
          note: reason,
        );

        final result = await sl<CreateOvertimeRequestUseCase>()(params);
        if (!mounted) return null;

        if (result.isLeft()) {
          return result.getLeft().toNullable()?.message ?? 'Lỗi gửi yêu cầu tăng ca';
        }

        final l10n = context.l10n;
        final dStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        final msg = isSub
            ? l10n.overtimeSubmittedForSubordinateMsg(dStr, employeeName ?? empCode)
            : l10n.overtimeSubmittedMsg(dStr, '$sH:$sM - $eH:$eM');

        await AppSuccessDialog.show(context, title: l10n.overtimeSubmittedTitle, message: msg);
        await _loadApprovals(forceRefresh: true);
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final pendingCount = _approvals.where((a) => a.isPending).length;
    final processedCount = _approvals.where((a) => !a.isPending).length;

    final filterOptions = [
      ('all', l10n.approvalTypeFilterAll),
      ('timesheet', l10n.approvalTypeFilterCorrection),
      ('ot', l10n.approvalTypeFilterOT),
      ('leave', l10n.approvalTypeFilterLeave),
    ];

    final filtered = _approvals.where((item) {
      if (_selectedCategory != 'all') {
        if (_selectedCategory == 'timesheet') {
          if (item.category != 'timesheet' && item.category != 'correction') return false;
        } else if (item.category != _selectedCategory) {
          return false;
        }
      }
      if (_statusTab == 0) return item.isPending;
      if (_statusTab == 1) return !item.isPending;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ApprovalsTopBar(
              pendingCount: pendingCount,
              onCreateOvertime: _openCreateOvertimeModal,
            ),
            ApprovalsStatusTabs(
              selectedTab: _statusTab,
              pendingCount: pendingCount,
              processedCount: processedCount,
              totalCount: _approvals.length,
              onTabChanged: (tab) => setState(() => _statusTab = tab),
            ),
            ApprovalsFilterChips(
              options: filterOptions,
              selectedKey: _selectedCategory,
              onSelected: (key) => setState(() => _selectedCategory = key),
            ),
            10.gapH,
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _loadApprovals(forceRefresh: true),
                      child: filtered.isEmpty
                          ? const ApprovalsEmptyView()
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                              itemCount: filtered.length,
                              itemBuilder: (ctx, idx) {
                                final item = filtered[idx];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () => unawaited(_openDetail(item, idx)),
                                    child: ApprovalCard(
                                      item: item,
                                      onApprove: () => _handleApprove(item),
                                      onReject: (reason) => _handleReject(item, reason),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateOvertimeModal,
        backgroundColor: colors.pineGreen,
        icon: const Icon(Icons.more_time_rounded, color: Colors.white, size: 20),
        label: Text(
          context.l10n.createOvertimeForSubordinate,
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Future<void> _openDetail(ApprovalItem item, int idx) async {
    final statusStr = item.isApproved ? 'approved' : (item.isRejected ? 'rejected' : 'pending');
    final hasReason = item.reason != null && item.reason!.trim().isNotEmpty;
    final fields = <(String, String)>[
      if (item.id != null && item.id!.isNotEmpty) ('Mã yêu cầu', item.id!),
      ('Loại yêu cầu', item.type), ('Người gửi', item.name),
      if (item.department != null && item.department!.trim().isNotEmpty) ('Nơi làm việc', item.department!),
      ('Thời gian', item.dates),
      if (item.worktime != null && item.worktime! > 0) ('Giờ làm việc', '${item.worktime}h'),
      if (hasReason) ('Lý do / Ghi chú', item.reason!),
      if (item.attendanceSnippet != null && item.attendanceSnippet!.isNotEmpty) ('Chi tiết', item.attendanceSnippet!),
    ];

    final result = await context.push<dynamic>(
      AppRoutes.requestDetail,
      extra: {
        'code': item.id ?? 'RQ-${item.category.toUpperCase()}',
        'title': item.type, 'category': item.category,
        'requesterName': item.name, 'department': item.department,
        'initialStatus': statusStr, 'isApprover': true, 'rawItem': item,
        'swapComparison': item.swapBothSchedules,
        'attendanceSnippet': item.attendanceSnippet,
        'fields': fields,
      },
    );

    if (result == 'approved' || result == true) {
      final matchIdx = _approvals.indexWhere((a) => a.id == item.id && a.category == item.category);
      if (matchIdx != -1 && mounted) {
        setState(() {
          _approvals[matchIdx] = item.copyWith(status: 1, statusText: 'Đã duyệt');
        });
      }
    } else if (result == 'rejected') {
      final matchIdx = _approvals.indexWhere((a) => a.id == item.id && a.category == item.category);
      if (matchIdx != -1 && mounted) {
        setState(() {
          _approvals[matchIdx] = item.copyWith(status: 2, statusText: 'Từ chối');
        });
      }
    }
  }
}
