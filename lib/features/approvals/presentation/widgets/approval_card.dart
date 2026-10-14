import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/approvals/presentation/models/approval_item.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_reject_dialog.dart';

export 'package:vstech_hrm/features/approvals/presentation/models/approval_item.dart';

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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final item = widget.item;
    final l10n = context.l10n;

    final statusBg = item.isApproved
        ? colors.pineGreen.withValues(alpha: 0.15)
        : item.isRejected
            ? colors.error.withValues(alpha: 0.15)
            : colors.accentAmber.withValues(alpha: 0.15);
    final statusColor = item.isApproved
        ? colors.pineGreen
        : item.isRejected
            ? colors.error
            : colors.accentAmber;
    final statusLabel = item.isApproved
        ? l10n.leaveStatusFilterApproved
        : item.isRejected
            ? l10n.leaveStatusFilterRejected
            : l10n.statusPending;

    final subtitleParts = <String>[
      item.type,
      if (item.dates.isNotEmpty) item.dates,
      if (item.worktime != null && item.worktime! > 0) '${item.worktime}h',
    ];

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
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.id != null && item.id!.isNotEmpty) ...[
                      2.gapH,
                      Text(
                        '#${item.id}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.primaryIndigo,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    3.gapH,
                    Text(
                      subtitleParts.join(' · '),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                child: Text(statusLabel, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: statusColor)),
              ),
            ],
          ),
          // Reason card - only shown if reason is not empty
          if (item.reason != null && item.reason!.trim().isNotEmpty) ...[
            10.gapH,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(color: colors.cardSecondary, borderRadius: BorderRadius.circular(12)),
              child: Text(item.reason!, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.45, color: colors.textSecondary)),
            ),
          ],

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

          // Action Buttons or Processed Status Bar
          if (item.isPending)
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
                      onPressed: () => unawaited(ApprovalRejectDialog.show(context, onConfirm: widget.onReject)),
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
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  AppIcon(
                    item.isApproved ? AppIcons.check : AppIcons.close,
                    size: 16,
                    color: statusColor,
                  ),
                  8.gapW,
                  Expanded(
                    child: Text(
                      item.isApproved ? 'Đã được phê duyệt' : 'Đã từ chối phiếu',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: statusColor),
                    ),
                  ),
                  Text(
                    'Xem chi tiết ›',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
