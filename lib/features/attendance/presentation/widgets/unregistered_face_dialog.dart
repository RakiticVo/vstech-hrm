import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Modal dialog prompting employee to complete face biometric registration before punching.
class UnregisteredFaceDialog extends StatelessWidget {
  const UnregisteredFaceDialog({
    this.onGoToEnrollment,
    this.onDismiss,
    super.key,
  });

  final VoidCallback? onGoToEnrollment;
  final VoidCallback? onDismiss;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onGoToEnrollment,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UnregisteredFaceDialog(
        onGoToEnrollment: onGoToEnrollment,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: AppIcon(
                AppIcons.faceScan,
                color: Color(0xFFF59E0B),
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.faceAuthTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.faceNotRegisteredPrompt,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  context.pop();
                  if (onDismiss != null) {
                    onDismiss!();
                  } else {
                    context.pop();
                  }
                },
                child: Text(
                  'Để sau',
                  style: TextStyle(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.pop();
                  if (onGoToEnrollment != null) {
                    onGoToEnrollment!();
                  } else {
                    unawaited(context.push(AppRoutes.faceEnrollment));
                  }
                },
                child: Text(
                  l10n.goToProfileCta,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
