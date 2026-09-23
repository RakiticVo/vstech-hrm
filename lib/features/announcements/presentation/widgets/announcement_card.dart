import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';

/// Reusable card displaying an announcement item in list view.
class AnnouncementCard extends StatelessWidget {
  const new({
    required this.announcement,
    required this.onTap,
    super.key,
  });

  final AnnouncementEntity announcement;
  final VoidCallback onTap;

  String _formatScope(BuildContext context, AnnouncementScope scope) {
    final l10n = context.l10n;
    return switch (scope) {
      AnnouncementScope.company => l10n.announcementScopeCompany,
      AnnouncementScope.office => l10n.announcementScopeOffice,
      AnnouncementScope.factory => l10n.announcementScopeFactory,
      AnnouncementScope.department => l10n.announcementScopeDept,
      AnnouncementScope.all => l10n.announcementScopeAll,
    };
  }

  (Color, Color) _scopeColors(AnnouncementScope scope, AppColorsExtension colors) {
    return switch (scope) {
      AnnouncementScope.company => (colors.primaryIndigo, const Color(0xFFE0E7FF)),
      AnnouncementScope.factory => (const Color(0xFFD97706), const Color(0xFFFEF3C7)),
      AnnouncementScope.office => (const Color(0xFF0F766E), const Color(0xFFCCFBF1)),
      AnnouncementScope.department => (const Color(0xFF7C3AED), const Color(0xFFEDE9FE)),
      AnnouncementScope.all => (colors.textSecondary, colors.cardSecondary),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (chipTextColor, chipBgColor) = _scopeColors(announcement.scope, colors);
    final dateStr = DateFormat('dd/MM/yyyy • HH:mm').format(announcement.publishedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: announcement.isRead ? colors.surface : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: announcement.isRead
              ? colors.border
              : colors.primaryIndigo.withValues(alpha: 0.35),
          width: announcement.isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: chipBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatScope(context, announcement.scope),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: chipTextColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (!announcement.isRead) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: colors.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.l10n.announcementUnreadBadge,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      8.gapW,
                    ],
                    Text(
                      dateStr,
                      style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
                    ),
                  ],
                ),
                10.gapH,
                Text(
                  announcement.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: announcement.isRead ? FontWeight.w700 : FontWeight.w900,
                    color: colors.textPrimary,
                    height: 1.3,
                  ),
                ),
                if (announcement.summary != null) ...[
                  6.gapH,
                  Text(
                    announcement.summary!,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                12.gapH,
                Row(
                  children: [
                    Icon(
                      Symbols.verified_user,
                      size: 14,
                      color: colors.textTertiary,
                    ),
                    6.gapW,
                    Expanded(
                      child: Text(
                        announcement.authorName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Symbols.chevron_right,
                      size: 18,
                      color: colors.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
