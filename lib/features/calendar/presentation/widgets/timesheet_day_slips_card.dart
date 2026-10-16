import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

/// Card displaying attached leave, overtime, and explanation slips for a specific day.
class TimesheetDaySlipsCard extends StatelessWidget {
  const new({
    required this.date,
    this.leaves = const [],
    this.overtimes = const [],
    this.corrections = const [],
    this.showSubmitCorrection = false,
    super.key,
  });

  final DateTime date;
  final List<LeaveItemEntity> leaves;
  final List<OvertimeItemEntity> overtimes;
  final List<CorrectionItemEntity> corrections;
  final bool showSubmitCorrection;

  bool get hasAnySlips =>
      leaves.isNotEmpty || overtimes.isNotEmpty || corrections.isNotEmpty || showSubmitCorrection;

  @override
  Widget build(BuildContext context) {
    if (!hasAnySlips) return const SizedBox.shrink();

    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.timesheetRelatedSlipsTitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
          8.gapH,
          for (final l in leaves)
            _buildItem(
              colors: colors,
              color: const Color(0xFF8B5CF6),
              icon: Icons.beach_access_rounded,
              title: '${l10n.timesheetLeaveSlip}: ${l.leavePlan}',
              subtitle: l.note ?? '',
              statusText: l.statusText,
              isApproved: l.isApproved,
            ),
          for (final o in overtimes)
            _buildItem(
              colors: colors,
              color: const Color(0xFFEA580C),
              icon: Icons.bolt_rounded,
              title: '${l10n.timesheetOvertimeSlip}: +${o.length ?? 0}h (${o.overtimeTypeName ?? l10n.legendOvertime})',
              subtitle: o.timeRange ?? o.note ?? '',
              statusText: o.statusText,
              isApproved: o.isApproved,
            ),
          for (final c in corrections)
            _buildItem(
              colors: colors,
              color: const Color(0xFF0284C7),
              icon: Icons.edit_note_rounded,
              title: '${l10n.timesheetExplanationSlip}: ${c.reasonTypeName ?? l10n.legendCorrection}',
              subtitle: [
                if (c.shiftName != null && c.shiftName!.isNotEmpty)
                  'Ca: ${c.shiftName}${c.shiftStart != null && c.shiftEnd != null ? ' (${c.shiftStart}-${c.shiftEnd})' : ''}',
                if (c.confirmerName != null)
                  l10n.timesheetApproverLabel(c.confirmerName!)
                else if (c.note != null && c.note!.isNotEmpty)
                  c.note!,
              ].join(' · '),
              statusText: c.isApproved
                  ? l10n.statusApproved
                  : (c.isReject ? l10n.statusRejected : l10n.statusPending),
              isApproved: c.isApproved,
            ),
          if (showSubmitCorrection && corrections.isEmpty) ...[
            8.gapH,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  unawaited(context.push(AppRoutes.attendanceCorrection));
                },
                icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                label: Text(l10n.timesheetSendCorrectionCta),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0284C7),
                  side: const BorderSide(color: Color(0xFF0284C7)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItem({
    required AppColorsExtension colors,
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required String statusText,
    required bool isApproved,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 16, color: color),
          ),
          8.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  3.gapH,
                  Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
          8.gapW,
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isApproved
                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                    : color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: isApproved ? const Color(0xFF10B981) : color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
