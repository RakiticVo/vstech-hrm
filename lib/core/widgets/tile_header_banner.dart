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
    this.height = 140,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final String? avatarFallbackText;
  final VoidCallback? onNotificationTap;
  final bool hasUnreadNotification;
  final Widget? trailing;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      height: height,
      color: colors.primaryIndigo,
      child: Stack(
        children: [
          // Background Canvas Tile Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: TilePatternPainter(
                backgroundColor: colors.primaryIndigo,
                patternColor: Colors.white.withValues(alpha: 0.08),
                tileSize: 42,
              ),
            ),
          ),

          // Content Layer
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          style: AppTextStyles.titleMedium(color: Colors.white).copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodySmall(
                              color: Colors.white.withValues(alpha: 0.8),
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
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.accentAmber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          avatarFallbackText ?? 'VS',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(AppColorsExtension colors) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
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
                color: Colors.white,
                size: 22,
                weight: 400,
              ),
              if (hasUnreadNotification)
                Positioned(
                  top: 9,
                  right: 9,
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
