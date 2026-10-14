import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/logout_confirm_dialog.dart';
import 'package:vstech_hrm/features/settings/presentation/widgets/settings_common_widgets.dart';
import 'package:vstech_hrm/features/settings/presentation/widgets/settings_display_section.dart';

/// Screen 16: Application Settings for Notifications, Appearance, Security, and Session.
class SettingsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotification = true;
  bool _emailReport = false;
  bool _punchReminder = true;
  bool _hasBiometrics = false;
  bool _biometrics = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkBiometricSupport());
  }

  Future<void> _checkBiometricSupport() async {
    try {
      if (sl.isRegistered<FlutterSecureStorage>()) {
        final storage = sl<FlutterSecureStorage>();
        final enabledStr = await storage.read(key: AppConstants.keyBiometricEnabled);
        if (mounted) {
          setState(() => _biometrics = enabledStr == 'true');
        }
      }
      final localAuth = LocalAuthentication();
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;
      if (mounted) {
        setState(() => _hasBiometrics = isSupported && canCheck);
      }
    } on Object {
      // Fallback
    }
  }

  Future<void> _toggleBiometrics(bool value) async {
    if (value) {
      var didAuth = true;
      if (_hasBiometrics) {
        try {
          final localAuth = LocalAuthentication();
          didAuth = await localAuth.authenticate(
            localizedReason: context.l10n.biometricUnlockDesc,
          );
        } on Object {
          didAuth = false;
        }
      }
      if (didAuth && mounted) {
        setState(() => _biometrics = true);
        if (sl.isRegistered<FlutterSecureStorage>()) {
          await sl<FlutterSecureStorage>().write(
            key: AppConstants.keyBiometricEnabled,
            value: 'true',
          );
        }
      }
    } else {
      setState(() => _biometrics = false);
      if (sl.isRegistered<FlutterSecureStorage>()) {
        await sl<FlutterSecureStorage>().write(
          key: AppConstants.keyBiometricEnabled,
          value: 'false',
        );
      }
    }
  }

  Future<void> _togglePushNotification(bool value) async {
    if (value) {
      final granted = await AppPermissionHandler.requestNotification(context);
      if (!mounted) return;
      setState(() => _pushNotification = granted);
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.enableNotificationInSettings)),
        );
      }
    } else {
      setState(() => _pushNotification = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.arrowLeft, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.settingsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          // Section: Thông báo
          SettingsSectionHeader(title: context.l10n.notificationsSection),
          SettingsContainer(children: [
            SettingsSwitchTile(
              title: context.l10n.pushNotifications,
              subtitle: context.l10n.pushNotificationsDesc,
              value: _pushNotification,
              onChanged: _togglePushNotification,
            ),
            Divider(height: 1, color: colors.border),
            SettingsSwitchTile(
              title: context.l10n.emailReport,
              subtitle: context.l10n.emailReportDesc,
              value: _emailReport,
              onChanged: (v) => setState(() => _emailReport = v),
            ),
            Divider(height: 1, color: colors.border),
            SettingsSwitchTile(
              title: context.l10n.punchReminder,
              subtitle: context.l10n.punchReminderDesc,
              value: _punchReminder,
              onChanged: (v) => setState(() => _punchReminder = v),
            ),
          ]),
          20.gapH,

          // Section: Hiển thị & Giao diện (Theme & Language)
          SettingsSectionHeader(title: context.l10n.displaySection),
          const SettingsDisplaySection(),
          20.gapH,

          // Section: Quyền truy cập & Bảo mật
          SettingsSectionHeader(title: context.l10n.securityAndPrivacySection),
          SettingsContainer(children: [
            SettingsSwitchTile(
              title: context.l10n.biometricUnlock,
              subtitle: context.l10n.biometricUnlockDesc,
              value: _biometrics,
              onChanged: _toggleBiometrics,
            ),
            Divider(height: 1, color: colors.border),
            ListTile(
              leading: AppIcon(AppIcons.smartphone, color: colors.primaryIndigo),
              title: Text(
                context.l10n.registeredDeviceTitle,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              subtitle: Text(
                context.l10n.registeredDeviceSub,
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
              trailing: AppIcon(AppIcons.chevronRight, size: 18, color: colors.textTertiary),
              onTap: () => context.push(AppRoutes.registeredDevice),
            ),
            Divider(height: 1, color: colors.border),
            ListTile(
              leading: AppIcon(AppIcons.shieldCheck, color: colors.primaryIndigo),
              title: Text(
                context.l10n.manageDevicePermissions,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              subtitle: Text(
                context.l10n.permissionsSubtext,
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
              trailing: AppIcon(AppIcons.externalLink, size: 18, color: colors.textTertiary),
              onTap: openAppSettings,
            ),
          ]),
          20.gapH,

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.error,
              side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => unawaited(LogoutConfirmDialog.show(context)),
            icon: AppIcon(AppIcons.logout, size: 18, color: colors.error),
            label: Text(
              context.l10n.logoutButton,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
          ),
          20.gapH,

          Center(
            child: Text(
              context.l10n.appVersionFooter,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: colors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
