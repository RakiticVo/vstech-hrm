import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_toast.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_success_dialog.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/unregistered_face_dialog.dart';

/// Helper to handle AttendanceBloc state events on FaceScanScreen cleanly.
class FaceScanListenerHelper {
  const FaceScanListenerHelper._();

  static void handleState({
    required BuildContext context,
    required AttendanceState state,
    required bool isOfflineMode,
    required Future<void> Function() onInitCamera,
    required Future<void> Function() onGoToEnrollment,
    required Future<void> Function(AttendanceRecordEntity) onShowSuccess,
  }) {
    if (isOfflineMode) return;
    final colors = context.colors;
    final l10n = context.l10n;

    if (state.status == AttendanceProcessStatus.readyToScan) {
      unawaited(onInitCamera());
    } else if (state.status == AttendanceProcessStatus.faceNotRegistered) {
      unawaited(
        UnregisteredFaceDialog.show(
          context,
          onGoToEnrollment: () => unawaited(onGoToEnrollment()),
          onDismiss: () => context.pop(),
        ),
      );
    } else if (state.status == AttendanceProcessStatus.faceVerifyFailed) {
      AppToast.showError(
        context,
        state.errorMessage ?? 'Xác thực khuôn mặt thất bại',
      );
    } else if (state.status == AttendanceProcessStatus.success && state.lastRecord != null) {
      unawaited(onShowSuccess(state.lastRecord!));
    } else if (state.status == AttendanceProcessStatus.failure) {
      AppToast.showError(
        context,
        state.errorMessage ?? l10n.attendanceFailed,
      );
    }
  }

  static Future<void> showSuccessReceipt(
    BuildContext context,
    AttendanceRecordEntity record,
  ) async {
    unawaited(HapticFeedback.mediumImpact());
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AttendanceSuccessSheet(
        record: record,
        onClose: () => sheetContext.pop(),
      ),
    );
    if (context.mounted) {
      context.pop(true);
    }
  }
}
