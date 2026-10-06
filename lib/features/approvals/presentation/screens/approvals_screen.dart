import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_timesheet_correction_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_timesheet_correction_usecase.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_card.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approvals_filter_chips.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/confirm_timesheet_dialog.dart';

/// Screen G3: Direct Manager Approval Center with type filters & detail insights.
class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  String _selectedCategory = 'all';
  bool _isLoading = false;
  List<ApprovalItem> _approvals = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadApprovals());
  }

  Future<void> _loadApprovals() async {
    setState(() => _isLoading = true);
    final result = await sl<GetPendingApprovalsUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (list) {
        setState(() {
          _isLoading = false;
          _approvals = list.map((e) {
            final code = e.employeeCode ?? 'NV-${e.id}';
            return ApprovalItem(
              id: e.id.toString(),
              initials: 'NV',
              name: 'Nhân viên $code',
              type: 'Xác nhận giờ công · ${e.reasonTypeName ?? 'Chờ xác nhận'}',
              dates: e.workDate ?? '',
              reason: e.note ?? e.reasonTypeName ?? 'Xác nhận giờ làm việc',
              category: 'correction',
              attendanceSnippet: 'Giờ làm: ${e.worktime ?? 0}h',
              worktime: e.worktime,
            );
          }).toList();
        });
      },
    );
  }

  Future<void> _handleApprove(ApprovalItem item) async {
    final idInt = int.tryParse(item.id ?? '');
    if (idInt == null) {
      setState(() => _approvals.remove(item));
      return;
    }

    if (item.category == 'correction') {
      await ConfirmTimesheetDialog.show(
        context,
        item: item,
        onConfirm: (hours, note) => _executeApprove(item, idInt, hours: hours, note: note),
      );
      return;
    }

    await _executeApprove(item, idInt);
  }

  Future<void> _executeApprove(ApprovalItem item, int idInt, {double? hours, String? note}) async {
    final res = await sl<ApproveTimesheetCorrectionUseCase>()(
      idInt,
      confirmedWorktime: hours,
      note: note,
    );
    if (!mounted) return;
    res.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: context.colors.error),
      ),
      (_) {
        setState(() => _approvals.remove(item));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.confirmTimesheetSuccess(item.name))),
        );
      },
    );
  }

  Future<void> _handleReject(ApprovalItem item, String reason) async {
    final idInt = int.tryParse(item.id ?? '');
    if (idInt != null) {
      final res = await sl<RejectTimesheetCorrectionUseCase>()(idInt, note: reason);
      if (!mounted) return;
      res.fold(
        (f) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message), backgroundColor: context.colors.error),
        ),
        (_) {
          setState(() => _approvals.remove(item));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.requestRejectedSuccess(item.name))),
          );
        },
      );
    } else {
      setState(() => _approvals.remove(item));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final filterOptions = [
      ('all', l10n.approvalTypeFilterAll),
      ('correction', l10n.approvalTypeFilterCorrection),
      ('ot', l10n.approvalTypeFilterOT),
      ('leave', l10n.approvalTypeFilterLeave),
      ('swap', l10n.approvalTypeFilterSwap),
      ('offSite', l10n.approvalTypeFilterOffSite),
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
                      onRefresh: _loadApprovals,
                      child: filtered.isEmpty
                          ? ListView(
                              children: [
                                120.gapH,
                                Center(
                                  child: Column(
                                    children: [
                                      AppIcon(AppIcons.approvals, size: 48, color: colors.pineGreen),
                                      12.gapH,
                                      Text(
                                        l10n.noPendingApprovals,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
    );
  }

  Future<void> _openDetail(ApprovalItem item, int idx) {
    return context.push(
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
  }
}
