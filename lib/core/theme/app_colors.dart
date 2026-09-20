import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const new({
    required this.tileDark,
    required this.tealPrimary,
    required this.tealLight,
    required this.amberCta,
    required this.amberInk,
    required this.amberInkOnTint,
    required this.greenInk,
    required this.redInk,
    required this.cream,
    required this.pageBackground,
    required this.cardBackground,
    required this.cardSecondary,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
  });

  final Color tileDark;
  final Color tealPrimary;
  final Color tealLight;
  final Color amberCta;
  final Color amberInk;
  final Color amberInkOnTint;
  final Color greenInk;
  final Color redInk;
  final Color cream;
  final Color pageBackground;
  final Color cardBackground;
  final Color cardSecondary;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color error;

  // Semantic & Design Token Aliases
  Color get primaryIndigo => tileDark;
  Color get accentAmber => amberCta;
  Color get accentAmberDark => amberInk;
  Color get pineGreen => greenInk;
  Color get brickRed => redInk;
  Color get background => pageBackground;
  Color get cardSurface => cardBackground;
  Color get surface => cardBackground;
  Color get textTertiary => textSecondary.withValues(alpha: 0.7);
  Color get shadow => const Color(0xFF000000);

  static const light = AppColorsExtension(
    tileDark: Color(0xFF0A544E),
    tealPrimary: Color(0xFF0F766E),
    tealLight: Color(0xFF14B8A6),
    amberCta: Color(0xFFF59E0B),
    amberInk: Color(0xFFB45309),
    amberInkOnTint: Color(0xFF92400E),
    greenInk: Color(0xFF047857),
    redInk: Color(0xFFB91C1C),
    cream: Color(0xFFFFF8EC),
    pageBackground: Color(0xFFF6F4EF),
    cardBackground: Color(0xFFFFFFFF),
    cardSecondary: Color(0xFFF0EDE5),
    border: Color(0xFFE3DFD6),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF5B6572),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
  );

  static const dark = AppColorsExtension(
    tileDark: Color(0xFF0A544E),
    tealPrimary: Color(0xFF2DD4BF),
    tealLight: Color(0xFF5EEAD4),
    amberCta: Color(0xFFFBBF24),
    amberInk: Color(0xFFFBBF24),
    amberInkOnTint: Color(0xFFFBBF24),
    greenInk: Color(0xFF34D399),
    redInk: Color(0xFFF87171),
    cream: Color(0xFFFFF8EC),
    pageBackground: Color(0xFF111827),
    cardBackground: Color(0xFF1F2937),
    cardSecondary: Color(0xFF263243),
    border: Color(0xFF374151),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
  );

  @override
  AppColorsExtension copyWith({
    Color? tileDark,
    Color? tealPrimary,
    Color? tealLight,
    Color? amberCta,
    Color? amberInk,
    Color? amberInkOnTint,
    Color? greenInk,
    Color? redInk,
    Color? cream,
    Color? pageBackground,
    Color? cardBackground,
    Color? cardSecondary,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return AppColorsExtension(
      tileDark: tileDark ?? this.tileDark,
      tealPrimary: tealPrimary ?? this.tealPrimary,
      tealLight: tealLight ?? this.tealLight,
      amberCta: amberCta ?? this.amberCta,
      amberInk: amberInk ?? this.amberInk,
      amberInkOnTint: amberInkOnTint ?? this.amberInkOnTint,
      greenInk: greenInk ?? this.greenInk,
      redInk: redInk ?? this.redInk,
      cream: cream ?? this.cream,
      pageBackground: pageBackground ?? this.pageBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardSecondary: cardSecondary ?? this.cardSecondary,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  AppColorsExtension lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      tileDark: Color.lerp(tileDark, other.tileDark, t)!,
      tealPrimary: Color.lerp(tealPrimary, other.tealPrimary, t)!,
      tealLight: Color.lerp(tealLight, other.tealLight, t)!,
      amberCta: Color.lerp(amberCta, other.amberCta, t)!,
      amberInk: Color.lerp(amberInk, other.amberInk, t)!,
      amberInkOnTint: Color.lerp(amberInkOnTint, other.amberInkOnTint, t)!,
      greenInk: Color.lerp(greenInk, other.greenInk, t)!,
      redInk: Color.lerp(redInk, other.redInk, t)!,
      cream: Color.lerp(cream, other.cream, t)!,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardSecondary: Color.lerp(cardSecondary, other.cardSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.light;
}
