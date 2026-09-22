import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';

/// Top header banner with Saigon Tile pattern and customizable content.
class TileHeaderBanner extends StatelessWidget {
  const new({
    required this.title,
    this.subtitle,
    this.avatarUrl,
    this.avatarFallbackText,
    this.onNotificationTap,
    this.hasUnreadNotification = false,
    this.trailing,
    this.height,
    this.bottomPadding = 14.0,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final String? avatarFallbackText;
  final VoidCallback? onNotificationTap;
  final bool hasUnreadNotification;
  final Widget? trailing;
  final double? height;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternColor = isDark
        ? const Color(0xFF2DD4BF).withValues(alpha: 0.16)
        : const Color(0xFFFFF8EC).withValues(alpha: 0.19);

    return Container(
      width: double.infinity,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: colors.primaryIndigo,
      ),
      child: Stack(
        children: [
          // Background Canvas Tile Pattern strictly clipped
          Positioned.fill(
            child: ClipRect(
              child: CustomPaint(
                painter: TilePatternPainter(
                  backgroundColor: colors.primaryIndigo,
                  patternColor: patternColor,
                  tileSize: 46,
                ),
              ),
            ),
          ),

          // Content Layer
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
              child: Row(
                children: [
                  // Avatar or Fallback Initials
                  if (avatarUrl != null || avatarFallbackText != null) ...[
                    _buildAvatar(colors),
                    const SizedBox(width: 12),
                  ],

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleMedium(color: const Color(0xFFFFF8EC)).copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodySmall(
                              color: const Color(0xFFFFF8EC).withValues(alpha: 0.85),
                            ).copyWith(
                              fontWeight: FontWeight.w600,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing or Notification button
                  if (trailing != null)
                    trailing!
                  else if (onNotificationTap != null)
                    _buildNotificationButton(colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(AppColorsExtension colors) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Center(
        child: Text(
          avatarFallbackText ?? 'VS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: colors.primaryIndigo,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(AppColorsExtension colors) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onNotificationTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Symbols.notifications,
                color: Color(0xFFFFF8EC),
                size: 20,
                weight: 500,
              ),
              if (hasUnreadNotification)
                Positioned(
                  top: 7,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: colors.accentAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
