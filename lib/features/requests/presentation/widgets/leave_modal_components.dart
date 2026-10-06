import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';

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

/// Attachment selector button for Leave Request modal.
class LeaveAttachmentButton extends StatelessWidget {
  const LeaveAttachmentButton({
    required this.attachedFileName,
    required this.onTap,
    required this.colors,
    required this.placeholderText,
    super.key,
  });

  final String? attachedFileName;
  final VoidCallback onTap;
  final AppColorsExtension colors;
  final String placeholderText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              attachedFileName != null ? AppIcons.check : AppIcons.attach,
              size: 16,
              color: attachedFileName != null ? colors.pineGreen : colors.textSecondary,
            ),
            6.gapW,
            Text(
              attachedFileName ?? placeholderText,
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draft and Submit button pair for Leave Request modal.
class LeaveActionButtons extends StatelessWidget {
  const LeaveActionButtons({
    required this.onDraft,
    required this.onSubmit,
    required this.draftLabel,
    required this.submitLabel,
    required this.colors,
    super.key,
  });

  final VoidCallback onDraft;
  final VoidCallback onSubmit;
  final String draftLabel;
  final String submitLabel;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: colors.border),
            ),
            onPressed: onDraft,
            child: Text(
              draftLabel,
              style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        10.gapW,
        Expanded(
          flex: 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: const Color(0xFF1C1408),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onSubmit,
            child: Text(
              submitLabel,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

/// Reusable plan chips selector for Leave Request modal.
class LeavePlanSelector extends StatelessWidget {
  const LeavePlanSelector({
    required this.plans,
    required this.selectedPlan,
    required this.onSelected,
    required this.colors,
    this.isLoading = false,
    super.key,
  });

  final List<LeavePlanEntity> plans;
  final LeavePlanEntity? selectedPlan;
  final ValueChanged<LeavePlanEntity> onSelected;
  final AppColorsExtension colors;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 36,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: plans.map((p) {
        final isSel = selectedPlan?.code == p.code;
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onSelected(p),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSel ? colors.primaryIndigo.withValues(alpha: 0.1) : colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSel ? colors.primaryIndigo : colors.border,
                width: isSel ? 1.5 : 1,
              ),
            ),
            child: Text(
              p.name,
              style: TextStyle(
                fontSize: 12,
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
