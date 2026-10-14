import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';
/// Widget rendering badges for attached leave, overtime, and explanation tickets of an employee.
class RosterTicketBadges extends StatelessWidget {
  const RosterTicketBadges({
    required this.item,
    super.key,
  });

  final ShiftRosterItemEntity item;

  @override
  Widget build(BuildContext context) {
    if (!item.hasTickets) return const SizedBox.shrink();

    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final leave in item.leaveRequests)
          _buildTicketBadge(
            color: const Color(0xFF8B5CF6),
            icon: Icons.beach_access_rounded,
            title: '${l10n.timesheetLeaveSlip}: ${leave.leavePlan}',
            status: leave.statusText,
            isApproved: leave.isApproved,
          ),
        for (final ot in item.overtimeRequests)
          _buildTicketBadge(
            color: colors.accentAmber,
            icon: Icons.bolt_rounded,
            title: '${l10n.timesheetOvertimeSlip}: +${ot.length ?? 0}h (${ot.overtimeTypeName ?? l10n.legendOvertime})',
            status: ot.statusText,
            isApproved: ot.isApproved,
          ),
        for (final corr in item.correctionRequests)
          _buildTicketBadge(
            color: const Color(0xFF0284C7),
            icon: Icons.edit_note_rounded,
            title: '${l10n.timesheetExplanationSlip}: ${corr.reasonTypeName ?? l10n.legendCorrection} (${corr.worktime ?? 0}h)',
            status: corr.isApproved
                ? l10n.statusApproved
                : (corr.isReject ? l10n.statusRejected : l10n.statusPending),
            isApproved: corr.isApproved,
          ),
      ],
    );
  }

  Widget _buildTicketBadge({
    required Color color,
    required IconData icon,
    required String title,
    required String status,
    required bool isApproved,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          5.gapW,
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          6.gapW,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: isApproved
                  ? const Color(0xFF10B981).withValues(alpha: 0.15)
                  : color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: isApproved ? const Color(0xFF10B981) : color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
