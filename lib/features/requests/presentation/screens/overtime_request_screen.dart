import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_request_modal.dart';

/// Screen 11: Register Overtime hours with monthly filter, estimate calculator and interactive input modal.
class OvertimeRequestScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OvertimeRequestScreen> createState() => _OvertimeRequestScreenState();
}

class _OvertimeRequestScreenState extends State<OvertimeRequestScreen> {
  String _date = '16/09/2026';
  String _time = '18:00 — 21:00';
  String _total = '3h · x1.5';
  String _selectedMonth = 'Tháng 9, 2026';

  final List<({String date, String time, String duration, String status, Color color})> _history = [
    (date: '12/09/2026', time: '18:00 — 21:00', duration: '3h', status: 'Đã duyệt', color: const Color(0xFF0D9488)),
    (date: '05/09/2026', time: '18:00 — 22:00', duration: '4h', status: 'Đã duyệt', color: const Color(0xFF0D9488)),
    (date: '29/08/2026', time: '18:00 — 21:00', duration: '3h', status: 'Đã duyệt', color: const Color(0xFF0D9488)),
    (date: '22/08/2026', time: '18:00 — 20:00', duration: '2h', status: 'Từ chối', color: const Color(0xFFE11D48)),
  ];

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
            _history.insert(
              0,
              (
                date: newDate,
                time: newTime,
                duration: newTotal.split(' · ')[0],
                status: 'Chờ duyệt',
                color: const Color(0xFFF59E0B),
              ),
            );
          });
          unawaited(
            AppSuccessDialog.show(
              context,
              title: 'Đã gửi đăng ký tăng ca!',
              message: 'Yêu cầu làm thêm giờ ngày $newDate ($newTime) đã được gửi cho Quản lý phê duyệt.',
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
          'Đăng ký tăng ca',
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
              child: const Text('Gửi yêu cầu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
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
              Expanded(child: _buildStatCard('Tháng này', '12h', colors.textPrimary, colors)),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard('Đã thanh toán', '1.8M', colors.primaryIndigo, colors)),
            ],
          ),
          const SizedBox(height: 20),

          // Tăng ca mới
          Text('Tăng ca mới', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          const SizedBox(height: 10),
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
                  _buildFormRow('Tổng cộng', _total, colors, isHighlight: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Lịch sử tăng ca with MonthPickerButton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lịch sử tăng ca', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
              MonthPickerButton(
                selectedMonth: _selectedMonth,
                onMonthChanged: (m) => setState(() => _selectedMonth = m),
                isCompact: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (filteredHistory.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Text(
                'Không có dữ liệu tăng ca trong $_selectedMonth',
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
                            Text(h.date, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(h.time, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(h.duration, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                            const SizedBox(width: 12),
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
