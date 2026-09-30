import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Interactive button for Biometric authentication (Face ID or Fingerprint).
class BiometricLoginButton extends StatelessWidget {
  const BiometricLoginButton({
    required this.primaryBiometric,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final BiometricType? primaryBiometric;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final isFingerprint = primaryBiometric == BiometricType.fingerprint;
    final isFace = primaryBiometric == BiometricType.face;

    final iconName = isFingerprint ? AppIcons.fingerprint : AppIcons.scanFace;
    final label = isFace
        ? l10n.loginWithFaceId
        : isFingerprint
            ? l10n.loginWithFingerprint
            : l10n.biometricLogin;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: AppIcon(iconName, color: colors.primaryIndigo, size: 20),
        label: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textPrimary),
        ),
      ),
    );
  }
}
