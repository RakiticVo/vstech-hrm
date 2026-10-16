import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Dialog prompting manager for a mandatory rejection reason.
class ApprovalRejectDialog extends StatelessWidget {
  const new({
    required this.onConfirm,
    super.key,
  });

  final void Function(String reason) onConfirm;

  static Future<void> show(BuildContext context, {required void Function(String reason) onConfirm}) {
    return showDialog<void>(
      context: context,
      builder: (_) => ApprovalRejectDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final colors = context.colors;
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.actionReject,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.approvalMandatoryRejectReason, style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
          8.gapH,
          TextField(
            controller: controller,
            maxLines: 3,
            style: TextStyle(fontSize: 13, color: colors.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.cardSecondary,
              hintText: 'Nhập lý do cụ thể...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancelButton, style: TextStyle(color: colors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: colors.error, foregroundColor: Colors.white),
          onPressed: () {
            final r = controller.text.trim();
            if (r.isEmpty) return;
            Navigator.pop(context);
            onConfirm(r);
          },
          child: Text(l10n.actionReject, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}
