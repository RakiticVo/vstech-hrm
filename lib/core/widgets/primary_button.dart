import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

/// Primary Indigo Action Button following VSTech Design System.
class PrimaryButton extends StatelessWidget {
  const new({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 48,
    this.width = double.infinity,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryIndigo,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.primaryIndigo.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.buttonMedium(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
