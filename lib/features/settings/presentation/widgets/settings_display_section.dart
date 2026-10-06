import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/session/locale_cubit.dart';
import 'package:vstech_hrm/core/session/theme_cubit.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/language_selection_sheet.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/theme_selection_sheet.dart';

/// Section for configuring display appearance (ThemeMode) and language (Locale).
class SettingsDisplaySection extends StatelessWidget {
  const new({super.key});

  String _themeModeTitle(ThemeMode mode, BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return context.l10n.themeLight;
      case ThemeMode.dark:
        return context.l10n.themeDark;
      case ThemeMode.system:
        return context.l10n.themeSystem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final themeMode = context.watch<ThemeCubit>().state;
    final locale = context.watch<LocaleCubit>().state;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.border),
        ),
        child: Column(
        children: [
          ListTile(
            leading: AppIcon(AppIcons.darkMode, color: colors.primaryIndigo),
            title: Text(
              context.l10n.themeModeLabel,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            subtitle: Text(
              _themeModeTitle(themeMode, context),
              style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
            ),
            trailing: AppIcon(
              AppIcons.chevronRight,
              size: 18,
              color: colors.textTertiary,
            ),
            onTap: () => unawaited(ThemeSelectionSheet.show(context)),
          ),
          Divider(height: 1, color: colors.border),
          ListTile(
            leading: AppIcon(AppIcons.globe, color: colors.primaryIndigo),
            title: Text(
              context.l10n.languageLabel,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            subtitle: Text(
              locale.languageCode == 'en'
                  ? context.l10n.englishLanguage
                  : context.l10n.vietnameseLanguage,
              style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.languageCode.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colors.primaryIndigo,
                  ),
                ),
                4.gapW,
                AppIcon(
                  AppIcons.chevronRight,
                  size: 18,
                  color: colors.textTertiary,
                ),
              ],
            ),
            onTap: () => unawaited(LanguageSelectionSheet.show(context)),
          ),
        ],
      ),
    ),
  );
}
}
