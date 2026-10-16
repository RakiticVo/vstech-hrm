import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';
/// Widget rendering badges for attached leave, overtime, and explanation tickets of an employee.
class RosterTicketBadges extends StatelessWidget {
  const new({
    required this.item,
    super.key,
  });

  final ShiftRosterItemEntity item;

  @override
  Widget build(BuildContext context) {
    if (!item.hasTickets) return const SizedBox.shrink();

    final colors = context.colors;
    final l10n = context.l10n;
    final maxBadgeWidth = context.wp(65);

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          for (final leave in item.leaveRequests)
            _buildTicketBadge(
              maxWidth: maxBadgeWidth,
              color: const Color(0xFF8B5CF6),
              icon: Icons.beach_access_rounded,
              title: leave.leavePlan.trim().isNotEmpty
                  ? leave.leavePlan.trim()
                  : l10n.legendLeave,
              status: leave.statusText,
              isApproved: leave.isApproved,
            ),
          for (final ot in item.overtimeRequests)
            _buildTicketBadge(
              maxWidth: maxBadgeWidth,
              color: colors.accentAmber,
              icon: Icons.bolt_rounded,
              title: '+${ot.length != null ? (ot.length! % 1 == 0 ? ot.length!.toInt() : ot.length) : 0}h ${l10n.legendOvertime}',
              status: ot.statusText,
              isApproved: ot.isApproved,
            ),
          for (final corr in item.correctionRequests)
            _buildTicketBadge(
              maxWidth: maxBadgeWidth,
              color: const Color(0xFF0284C7),
              icon: Icons.edit_note_rounded,
              title: corr.reasonTypeName?.trim().isNotEmpty == true
                  ? corr.reasonTypeName!.trim()
                  : l10n.legendCorrection,
              status: corr.isApproved
                  ? l10n.statusApproved
                  : (corr.isReject ? l10n.statusRejected : l10n.statusPending),
              isApproved: corr.isApproved,
            ),
        ],
      ),
    );
  }

  Widget _buildTicketBadge({
    required double maxWidth,
    required Color color,
    required IconData icon,
    required String title,
    required String status,
    required bool isApproved,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            4.gapW,
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            5.gapW,
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
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isApproved ? const Color(0xFF10B981) : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
