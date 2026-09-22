import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:permission_handler/permission_handler.dart';
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
          const SnackBar(content: Text('Vui lòng bật quyền Thông báo trong Cài đặt hệ thống')),
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
          'Cài đặt',
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
          _buildSectionHeader('Thông báo', colors),
          _buildContainer([
            _buildSwitchTile(
              'Thông báo đẩy',
              'Nhận thông báo phê duyệt và ca làm',
              _pushNotification,
              _togglePushNotification,
              colors,
            ),
            Divider(height: 1, color: colors.border),
            _buildSwitchTile(
              'Email báo cáo',
              'Gửi bản tóm tắt công & lương qua email',
              _emailReport,
              (v) => setState(() => _emailReport = v),
              colors,
            ),
            Divider(height: 1, color: colors.border),
            _buildSwitchTile(
              'Nhắc nhở chấm công',
              'Thông báo trước ca làm 15 phút',
              _punchReminder,
              (v) => setState(() => _punchReminder = v),
              colors,
            ),
          ], colors),
          const SizedBox(height: 22),

          // Section: Quyền truy cập hệ thống
          _buildSectionHeader('Quyền truy cập hệ thống', colors),
          _buildContainer([
            ListTile(
              leading: Icon(Symbols.shield, color: colors.primaryIndigo),
              title: Text(
                'Quản lý quyền thiết bị',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              subtitle: Text(
                'Máy ảnh, Vị trí GPS, Tệp & ảnh, Thông báo',
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
              trailing: Icon(Symbols.open_in_new, size: 18, color: colors.textTertiary),
              onTap: openAppSettings,
            ),
          ], colors),
          const SizedBox(height: 22),

          // Section: Bảo mật
          _buildSectionHeader('Bảo mật & Quyền riêng tư', colors),
          _buildContainer([
            _buildSwitchTile(
              'Mở khoá sinh trắc học',
              'Dùng Face ID hoặc vân tay để mở app',
              _biometrics,
              (v) => setState(() => _biometrics = v),
              colors,
            ),
            Divider(height: 1, color: colors.border),
            _buildSwitchTile(
              'Tự động khoá',
              'Khoá app ngay khi chuyển sang ứng dụng khác',
              _autoLock,
              (v) => setState(() => _autoLock = v),
              colors,
            ),
          ], colors),
          const SizedBox(height: 22),

          // Section: Trạng thái thiết kế & Dữ liệu
          _buildSectionHeader('Thiết kế & Hệ thống', colors),
          _buildContainer([
            ListTile(
              leading: Icon(Symbols.palette, color: colors.primaryIndigo),
              title: Text(
                'Minh họa 4 Trạng thái (Empty, Shimmer, Error, Success)',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              subtitle: Text(
                'Kiểm thử giao diện Rỗng, Đăng tải, Báo lỗi & Thành công',
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
              trailing: Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
              onTap: () => context.push(AppRoutes.stateShowcase),
            ),
            Divider(height: 1, color: colors.border),
            ListTile(
              leading: Icon(Symbols.cleaning_services, color: colors.textSecondary),
              title: Text(
                'Xoá bộ nhớ đệm (Cache)',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              trailing: Text(
                '14.2 MB',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textTertiary),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã dọn dẹp bộ nhớ đệm thành công')),
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
