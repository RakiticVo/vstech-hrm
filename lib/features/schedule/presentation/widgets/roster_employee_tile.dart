import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/roster_ticket_badges.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

/// Tile displaying an individual employee's daily shift details in the roster.
class RosterEmployeeTile extends StatelessWidget {
  const new({
    required this.item,
    super.key,
  });

  final ShiftRosterItemEntity item;

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'NV';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final initials = _getInitials(item.employeeName);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(colors, initials),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(colors),
                4.gapH,
                _buildDepartment(colors),
                8.gapH,
                _buildShiftInfo(context, colors, l10n),
                RosterTicketBadges(item: item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(AppColorsExtension colors, String initials) {
    final avatarBg = item.isDayOff
        ? Colors.grey.shade400
        : (item.isScheduled ? colors.tealPrimary : const Color(0xFF3B82F6));

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: avatarBg.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: avatarBg.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: avatarBg,
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsExtension colors) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.employeeName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.border),
          ),
          child: Text(
            item.employeeCode,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartment(AppColorsExtension colors) {
    if (item.departmentName == null || item.departmentName!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      item.departmentName!,
      style: TextStyle(
        fontSize: 12,
        color: colors.textSecondary,
      ),
    );
  }

  Widget _buildShiftInfo(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    if (item.isDayOff) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(AppIcons.holiday, size: 14, color: Colors.grey),
            6.gapW,
            Text(
              l10n.shiftSourceOff,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final badgeColor = item.isOvernight ? const Color(0xFF7C3AED) : colors.tealPrimary;

    final rawName = item.shiftName ?? item.shiftCode ?? 'Ca làm việc';
    final cleanName = rawName.replaceFirst(RegExp(r'^Ca\s*[:\-]?\s*', caseSensitive: false), '').trim();
    final hasTimeInName = cleanName.contains('(') || cleanName.contains(':');
    final timeSuffix = (!hasTimeInName && item.startHour != null && item.endHour != null)
        ? ' (${item.startHour} - ${item.endHour})'
        : '';
    final labelText = '$cleanName$timeSuffix';

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: context.w(0.68)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: badgeColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppIcons.shift, size: 13, color: badgeColor),
            5.gapW,
            Flexible(
              child: Text(
                labelText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: badgeColor,
                ),
              ),
            ),
            if (item.isOvernight) ...[
              5.gapW,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.shiftOvernightBadge,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
