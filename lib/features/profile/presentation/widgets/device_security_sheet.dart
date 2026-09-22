import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:safe_device/safe_device.dart';
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
          const SizedBox(height: 18),
          Text(
            'THIẾT BỊ & AN TOÀN HỆ THỐNG',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 6),
          Text(
            'Thiết bị liên kết',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Quy định bảo mật ràng buộc tài khoản với 1 thiết bị duy nhất để chấm công và xem phiếu lương.',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
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
                      const SizedBox(width: 12),
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
                              'Thiết bị chính thức • Đã đăng ký',
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
                    label: 'Thiết bị thực tế',
                    status: _isRealDevice ? 'Hợp lệ (Physical)' : 'Cảnh báo (Simulator)',
                    isSafe: _isRealDevice,
                    colors: colors,
                  ),
                  const SizedBox(height: 8),
                  _buildSecurityRow(
                    icon: Symbols.security,
                    label: 'Root / Jailbreak',
                    status: !_isJailBroken ? 'An toàn (Chưa Root)' : 'Phát hiện can thiệp!',
                    isSafe: !_isJailBroken,
                    colors: colors,
                  ),
                  const SizedBox(height: 8),
                  _buildSecurityRow(
                    icon: Symbols.location_on,
                    label: 'Giả lập vị trí (Mock GPS)',
                    status: !_isMockLocation ? 'Không phát hiện' : 'Phát hiện vị trí ảo!',
                    isSafe: !_isMockLocation,
                    colors: colors,
                  ),
                  const SizedBox(height: 8),
                  _buildSecurityRow(
                    icon: Symbols.code,
                    label: 'Chế độ nhà phát triển',
                    status: _isDevMode ? 'Đang bật (Dev Mode)' : 'Tắt',
                    isSafe: !_isDevMode,
                    colors: colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Đóng',
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
