import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/leave_request_modal.dart';

/// Screen 10: Leave Management & History with monthly filter and quick creation modal.
class LeaveRequestScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  String _type = 'Phép năm';
  String _startDate = '21/09/2026';
  String _endDate = '23/09/2026';
  String _totalDays = '3 ngày';

  void _openModal() {
    unawaited(
      LeaveRequestModal.show(
        context,
        initialType: _type,
        initialStartDate: _startDate,
        initialEndDate: _endDate,
        onConfirm: (newType, start, end, total, reason) {
          setState(() {
            _type = newType;
            _startDate = start;
            _endDate = end;
            _totalDays = total;
          });
          final l10n = context.l10n;
          unawaited(
            AppSuccessDialog.show(
              context,
              title: l10n.leaveRequestSubmittedTitle,
              message: l10n.leaveRequestSubmittedMsg(newType, start, end, total),
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
              onPressed: _openModal,
              child: Text(l10n.submitRequestButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
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
                  _buildFormRow(l10n.leaveTypeLabel, _type, colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.timeRangeLabel, '$_startDate — $_endDate', colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.totalLabel, _totalDays, colors, isHighlight: true),
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
        Expanded(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
        ),
        8.gapW,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isHighlight ? colors.primaryIndigo : colors.textPrimary,
              ),
            ),
            4.gapW,
            AppIcon(AppIcons.correction, size: 14, color: colors.textTertiary),
          ],
        ),
      ],
    );
  }
}
