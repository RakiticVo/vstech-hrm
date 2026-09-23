import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/attendance_correction_modal.dart';

/// Screen 12: Attendance Correction Management & History with monthly filter and quick creation modal.
class AttendanceCorrectionScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AttendanceCorrectionScreen> createState() => _AttendanceCorrectionScreenState();
}

class _AttendanceCorrectionScreenState extends State<AttendanceCorrectionScreen> {
  String _date = '15/09/2026';
  String _issue = 'Thiếu giờ ra';
  String _time = '17:34';
  String _selectedMonth = 'Tháng 9, 2026';

  final List<({String date, String issue, String detail, String status, Color color})> _history = [
    (date: '15/09/2026', issue: 'Thiếu giờ ra', detail: 'Sửa ra 17:34', status: 'Chờ duyệt', color: const Color(0xFFF59E0B)),
    (date: '08/09/2026', issue: 'Thiếu giờ vào', detail: 'Sửa vào 08:02', status: 'Đã duyệt', color: const Color(0xFF0D9488)),
    (date: '25/08/2026', issue: 'Sai ca làm', detail: 'Sửa ra 17:30', status: 'Đã duyệt', color: const Color(0xFF0D9488)),
    (date: '12/08/2026', issue: 'Lỗi máy quét', detail: 'Sửa vào 08:30', status: 'Từ chối', color: const Color(0xFFE11D48)),
  ];

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
            _history.insert(
              0,
              (
                date: newDate,
                issue: newIssue,
                detail: 'Sửa $newTime',
                status: 'Chờ duyệt',
                color: const Color(0xFFF59E0B),
              ),
            );
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

    final filteredHistory = _history.where((h) {
      if (_selectedMonth == 'Tất cả') return true;
      if (_selectedMonth.contains('9')) return h.date.contains('09/');
      if (_selectedMonth.contains('8')) return h.date.contains('08/');
      if (_selectedMonth.contains('7')) return h.date.contains('07/');
      if (_selectedMonth.contains('6')) return h.date.contains('06/');
      return true;
    }).toList();

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
          24.gapH,

          // Lịch sử sửa công with MonthPickerButton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.correctionHistorySection, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
              MonthPickerButton(
                selectedMonth: _selectedMonth,
                onMonthChanged: (m) => setState(() => _selectedMonth = m),
                isCompact: true,
              ),
            ],
          ),
          10.gapH,
          if (filteredHistory.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Text(
                l10n.noCorrectionsInMonth(_selectedMonth),
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
            )
          else
            ...filteredHistory.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${h.date} · ${h.issue}', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                            3.gapH,
                            Text(h.detail, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: h.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            h.status,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: h.color),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
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
        Text(label, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isHighlight ? colors.primaryIndigo : colors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Symbols.edit, size: 14, color: colors.textTertiary),
          ],
        ),
      ],
    );
  }
}
