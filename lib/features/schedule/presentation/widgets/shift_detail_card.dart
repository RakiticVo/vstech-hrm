import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_swap_modal.dart';

/// Detailed card displaying all metadata for a selected shift.
class ShiftDetailCard extends StatelessWidget {
  const new({
    required this.shift,
    super.key,
  });

  final ShiftScheduleEntity shift;

  Widget _buildStatusBadge(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    String label;
    Color bg;
    Color fg;

    switch (shift.status) {
      case ShiftStatus.active:
        label = l10n.shiftStatusActive;
        bg = colors.tealPrimary.withValues(alpha: 0.15);
        fg = colors.tealPrimary;
      case ShiftStatus.completed:
        label = l10n.shiftStatusCompleted;
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = colors.textSecondary;
      case ShiftStatus.upcoming:
        label = l10n.shiftStatusUpcoming;
        bg = Colors.blue.withValues(alpha: 0.15);
        fg = Colors.blue.shade700;
      case ShiftStatus.dayOff:
        label = l10n.shiftStatusDayOff;
        bg = Colors.orange.withValues(alpha: 0.15);
        fg = Colors.orange.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colors.textSecondary),
          10.gapW,
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    if (shift.isDayOff) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Symbols.beach_access, size: 40, color: Colors.orange),
            ),
            16.gapH,
            Text(
              l10n.dayOffTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary),
            ),
            6.gapH,
            Text(
              l10n.dayOffDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
            20.gapH,
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.overtimeCreate),
              icon: const Icon(Symbols.add_circle, size: 18),
              label: Text(l10n.registerOvertimeCta),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.tealPrimary,
                side: BorderSide(color: colors.tealPrimary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: shift.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              8.gapW,
              Expanded(
                child: Text(
                  shift.shiftName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary),
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          16.gapH,
          _buildInfoRow(
            icon: Symbols.schedule,
            label: l10n.shiftLabelTime,
            value: '${shift.startTime} — ${shift.endTime}',
            context: context,
          ),
          _buildInfoRow(
            icon: Symbols.restaurant,
            label: l10n.shiftLabelBreak,
            value: shift.breakTime,
            context: context,
          ),
          _buildInfoRow(
            icon: Symbols.store,
            label: l10n.shiftLabelLocation,
            value: shift.branchName,
            context: context,
          ),
          _buildInfoRow(
            icon: Symbols.badge,
            label: l10n.shiftLabelManager,
            value: shift.managerName,
            context: context,
          ),
          if (shift.notes != null)
            _buildInfoRow(
              icon: Symbols.notes,
              label: l10n.shiftLabelNotes,
              value: shift.notes!,
              context: context,
            ),
          18.gapH,
          const Divider(height: 1),
          14.gapH,
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ShiftSwapModal.show(context, shift),
                  icon: const Icon(Symbols.swap_horiz, size: 18),
                  label: Text(l10n.shiftSwapButton),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.tealPrimary,
                    side: BorderSide(color: colors.tealPrimary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              12.gapW,
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.overtimeCreate),
                  icon: const Icon(Symbols.more_time, size: 18),
                  label: Text(l10n.shiftOvertimeButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.tealPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
