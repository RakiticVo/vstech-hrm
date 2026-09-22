import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Reusable error state display with warning icon, message, and retry button.
class AppErrorState extends StatelessWidget {
  const new({
    this.title,
    this.message,
    this.onRetry,
    this.retryLabel,
    super.key,
  });

  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedTitle = title ?? context.l10n.errorOccurredTitle;
    final resolvedMessage = message ?? context.l10n.errorOccurredMessage;
    final resolvedRetryLabel = retryLabel ?? context.l10n.retry;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.error,
                size: 36,
                color: colors.error,
              ),
            ),
            18.gapH,
            Text(
              resolvedTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            8.gapH,
            Text(
              resolvedMessage,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              22.gapH,
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryIndigo,
                  foregroundColor: const Color(0xFFFFF8EC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: onRetry,
                icon: const Icon(Symbols.refresh, size: 18),
                label: Text(
                  resolvedRetryLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
