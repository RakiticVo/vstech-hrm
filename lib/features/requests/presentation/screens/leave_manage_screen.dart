import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_leave_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_plans_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/leave_request_modal.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_status_filter_chips.dart';

/// Screen 11: Dedicated Leave Management Screen (`leave` in mockup & flow).
class LeaveManageScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LeaveManageScreen> createState() => _LeaveManageScreenState();
}

class _LeaveManageScreenState extends State<LeaveManageScreen> {
  String _selectedMonth = 'Tháng 9, 2026';
  String _selectedStatus = 'all';
  bool _isLoading = false;
  List<RequestData> _leaveRequests = [];
  List<LeavePlanEntity> _leavePlans = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    if (sl.isRegistered<GetLeavePlansUseCase>()) {
      final plansResult = await sl<GetLeavePlansUseCase>()();
      plansResult.fold((_) {}, (plans) => _leavePlans = plans);
    }
    if (!sl.isRegistered<GetLeaveRequestsUseCase>()) {
      setState(() => _isLoading = false);
      return;
    }
    final result = await sl<GetLeaveRequestsUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (entities) {
        setState(() {
          _isLoading = false;
          _leaveRequests = entities.map((e) {
            final statusCode = e.status == 0 ? 1 : (e.status == 1 ? 2 : 3);
            return RequestData(
              mark: 'P',
              type: '${e.leavePlan} · ${e.code}',
              dates: '${e.validFrom ?? ''} - ${e.validTo ?? ''}',
              status: e.statusText,
              statusCode: statusCode,
              stage: e.statusText,
              completedSteps: statusCode,
              requestTypeKey: 'leave',
            );
          }).toList();
        });
      },
    );
  }

  String _toYmd(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _cleanYmd(String? raw, DateTime fallback) {
    if (raw == null || raw.isEmpty) return _toYmd(fallback);
    if (raw.length >= 10 && raw.contains('-')) return raw.substring(0, 10);
    return _toYmd(fallback);
  }

  Future<void> _showCreateLeaveModal() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    await LeaveRequestModal.show(
      context,
      initialFrom: tomorrow,
      initialTo: tomorrow,
      availablePlans: _leavePlans,
      onConfirm: (plan, from, to, total, halfShift, reason) async {
        await _submitLeave(plan, from, to, total, halfShift, reason);
      },
    );
  }

  Future<void> _submitLeave(
    LeavePlanEntity plan,
    DateTime from,
    DateTime to,
    double total,
    String? halfShift,
    String reason,
  ) async {
    final fromStr = _toYmd(from);
    final toStr = _toYmd(to);
    final validFromStr = _cleanYmd(plan.validFrom, DateTime(from.year, 1, 1));
    final validToStr = _cleanYmd(plan.validTo, DateTime(from.year + 1, 3, 31));

    final params = CreateLeaveParams(
      from: fromStr,
      to: toStr,
      validFrom: validFromStr,
      validTo: validToStr,
      leavePlanCode: plan.code,
      leaveAmountType: total,
      halfShiftType: halfShift,
      note: reason,
      isMultiple: fromStr != toStr,
    );

    final result = await sl<CreateLeaveRequestUseCase>()(params);
    if (!mounted) return;

    final l10n = context.l10n;
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure?.message ?? 'Lỗi gửi đơn nghỉ phép'), backgroundColor: Colors.red),
      );
      return;
    }

    await _loadData();
    if (!mounted) return;
    final startStr = '${from.day.toString().padLeft(2, '0')}/${from.month.toString().padLeft(2, '0')}/${from.year}';
    final endStr = '${to.day.toString().padLeft(2, '0')}/${to.month.toString().padLeft(2, '0')}/${to.year}';
    await AppSuccessDialog.show(
      context,
      title: l10n.leaveRequestSubmittedTitle,
      message: l10n.leaveRequestSubmittedMsg(plan.name, startStr, endStr, '${total.toStringAsFixed(1)} ngày'),
    );
  }

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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: AppIcon(AppIcons.plus, color: colors.primaryIndigo, size: 22),
            tooltip: l10n.createLeaveBtn,
            onPressed: () => unawaited(_showCreateLeaveModal()),
          ),
        ],
      ),
      body: Column(
        children: [
          14.gapH,
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
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          10.gapH,
          RequestStatusFilterChips(
            selectedStatus: _selectedStatus,
            onStatusChanged: (s) => setState(() => _selectedStatus = s),
            options: filterOptions,
            colors: colors,
          ),
          12.gapH,
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: filtered.isEmpty
                        ? Center(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Center(
                                  child: Text(
                                    l10n.noRequestsInMonth(_selectedMonth),
                                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                  ),
                                ),
                              ],
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
                                onTap: () => context.push(
                                  AppRoutes.requestDetail,
                                  extra: {
                                    'code': req.type,
                                    'title': req.type,
                                    'category': 'leave',
                                    'requesterName': 'Nhân viên',
                                    'initialStatus': req.statusCode == 2
                                        ? 'approved'
                                        : req.statusCode == 3
                                            ? 'rejected'
                                            : 'pending',
                                    'isApprover': false,
                                  },
                                ),
                                child: RequestCard(item: req),
                              );
                            },
                          ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: PrimaryButton(
              text: l10n.createLeaveBtn,
              iconName: AppIcons.plus,
              onPressed: () => unawaited(_showCreateLeaveModal()),
            ),
          ),
        ],
      ),
    );
  }
}
