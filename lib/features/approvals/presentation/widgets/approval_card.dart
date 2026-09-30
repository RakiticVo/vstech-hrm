import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

class ApprovalItem {
  const new({
    required this.initials,
    required this.name,
    required this.type,
    required this.dates,
    required this.reason,
    this.category = 'leave',
    this.attendanceSnippet,
    this.swapBothSchedules,
    this.internalNote,
  });

  final String initials;
  final String name;
  final String type;
  final String dates;
  final String reason;
  final String category;
  final String? attendanceSnippet;
  final String? swapBothSchedules;
  final String? internalNote;
}

class ApprovalCard extends StatefulWidget {
  const new({
    required this.item,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final ApprovalItem item;
  final VoidCallback onApprove;
  final void Function(String reason) onReject;

  @override
  State<ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<ApprovalCard> {
  bool _showDetails = false;

  void _showRejectDialog(BuildContext context, AppColorsExtension colors) {
    final controller = TextEditingController();
    final l10n = context.l10n;
    unawaited(
      showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.actionReject, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary)),
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancelButton, style: TextStyle(color: colors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colors.error, foregroundColor: Colors.white),
            onPressed: () {
              final r = controller.text.trim();
              if (r.isEmpty) return;
              Navigator.pop(ctx);
              widget.onReject(r);
            },
            child: Text(l10n.actionReject, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final item = widget.item;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: colors.cardSecondary, borderRadius: BorderRadius.circular(13)),
                child: Center(
                  child: Text(item.initials, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.primaryIndigo)),
                ),
              ),
              11.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                    2.gapH,
                    Text('${item.type} · ${item.dates}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(color: colors.accentAmber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(l10n.statusPending, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: colors.accentAmber)),
              ),
            ],
          ),
          10.gapH,

          // Reason card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(color: colors.cardSecondary, borderRadius: BorderRadius.circular(12)),
            child: Text(item.reason, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.45, color: colors.textSecondary)),
          ),

          // Shift swap schedules comparison
          if (item.swapBothSchedules != null) ...[
            8.gapH,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.primaryIndigo.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.primaryIndigo.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  AppIcon(AppIcons.shiftSwap, size: 18, color: colors.primaryIndigo),
                  8.gapW,
                  Expanded(
                    child: Text(
                      '${l10n.approvalSwapBothSchedules}:\n${item.swapBothSchedules}',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Attendance snapshot
          if (item.attendanceSnippet != null) ...[
            8.gapH,
            InkWell(
              onTap: () => setState(() => _showDetails = !_showDetails),
              child: Row(
                children: [
                  AppIcon(AppIcons.attendance, size: 15, color: colors.primaryIndigo),
                  6.gapW,
                  Expanded(
                    child: Text(
                      '${l10n.approvalAttendanceSnippet}: ${item.attendanceSnippet}',
                      style: TextStyle(fontSize: 11.5, color: colors.primaryIndigo, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          12.gapH,

          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 10,
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _showRejectDialog(context, colors),
                    child: Text(l10n.actionReject, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: colors.error)),
                  ),
                ),
              ),
              9.gapW,
              Expanded(
                flex: 14,
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.pineGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: widget.onApprove,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppIcon(AppIcons.check, size: 18, color: Colors.white),
                        6.gapW,
                        Text(l10n.actionApprove, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
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
