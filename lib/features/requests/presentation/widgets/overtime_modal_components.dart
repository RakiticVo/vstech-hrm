import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';

/// Interactive Time Picker Tile for Overtime Modal.
class OvertimeTimePickerTile extends StatelessWidget {
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: colors.cardSecondary,
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
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                AppIcon(AppIcons.clock, size: 14, color: colors.primaryIndigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Dynamic calculated duration badge for Overtime Modal.
class OvertimeDurationBadge extends StatelessWidget {
  const new({
    required this.length,
    required this.colors,
    this.scale,
    super.key,
  });

  final double length;
  final double? scale;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: colors.pineGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          AppIcon(AppIcons.overtime, size: 16, color: colors.pineGreen),
          6.gapW,
          Expanded(
            child: Text(
              'Thời lượng: ${length.toStringAsFixed(1)} giờ',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.pineGreen),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern styled selector for Overtime Types in Overtime Modal.
class OvertimeTypeSelector extends StatelessWidget {
  const new({
    required this.types,
    required this.selectedType,
    required this.onSelected,
    required this.colors,
    super.key,
  });

  final List<OvertimeTypeEntity> types;
  final OvertimeTypeEntity selectedType;
  final ValueChanged<OvertimeTypeEntity> onSelected;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    final effectiveValue = types.any((t) => t.code == selectedType.code)
        ? types.firstWhere((t) => t.code == selectedType.code)
        : (types.isNotEmpty ? types.first : null);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
        color: colors.cardSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OvertimeTypeEntity>(
          value: effectiveValue,
          isExpanded: true,
          icon: AppIcon(AppIcons.chevronDown, size: 18, color: colors.primaryIndigo),
          dropdownColor: colors.surface,
          borderRadius: BorderRadius.circular(14),
          selectedItemBuilder: (context) {
            return types.map((t) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          items: types.map((t) {
            final isSelected = t.code == selectedType.code;
            return DropdownMenuItem<OvertimeTypeEntity>(
              value: t,
              child: Text(
                t.name,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? colors.primaryIndigo : colors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onSelected(val);
          },
        ),
      ),
    );
  }
}

/// Date picker tile component for Overtime Modal.
class OvertimeDatePickerTile extends StatelessWidget {
  const new({
    required this.dateStr,
    required this.onTap,
    required this.colors,
    super.key,
  });

  final String dateStr;
  final VoidCallback onTap;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: colors.cardSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateStr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            AppIcon(AppIcons.calendar, size: 18, color: colors.primaryIndigo),
          ],
        ),
      ),
    );
  }
}

/// Debounced submit button with loading spinner for Overtime Modal.
class OvertimeSubmitButton extends StatelessWidget {
  const new({
    required this.title,
    required this.isSubmitting,
    required this.onPressed,
    super.key,
  });

  final String title;
  final bool isSubmitting;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B),
          foregroundColor: const Color(0xFF1C1408),
          disabledBackgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: isSubmitting ? null : onPressed,
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1C1408)),
                ),
              )
            : Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

typedef OvertimeTypeChips = OvertimeTypeSelector;
