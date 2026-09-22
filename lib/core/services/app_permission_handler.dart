import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Centralized service handling contextual device permission requests.
/// Follows docs/security.md §6 and copywriting guidelines (natural Vietnamese, clear rationale).
abstract final class AppPermissionHandler {
  /// Requests Camera permission contextually for Face ID login or Face Scan Attendance.
  static Future<bool> requestCamera(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    final result = await Permission.camera.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied && context.mounted) {
      await _showPermissionRationaleDialog(
        context: context,
        icon: Symbols.photo_camera,
        title: 'Cần quyền truy cập máy ảnh',
        message: 'Để quét khuôn mặt nhận diện khi đăng nhập Face ID và chấm công, '
            'vui lòng cấp quyền Camera trong Cài đặt thiết bị.',
        permission: Permission.camera,
      );
    }
    return false;
  }

  /// Requests Location permission for Geofencing verification during attendance punch.
  static Future<bool> requestLocation(BuildContext context) async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;

    final result = await Permission.locationWhenInUse.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied && context.mounted) {
      await _showPermissionRationaleDialog(
        context: context,
        icon: Symbols.location_on,
        title: 'Cần quyền truy cập vị trí',
        message: 'Ứng dụng cần xác nhận bạn đang ở cơ sở làm việc để ghi nhận chấm công hợp lệ. '
            'Vui lòng bật quyền Vị trí trong Cài đặt thiết bị.',
        permission: Permission.locationWhenInUse,
      );
    }
    return false;
  }

  /// Requests Photos/Storage permission for attaching evidence documents.
  static Future<bool> requestPhotos(BuildContext context) async {
    final photosStatus = await Permission.photos.status;
    if (photosStatus.isGranted) return true;

    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) return true;

    final result = await Permission.photos.request();
    if (result.isGranted) return true;

    final storageResult = await Permission.storage.request();
    if (storageResult.isGranted) return true;

    if ((result.isPermanentlyDenied || storageResult.isPermanentlyDenied) && context.mounted) {
      await _showPermissionRationaleDialog(
        context: context,
        icon: Symbols.attach_file,
        title: 'Cần quyền truy cập tệp & hình ảnh',
        message: 'Để đính kèm minh chứng cho đơn xin nghỉ phép hoặc sửa công, '
            'vui lòng cấp quyền truy cập Thư viện ảnh trong Cài đặt.',
        permission: Permission.photos,
      );
    }
    return false;
  }

  /// Requests Notifications permission after meaningful user interaction.
  static Future<bool> requestNotification(BuildContext context) async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    final result = await Permission.notification.request();
    return result.isGranted;
  }

  static Future<void> _showPermissionRationaleDialog({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required Permission permission,
  }) async {
    final colors = context.colors;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primaryIndigo.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colors.primaryIndigo, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 13.5,
            color: colors.textSecondary,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Để sau',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colors.textTertiary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryIndigo,
              foregroundColor: const Color(0xFFFFF8EC),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              unawaited(openAppSettings());
            },
            child: const Text(
              'Mở cài đặt',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
