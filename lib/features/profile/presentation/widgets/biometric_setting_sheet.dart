import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_symbols_icons/symbols.dart';
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
        localizedReason: 'Vui lòng xác thực sinh trắc học để kiểm tra phần cứng',
      );
      if (mounted) {
        setState(() {
          _authResultStatus = didAuthenticate
              ? 'Xác thực sinh trắc học thành công!'
              : 'Xác thực không thành công hoặc đã bị hủy.';
        });
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _authResultStatus = 'Lỗi xác thực: $e';
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
          const SizedBox(height: 18),
          Text(
            'BẢO MẬT SINH TRẮC HỌC',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 6),
          Text(
            'Xác thực Vân tay / Khuôn mặt',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Dùng sinh trắc học thiết bị để mở khoá ứng dụng nhanh chóng và bảo vệ xem phiếu lương.',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
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
                          const SizedBox(width: 10),
                          Text(
                            'Kích hoạt sinh trắc học',
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
                    'Hỗ trợ phần cứng:',
                    _isDeviceSupported ? 'Khả dụng' : 'Không hỗ trợ',
                    _isDeviceSupported ? colors.success : colors.error,
                  ),
                  const SizedBox(height: 6),
                  _buildStatusRow(
                    'Cảm biến sinh trắc:',
                    _canCheckBiometrics ? 'Đã cài đặt trên máy' : 'Chưa thiết lập',
                    _canCheckBiometrics ? colors.success : colors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _authResultStatus!,
                        style: AppTextStyles.bodySmall(color: colors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            PrimaryButton(
              text: 'Kiểm tra cảm biến ngay',
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
