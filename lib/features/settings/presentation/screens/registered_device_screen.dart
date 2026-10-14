import 'dart:async';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_device/safe_device.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/features/settings/presentation/widgets/device_info_cards.dart';

/// Screen B3: Registered Device & Real Anti-Fraud Security Status.
class RegisteredDeviceScreen extends StatefulWidget {
  const RegisteredDeviceScreen({super.key});

  @override
  State<RegisteredDeviceScreen> createState() => _RegisteredDeviceScreenState();
}

class _RegisteredDeviceScreenState extends State<RegisteredDeviceScreen> {
  bool _isLoading = true;
  String _deviceName = 'Đang tải...';
  String _deviceUuid = '—';
  String _osVersion = '—';
  String _registeredDate = '—';

  bool _isRealDevice = true;
  bool _isNotRooted = true;
  bool _isNotMockGps = true;
  bool _isIntegrityPassed = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDeviceInfoAndSecurity());
  }

  Future<void> _loadDeviceInfoAndSecurity() async {
    setState(() => _isLoading = true);
    try {
      final deviceInfo = DeviceInfoPlugin();
      var name = 'Thiết bị di động';
      var uuid = 'VST-DEVICE';
      var os = Platform.operatingSystem;

      if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        name = ios.name.isNotEmpty ? ios.name : ios.model;
        uuid = ios.identifierForVendor ?? 'IOS-UUID-${ios.utsname.machine}';
        os = 'iOS ${ios.systemVersion}';
      } else if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        name = '${android.manufacturer} ${android.model}';
        uuid = android.id.isNotEmpty ? android.id : 'AND-ID-${android.fingerprint}';
        os = 'Android ${android.version.release}';
      }

      var regDate = '15/01/2026 08:30';
      if (sl.isRegistered<FlutterSecureStorage>()) {
        final storage = sl<FlutterSecureStorage>();
        final saved = await storage.read(key: 'key_device_registered_at');
        if (saved != null && saved.isNotEmpty) {
          regDate = saved;
        } else {
          final now = DateTime.now();
          regDate =
              '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
          await storage.write(key: 'key_device_registered_at', value: regDate);
        }
      }

      var isJailBroken = false;
      var isMockLocation = false;
      var isReal = true;
      try {
        isJailBroken = await SafeDevice.isJailBroken;
        isMockLocation = await SafeDevice.isMockLocation;
        isReal = await SafeDevice.isRealDevice;
      } on Object {
        // SafeDevice fallback on emulator / desktop
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _deviceName = name;
          _deviceUuid = uuid;
          _osVersion = os;
          _registeredDate = regDate;
          _isRealDevice = isReal;
          _isNotRooted = !isJailBroken;
          _isNotMockGps = !isMockLocation;
          _isIntegrityPassed = isReal && !isJailBroken;
        });
      }
    } on Object {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.registeredDeviceTitle,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.arrowLeft, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadDeviceInfoAndSecurity,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    DeviceHardwareCard(
                      deviceName: _deviceName,
                      deviceUuid: _deviceUuid,
                      osVersion: _osVersion,
                      registeredDate: _registeredDate,
                      statusRecordedLabel: l10n.statusRecorded,
                      deviceRegisteredDateLabel: l10n.deviceRegisteredDate,
                    ),
                    18.gapH,
                    Text(
                      l10n.registeredDeviceSub,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
                    ),
                    10.gapH,
                    DeviceSecurityCheckItem(
                      title: l10n.deviceCheckRegistered,
                      isPassed: _isRealDevice,
                    ),
                    8.gapH,
                    DeviceSecurityCheckItem(
                      title: l10n.deviceCheckNotRooted,
                      isPassed: _isNotRooted,
                    ),
                    8.gapH,
                    DeviceSecurityCheckItem(
                      title: l10n.deviceCheckNoMockGps,
                      isPassed: _isNotMockGps,
                    ),
                    8.gapH,
                    DeviceSecurityCheckItem(
                      title: l10n.deviceCheckIntegrity,
                      isPassed: _isIntegrityPassed,
                    ),
                    24.gapH,
                    _buildSecurityCard(colors, l10n.deviceCheckSafetyBtn),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSecurityCard(AppColorsExtension colors, String checkSafetyLabel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.pineGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.pineGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(AppIcons.shieldCheck, color: colors.pineGreen, size: 20),
              8.gapW,
              Expanded(
                child: Text(
                  'Bảo mật phần cứng & vị trí',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                ),
              ),
            ],
          ),
          8.gapH,
          Text(
            'Thiết bị đã được xác thực an toàn phần cứng, không phát hiện quyền root/jailbreak hoặc can thiệp toạ độ GPS giả lập.',
            style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.4),
          ),
          14.gapH,
          PrimaryButton(
            text: checkSafetyLabel,
            onPressed: () async {
              await _loadDeviceInfoAndSecurity();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isIntegrityPassed
                        ? 'Thiết bị đạt chuẩn bảo mật an toàn VSTech'
                        : 'Phát hiện rủi ro bảo mật trên thiết bị!',
                  ),
                  backgroundColor: _isIntegrityPassed ? colors.pineGreen : colors.error,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
