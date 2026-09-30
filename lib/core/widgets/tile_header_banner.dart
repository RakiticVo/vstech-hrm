import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Top header banner with Saigon Tile pattern and customizable content.
class TileHeaderBanner extends StatelessWidget {
  const TileHeaderBanner({
    required this.title,
    this.subtitle,
    this.secondSubtitle,
    this.avatarUrl,
    this.avatarFallbackText,
    this.onBack,
    this.onNotificationTap,
    this.hasUnreadNotification = false,
    this.trailing,
    this.height,
    this.bottomPadding = 14.0,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? secondSubtitle;
  final String? avatarUrl;
  final String? avatarFallbackText;
  final VoidCallback? onBack;
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
        color: colors.tileDark,
      ),
      child: Stack(
        children: [
          // Background Canvas Tile Pattern strictly clipped
          Positioned.fill(
            child: ClipRect(
              child: CustomPaint(
                painter: TilePatternPainter(
                  backgroundColor: colors.tileDark,
                  patternColor: patternColor,
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
                  // Back button if onBack is provided
                  if (onBack != null) ...[
                    _buildBackButton(),
                    const SizedBox(width: 12),
                  ],

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
                          maxLines: 2,
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
                        if (secondSubtitle != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcon(
                                AppIcons.building,
                                size: 13,
                                color: const Color(0xFFFFF8EC).withValues(alpha: 0.85),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  secondSubtitle!,
                                  style: AppTextStyles.bodySmall(
                                    color: const Color(0xFFFFF8EC).withValues(alpha: 0.85),
                                  ).copyWith(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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

  Widget _buildBackButton() {
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
          onTap: onBack,
          child: const Center(
            child: AppIcon(
              AppIcons.back,
              color: Color(0xFFFFF8EC),
              size: 20,
            ),
          ),
        ),
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
            color: colors.tileDark,
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
              const AppIcon(
                AppIcons.bell,
                color: Color(0xFFFFF8EC),
                size: 20,
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
