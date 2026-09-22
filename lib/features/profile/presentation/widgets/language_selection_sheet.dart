import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/session/locale_cubit.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// BottomSheet to choose app display language (Vietnamese, English).
class LanguageSelectionSheet extends StatelessWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const LanguageSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentLocale = context.watch<LocaleCubit>().state;

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
            'CÀI ĐẶT NGÔN NGỮ',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 6),
          Text(
            'Chọn ngôn ngữ hiển thị',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Giao diện và thông báo sẽ được chuyển đổi ngay lập tức sang ngôn ngữ bạn chọn.',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          _buildLanguageItem(
            context: context,
            locale: const Locale('vi'),
            title: 'Tiếng Việt',
            subtitle: 'Ngôn ngữ mặc định của ứng dụng.',
            flag: '🇻🇳',
            isSelected: currentLocale.languageCode == 'vi',
            colors: colors,
          ),
          const SizedBox(height: 10),
          _buildLanguageItem(
            context: context,
            locale: const Locale('en'),
            title: 'English',
            subtitle: 'English display for global workplace standards.',
            flag: '🇬🇧',
            isSelected: currentLocale.languageCode == 'en',
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

  Widget _buildLanguageItem({
    required BuildContext context,
    required Locale locale,
    required String title,
    required String subtitle,
    required String flag,
    required bool isSelected,
    required AppColorsExtension colors,
  }) {
    return InkWell(
      onTap: () {
        unawaited(context.read<LocaleCubit>().setLocale(locale));
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
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
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
