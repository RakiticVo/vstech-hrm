import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Modal bottom sheet to pick date, issue type, corrected checkout time, and reason.
class AttendanceCorrectionModal extends StatefulWidget {
  const new({
    required this.initialDate,
    required this.initialIssue,
    required this.initialTime,
    required this.onConfirm,
    super.key,
  });

  final String initialDate;
  final String initialIssue;
  final String initialTime;
  final void Function(String date, String issue, String time, String reason) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required String initialDate,
    required String initialIssue,
    required String initialTime,
    required void Function(String date, String issue, String time, String reason) onConfirm,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => AttendanceCorrectionModal(
        initialDate: initialDate,
        initialIssue: initialIssue,
        initialTime: initialTime,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AttendanceCorrectionModal> createState() => _AttendanceCorrectionModalState();
}

class _AttendanceCorrectionModalState extends State<AttendanceCorrectionModal> {
  late String _selectedDate;
  late String _selectedIssue;
  late String _time;
  String? _attachedFileName;
  late TextEditingController _reasonController;

  final _issues = const [
    'Thiếu giờ ra',
    'Thiếu giờ vào',
    'Sai ca làm',
    'Lỗi máy quét',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedIssue = widget.initialIssue;
    _time = widget.initialTime;
    _reasonController = TextEditingController(
      text: 'Điện thoại hết pin cuối ca. Log bảo vệ ghi nhận tôi ra lúc 17:34.',
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 9, 15),
      firstDate: DateTime(2026, 8),
      lastDate: DateTime(2026, 12),
    );
    if (picked != null) {
      final d = picked.day.toString().padLeft(2, '0');
      final m = picked.month.toString().padLeft(2, '0');
      setState(() => _selectedDate = '$d/$m/${picked.year}');
    }
  }

  Future<void> _pickTime() async {
    final parts = _time.split(':');
    final initialH = int.tryParse(parts[0]) ?? 17;
    final initialM = parts.length > 1 ? (int.tryParse(parts[1]) ?? 34) : 0;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialH, minute: initialM),
    );
    if (picked != null) {
      final h = picked.hour.toString().padLeft(2, '0');
      final m = picked.minute.toString().padLeft(2, '0');
      setState(() => _time = '$h:$m');
    }
  }

  Future<void> _pickAttachment() async {
    final granted = await AppPermissionHandler.requestPhotos(context);
    if (!mounted) return;
    if (granted) {
      setState(() => _attachedFileName = 'bang_log_bao_ve.jpg');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã chọn minh chứng: bang_log_bao_ve.jpg (850 KB)'),
          backgroundColor: Color(0xFF0F766E),
        ),
      );
    }
  }

  void _onConfirmTap() {
    Navigator.pop(context);
    widget.onConfirm(_selectedDate, _selectedIssue, _time, _reasonController.text.trim());
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
                Text('Tạo yêu cầu sửa công', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                IconButton(icon: const Icon(Symbols.close, size: 20), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildPickerTile('Ngày sửa', _selectedDate, Symbols.calendar_today, _pickDate, colors)),
                const SizedBox(width: 10),
                Expanded(child: _buildPickerTile('Sửa thành giờ', _time, Symbols.schedule, _pickTime, colors)),
              ],
            ),
            const SizedBox(height: 14),
            Text('Vấn đề phát sinh', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _issues.map((issue) {
                final isSel = _selectedIssue == issue;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedIssue = issue),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSel ? colors.primaryIndigo.withValues(alpha: 0.1) : colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSel ? colors.primaryIndigo : colors.border, width: isSel ? 1.5 : 1),
                    ),
                    child: Text(issue, style: TextStyle(fontSize: 12.5, fontWeight: isSel ? FontWeight.w800 : FontWeight.w600, color: isSel ? colors.primaryIndigo : colors.textPrimary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Text('Giải trình chi tiết', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
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
                    Text(_attachedFileName ?? 'Đính kèm ảnh/minh chứng (không bắt buộc)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary)),
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
                child: const Text('Xác nhận gửi yêu cầu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerTile(String label, String value, IconData icon, VoidCallback onTap, AppColorsExtension colors) {
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
                Icon(icon, size: 14, color: colors.primaryIndigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
