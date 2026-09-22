import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

/// Secondary Outlined or Neutral Button.
class SecondaryButton extends StatelessWidget {
  const new({
    required this.text,
    required this.onPressed,
    this.icon,
    this.height = 48,
    this.width = double.infinity,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border),
          backgroundColor: colors.cardSecondary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: colors.textPrimary),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTextStyles.buttonMedium(color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
