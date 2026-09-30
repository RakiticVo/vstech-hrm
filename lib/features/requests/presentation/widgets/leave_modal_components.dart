import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Reusable mode chip for Leave Half-day selector.
class LeaveModeChip extends StatelessWidget {
  const new({
    required this.text,
    required this.mode,
    required this.currentMode,
    required this.onSelected,
    required this.colors,
    super.key,
  });

  final String text;
  final int mode;
  final int currentMode;
  final ValueChanged<int> onSelected;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    final active = currentMode == mode;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onSelected(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: active ? colors.primaryIndigo : colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: active ? colors.primaryIndigo : colors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable Date Picker display tile for Leave Request modal.
class LeaveDateTile extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onTap,
    required this.colors,
    super.key,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
            2.gapH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                AppIcon(AppIcons.calendar, size: 14, color: colors.primaryIndigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
