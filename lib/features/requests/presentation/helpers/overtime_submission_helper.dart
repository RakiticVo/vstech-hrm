import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/app_toast.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_overtime_request_usecase.dart';

/// Helper handling overtime creation submission and user feedback.
class OvertimeSubmissionHelper {
  static Future<String?> submit({
    required BuildContext context,
    required OvertimeTypeEntity type,
    required DateTime date,
    required DateTime start,
    required DateTime end,
    required double length,
    required String reason,
    required Future<void> Function() onReload,
    String? employeeCode,
    String? employeeName,
    bool? accept,
  }) async {
    final auth = sl.isRegistered<AuthCubit>() ? sl<AuthCubit>().state : null;
    final curEmp = auth is Authenticated ? auth.user.employeeCode : 'NV001';
    final empCode = employeeCode ?? curEmp;
    final isSub = employeeCode != null && employeeCode != curEmp;
    final ymd =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final sTime =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final eTime =
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';

    final params = CreateOvertimeParams(
      employeeCode: empCode,
      adminEmployeeCode: isSub ? empCode : null,
      accept: accept,
      date: ymd,
      length: length,
      overtimeTypeCode: type.code,
      startOvertime: '${ymd}T$sTime:00',
      endOvertime: '${ymd}T$eTime:00',
      note: reason,
    );

    final result = await sl<CreateOvertimeRequestUseCase>()(params);
    if (!context.mounted) return null;

    if (result.isLeft()) {
      final msg =
          result.getLeft().toNullable()?.message ?? 'Lỗi gửi yêu cầu tăng ca';
      context.showErrorToast(msg);
      return msg;
    }

    await onReload();
    if (!context.mounted) return null;
    final l10n = context.l10n;
    final dStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final msg = isSub
        ? l10n.overtimeSubmittedForSubordinateMsg(dStr, employeeName ?? empCode)
        : l10n.overtimeSubmittedMsg(dStr, '$sTime - $eTime');
    await AppSuccessDialog.show(context,
        title: l10n.overtimeSubmittedTitle, message: msg);
    return null;
  }
}
