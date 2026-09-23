import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Reusable success dialog or state card with animated green checkmark.
class AppSuccessDialog extends StatelessWidget {
  const new({
    this.title,
    this.message,
    this.buttonLabel,
    this.onDismiss,
    super.key,
  });

  final String? title;
  final String? message;
  final String? buttonLabel;
  final VoidCallback? onDismiss;

  static Future<void> show(
    BuildContext context, {
    String? title,
    String? message,
    String? buttonLabel,
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
    final resolvedTitle = title ?? context.l10n.successDialogTitle;
    final resolvedMessage = message ?? context.l10n.successDialogMessage;
    final resolvedButtonLabel = buttonLabel ?? context.l10n.doneButton;

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
          18.gapH,
          Text(
            resolvedTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          8.gapH,
          Text(
            resolvedMessage,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          24.gapH,
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
                resolvedButtonLabel,
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
