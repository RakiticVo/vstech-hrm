import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/biometric_login_button.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/login_header_widget.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/login_submit_button.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/remember_me_row.dart';

/// Screen 02: Login Screen connected to real OpenAPI backend.
class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;
  BiometricType? _primaryBiometric;
  bool _canUseBiometric = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkBiometrics());
    unawaited(_loadSavedCredentials());
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final isRemembered = await storage.read(key: AppConstants.keyRememberMe) == 'true';
      if (!isRemembered || !mounted) return;
      final savedUser = await storage.read(key: AppConstants.keySavedUsername);
      final savedPass = await storage.read(key: AppConstants.keySavedPassword);
      if (mounted) {
        setState(() {
          _rememberMe = true;
          if (savedUser?.isNotEmpty ?? false) _codeController.text = savedUser!;
          if (savedPass?.isNotEmpty ?? false) _passwordController.text = savedPass!;
        });
      }
    } on Object {
      // Storage read error fallback
    }
  }

  Future<void> _saveRememberMeCredentials(String username, String password) async {
    try {
      final storage = sl<FlutterSecureStorage>();
      await storage.write(key: AppConstants.keySavedUsername, value: username);
      await storage.write(key: AppConstants.keySavedPassword, value: password);
      await storage.write(key: AppConstants.keyRememberMe, value: _rememberMe ? 'true' : 'false');
    } on Object {
      // Storage write error ignored
    }
  }

  void _onRememberMeChanged(bool? value) {
    final enabled = value ?? false;
    setState(() => _rememberMe = enabled);
    unawaited(sl<FlutterSecureStorage>().write(
      key: AppConstants.keyRememberMe,
      value: enabled ? 'true' : 'false',
    ));
  }

  Future<void> _checkBiometrics() async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final isEnabledInSettings =
          (await storage.read(key: AppConstants.keyBiometricEnabled)) == 'true';
      if (!isEnabledInSettings) {
        if (mounted) {
          setState(() {
            _canUseBiometric = false;
            _primaryBiometric = null;
          });
        }
        return;
      }

      final localAuth = LocalAuthentication();
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;
      if (isSupported && canCheck) {
        final available = await localAuth.getAvailableBiometrics();
        if (available.isNotEmpty && mounted) {
          setState(() {
            _canUseBiometric = true;
            _primaryBiometric = available.contains(BiometricType.face)
                ? BiometricType.face
                : BiometricType.fingerprint;
          });
          return;
        }
      }
    } on Object {
      // Local biometrics hardware check fallback
    }
    if (mounted) {
      setState(() {
        _canUseBiometric = false;
        _primaryBiometric = null;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final username = _codeController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.fillRequiredField), backgroundColor: context.colors.error),
      );
      return;
    }

    unawaited(_saveRememberMeCredentials(username, password));
    unawaited(context.read<AuthCubit>().login(username: username, password: password));
  }

  Future<void> _onBiometricLogin() async {
    if (!_canUseBiometric) return;

    final storage = sl<FlutterSecureStorage>();
    final savedUser = await storage.read(key: AppConstants.keySavedUsername);
    final savedPass = await storage.read(key: AppConstants.keySavedPassword);
    final effectiveUser = (savedUser?.isNotEmpty ?? false) ? savedUser! : _codeController.text.trim();
    final effectivePass = (savedPass?.isNotEmpty ?? false) ? savedPass! : _passwordController.text.trim();

    if (effectiveUser.isEmpty || effectivePass.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.noSavedCredentialsForBiometric), backgroundColor: context.colors.error),
      );
      return;
    }

    try {
      final localAuth = LocalAuthentication();
      final isFace = _primaryBiometric == BiometricType.face;
      final reason = isFace ? context.l10n.faceIdAuthReason : context.l10n.fingerprintAuthReason;
      final didAuth = await localAuth.authenticate(localizedReason: reason);
      if (didAuth && mounted) {
        unawaited(context.read<AuthCubit>().login(username: effectiveUser, password: effectivePass));
      }
    } on Object {
      // Biometric canceled or failed
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final authState = context.watch<AuthCubit>().state;
    final isLoading = authState is AuthLoading;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated &&
            state.message != null &&
            state.message!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: colors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: context.paddingCustom(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeaderWidget(),
                24.gapH,
                buildAuthFieldLabel(l10n.employeeCode, colors),
                6.gapH,
                TextField(
                  controller: _codeController,
                  decoration: buildAuthInputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: AppIcon(AppIcons.user, color: colors.textSecondary, size: 20),
                    ),
                    colors: colors,
                  ),
                ),
                16.gapH,
                buildAuthFieldLabel(l10n.password, colors),
                6.gapH,
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: buildAuthInputDecoration(
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
                RememberMeRow(
                  rememberMe: _rememberMe,
                  onChanged: _onRememberMeChanged,
                  onForgotPassword: () => unawaited(context.push(AppRoutes.forgotPassword)),
                ),
                20.gapH,
                LoginSubmitButton(
                  isLoading: isLoading,
                  onPressed: _onLogin,
                ),
                if (_canUseBiometric) ...[
                  18.gapH,
                  BiometricLoginButton(
                    primaryBiometric: _primaryBiometric,
                    isLoading: isLoading,
                    onPressed: _onBiometricLogin,
                  ),
                ],
                24.gapH,
                Center(
                  child: Text(
                    l10n.contactHr,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: colors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
