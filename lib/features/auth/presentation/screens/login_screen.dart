import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/biometric_login_button.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/demo_quick_login_section.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/face_id_login_sheet.dart';

/// Screen 02: Login Screen conforming to Clean Architecture and AppLayout.
class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codeController = TextEditingController(text: 'NV-04821');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  BiometricType? _primaryBiometric;
  bool _canUseBiometric = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkBiometrics());
  }

  Future<void> _checkBiometrics() async {
    try {
      final localAuth = LocalAuthentication();
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;
      if (isSupported && canCheck) {
        final available = await localAuth.getAvailableBiometrics();
        if (mounted) {
          setState(() {
            _canUseBiometric = true;
            if (available.contains(BiometricType.face)) {
              _primaryBiometric = BiometricType.face;
            } else if (available.contains(BiometricType.fingerprint) ||
                available.contains(BiometricType.strong) ||
                available.contains(BiometricType.weak)) {
              _primaryBiometric = BiometricType.fingerprint;
            } else {
              _primaryBiometric = BiometricType.fingerprint;
            }
          });
        }
      }
    } on Object {
      // Local biometrics unsupported fallback
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    unawaited(
      context.read<AuthCubit>().login(
            username: _codeController.text.trim(),
            password: _passwordController.text.trim(),
          ),
    );
  }

  Future<void> _onBiometricLogin() async {
    final l10n = context.l10n;
    if (_canUseBiometric) {
      try {
        final localAuth = LocalAuthentication();
        final isFace = _primaryBiometric == BiometricType.face;
        final reason = isFace ? l10n.faceIdAuthReason : l10n.fingerprintAuthReason;
        final didAuth = await localAuth.authenticate(
          localizedReason: reason,
        );
        if (didAuth && mounted) {
          await context.read<AuthCubit>().loginAsDemo(UserRole.employee);
          return;
        }
      } on Object {
        // Biometric canceled or failed
      }
    } else {
      unawaited(FaceIdLoginSheet.show(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final authState = context.watch<AuthCubit>().state;
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.paddingCustom(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.gapH,
              Container(
                width: context.custom(normal: 48, compact: 40).toDouble(),
                height: context.custom(normal: 48, compact: 40).toDouble(),
                decoration: BoxDecoration(
                  color: colors.primaryIndigo,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: AppIcon(AppIcons.user, color: Color(0xFFFFF8EC), size: 24),
                ),
              ),
              20.gapH,
              Text(
                '${l10n.greetingDefault}!',
                style: TextStyle(
                  fontSize: context.custom(normal: 26, compact: 22).toDouble(),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: colors.textPrimary,
                ),
              ),
              6.gapH,
              Text(
                l10n.loginInstruction,
                style: TextStyle(
                  fontSize: context.custom(normal: 13.5, compact: 12),
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
              24.gapH,
              _buildFieldLabel(l10n.employeeCode, colors),
              6.gapH,
              TextField(
                controller: _codeController,
                decoration: _inputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AppIcon(AppIcons.user, color: colors.textSecondary, size: 20),
                  ),
                  colors: colors,
                ),
              ),
              16.gapH,
              _buildFieldLabel(l10n.password, colors),
              6.gapH,
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AppIcon(AppIcons.lock, color: colors.textSecondary, size: 20),
                  ),
                  colors: colors,
                  suffixIcon: IconButton(
                    icon: AppIcon(_obscurePassword ? AppIcons.eyeOff : AppIcons.eye, size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              12.gapH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: colors.primaryIndigo,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        ),
                      ),
                      8.gapW,
                      Text(
                        'Ghi nhớ',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textPrimary),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => unawaited(context.push(AppRoutes.forgotPassword)),
                    child: Text(
                      l10n.forgotPasswordShort,
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.primaryIndigo),
                    ),
                  ),
                ],
              ),
              20.gapH,
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentAmber,
                    foregroundColor: const Color(0xFF1C1408),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: isLoading ? null : _onLogin,
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.loginButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
              18.gapH,
              Row(
                children: [
                  Expanded(child: Divider(color: colors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(l10n.orDivider, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textTertiary)),
                  ),
                  Expanded(child: Divider(color: colors.border)),
                ],
              ),
              18.gapH,
              BiometricLoginButton(
                primaryBiometric: _primaryBiometric,
                isLoading: isLoading,
                onPressed: _onBiometricLogin,
              ),
              16.gapH,
              const DemoQuickLoginSection(),
              24.gapH,
              Center(
                child: Text(l10n.contactHr, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: colors.textTertiary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text, AppColorsExtension colors) {
    return Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary));
  }

  InputDecoration _inputDecoration({required Widget prefixIcon, required AppColorsExtension colors, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colors.cardSecondary,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.primaryIndigo, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
