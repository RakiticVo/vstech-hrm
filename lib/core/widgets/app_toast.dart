import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vstech_hrm/core/widgets/app_toast_card.dart';

export 'package:vstech_hrm/core/widgets/app_toast_card.dart';

/// Floating soft toast utility replacing boxy snackbars with pleasant, pill-shaped notifications.
class AppToast {
  const new _();

  /// Default durations
  static const Duration defaultDuration = Duration(milliseconds: 2800);
  static const Duration errorDuration = Duration(milliseconds: 3400);

  /// Show a floating toast with smooth tactile feedback and soft aesthetics.
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = defaultDuration,
  }) {
    // Subtle haptic response for physical softness
    switch (type) {
      case ToastType.success:
      case ToastType.info:
        unawaited(HapticFeedback.lightImpact());
      case ToastType.warning:
      case ToastType.error:
        unawaited(HapticFeedback.mediumImpact());
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        createSnackBar(
          context: context,
          message: message,
          type: type,
          title: title,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration,
        ),
      );
  }

  /// Convenience helper for success messages.
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = defaultDuration,
  }) {
    show(context, message, type: ToastType.success, title: title, duration: duration);
  }

  /// Convenience helper for error messages.
  static void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = errorDuration,
  }) {
    show(context, message, type: ToastType.error, title: title, duration: duration);
  }

  /// Convenience helper for warning messages.
  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = defaultDuration,
  }) {
    show(context, message, type: ToastType.warning, title: title, duration: duration);
  }

  /// Convenience helper for informational messages.
  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = defaultDuration,
  }) {
    show(context, message, title: title, duration: duration);
  }

  /// Creates a floating SnackBar housing the rounded AppToastCard.
  static SnackBar createSnackBar({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = defaultDuration,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      content: AppToastCard(
        message: message,
        type: type,
        title: title,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }
}

/// BuildContext extensions for concise toast triggering.
extension ToastContextExtension on BuildContext {
  void showToast(
    String message, {
    ToastType type = ToastType.info,
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = AppToast.defaultDuration,
  }) => AppToast.show(
    this,
    message,
    type: type,
    title: title,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
  );

  void showSuccessToast(
    String message, {
    String? title,
    Duration duration = AppToast.defaultDuration,
  }) => AppToast.showSuccess(this, message, title: title, duration: duration);

  void showErrorToast(
    String message, {
    String? title,
    Duration duration = AppToast.errorDuration,
  }) => AppToast.showError(this, message, title: title, duration: duration);

  void showWarningToast(
    String message, {
    String? title,
    Duration duration = AppToast.defaultDuration,
  }) => AppToast.showWarning(this, message, title: title, duration: duration);

  void showInfoToast(
    String message, {
    String? title,
    Duration duration = AppToast.defaultDuration,
  }) => AppToast.showInfo(this, message, title: title, duration: duration);
}
