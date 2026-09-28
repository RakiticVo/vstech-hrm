import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Bottom action bar for request detail (Employee mode vs Approver mode).
class RequestDetailApproverBar extends StatefulWidget {
  const RequestDetailApproverBar({
    required this.isApprover,
    required this.isPending,
    required this.onCancel,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final bool isApprover;
  final bool isPending;
  final VoidCallback onCancel;
  final void Function(String internalNote) onApprove;
  final void Function(String reason, String internalNote) onReject;

  @override
  State<RequestDetailApproverBar> createState() => _RequestDetailApproverBarState();
}

class _RequestDetailApproverBarState extends State<RequestDetailApproverBar> {
  final _internalNoteController = TextEditingController();

  @override
  void dispose() {
    _internalNoteController.dispose();
    super.dispose();
  }

  void _showRejectDialog() {
    final reasonController = TextEditingController();
    final colors = context.colors;
    final l10n = context.l10n;

    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          l10n.rejectRequestConfirm,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.approvalMandatoryRejectReason,
              style: TextStyle(fontSize: 12.5, color: colors.textSecondary),
            ),
            10.gapH,
            TextField(
              controller: reasonController,
              maxLines: 3,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.fillRequiredField,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) return;
              Navigator.of(ctx).pop();
              widget.onReject(reason, _internalNoteController.text.trim());
            },
            child: Text(l10n.leaveStatusFilterRejected),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    if (!widget.isPending) {
      return const SizedBox.shrink();
    }

    // Employee mode (Can cancel request)
    if (!widget.isApprover) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.error,
              side: BorderSide(color: colors.error.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Symbols.cancel, size: 20),
            label: Text(
              l10n.cancelRequestBtn,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            onPressed: widget.onCancel,
          ),
        ),
      );
    }

    // Approver mode
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _internalNoteController,
            decoration: InputDecoration(
              hintText: l10n.internalNoteHint,
              hintStyle: TextStyle(fontSize: 12.5, color: colors.textTertiary),
              prefixIcon: Icon(Symbols.note_alt, size: 18, color: colors.textSecondary),
              filled: true,
              fillColor: colors.cardSecondary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.border),
              ),
            ),
          ),
          12.gapH,
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      side: BorderSide(color: colors.error.withValues(alpha: 0.6)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Symbols.close, size: 18),
                    label: Text(
                      l10n.actionReject,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    onPressed: _showRejectDialog,
                  ),
                ),
              ),
              12.gapW,
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primaryIndigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Symbols.check, size: 18),
                    label: Text(
                      l10n.actionApprove,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    onPressed: () => widget.onApprove(_internalNoteController.text.trim()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
