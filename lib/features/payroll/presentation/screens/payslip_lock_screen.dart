import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/pin_code_keypad.dart';

/// Screen 13 / F4: Payslip Biometric & PIN Security Gate (`payslip-lock`).
class PayslipLockScreen extends StatefulWidget {
  const PayslipLockScreen({
    this.targetRoute = AppRoutes.payslipDetail,
    super.key,
  });

  final String targetRoute;

  @override
  State<PayslipLockScreen> createState() => _PayslipLockScreenState();
}

class _PayslipLockScreenState extends State<PayslipLockScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _validPin = '123456';
  static const int _maxAttempts = 5;

  String _enteredPin = '';
  int _remainingAttempts = _maxAttempts;
  bool _isError = false;
  int _lockoutSeconds = 0;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_authenticateWithBiometrics());
    });
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_lockoutSeconds > 0) return;
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!isSupported && !canCheck) return;

      final didAuth = await _localAuth.authenticate(
        localizedReason: context.l10n.payslipLockBiometricPrompt,
      );

      if (didAuth && mounted) {
        _onUnlockSuccess();
      }
    } on Object {
      // Biometrics unavailable or cancelled
    }
  }

  void _onDigitPressed(String digit) {
    if (_lockoutSeconds > 0 || _enteredPin.length >= 6) return;

    setState(() {
      _isError = false;
      _enteredPin += digit;
    });

    if (_enteredPin.length == 6) {
      _verifyPin();
    }
  }

  void _onDeletePressed() {
    if (_lockoutSeconds > 0 || _enteredPin.isEmpty) return;
    setState(() {
      _isError = false;
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  void _verifyPin() {
    if (_enteredPin == _validPin) {
      _onUnlockSuccess();
    } else {
      unawaited(HapticFeedback.vibrate());
      setState(() {
        _isError = true;
        _remainingAttempts -= 1;
        _enteredPin = '';
      });

      if (_remainingAttempts <= 0) {
        _startLockout();
      }
    }
  }

  void _startLockout() {
    setState(() {
      _lockoutSeconds = 30;
      _remainingAttempts = _maxAttempts;
    });

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lockoutSeconds <= 1) {
        timer.cancel();
        if (mounted) setState(() => _lockoutSeconds = 0);
      } else {
        if (mounted) setState(() => _lockoutSeconds -= 1);
      }
    });
  }

  void _onUnlockSuccess() {
    unawaited(HapticFeedback.lightImpact());
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      context.go(widget.targetRoute);
    }
  }

  void _showForgotPinDialog() {
    final l10n = context.l10n;
    final colors = context.colors;
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l10n.payslipLockForgotPin,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          content: Text(
            'Mã PIN phiếu lương mặc định trong bản demo là 123456. Vui lòng liên hệ HR để đặt lại nếu cần.',
            style: TextStyle(fontSize: 13, color: colors.textSecondary, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primaryIndigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.confirm, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.info, size: 20),
            onPressed: _showForgotPinDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.primaryIndigo.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: AppIcon(
                    AppIcons.lock,
                    size: 40,
                    color: colors.primaryIndigo,
                  ),
                ),
              ),
              18.gapH,
              Text(
                l10n.payslipLockTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              8.gapH,
              Text(
                l10n.payslipLockSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
              20.gapH,

              // Status message or lockout countdown
              if (_lockoutSeconds > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${l10n.payslipLockLocked} (${_lockoutSeconds}s)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: colors.error,
                    ),
                  ),
                )
              else if (_isError)
                Text(
                  l10n.payslipLockWrongPin('$_remainingAttempts'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.error,
                  ),
                )
              else
                const SizedBox(height: 20),

              24.gapH,

              // PIN Keypad
              PinCodeKeypad(
                pinLength: 6,
                currentLength: _enteredPin.length,
                isError: _isError,
                isDisabled: _lockoutSeconds > 0,
                onDigitPressed: _onDigitPressed,
                onDeletePressed: _onDeletePressed,
                onBiometricPressed: _authenticateWithBiometrics,
              ),

              18.gapH,
              TextButton(
                onPressed: _showForgotPinDialog,
                child: Text(
                  l10n.payslipLockForgotPin,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryIndigo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
