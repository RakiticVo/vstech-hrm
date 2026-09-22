import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.proofSelected('bang_log_bao_ve.jpg', '850 KB')),
            backgroundColor: const Color(0xFF0F766E),
          ),
        );
      }
    }
  }

  void _onConfirmTap() {
    Navigator.pop(context);
    widget.onConfirm(_selectedDate, _selectedIssue, _time, _reasonController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final issues = [
      l10n.issueMissingCheckout,
      l10n.issueMissingCheckin,
      l10n.issueWrongShift,
      l10n.issueScannerError,
    ];

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
                Text(l10n.createCorrectionTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                IconButton(icon: const Icon(Symbols.close, size: 20), onPressed: () => Navigator.pop(context)),
              ],
            ),
            12.gapH,
            Row(
              children: [
                Expanded(child: _buildPickerTile(l10n.correctionDateLabel, _selectedDate, Symbols.calendar_today, _pickDate, colors)),
                10.gapW,
                Expanded(child: _buildPickerTile(l10n.correctionTimeLabel, _time, Symbols.schedule, _pickTime, colors)),
              ],
            ),
            14.gapH,
            Text(l10n.correctionIssueLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            8.gapH,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: issues.map((issue) {
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
            14.gapH,
            Text(l10n.explanationDetailLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            6.gapH,
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
            12.gapH,
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
                    6.gapW,
                    Text(_attachedFileName ?? l10n.addProofOptional, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary)),
                  ],
                ),
              ),
            ),
            18.gapH,
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
                child: Text(l10n.confirmSendCorrection, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
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
            4.gapH,
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
