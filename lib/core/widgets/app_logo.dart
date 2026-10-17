import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/constants/app_assets.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

/// Supported visual variants for the official VSTech HRM logo.
enum AppLogoVariant {
  /// Cream colored full logo (`#FFF8EC`), ideal for deep teal backgrounds.
  cream,

  /// Deep teal full logo (`#0A544E`), ideal for light warm backgrounds.
  teal,

  /// Pure white full logo, ideal for dark mode or dark backgrounds.
  white,

  /// Pure black full logo, ideal for monochrome documentation or prints.
  black,

  /// Original multi-colored VStech corporate logo.
  original,

  /// Standalone VS mark in cream.
  markCream,

  /// Standalone VS mark in deep teal.
  markTeal,

  /// High-resolution 1024x1024 app icon tile.
  appIcon,

  /// Legacy programmatic 'VS' rounded badge container.
  legacyBadge,
}

/// Unified logo widget providing all official brand assets alongside the legacy
/// custom badge for backward compatibility and future reuse.
class AppLogo extends StatelessWidget {
  /// Displays the official cream logo on dark/teal surfaces.
  const new cream({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.cream,
        size = null,
        title = null,
        subtitle = null;

  /// Displays the official teal logo on light surfaces.
  const new teal({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.teal,
        size = null,
        title = null,
        subtitle = null;

  /// Displays the official white logo.
  const new white({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.white,
        size = null,
        title = null,
        subtitle = null;

  /// Displays the official black logo.
  const new black({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.black,
        size = null,
        title = null,
        subtitle = null;

  /// Displays the original full logo.
  const new original({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.original,
        size = null,
        title = null,
        subtitle = null;

  /// Displays the standalone VS mark in cream.
  const new markCream({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.markCream,
        size = null,
        title = null,
        subtitle = null;

  /// Displays the standalone VS mark in teal.
  const new markTeal({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.markTeal,
        size = null,
        title = null,
        subtitle = null;

  /// Displays the 1024px app icon.
  const new appIcon({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  })  : variant = AppLogoVariant.appIcon,
        size = null,
        title = null,
        subtitle = null;

  /// Preserved legacy programmatic badge widget (white square with 'VS' text).
  const new legacyBadge({
    super.key,
    this.size = 80,
    this.title,
    this.subtitle,
  })  : variant = AppLogoVariant.legacyBadge,
        width = size,
        height = size,
        fit = BoxFit.contain;

  final AppLogoVariant variant;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit fit;
  final String? title;
  final String? subtitle;

  String? get _assetPath {
    switch (variant) {
      case AppLogoVariant.cream:
        return AppAssets.logoCream;
      case AppLogoVariant.teal:
        return AppAssets.logoTeal;
      case AppLogoVariant.white:
        return AppAssets.logoWhite;
      case AppLogoVariant.black:
        return AppAssets.logoBlack;
      case AppLogoVariant.original:
        return AppAssets.logoOriginal;
      case AppLogoVariant.markCream:
        return AppAssets.markCream;
      case AppLogoVariant.markTeal:
        return AppAssets.markTeal;
      case AppLogoVariant.appIcon:
        return AppAssets.appIcon;
      case AppLogoVariant.legacyBadge:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (variant == AppLogoVariant.legacyBadge) {
      return _buildLegacyBadge(context);
    }

    final asset = _assetPath;
    if (asset == null) return const SizedBox.shrink();

    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _buildLegacyBadge(BuildContext context) {
    final colors = context.colors;
    final badgeSize = size ?? 80;
    final radius = badgeSize * 0.25;

    final badge = Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'VS',
          style: TextStyle(
            fontSize: badgeSize * 0.4,
            fontWeight: FontWeight.w900,
            color: colors.primaryIndigo,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );

    if (title == null && subtitle == null) {
      return badge;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        if (title != null) ...[
          const SizedBox(height: 20),
          Text(
            title!,
            style: AppTextStyles.headlineLarge(color: Colors.white).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: AppTextStyles.bodyMedium(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ],
    );
  }
}
