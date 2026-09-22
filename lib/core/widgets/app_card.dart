import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Reusable Card component respecting VSTech design elevation and borders.
class AppCard extends StatelessWidget {
  const new({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 14,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.showShadow = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardBg = backgroundColor ?? colors.cardSurface;
    final border = borderColor ?? colors.border;

    final cardDecoration = BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: border.withValues(alpha: 0.7)),
      boxShadow: showShadow
          ? [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ]
          : null,
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        decoration: cardDecoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onTap,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      padding: padding,
      decoration: cardDecoration,
      child: child,
    );
  }
}
