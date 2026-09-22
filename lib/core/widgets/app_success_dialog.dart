import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Reusable success dialog or state card with animated green checkmark.
class AppSuccessDialog extends StatelessWidget {
  const new({
    this.title = 'Thao tác thành công!',
    this.message = 'Yêu cầu của bạn đã được ghi nhận và chuyển cho cấp trên xử lý.',
    this.buttonLabel = 'Xong',
    this.onDismiss,
    super.key,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onDismiss;

  static Future<void> show(
    BuildContext context, {
    String title = 'Thao tác thành công!',
    String message = 'Yêu cầu của bạn đã được ghi nhận và chuyển cho cấp trên xử lý.',
    String buttonLabel = 'Xong',
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: AppSuccessDialog(
          title: title,
          message: message,
          buttonLabel: buttonLabel,
          onDismiss: () {
            Navigator.pop(ctx);
            onDismiss?.call();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: colors.pineGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.check_circle,
              size: 44,
              color: colors.pineGreen,
              weight: 600,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.pineGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (onDismiss != null) {
                  onDismiss!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
