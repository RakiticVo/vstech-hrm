import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// BottomSheet to view, configure, and test local biometric authentication.
class BiometricSettingSheet extends StatefulWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const BiometricSettingSheet(),
    );
  }

  @override
  State<BiometricSettingSheet> createState() => _BiometricSettingSheetState();
}

class _BiometricSettingSheetState extends State<BiometricSettingSheet> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isDeviceSupported = false;
  bool _canCheckBiometrics = false;
  bool _isEnabled = true;
  bool _isLoading = true;
  String? _authResultStatus;

  @override
  void initState() {
    super.initState();
    unawaited(_checkHardware());
  }

  Future<void> _checkHardware() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      if (mounted) {
        setState(() {
          _isDeviceSupported = isSupported;
          _canCheckBiometrics = canCheck;
          _isLoading = false;
        });
      }
    } on Object catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _testBiometric() async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Biometric hardware verification',
      );
      if (mounted) {
        setState(() {
          _authResultStatus = didAuthenticate
              ? 'OK'
              : 'Failed';
        });
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _authResultStatus = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          18.gapH,
          Text(
            context.l10n.biometricSecurityTitle,
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          6.gapH,
          Text(
            context.l10n.biometricAuthTitle,
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          6.gapH,
          Text(
            context.l10n.biometricDesc,
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          16.gapH,
          if (_isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ))
          else ...[
            AppCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Symbols.fingerprint, size: 24, color: colors.tealPrimary),
                          10.gapW,
                          Text(
                            context.l10n.enableBiometrics,
                            style: AppTextStyles.bodyMedium(color: colors.textPrimary)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: _isEnabled,
                        activeThumbColor: colors.tealPrimary,
                        onChanged: (val) => setState(() => _isEnabled = val),
                      ),
                    ],
                  ),
                  Divider(height: 16, color: colors.border.withValues(alpha: 0.5)),
                  _buildStatusRow(
                    context.l10n.hardwareSupportLabel,
                    _isDeviceSupported ? context.l10n.hardwareAvailable : context.l10n.hardwareNotSupported,
                    _isDeviceSupported ? colors.success : colors.error,
                  ),
                  6.gapH,
                  _buildStatusRow(
                    context.l10n.biometricSensorLabel,
                    _canCheckBiometrics ? context.l10n.sensorConfigured : context.l10n.sensorNotConfigured,
                    _canCheckBiometrics ? colors.success : colors.warning,
                  ),
                ],
              ),
            ),
            14.gapH,
            if (_authResultStatus != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.tealPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.tealPrimary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Symbols.info, size: 20, color: colors.tealPrimary),
                    8.gapW,
                    Expanded(
                      child: Text(
                        _authResultStatus!,
                        style: AppTextStyles.bodySmall(color: colors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              14.gapH,
            ],
            PrimaryButton(
              text: context.l10n.testBiometricNow,
              icon: Symbols.fingerprint,
              onPressed: _testBiometric,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall(color: Colors.grey)),
        Text(
          value,
          style: AppTextStyles.bodySmall(color: statusColor)
              .copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
