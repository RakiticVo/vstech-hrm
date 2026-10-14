import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';

/// Detailed card displaying all metadata for a selected shift.
class ShiftDetailCard extends StatelessWidget {
  const new({
    required this.shift,
    super.key,
  });

  final ShiftScheduleEntity shift;

  Widget _buildInfoRow({
    required String iconName,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    final colors = context.colors;
    final cleanLabel = label.replaceAll(':', '').trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: AppIcon(iconName, size: 18, color: colors.textSecondary),
          ),
          10.gapW,
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$cleanLabel: ',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
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
              child: const AppIcon(AppIcons.holiday, size: 40, color: Colors.orange),
            ),
            16.gapH,
            Text(
              l10n.dayOffTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary),
            ),
            10.gapH,
            Text(
              l10n.dayOffDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
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
              if (shift.isOvernight) ...[
                8.gapW,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.shiftOvernightBadge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                ),
              ],
            ],
          ),
          14.gapH,
          _buildInfoRow(
            iconName: AppIcons.calendar,
            label: l10n.shiftLabelDate,
            value: DateFormat('EEEE, dd/MM/yyyy', 'vi').format(shift.date),
            context: context,
          ),
          if (shift.shiftCode != null && shift.shiftCode!.isNotEmpty)
            _buildInfoRow(
              iconName: AppIcons.idCard,
              label: l10n.shiftLabelCode,
              value: shift.shiftCode!,
              context: context,
            ),
          _buildInfoRow(
            iconName: AppIcons.shift,
            label: l10n.shiftLabelTime,
            value: shift.isOvernight
                ? '${shift.startTime} — ${shift.endTime} (${l10n.shiftOvernightBadge})'
                : '${shift.startTime} — ${shift.endTime}',
            context: context,
          ),
          if (shift.source != null)
            _buildInfoRow(
              iconName: AppIcons.attendance,
              label: l10n.shiftLabelSource,
              value: shift.isScheduled ? l10n.shiftSourceScheduled : l10n.shiftSourceDefault,
              context: context,
            ),
        ],
      ),
    );
  }
}
