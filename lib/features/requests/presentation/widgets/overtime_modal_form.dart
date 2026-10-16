import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_modal_components.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_validation_helper.dart';

/// Form fields container for Overtime Request Modal.
class OvertimeModalFormFields extends StatelessWidget {
  const new({
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.types,
    required this.selectedType,
    required this.length,
    required this.reasonController,
    required this.onPickDate,
    required this.onPickTime,
    required this.onSelectType,
    required this.onReasonChanged,
    required this.colors,
    this.validInfo,
    this.selectedEmployee,
    this.onPickEmployee,
    this.isManager = false,
    this.acceptImmediately = false,
    this.onAcceptChanged,
    super.key,
  });

  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<OvertimeTypeEntity> types;
  final OvertimeTypeEntity selectedType;
  final double length;
  final TextEditingController reasonController;
  final VoidCallback onPickDate;
  final void Function({required bool isStart}) onPickTime;
  final ValueChanged<OvertimeTypeEntity> onSelectType;
  final ValueChanged<String> onReasonChanged;
  final AppColorsExtension colors;
  final ValidMaxHourEntity? validInfo;
  final ManagedEmployeeEntity? selectedEmployee;
  final VoidCallback? onPickEmployee;
  final bool isManager;
  final bool acceptImmediately;
  final ValueChanged<bool>? onAcceptChanged;

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isManager || onPickEmployee != null) ...[
          Text(
            l10n.overtimeTargetEmployee,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
          6.gapH,
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onPickEmployee,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: colors.cardSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: selectedEmployee != null
                        ? colors.pineGreen.withValues(alpha: 0.15)
                        : colors.accentAmber.withValues(alpha: 0.2),
                    child: Text(
                      selectedEmployee != null && selectedEmployee!.name.isNotEmpty
                          ? selectedEmployee!.name[0].toUpperCase()
                          : 'T',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: selectedEmployee != null ? colors.pineGreen : colors.accentAmber,
                      ),
                    ),
                  ),
                  10.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedEmployee != null
                              ? selectedEmployee!.name
                              : l10n.overtimeTargetSelf,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        if (selectedEmployee != null)
                          Text(
                            '${selectedEmployee!.code}${selectedEmployee!.department != null ? ' · ${selectedEmployee!.department}' : ''}',
                            style: TextStyle(fontSize: 11, color: colors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.unfold_more, size: 18, color: colors.textTertiary),
                ],
              ),
            ),
          ),
          12.gapH,
        ],
        Text(
          l10n.overtimeDateLabel,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
        ),
        6.gapH,
        OvertimeDatePickerTile(
          dateStr: _formatDate(selectedDate),
          onTap: onPickDate,
          colors: colors,
        ),
        12.gapH,
        Text(
          l10n.overtimeTimeRangeLabel,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
        ),
        6.gapH,
        Row(
          children: [
            Expanded(
              child: OvertimeTimePickerTile(
                label: l10n.startTimeLabel,
                value: _formatTime(startTime),
                onTap: () => onPickTime(isStart: true),
                colors: colors,
              ),
            ),
            10.gapW,
            Expanded(
              child: OvertimeTimePickerTile(
                label: l10n.endTimeLabel,
                value: _formatTime(endTime),
                onTap: () => onPickTime(isStart: false),
                colors: colors,
              ),
            ),
          ],
        ),
        10.gapH,
        Text(
          'Loại tăng ca',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
        ),
        6.gapH,
        OvertimeTypeSelector(
          types: types,
          selectedType: selectedType,
          onSelected: onSelectType,
          colors: colors,
        ),
        10.gapH,
        OvertimeDurationBadge(length: length, colors: colors),
        if (validInfo != null || isManager)
          OvertimeValidationNotice(
            validInfo: validInfo,
            currentLength: length,
            skipMaxHour: isManager,
            colors: colors,
          ),
        12.gapH,
        Text(
          l10n.overtimeReasonLabel,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
        ),
        6.gapH,
        TextField(
          controller: reasonController,
          maxLines: 2,
          style: TextStyle(fontSize: 13, color: colors.textPrimary),
          onChanged: onReasonChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardSecondary,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.border),
            ),
          ),
        ),
        if (isManager || selectedEmployee != null) ...[
          12.gapH,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colors.cardSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duyệt luôn phiếu này',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Ghi nhận giờ tăng ca trực tiếp vào bảng công',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: acceptImmediately,
                  onChanged: onAcceptChanged,
                  activeTrackColor: colors.pineGreen,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Inline error banner for Overtime Request Modal.
class OvertimeErrorBanner extends StatelessWidget {
  const new({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: Colors.red),
          8.gapW,
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
