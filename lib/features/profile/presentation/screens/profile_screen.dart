import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_info_card.dart';

/// Screen 19: Comprehensive Employee Profile matching Screen 19 reference image.
class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;

    final user = authState is Authenticated ? authState.user : null;
    final isManager = authState is Authenticated && authState.role.isManager;

    final userName = user?.name ?? 'Nguyễn Minh Tuấn';
    final userCode = user?.employeeCode ?? 'NV-04821';
    final department = user?.department ?? 'Vận hành';
    final userEmail = user?.email ?? 'minh.tuan@company.vn';

    final personalRows = [
      ('Họ và tên', userName),
      ('Ngày sinh', '14/03/1994'),
      ('Điện thoại', '+84 908 221 470'),
      ('Email', userEmail),
      ('Địa chỉ', 'Q.3, TP. Hồ Chí Minh'),
    ];

    final workRows = [
      ('Bộ phận', department),
      ('Chức danh', 'Giám sát cửa hàng'),
      ('Quản lý', 'Lê Thu Hà'),
      ('Ngày vào', '02/05/2021'),
      ('Trạng thái', 'Chính thức'),
    ];

    final bankRows = [
      ('Ngân hàng', 'Vietcombank'),
      ('Số tài khoản', '•••• 4821'),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text(
          'Cá nhân',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Symbols.settings, size: 22, color: colors.textPrimary),
            onPressed: () => context.push(AppRoutes.settings),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // Part 1: Bounded Header Card
          ProfileHeaderCard(
            name: userName,
            employeeCode: userCode,
            position: 'Giám sát cửa hàng · Vận hành',
            isManager: isManager,
          ),
          const SizedBox(height: 18),

          // Thông tin cá nhân
          ProfileInfoCard(
            title: 'Thông tin cá nhân',
            rows: personalRows,
          ),
          const SizedBox(height: 16),

          // Part 2: Thông tin công việc
          ProfileInfoCard(
            title: 'Thông tin công việc',
            rows: workRows,
          ),
          const SizedBox(height: 16),

          // Tài khoản ngân hàng
          ProfileInfoCard(
            title: 'Tài khoản ngân hàng',
            rows: bankRows,
          ),
          const SizedBox(height: 16),

          // Profile Quick Links (K, H, T, C)
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                _buildLetterLinkTile('K', 'Liên hệ khẩn cấp', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Liên hệ khẩn cấp: 0908 221 470 (Người thân)')),
                  );
                }, colors),
                Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                _buildLetterLinkTile('H', 'Hồ sơ & tài liệu', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hồ sơ nhân viên & Hợp đồng lao động')),
                  );
                }, colors),
                Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                _buildLetterLinkTile('T', 'Tuyển dụng nội bộ', () => context.push(AppRoutes.jobRecruitment), colors),
                Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                _buildLetterLinkTile('C', 'Cài đặt', () => context.push(AppRoutes.settings), colors),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Nút Đăng xuất
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.error,
              side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _confirmLogout(context, colors),
            icon: const Icon(Symbols.logout, size: 18),
            label: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterLinkTile(String letter, String title, VoidCallback onTap, AppColorsExtension colors) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: colors.primaryIndigo,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppColorsExtension colors) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Xác nhận đăng xuất',
            style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          content: Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng VSTech HRM không?',
            style: TextStyle(fontSize: 13, color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Hủy', style: TextStyle(fontWeight: FontWeight.w700, color: colors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                unawaited(context.read<AuthCubit>().logout());
              },
              child: const Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}
