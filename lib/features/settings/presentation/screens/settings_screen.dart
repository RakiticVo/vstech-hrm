import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 16: Application Settings for Notifications, Privacy, Permissions, and States.
class SettingsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotification = true;
  bool _emailReport = false;
  bool _punchReminder = true;
  bool _biometrics = true;
  bool _autoLock = false;

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
          icon: const Icon(Symbols.arrow_back),
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
          _buildSectionHeader(context.l10n.notificationsSection, colors),
          _buildContainer([
            _buildSwitchTile(
              context.l10n.pushNotifications,
              context.l10n.pushNotificationsDesc,
              _pushNotification,
              _togglePushNotification,
              colors,
            ),
            Divider(height: 1, color: colors.border),
            _buildSwitchTile(
              context.l10n.emailReport,
              context.l10n.emailReportDesc,
              _emailReport,
              (v) => setState(() => _emailReport = v),
              colors,
            ),
            Divider(height: 1, color: colors.border),
            _buildSwitchTile(
              context.l10n.punchReminder,
              context.l10n.punchReminderDesc,
              _punchReminder,
              (v) => setState(() => _punchReminder = v),
              colors,
            ),
          ], colors),
          22.gapH,

          // Section: Quyền truy cập hệ thống
          _buildSectionHeader(context.l10n.systemPermissionsSection, colors),
          _buildContainer([
            ListTile(
              leading: Icon(Symbols.shield, color: colors.primaryIndigo),
              title: Text(
                context.l10n.manageDevicePermissions,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              subtitle: Text(
                context.l10n.permissionsSubtext,
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
              trailing: Icon(Symbols.open_in_new, size: 18, color: colors.textTertiary),
              onTap: openAppSettings,
            ),
          ], colors),
          22.gapH,

          // Section: Bảo mật
          _buildSectionHeader(context.l10n.securityAndPrivacySection, colors),
          _buildContainer([
            _buildSwitchTile(
              context.l10n.biometricUnlock,
              context.l10n.biometricUnlockDesc,
              _biometrics,
              (v) => setState(() => _biometrics = v),
              colors,
            ),
            Divider(height: 1, color: colors.border),
            _buildSwitchTile(
              context.l10n.autoLock,
              context.l10n.autoLockDesc,
              _autoLock,
              (v) => setState(() => _autoLock = v),
              colors,
            ),
          ], colors),
          22.gapH,

          // Section: Trạng thái thiết kế & Dữ liệu
          _buildSectionHeader(context.l10n.designAndSystemSection, colors),
          _buildContainer([
            ListTile(
              leading: Icon(Symbols.palette, color: colors.primaryIndigo),
              title: Text(
                context.l10n.uiStateShowcase,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              subtitle: Text(
                context.l10n.uiStateShowcaseDesc,
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
              trailing: Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
              onTap: () => context.push(AppRoutes.stateShowcase),
            ),
            Divider(height: 1, color: colors.border),
            ListTile(
              leading: Icon(Symbols.cleaning_services, color: colors.textSecondary),
              title: Text(
                context.l10n.clearCache,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              trailing: Text(
                '14.2 MB',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textTertiary),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.cacheClearedSnackbar)),
                );
              },
            ),
          ], colors),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
      ),
    );
  }

  Widget _buildContainer(List<Widget> children, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    AppColorsExtension colors,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colors.primaryIndigo,
      title: Text(
        title,
        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
      ),
    );
  }
}
