import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Reusable confirmation dialog for logging out of the application.
class LogoutConfirmDialog extends StatelessWidget {
  const new({super.key});

  /// Displays the logout confirmation dialog and handles session termination.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const LogoutConfirmDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        l10n.logoutConfirmTitle,
        style: TextStyle(
          fontSize: 16.5,
          fontWeight: FontWeight.w800,
          color: colors.textPrimary,
        ),
      ),
      content: Text(
        l10n.logoutConfirmMsg,
        style: TextStyle(
          fontSize: 13,
          color: colors.textSecondary,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancelButton,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await context.read<AuthCubit>().logout();
            if (context.mounted) {
              try {
                context.go(AppRoutes.login);
              } on Object {
                // In test or non-GoRouter environments
              }
            }
          },
          icon: const AppIcon(AppIcons.logout, size: 16, color: Colors.white),
          label: Text(
            l10n.logoutButton,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
