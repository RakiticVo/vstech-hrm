import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Semantic types for app-wide toasts.
enum ToastType {
  success,
  error,
  warning,
  info;

  Color resolveAccent(AppColorsExtension colors) {
    switch (this) {
      case ToastType.success:
        return colors.success;
      case ToastType.error:
        return colors.error;
      case ToastType.warning:
        return colors.warning;
      case ToastType.info:
        return colors.tealLight;
    }
  }

  String get iconName {
    switch (this) {
      case ToastType.success:
        return AppIcons.checkCircle2;
      case ToastType.error:
        return AppIcons.xCircle;
      case ToastType.warning:
        return AppIcons.alertTriangle;
      case ToastType.info:
        return AppIcons.info;
    }
  }
}

/// Floating pill container with gentle shadows and soft rounded edges.
class AppToastCard extends StatelessWidget {
  const new({
    required this.message,
    this.type = ToastType.info,
    this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String message;
  final ToastType type;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = type.resolveAccent(colors);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: accent.withValues(alpha: 0.26),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                type.iconName,
                size: 18,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null && title!.isNotEmpty) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12.8,
                    fontWeight: title != null ? FontWeight.w500 : FontWeight.w600,
                    color: title != null ? const Color(0xFFCBD5E1) : Colors.white,
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onAction!();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
