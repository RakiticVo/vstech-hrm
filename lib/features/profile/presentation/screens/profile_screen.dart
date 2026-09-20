import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/secondary_button.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';

/// User profile and account preferences screen.
class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;
    final isManager = authState is Authenticated && authState.role.isManager;

    final userName = user?.name ?? 'Nguyễn Văn An';
    final userCode = user?.employeeCode ?? 'NV0142';
    final department = user?.department ?? 'Bộ phận Phát triển Mobile';
    final userEmail = user?.email ?? 'nguyen.an@vstech.vn';

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: userName,
            subtitle: '$userCode • $department',
            avatarFallbackText: userName.isNotEmpty ? userName.substring(0, 1) : 'VS',
            height: 150,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard(userEmail, isManager, colors),
                const SizedBox(height: 16),
                _buildMenuSection(
                  title: 'BẢO MẬT & THIẾT BỊ',
                  items: const [
                    _MenuItem(icon: Symbols.fingerprint, title: 'Xác thực sinh trắc học', trailing: 'Đã bật'),
                    _MenuItem(icon: Symbols.phonelink_lock, title: 'Khóa ứng dụng', trailing: 'Mã PIN'),
                    _MenuItem(icon: Symbols.smartphone, title: 'Thiết bị liên kết', trailing: 'iPhone 15 Pro'),
                  ],
                  colors: colors,
                ),
                const SizedBox(height: 16),
                _buildMenuSection(
                  title: 'HỆ THỐNG & CÀI ĐẶT',
                  items: const [
                    _MenuItem(icon: Symbols.dark_mode, title: 'Giao diện', trailing: 'Theo hệ thống'),
                    _MenuItem(icon: Symbols.language, title: 'Ngôn ngữ', trailing: 'Tiếng Việt'),
                    _MenuItem(icon: Symbols.info, title: 'Phiên bản ứng dụng', trailing: 'v1.0.0 (Phase 0)'),
                  ],
                  colors: colors,
                ),
                const SizedBox(height: 24),
                SecondaryButton(
                  text: 'Đăng xuất tài khoản',
                  icon: Symbols.logout,
                  onPressed: () => context.read<AuthCubit>().logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String email, bool isManager, AppColorsExtension colors) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'VAI TRÒ HIỆN TẠI',
                style: AppTextStyles.labelMicro(color: colors.textTertiary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isManager
                      ? colors.accentAmber.withValues(alpha: 0.15)
                      : colors.primaryIndigo.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isManager ? 'Quản lý (QL / MSS)' : 'Nhân viên (NV / ESS)',
                  style: AppTextStyles.labelMicro(
                    color: isManager ? colors.accentAmberDark : colors.primaryIndigo,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Symbols.mail, size: 18, color: colors.textTertiary),
              const SizedBox(width: 8),
              Text(email, style: AppTextStyles.bodyMedium(color: colors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
    required AppColorsExtension colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelMicro(color: colors.textTertiary)),
        const SizedBox(height: 8),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, size: 22, color: colors.textSecondary),
                    title: Text(item.title, style: AppTextStyles.bodyMedium(color: colors.textPrimary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.trailing, style: AppTextStyles.bodySmall(color: colors.textTertiary)),
                        const SizedBox(width: 4),
                        Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
                      ],
                    ),
                    onTap: () {},
                  ),
                  if (index < items.length - 1)
                    Divider(height: 1, indent: 52, color: colors.border.withValues(alpha: 0.5)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const new({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String trailing;
}
