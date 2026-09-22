import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Modal bottom sheet to pick leave type, start/end dates, reason, and attachment.
class LeaveRequestModal extends StatefulWidget {
  const new({
    required this.initialType,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onConfirm,
    super.key,
  });

  final String initialType;
  final String initialStartDate;
  final String initialEndDate;
  final void Function(String type, String startDate, String endDate, String totalDays, String reason) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required String initialType,
    required String initialStartDate,
    required String initialEndDate,
    required void Function(String type, String startDate, String endDate, String totalDays, String reason) onConfirm,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => LeaveRequestModal(
        initialType: initialType,
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<LeaveRequestModal> createState() => _LeaveRequestModalState();
}

class _LeaveRequestModalState extends State<LeaveRequestModal> {
  late String _selectedType;
  late String _startDate;
  late String _endDate;
  String? _attachedFileName;
  late TextEditingController _reasonController;

  final _leaveTypes = const [
    'Phép năm',
    'Nghỉ bệnh',
    'Không lương',
    'Phép đặc biệt',
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _reasonController = TextEditingController(
      text: 'Gia đình đã đặt chuyến đi, công việc đã bàn giao cho đồng nghiệp.',
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 9, 21),
      firstDate: DateTime(2026, 8),
      lastDate: DateTime(2026, 12),
    );
    if (picked != null) {
      final d = picked.day.toString().padLeft(2, '0');
      final m = picked.month.toString().padLeft(2, '0');
      setState(() => _startDate = '$d/$m/${picked.year}');
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 9, 23),
      firstDate: DateTime(2026, 8),
      lastDate: DateTime(2026, 12),
    );
    if (picked != null) {
      final d = picked.day.toString().padLeft(2, '0');
      final m = picked.month.toString().padLeft(2, '0');
      setState(() => _endDate = '$d/$m/${picked.year}');
    }
  }

  Future<void> _pickAttachment() async {
    final granted = await AppPermissionHandler.requestPhotos(context);
    if (!mounted) return;
    if (granted) {
      setState(() => _attachedFileName = 'don_xin_nghi.pdf');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã chọn tệp đính kèm: don_xin_nghi.pdf (1.2 MB)'),
          backgroundColor: Color(0xFF0F766E),
        ),
      );
    }
  }

  void _onConfirmTap() {
    Navigator.pop(context);
    widget.onConfirm(_selectedType, _startDate, _endDate, '3 ngày', _reasonController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 20, 18, bottomInset + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tạo đơn xin nghỉ phép', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                IconButton(icon: const Icon(Symbols.close, size: 20), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Loại nghỉ phép', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _leaveTypes.map((t) {
                final isSel = _selectedType == t;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedType = t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSel ? colors.primaryIndigo.withValues(alpha: 0.1) : colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSel ? colors.primaryIndigo : colors.border, width: isSel ? 1.5 : 1),
                    ),
                    child: Text(t, style: TextStyle(fontSize: 12.5, fontWeight: isSel ? FontWeight.w800 : FontWeight.w600, color: isSel ? colors.primaryIndigo : colors.textPrimary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _buildDatePickerTile('Từ ngày', _startDate, _pickStartDate, colors)),
                const SizedBox(width: 10),
                Expanded(child: _buildDatePickerTile('Đến ngày', _endDate, _pickEndDate, colors)),
              ],
            ),
            const SizedBox(height: 14),
            Text('Lý do', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickAttachment,
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_attachedFileName != null ? Symbols.check_circle : Symbols.attach_file, size: 16, color: _attachedFileName != null ? colors.primaryIndigo : colors.textSecondary),
                    const SizedBox(width: 6),
                    Text(_attachedFileName ?? 'Thêm tệp đính kèm (không bắt buộc)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF1C1408),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: _onConfirmTap,
                child: const Text('Xác nhận gửi đơn', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerTile(String label, String value, VoidCallback onTap, AppColorsExtension colors) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                Icon(Symbols.calendar_today, size: 14, color: colors.primaryIndigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
