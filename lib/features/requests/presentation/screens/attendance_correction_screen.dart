import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/attendance_correction_modal.dart';

/// Screen 12: Attendance Correction with quick creation modal and warning alert.
class AttendanceCorrectionScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AttendanceCorrectionScreen> createState() => _AttendanceCorrectionScreenState();
}

class _AttendanceCorrectionScreenState extends State<AttendanceCorrectionScreen> {
  String _date = '15/09/2026';
  String _issue = 'Thiếu giờ ra';
  String _time = '17:34';

  void _openModal() {
    unawaited(
      AttendanceCorrectionModal.show(
        context,
        initialDate: _date,
        initialIssue: _issue,
        initialTime: _time,
        onConfirm: (newDate, newIssue, newTime, reason) {
          setState(() {
            _date = newDate;
            _issue = newIssue;
            _time = newTime;
          });
          final l10n = context.l10n;
          unawaited(
            AppSuccessDialog.show(
              context,
              title: l10n.correctionSubmittedTitle,
              message: l10n.correctionSubmittedMsg(newIssue, newDate, newTime),
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
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.requestTypeCorrection,
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
          Row(
            children: [
              Expanded(child: _buildStatCard(l10n.thisMonthStat, '2 đơn', colors.textPrimary, colors)),
              10.gapW,
              Expanded(child: _buildStatCard(l10n.needsActionStat, '1 ngày', const Color(0xFFE11D48), colors)),
            ],
          ),
          14.gapH,

          // Red Warning alert banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDA4AF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Symbols.error, size: 18, color: Color(0xFFE11D48)),
                8.gapW,
                Expanded(
                  child: Text(
                    l10n.correctionWarningBanner,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE11D48), height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          18.gapH,

          // Yêu cầu sửa công mới preview card
          Text(l10n.newCorrectionRequestSection, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
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
                  _buildFormRow(l10n.correctionDateLabel, _date, colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.correctionIssueTitle, _issue, colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.correctionChangeTo, _time, colors, isHighlight: true),
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
          const SizedBox(height: 6),
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
            Icon(Symbols.edit, size: 14, color: colors.textTertiary),
          ],
        ),
      ],
    );
  }
}
