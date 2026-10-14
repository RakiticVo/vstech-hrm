import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';

/// Reusable Date/Time picker tile for Attendance Correction Modal.
class CorrectionPickerTile extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.iconName,
    required this.onTap,
    required this.colors,
    super.key,
  });

  final String label;
  final String value;
  final String iconName;
  final VoidCallback onTap;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
            4.gapH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: colors.textPrimary),
                ),
                AppIcon(iconName, size: 14, color: colors.primaryIndigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Selector chips for correction reasons in Attendance Correction Modal.
class CorrectionReasonChips extends StatelessWidget {
  const new({
    required this.reasons,
    required this.selectedReason,
    required this.onSelected,
    required this.colors,
    super.key,
  });

  final List<CorrectionReasonEntity> reasons;
  final CorrectionReasonEntity selectedReason;
  final ValueChanged<CorrectionReasonEntity> onSelected;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: reasons.map((r) {
        final isSel = selectedReason.code == r.code;
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onSelected(r),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isSel ? colors.primaryIndigo.withValues(alpha: 0.1) : colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSel ? colors.primaryIndigo : colors.border, width: isSel ? 1.5 : 1),
            ),
            child: Text(
              r.name,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                color: isSel ? colors.primaryIndigo : colors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
