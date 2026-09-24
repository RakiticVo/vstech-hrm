import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Categorization of device screen dimensions for responsive adaptation.
enum DeviceScreenType {
  /// Compact screen (width < 360dp, e.g. iPhone SE, compact Android devices).
  compact,

  /// Standard smartphone screen (360dp <= width <= 414dp, modern smartphones).
  normal,

  /// Expanded smartphone or tablet screen (width > 414dp, large devices/tablets).
  expanded,
}

/// Central pure Flutter responsive design utility.
abstract final class AppLayout {
  /// Base design mockup width (Saigon Tile design: 390dp).
  static const double baseWidth = 390;

  /// Base design mockup height (844dp).
  static const double baseHeight = 844;

  /// Returns current device screen category.
  static DeviceScreenType getScreenType(BuildContext context) {
    final width = screenWidth(context);
    if (width < 360) return DeviceScreenType.compact;
    if (width > 414) return DeviceScreenType.expanded;
    return DeviceScreenType.normal;
  }

  /// True if current screen width is below 360dp.
  static bool isSmallScreen(BuildContext context) =>
      screenWidth(context) < 360;

  /// True if current screen width is above 414dp.
  static bool isLargeScreen(BuildContext context) =>
      screenWidth(context) > 414;

  /// Active screen width.
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// Active screen height.
  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Proportional scaled width with safe bounds (0.8x to 1.25x).
  static double w(BuildContext context, double value) {
    final scale = screenWidth(context) / baseWidth;
    final clampedScale = math.max(0.8, math.min(1.25, scale));
    return (value * clampedScale).roundToDouble();
  }

  /// Percentage of screen width (e.g. 50 = 50% width).
  static double wp(BuildContext context, double percentage) =>
      screenWidth(context) * (percentage / 100);

  /// Proportional scaled height with safe bounds.
  static double h(BuildContext context, double value) {
    final scale = screenHeight(context) / baseHeight;
    final clampedScale = math.max(0.85, math.min(1.2, scale));
    return (value * clampedScale).roundToDouble();
  }

  /// Percentage of screen height (e.g. 25 = 25% height).
  static double hp(BuildContext context, double percentage) =>
      screenHeight(context) * (percentage / 100);

  /// Horizontal spacing SizedBox.
  static SizedBox gapW(double width) => SizedBox(width: width);

  /// Vertical spacing SizedBox.
  static SizedBox gapH(double height) => SizedBox(height: height);

  /// Horizontal spacing SizedBox based on screen width percentage.
  static SizedBox gapWp(BuildContext context, double percentage) =>
      SizedBox(width: wp(context, percentage));

  /// Vertical spacing SizedBox based on screen height percentage.
  static SizedBox gapHp(BuildContext context, double percentage) =>
      SizedBox(height: hp(context, percentage));

  /// Returns custom value tailored to active screen category.
  static T custom<T>(
    BuildContext context, {
    required T normal,
    T? compact,
    T? expanded,
  }) {
    switch (getScreenType(context)) {
      case DeviceScreenType.compact:
        return compact ?? normal;
      case DeviceScreenType.expanded:
        return expanded ?? normal;
      case DeviceScreenType.normal:
        return normal;
    }
  }

  /// Responsive padding for all edges with compact reduction.
  static EdgeInsets paddingAll(BuildContext context, double value) {
    final factor = isSmallScreen(context) ? 0.85 : 1.0;
    return EdgeInsets.all((value * factor).roundToDouble());
  }

  /// Responsive symmetric padding.
  static EdgeInsets paddingSymmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) {
    final factor = isSmallScreen(context) ? 0.85 : 1.0;
    return EdgeInsets.symmetric(
      horizontal: (horizontal * factor).roundToDouble(),
      vertical: (vertical * factor).roundToDouble(),
    );
  }

  /// Custom fine-grained edge insets per screen type.
  static EdgeInsets paddingCustom(
    BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) return paddingAll(context, all);
    final factor = isSmallScreen(context) ? 0.85 : 1.0;
    return EdgeInsets.only(
      top: ((top ?? vertical ?? 0) * factor).roundToDouble(),
      bottom: ((bottom ?? vertical ?? 0) * factor).roundToDouble(),
      left: ((left ?? horizontal ?? 0) * factor).roundToDouble(),
      right: ((right ?? horizontal ?? 0) * factor).roundToDouble(),
    );
  }
}

/// Concise extensions on [BuildContext] for responsive layout styling.
extension AppLayoutContextX on BuildContext {
  /// Current device screen category.
  DeviceScreenType get screenType => AppLayout.getScreenType(this);

  /// True if device screen width is below 360dp.
  bool get isSmallScreen => AppLayout.isSmallScreen(this);

  /// True if device screen width is above 414dp.
  bool get isLargeScreen => AppLayout.isLargeScreen(this);

  /// Active screen width.
  double get screenWidth => AppLayout.screenWidth(this);

  /// Active screen height.
  double get screenHeight => AppLayout.screenHeight(this);

  /// Scaled width.
  double w(double value) => AppLayout.w(this, value);

  /// Percentage of screen width.
  double wp(double percentage) => AppLayout.wp(this, percentage);

  /// Scaled height.
  double h(double value) => AppLayout.h(this, value);

  /// Percentage of screen height.
  double hp(double percentage) => AppLayout.hp(this, percentage);

  /// Horizontal spacing SizedBox.
  SizedBox gapW(double width) => AppLayout.gapW(width);

  /// Vertical spacing SizedBox.
  SizedBox gapH(double height) => AppLayout.gapH(height);

  /// Horizontal spacing SizedBox based on screen width percentage.
  SizedBox gapWp(double percentage) => AppLayout.gapWp(this, percentage);

  /// Vertical spacing SizedBox based on screen height percentage.
  SizedBox gapHp(double percentage) => AppLayout.gapHp(this, percentage);

  /// Custom value based on screen type.
  T custom<T>({required T normal, T? compact, T? expanded}) =>
      AppLayout.custom<T>(this, normal: normal, compact: compact, expanded: expanded);

  /// Responsive padding for all edges.
  EdgeInsets paddingAll(double value) => AppLayout.paddingAll(this, value);

  /// Responsive symmetric padding.
  EdgeInsets paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      AppLayout.paddingSymmetric(this, horizontal: horizontal, vertical: vertical);

  /// Custom fine-grained edge insets.
  EdgeInsets paddingCustom({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      AppLayout.paddingCustom(
        this,
        all: all,
        horizontal: horizontal,
        vertical: vertical,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      );
}

/// Concise extensions on [num] for SizedBox gap instantiation.
extension AppLayoutNumX on num {
  /// SizedBox with width equal to this number.
  SizedBox get gapW => SizedBox(width: toDouble());

  /// SizedBox with height equal to this number.
  SizedBox get gapH => SizedBox(height: toDouble());
}

/// Standardized fixed gap constants per design system.
abstract final class AppGap {
  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w6 = SizedBox(width: 6);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w12 = SizedBox(width: 12);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox h2 = SizedBox(height: 2);
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h6 = SizedBox(height: 6);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h10 = SizedBox(height: 10);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h20 = SizedBox(height: 20);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h32 = SizedBox(height: 32);
}
