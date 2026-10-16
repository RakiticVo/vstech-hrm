import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_card.dart';

/// Dialog for manager to verify and confirm employee's worktime.
class ConfirmTimesheetDialog extends StatefulWidget {
  const new({
    required this.item,
    required this.onConfirm,
    super.key,
  });

  final ApprovalItem item;
  final void Function(double? worktime, String? note) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required ApprovalItem item,
    required void Function(double? worktime, String? note) onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ConfirmTimesheetDialog(item: item, onConfirm: onConfirm),
    );
  }

  @override
  State<ConfirmTimesheetDialog> createState() => _ConfirmTimesheetDialogState();
}

class _ConfirmTimesheetDialogState extends State<ConfirmTimesheetDialog> {
  late final TextEditingController _hoursController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final defaultHours = widget.item.worktime ?? 8.0;
    _hoursController = TextEditingController(text: defaultHours.toStringAsFixed(1));
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.confirmTimesheetDialogTitle,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: colors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.item.name} · ${widget.item.dates}',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            12.gapH,
            Text(
              l10n.confirmTimesheetHoursLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            6.gapH,
            TextField(
              controller: _hoursController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.cardSecondary,
                suffixText: 'h',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
              ),
            ),
            10.gapH,
            Text(
              l10n.confirmTimesheetNoteLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            6.gapH,
            TextField(
              controller: _noteController,
              maxLines: 2,
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.cardSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancelButton,
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.pineGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.pop(context);
            final hours = double.tryParse(_hoursController.text);
            final note = _noteController.text.trim();
            widget.onConfirm(hours, note.isNotEmpty ? note : null);
          },
          child: Text(
            l10n.confirmTimesheetSubmitBtn,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
