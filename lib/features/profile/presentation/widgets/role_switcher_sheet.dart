import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// BottomSheet to switch user roles for Standalone Demo (NV vs QL).
class RoleSwitcherSheet extends StatelessWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const RoleSwitcherSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;
    final currentRole = authState is Authenticated ? authState.role : UserRole.employee;

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
            'CHUYỂN ĐỔI VAI TRÒ (DEMO)',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 6),
          Text(
            'Chọn vai trò trải nghiệm',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Chế độ Demo độc lập cho phép hoán đổi giao diện và luồng duyệt giữa Nhân viên và Quản lý tức thì.',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          _buildRoleOption(
            context: context,
            role: UserRole.employee,
            title: 'Nhân viên (NV / ESS)',
            subtitle: 'Nguyễn Văn An • NV0142\nChấm công, gửi đơn nghỉ phép, xem phiếu lương.',
            isSelected: currentRole == UserRole.employee,
            icon: Symbols.badge,
            colors: colors,
          ),
          const SizedBox(height: 12),
          _buildRoleOption(
            context: context,
            role: UserRole.manager,
            title: 'Quản lý trực tiếp (QL / MSS)',
            subtitle: 'Trần Thị Mai • NV0089\nXem dải chờ duyệt, duyệt cấp 1 các đơn từ nhân viên.',
            isSelected: currentRole == UserRole.manager,
            icon: Symbols.supervisor_account,
            colors: colors,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Đóng',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption({
    required BuildContext context,
    required UserRole role,
    required String title,
    required String subtitle,
    required bool isSelected,
    required IconData icon,
    required AppColorsExtension colors,
  }) {
    final borderColor = isSelected ? colors.tealPrimary : colors.border;
    final bgColor = isSelected
        ? colors.tealPrimary.withValues(alpha: 0.08)
        : colors.cardBackground;

    return InkWell(
      onTap: () {
        unawaited(context.read<AuthCubit>().loginAsDemo(role));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã chuyển sang vai trò: $title'),
            duration: const Duration(seconds: 2),
            backgroundColor: colors.tealPrimary,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.tealPrimary
                    : colors.border.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : colors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium(color: colors.textPrimary)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Symbols.check_circle, size: 22, color: colors.tealPrimary),
          ],
        ),
      ),
    );
  }
}
