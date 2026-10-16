import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_valid_max_hour_usecase.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

typedef OvertimeConfirmCallback = Future<String?> Function(
  OvertimeTypeEntity type,
  DateTime date,
  DateTime start,
  DateTime end,
  double length,
  String reason, {
  String? employeeCode,
  String? employeeName,
  bool? accept,
});

class OvertimeValidationHelper {
  static Future<ValidMaxHourEntity?> fetchValidMaxHour({
    required DateTime date,
    required String overtimeType,
    String? adminEmployee,
  }) async {
    if (!sl.isRegistered<GetValidMaxHourUseCase>()) return null;
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final result = await sl<GetValidMaxHourUseCase>().call(
      date: dateStr,
      overtimeTypeCode: overtimeType,
      adminEmployee: adminEmployee,
    );
    return await Future.value(result.fold((_) => null, (entity) => entity));
  }

  static double computeLength(TimeOfDay startTime, TimeOfDay endTime) {
    final startMin = startTime.hour * 60 + startTime.minute;
    final endMin = endTime.hour * 60 + endTime.minute;
    var diff = endMin - startMin;
    if (diff <= 0) diff += 24 * 60;
    final quarters = (diff / 15.0).round();
    return (quarters * 0.25).clamp(0.25, 24.0);
  }

  static List<OvertimeTypeEntity> cleanTypes(List<OvertimeTypeEntity> list) {
    return list
        .where((t) => t.code.toLowerCase() != 'default' && !t.name.contains('Chọn một dữ liệu'))
        .toList();
  }

  static String? validateSubmission({
    required OvertimeTypeEntity? selectedType,
    required String reason,
    required double length,
    ValidMaxHourEntity? validInfo,
    bool skipMaxHour = true,
  }) {
    if (selectedType == null || selectedType.code.toLowerCase() == 'default') {
      return 'Vui lòng chọn loại tăng ca hợp lệ';
    }
    if (reason.trim().isEmpty) {
      return 'Vui lòng nhập lý do tăng ca';
    }
    if (validInfo != null && validInfo.isLock) {
      return validInfo.message?.isNotEmpty == true
          ? validInfo.message!
          : 'Bảng chấm công ngày này đã bị khoá';
    }
    if (!skipMaxHour && validInfo != null) {
      if (length > validInfo.maxHour) {
        return 'Số giờ tăng ca ($length giờ) vượt quá giới hạn tối đa cho phép (${validInfo.maxHour} giờ)';
      }
    }
    return null;
  }

  static Future<DateTime?> pickDate(BuildContext context, DateTime current) =>
      showDatePicker(
        context: context,
        initialDate: current,
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 60)),
      );

  static Future<TimeOfDay?> pickTime(BuildContext context, TimeOfDay current) =>
      showTimePicker(context: context, initialTime: current);

  static List<OvertimeTypeEntity> defaultTypes(AppLocalizations l10n) => [
        OvertimeTypeEntity(code: 'OT_WEEKDAY', name: l10n.otRateWeekday),
        OvertimeTypeEntity(code: 'OT_WEEKEND', name: l10n.otRateWeekend, scale: 2),
        OvertimeTypeEntity(code: 'OT_HOLIDAY', name: l10n.otRateHoliday, scale: 3),
      ];
}

/// Banner showing Timesheet lock warning or maximum allowed hours for overtime.
class OvertimeValidationNotice extends StatelessWidget {
  const new({
    required this.validInfo,
    required this.currentLength,
    required this.colors,
    this.skipMaxHour = false,
    super.key,
  });

  final ValidMaxHourEntity? validInfo;
  final double currentLength;
  final AppColorsExtension colors;
  final bool skipMaxHour;

  @override
  Widget build(BuildContext context) {
    final info = validInfo;
    if (info == null && !skipMaxHour) return const SizedBox.shrink();

    if (info != null && info.isLock) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, size: 16, color: Colors.red),
            8.gapW,
            Expanded(
              child: Text(
                info.message?.isNotEmpty == true
                    ? info.message!
                    : 'Bảng công ngày này đã bị khoá, không thể gửi yêu cầu tăng ca.',
                style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    // When created by Manager for subordinate, display friendly bypass notice
    return const SizedBox.shrink();
  }
}
