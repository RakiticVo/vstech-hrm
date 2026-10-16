import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/payroll/presentation/helpers/payslip_auth_helper.dart';

/// Re-authentication dialog required before accessing detailed payslips.
class PayslipAuthDialog extends StatefulWidget {
  const new({
    required this.onAuthenticated,
    super.key,
  });

  final VoidCallback onAuthenticated;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAuthenticated,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PayslipAuthDialog(onAuthenticated: onAuthenticated),
    );
  }

  @override
  State<PayslipAuthDialog> createState() => _PayslipAuthDialogState();
}

class _PayslipAuthDialogState extends State<PayslipAuthDialog> {
  final _passwordController = TextEditingController();
  final _localAuth = LocalAuthentication();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasBiometrics = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initBiometrics());
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initBiometrics() async {
    final available = await PayslipAuthHelper.isBiometricsAvailable(_localAuth);
    if (!mounted) return;
    setState(() => _hasBiometrics = available);
    if (available) {
      unawaited(_authenticateBiometrics());
    }
  }

  Future<void> _authenticateBiometrics() async {
    try {
      final success = await _localAuth.authenticate(
        localizedReason: context.l10n.payslipLockBiometricPrompt,
      );
      if (success && mounted) {
        Navigator.of(context).pop();
        widget.onAuthenticated();
      }
    } on Object {
      // Biometrics failed or cancelled
    }
  }

  Future<void> _handlePasswordSubmit() async {
    final l10n = context.l10n;
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() => _errorMessage = l10n.payslipAuthEmptyPassword);
      return;
    }

    final authState = context.read<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;
    final isDemo = authState is Authenticated &&
        (authState.token.startsWith('mock_jwt_') || user?.employeeCode == 'NV0142');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final isValid = await PayslipAuthHelper.verifyPassword(
      password: password,
      isDemo: isDemo,
      employeeCode: user?.employeeCode,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (isValid) {
      Navigator.of(context).pop();
      widget.onAuthenticated();
    } else {
      setState(() => _errorMessage = l10n.payslipAuthIncorrectPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;
    final displayName = user?.name ?? user?.employeeCode ?? 'Tài khoản của bạn';

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.pineGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: AppIcon(AppIcons.lock, size: 20, color: colors.pineGreen)),
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.payslipAuthDialogTitle,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colors.textPrimary),
                      ),
                      2.gapH,
                      Text(
                        displayName,
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            14.gapH,
            Text(
              _hasBiometrics
                  ? l10n.payslipAuthDialogSubtitleBiometric
                  : l10n.payslipAuthDialogSubtitlePasswordOnly,
              style: TextStyle(fontSize: 12.5, color: colors.textSecondary, height: 1.35),
            ),
            14.gapH,
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              autofocus: !_hasBiometrics,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handlePasswordSubmit(),
              style: TextStyle(fontSize: 13.5, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.cardSecondary,
                hintText: l10n.payslipAuthPasswordHint,
                hintStyle: TextStyle(fontSize: 13, color: colors.textTertiary),
                prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 6),
                  child: AppIcon(AppIcons.lock, size: 16, color: colors.textSecondary),
                ),
                suffixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                suffixIcon: IconButton(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  icon: AppIcon(
                    _obscurePassword ? AppIcons.eyeOff : AppIcons.eye,
                    size: 17,
                    color: colors.textSecondary,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.pineGreen, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              ),
            ),
            if (_errorMessage != null) ...[
              8.gapH,
              Text(
                _errorMessage!,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.error),
              ),
            ],
            if (_hasBiometrics) ...[
              12.gapH,
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.pineGreen,
                  side: BorderSide(color: colors.pineGreen.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: _authenticateBiometrics,
                icon: const AppIcon(AppIcons.fingerprint, size: 20),
                label: Text(
                  l10n.useBiometricsButton,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.cancel,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.pineGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          ),
          onPressed: _isLoading ? null : _handlePasswordSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  l10n.confirm,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
        ),
      ],
    );
  }
}
