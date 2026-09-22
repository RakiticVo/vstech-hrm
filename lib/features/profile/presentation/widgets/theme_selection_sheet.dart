import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/session/theme_cubit.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// BottomSheet to choose app appearance theme (system, light, dark).
class ThemeSelectionSheet extends StatelessWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ThemeSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentTheme = context.watch<ThemeCubit>().state;

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
            'CÀI ĐẶT GIAO DIỆN',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 6),
          Text(
            'Chọn chế độ hiển thị',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Giao diện thay đổi ngay lập tức và tự động ghi nhớ cho các lần mở ứng dụng tiếp theo.',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          _buildThemeItem(
            context: context,
            mode: ThemeMode.system,
            title: 'Theo hệ thống',
            subtitle: 'Tự động đồng bộ với cài đặt Sáng / Tối của điện thoại.',
            icon: Symbols.settings_brightness,
            isSelected: currentTheme == ThemeMode.system,
            colors: colors,
          ),
          const SizedBox(height: 10),
          _buildThemeItem(
            context: context,
            mode: ThemeMode.light,
            title: 'Giao diện sáng',
            subtitle: 'Tông kem ấm & hoạ văn gạch bông Sài Gòn đặc trưng.',
            icon: Symbols.light_mode,
            isSelected: currentTheme == ThemeMode.light,
            colors: colors,
          ),
          const SizedBox(height: 10),
          _buildThemeItem(
            context: context,
            mode: ThemeMode.dark,
            title: 'Giao diện tối',
            subtitle: 'Tông xanh đen sâu, dịu mắt khi sử dụng ban đêm.',
            icon: Symbols.dark_mode,
            isSelected: currentTheme == ThemeMode.dark,
            colors: colors,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Xác nhận',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeItem({
    required BuildContext context,
    required ThemeMode mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required AppColorsExtension colors,
  }) {
    return InkWell(
      onTap: () {
        unawaited(context.read<ThemeCubit>().setThemeMode(mode));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.tealPrimary.withValues(alpha: 0.08)
              : colors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colors.tealPrimary : colors.border,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: isSelected ? colors.tealPrimary : colors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium(color: colors.textPrimary)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(color: colors.textTertiary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Symbols.check_circle, size: 20, color: colors.tealPrimary),
          ],
        ),
      ),
    );
  }
}
