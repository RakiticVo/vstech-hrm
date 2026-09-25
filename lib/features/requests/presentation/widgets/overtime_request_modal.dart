import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Modal bottom sheet to pick date, hours, reason, and compensation for overtime.
class OvertimeRequestModal extends StatefulWidget {
  const new({
    required this.initialDate,
    required this.initialStart,
    required this.initialEnd,
    required this.onConfirm,
    super.key,
  });

  final String initialDate;
  final String initialStart;
  final String initialEnd;
  final void Function(String date, String time, String total, String reason) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required String initialDate,
    required String initialStart,
    required String initialEnd,
    required void Function(String date, String time, String total, String reason) onConfirm,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => OvertimeRequestModal(
        initialDate: initialDate,
        initialStart: initialStart,
        initialEnd: initialEnd,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<OvertimeRequestModal> createState() => _OvertimeRequestModalState();
}

class _OvertimeRequestModalState extends State<OvertimeRequestModal> {
  late String _selectedDate;
  late String _startTime;
  late String _endTime;
  late TextEditingController _reasonController;
  bool _isCompOff = false;

  bool get _isHoliday => _selectedDate.contains('02/09') || _selectedDate.contains('30/04') || _selectedDate.contains('01/05');
  bool get _isWeekend => _selectedDate.contains('20/09') || _selectedDate.contains('27/09');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _startTime = widget.initialStart;
    _endTime = widget.initialEnd;
    _reasonController = TextEditingController(text: 'Kiểm kê và hỗ trợ đóng hàng bàn giao đối tác.');
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final rateLabel = _isHoliday ? l10n.otRateHoliday : (_isWeekend ? l10n.otRateWeekend : l10n.otRateWeekday);
    final rateFactor = _isHoliday ? 'x3.0' : (_isWeekend ? 'x2.0' : 'x1.5');

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 20, 18, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.overtimeModalTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary)),
              IconButton(icon: const Icon(Symbols.close, size: 20), onPressed: () => Navigator.pop(context)),
            ],
          ),
          12.gapH,

          // Date Selection
          Text(l10n.overtimeDateLabel, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          6.gapH,
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2026, 9, 16),
                firstDate: DateTime(2026, 8),
                lastDate: DateTime(2026, 12),
              );
              if (picked != null) {
                setState(() => _selectedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(color: colors.cardSecondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDate, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                  Icon(Symbols.calendar_month, size: 18, color: colors.primaryIndigo),
                ],
              ),
            ),
          ),
          12.gapH,

          // Time range
          Text(l10n.overtimeTimeRangeLabel, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          6.gapH,
          Row(
            children: [
              Expanded(child: _buildTimePickerTile(l10n.startTimeLabel, _startTime, colors)),
              10.gapW,
              Expanded(child: _buildTimePickerTile(l10n.endTimeLabel, _endTime, colors)),
            ],
          ),
          10.gapH,

          // Dynamic rate badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(color: colors.pineGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(Symbols.bolt, size: 16, color: colors.pineGreen),
                6.gapW,
                Expanded(child: Text(rateLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.pineGreen))),
              ],
            ),
          ),
          10.gapH,

          // Compensation Choice: Paid vs Comp-off
          Row(
            children: [
              Expanded(
                child: _buildCompTile(l10n.otCompensationPay, !_isCompOff, colors.primaryIndigo, () => setState(() => _isCompOff = false), colors),
              ),
              8.gapW,
              Expanded(
                child: _buildCompTile(l10n.otCompensationCompOff, _isCompOff, colors.accentAmber, () => setState(() => _isCompOff = true), colors),
              ),
            ],
          ),
          12.gapH,

          // Reason field
          Text(l10n.overtimeReasonLabel, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          6.gapH,
          TextField(
            controller: _reasonController,
            maxLines: 2,
            style: TextStyle(fontSize: 13, color: colors.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.cardSecondary,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
            ),
          ),
          18.gapH,

          // Confirm Button
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: const Color(0xFF1C1408),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.pop(context);
                final compTag = _isCompOff ? ' (Nghỉ bù)' : '';
                widget.onConfirm(_selectedDate, '$_startTime — $_endTime', '3h · $rateFactor$compTag', _reasonController.text);
              },
              child: Text(l10n.confirmSendOvertime, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompTile(String text, bool active, Color activeColor, VoidCallback onTap, AppColorsExtension colors) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? activeColor : colors.cardSecondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? activeColor : colors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: active ? (activeColor == colors.accentAmber ? const Color(0xFF1C1408) : Colors.white) : colors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildTimePickerTile(String label, String value, AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: colors.cardSecondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
          2.gapH,
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        ],
      ),
    );
  }
}
