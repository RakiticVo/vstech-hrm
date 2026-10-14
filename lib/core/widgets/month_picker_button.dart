import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/month_picker_dialog.dart';

/// Reusable month filter button that opens a custom Saigon Tile Month Picker Dialog.
/// Used across Request Center, Leave, Overtime, and Attendance Correction screens.
class MonthPickerButton extends StatelessWidget {
  const new({
    required this.selectedMonth,
    required this.onMonthChanged,
    this.allowAll = true,
    this.isCompact = false,
    super.key,
  });

  final String selectedMonth;
  final ValueChanged<String> onMonthChanged;
  final bool allowAll;
  final bool isCompact;

  Future<void> _showMonthPicker(BuildContext context) async {
    final result = await AppMonthPickerDialog.show(
      context,
      initialMonth: selectedMonth,
      allowAll: allowAll,
    );
    if (result != null && result.isNotEmpty) {
      onMonthChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => unawaited(_showMonthPicker(context)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 10 : 12,
            vertical: isCompact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                AppIcons.calendar,
                size: 16,
                color: colors.primaryIndigo,
              ),
              6.gapW,
              Text(
                selectedMonth,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 12.5,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              4.gapW,
              AppIcon(AppIcons.chevronDown, size: 16, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
