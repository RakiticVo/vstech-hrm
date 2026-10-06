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
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_leave_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_plans_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/leave_request_modal.dart';

/// Screen 10: Leave Management & History with monthly filter and quick creation modal.
class LeaveRequestScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  List<LeavePlanEntity> _plans = [];
  LeavePlanEntity? _selectedPlan;
  DateTime _from = DateTime.now().add(const Duration(days: 1));
  DateTime _to = DateTime.now().add(const Duration(days: 1));
  double _totalDays = 1;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPlans());
  }

  Future<void> _loadPlans() async {
    final res = await sl<GetLeavePlansUseCase>()();
    if (!mounted) return;
    res.fold((_) {}, (plans) {
      if (plans.isNotEmpty) {
        setState(() {
          _plans = plans;
          _selectedPlan = plans.first;
        });
      }
    });
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _toYmd(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _cleanYmd(String? raw, DateTime fallback) {
    if (raw == null || raw.isEmpty) return _toYmd(fallback);
    if (raw.length >= 10 && raw.contains('-')) return raw.substring(0, 10);
    return _toYmd(fallback);
  }

  void _openModal() {
    unawaited(
      LeaveRequestModal.show(
        context,
        initialFrom: _from,
        initialTo: _to,
        availablePlans: _plans,
        initialPlanCode: _selectedPlan?.code,
        onConfirm: (plan, from, to, total, halfShift, reason) async {
          setState(() {
            _selectedPlan = plan;
            _from = from;
            _to = to;
            _totalDays = total;
          });
          await _submitLeave(plan, from, to, total, halfShift, reason);
        },
      ),
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
    setState(() => _isSubmitting = true);
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
    setState(() => _isSubmitting = false);

    final l10n = context.l10n;
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
        );
      },
      (_) {
        unawaited(
          AppSuccessDialog.show(
            context,
            title: l10n.leaveRequestSubmittedTitle,
            message: l10n.leaveRequestSubmittedMsg(
              plan.name,
              _formatDate(from),
              _formatDate(to),
              '${total.toStringAsFixed(1)} ngày',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.requestTypeLeave,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: const Color(0xFF1C1408),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _isSubmitting ? null : _openModal,
              child: _isSubmitting
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(l10n.submitRequestButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // 2 Stats Cards
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => context.push(AppRoutes.leaveBalance),
            child: Row(
              children: [
                Expanded(child: _buildStatCard(l10n.leaveRemainingStat, '6.5 ngày', colors.textPrimary, colors)),
                10.gapW,
                Expanded(child: _buildStatCard(l10n.leaveUsedStat, '5.5 ngày', colors.primaryIndigo, colors)),
              ],
            ),
          ),
          20.gapH,

          // Đơn nghỉ phép mới card preview
          Text(l10n.newLeaveRequestSection, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          10.gapH,
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _openModal,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFormRow(l10n.leaveTypeLabel, _selectedPlan?.name ?? 'Phép năm', colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.timeRangeLabel, '${_formatDate(_from)} — ${_formatDate(_to)}', colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.totalLabel, '${_totalDays.toStringAsFixed(1)} ngày', colors, isHighlight: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color valueColor, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
          6.gapH,
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildFormRow(String label, String value, AppColorsExtension colors, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: colors.textSecondary))),
        8.gapW,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isHighlight ? colors.primaryIndigo : colors.textPrimary)),
            4.gapW,
            AppIcon(AppIcons.correction, size: 14, color: colors.textTertiary),
          ],
        ),
      ],
    );
  }
}
