import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
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
  String _selectedMonth = 'Tháng 9, 2026';

  final List<({String dates, String type, String duration, String status, Color color})> _history = [
    (dates: '21/09 — 23/09/2026', type: 'Phép năm', duration: '3 ngày', status: 'Chờ duyệt', color: const Color(0xFFF59E0B)),
    (dates: '14/08 — 15/08/2026', type: 'Nghỉ bệnh', duration: '2 ngày', status: 'Đã duyệt', color: const Color(0xFF0D9488)),
    (dates: '02/07/2026', type: 'Việc riêng', duration: '1 ngày', status: 'Đã duyệt', color: const Color(0xFF0D9488)),
    (dates: '10/06/2026', type: 'Không lương', duration: '1 ngày', status: 'Từ chối', color: const Color(0xFFE11D48)),
  ];

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
            _history.insert(
              0,
              (
                dates: '$start — $end',
                type: newType,
                duration: total,
                status: 'Chờ duyệt',
                color: const Color(0xFFF59E0B),
              ),
            );
          });
          unawaited(
            AppSuccessDialog.show(
              context,
              title: 'Đã gửi đơn xin nghỉ phép!',
              message: 'Đơn $newType từ $start đến $end ($total) đã được gửi tới Quản lý phê duyệt.',
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
      if (_selectedMonth.contains('9')) return h.dates.contains('09/');
      if (_selectedMonth.contains('8')) return h.dates.contains('08/');
      if (_selectedMonth.contains('7')) return h.dates.contains('07/');
      if (_selectedMonth.contains('6')) return h.dates.contains('06/');
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
          'Xin nghỉ phép',
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
              child: const Text('Gửi yêu cầu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
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
              Expanded(child: _buildStatCard('Phép năm còn', '6 ngày', colors.textPrimary, colors)),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard('Đã sử dụng', '6 ngày', colors.primaryIndigo, colors)),
            ],
          ),
          const SizedBox(height: 20),

          // Đơn nghỉ phép mới card preview
          Text('Đơn nghỉ phép mới', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          const SizedBox(height: 10),
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
                  _buildFormRow('Loại nghỉ', _type, colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow('Thời gian', '$_startDate — $_endDate', colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow('Tổng cộng', _totalDays, colors, isHighlight: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Lịch sử nghỉ phép header with MonthPickerButton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lịch sử đơn nghỉ phép', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
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
                'Không có đơn nghỉ phép nào trong $_selectedMonth',
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
                            Text(h.type, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                            const SizedBox(height: 3),
                            Text(h.dates, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
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
