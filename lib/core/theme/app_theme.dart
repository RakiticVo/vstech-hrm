import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

class AppTheme {
  const new _();

  static ThemeData get lightTheme => light;
  static ThemeData get darkTheme => dark;

  static ThemeData get light {
    const colors = AppColorsExtension.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: colors.pageBackground,
      colorScheme: ColorScheme.light(
        primary: colors.tealPrimary,
        secondary: colors.amberCta,
        surface: colors.cardBackground,
        error: colors.error,
        onPrimary: colors.cream,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.pageBackground,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(color: colors.textPrimary),
      ),
      extensions: const [colors],
    );
  }

  static ThemeData get dark {
    const colors = AppColorsExtension.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: colors.pageBackground,
      colorScheme: ColorScheme.dark(
        primary: colors.tealPrimary,
        secondary: colors.amberCta,
        surface: colors.cardBackground,
        error: colors.error,
        onPrimary: colors.pageBackground,
        onSecondary: colors.pageBackground,
        onSurface: colors.textPrimary,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.pageBackground,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(color: colors.textPrimary),
      ),
      extensions: const [colors],
    );
  }
}
