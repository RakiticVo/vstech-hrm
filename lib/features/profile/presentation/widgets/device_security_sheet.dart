import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:safe_device/safe_device.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// BottomSheet to inspect linked hardware device and verify security checks via safe_device.
class DeviceSecuritySheet extends StatefulWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const DeviceSecuritySheet(),
    );
  }

  @override
  State<DeviceSecuritySheet> createState() => _DeviceSecuritySheetState();
}

class _DeviceSecuritySheetState extends State<DeviceSecuritySheet> {
  bool _isLoading = true;
  bool _isRealDevice = true;
  bool _isJailBroken = false;
  bool _isMockLocation = false;
  bool _isDevMode = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkDeviceSecurity());
  }

  Future<void> _checkDeviceSecurity() async {
    try {
      final isReal = await SafeDevice.isRealDevice;
      final isJailBroken = await SafeDevice.isJailBroken;
      final isMock = await SafeDevice.isMockLocation;
      final isDev = await SafeDevice.isDevelopmentModeEnable;

      if (mounted) {
        setState(() {
          _isRealDevice = isReal;
          _isJailBroken = isJailBroken;
          _isMockLocation = isMock;
          _isDevMode = isDev;
          _isLoading = false;
        });
      }
    } on Object catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
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
            context.l10n.deviceSecurityTitle,
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          6.gapH,
          Text(
            context.l10n.linkedDeviceTitle,
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          6.gapH,
          Text(
            context.l10n.deviceSecurityDesc,
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          16.gapH,
          if (_isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ))
          else ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.tealPrimary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Symbols.smartphone, size: 24, color: colors.tealPrimary),
                      ),
                      12.gapW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Samsung SM-A057F',
                              style: AppTextStyles.titleMedium(color: colors.textPrimary)
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              context.l10n.officialDeviceRegistered,
                              style: AppTextStyles.bodySmall(color: colors.success),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.5)),
                  _buildSecurityRow(
                    icon: Symbols.verified_user,
                    label: context.l10n.physicalDeviceLabel,
                    status: _isRealDevice ? context.l10n.physicalDeviceValid : context.l10n.physicalDeviceWarning,
                    isSafe: _isRealDevice,
                    colors: colors,
                  ),
                  8.gapH,
                  _buildSecurityRow(
                    icon: Symbols.security,
                    label: context.l10n.jailbreakLabel,
                    status: !_isJailBroken ? context.l10n.jailbreakSafe : context.l10n.jailbreakDetected,
                    isSafe: !_isJailBroken,
                    colors: colors,
                  ),
                  8.gapH,
                  _buildSecurityRow(
                    icon: Symbols.location_on,
                    label: context.l10n.mockGpsLabel,
                    status: !_isMockLocation ? context.l10n.mockGpsNotDetected : context.l10n.mockGpsDetected,
                    isSafe: !_isMockLocation,
                    colors: colors,
                  ),
                  8.gapH,
                  _buildSecurityRow(
                    icon: Symbols.code,
                    label: context.l10n.developerModeLabel,
                    status: _isDevMode ? context.l10n.devModeOn : context.l10n.devModeOff,
                    isSafe: !_isDevMode,
                    colors: colors,
                  ),
                ],
              ),
            ),
            20.gapH,
            PrimaryButton(
              text: context.l10n.closeButton,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityRow({
    required IconData icon,
    required String label,
    required String status,
    required bool isSafe,
    required AppColorsExtension colors,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: AppTextStyles.bodySmall(color: colors.textSecondary)),
        ),
        Text(
          status,
          style: AppTextStyles.bodySmall(
            color: isSafe ? colors.success : colors.error,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
