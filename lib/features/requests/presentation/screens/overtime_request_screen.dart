import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_request_modal.dart';

/// Screen 11: Register Overtime hours with estimate calculator and interactive input modal.
class OvertimeRequestScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OvertimeRequestScreen> createState() => _OvertimeRequestScreenState();
}

class _OvertimeRequestScreenState extends State<OvertimeRequestScreen> {
  String _date = '16/09/2026';
  String _time = '18:00 — 21:00';
  String _total = '3h · x1.5';

  void _openInputModal() {
    unawaited(
      OvertimeRequestModal.show(
        context,
        initialDate: _date,
        initialStart: '18:00',
        initialEnd: '21:00',
        onConfirm: (newDate, newTime, newTotal, reason) {
          setState(() {
            _date = newDate;
            _time = newTime;
            _total = newTotal;
          });
          final l10n = context.l10n;
          unawaited(
            AppSuccessDialog.show(
              context,
              title: l10n.overtimeSubmittedTitle,
              message: l10n.overtimeSubmittedMsg(newDate, newTime),
            ),
          );
        },
      ),
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
          l10n.requestTypeOvertime,
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
              onPressed: _openInputModal,
              child: Text(l10n.submitRequestButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // 2 Stats Cards: Tháng này, Đã thanh toán
          Row(
            children: [
              Expanded(child: _buildStatCard(l10n.thisMonthStat, '12h', colors.textPrimary, colors)),
              10.gapW,
              Expanded(child: _buildStatCard(l10n.paidStat, '1.8M', colors.primaryIndigo, colors)),
            ],
          ),
          12.gapH,

          // Monthly Approved OT Header (E2) & Extra Hours Link (E3)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push(AppRoutes.extraHours),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colors.primaryIndigo.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.primaryIndigo.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  AppIcon(AppIcons.overtime, size: 18, color: colors.primaryIndigo),
                  8.gapW,
                  Expanded(
                    child: Text(
                      l10n.otMonthlyApprovedHeader('28.5'),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primaryIndigo),
                    ),
                  ),
                  AppIcon(AppIcons.chevronRight, size: 16, color: colors.primaryIndigo),
                ],
              ),
            ),
          ),
          20.gapH,

          // Tăng ca mới
          Text(l10n.newOvertimeRequestSection, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          10.gapH,
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _openInputModal,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFormRow('Ngày', _date, colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow('Giờ', _time, colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.totalLabel, _total, colors, isHighlight: true),
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
