import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

enum AppStatusType {
  pending,
  approved,
  rejected,
  draft,
  inProgress;

  static AppStatusType fromString(String? status) {
    if (status == null) return AppStatusType.draft;
    final s = status.toUpperCase().trim();
    if (s.contains('PENDING') || s.contains('CHỜ')) return AppStatusType.pending;
    if (s.contains('APPROV') || s.contains('DUYỆT') || s.contains('DONE')) {
      return AppStatusType.approved;
    }
    if (s.contains('REJECT') || s.contains('TỪ CHỐI') || s.contains('CANCEL')) {
      return AppStatusType.rejected;
    }
    if (s.contains('PROGRESS') || s.contains('ĐANG')) return AppStatusType.inProgress;
    return AppStatusType.draft;
  }
}

/// Pill-shaped status badge following VSTech Design tokens.
class StatusChip extends StatelessWidget {
  const new({
    required this.label,
    required this.type,
    super.key,
  });

  final String label;
  final AppStatusType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (bg, text) = switch (type) {
      AppStatusType.pending => (
          colors.accentAmber.withValues(alpha: 0.15),
          colors.accentAmberDark,
        ),
      AppStatusType.approved => (
          colors.pineGreen.withValues(alpha: 0.15),
          colors.pineGreen,
        ),
      AppStatusType.rejected => (
          colors.brickRed.withValues(alpha: 0.15),
          colors.brickRed,
        ),
      AppStatusType.inProgress => (
          colors.primaryIndigo.withValues(alpha: 0.15),
          colors.primaryIndigo,
        ),
      AppStatusType.draft => (
          colors.textTertiary.withValues(alpha: 0.15),
          colors.textSecondary,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMicro(color: text).copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
