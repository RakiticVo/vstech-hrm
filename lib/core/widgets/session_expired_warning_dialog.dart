import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/app_router.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/amber_cta_button.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Warning dialog displayed when the API returns session expiration (401 / 400).
/// Informs the user with an explicit warning dialog before routing to LoginScreen.
class SessionExpiredWarningDialog extends StatelessWidget {
  const new({super.key});

  static bool _isShowing = false;

  @visibleForTesting
  static void resetShowingForTesting() => _isShowing = false;

  /// Shows the dialog over the active navigation context.
  /// Debounced so concurrent API failures only display a single dialog.
  static Future<void> show(BuildContext context) async {
    if (_isShowing) return;
    _isShowing = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PopScope(
          canPop: false,
          child: SessionExpiredWarningDialog(),
        ),
      );
    } finally {
      _isShowing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning amber badge
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors.amberCta.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon(
                  AppIcons.warning,
                  size: 30,
                  color: colors.amberInk,
                ),
              ),
            ),
            16.gapH,

            // Title
            Text(
              l10n.sessionExpiredTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            8.gapH,

            // Message
            Text(
              l10n.sessionExpiredMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
                height: 1.45,
              ),
            ),
            22.gapH,

            // Action CTA button
            AmberCtaButton(
              text: l10n.sessionExpiredRelogin,
              iconName: AppIcons.logout,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                if (sl.isRegistered<AuthCubit>()) {
                  await sl<AuthCubit>().logout();
                }
                final navContext = rootNavigatorKey.currentContext;
                if (navContext != null && navContext.mounted) {
                  try {
                    navContext.go(AppRoutes.login);
                  } on Object {
                    // Handled in non-router environments
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
