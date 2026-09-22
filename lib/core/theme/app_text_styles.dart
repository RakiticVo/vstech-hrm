import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  const new _();

  static const String fontFamily = 'Source Sans 3';

  // Base getters
  static TextStyle get display => GoogleFonts.sourceSans3(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.2,
      );

  static TextStyle get h1 => GoogleFonts.sourceSans3(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get h2 => GoogleFonts.sourceSans3(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get subhead => GoogleFonts.sourceSans3(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get body => GoogleFonts.sourceSans3(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.sourceSans3(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.35,
      );

  static TextStyle get micro => GoogleFonts.sourceSans3(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // Parameterized scale helpers
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
      );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
      );

  static TextStyle headlineSmall({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextStyle labelMicro({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color,
      );

  static TextStyle buttonMedium({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  // Tabular figures for numbers, currency, dates, percentages
  static TextStyle tabular(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
