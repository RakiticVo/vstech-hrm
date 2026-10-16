import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';

/// Summary card displaying monthly statistics for timesheet correction requests.
class CorrectionSummaryCard extends StatelessWidget {
  const new({
    required this.corrections,
    super.key,
  });

  final List<CorrectionItemEntity> corrections;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final total = corrections.length;
    final approved = corrections.where((c) => c.isApproved).length;
    final pending = corrections.where((c) => c.isPending).length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.correctionSummaryTitle,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
          10.gapH,
          Row(
            children: [
              _buildStatChip(colors, l10n.leaveStatusFilterAll, '$total', const Color(0xFF0284C7)),
              8.gapW,
              _buildStatChip(colors, l10n.leaveStatusFilterPending, '$pending', colors.accentAmber),
              8.gapW,
              _buildStatChip(colors, l10n.leaveStatusFilterApproved, '$approved', const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(AppColorsExtension colors, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            2.gapH,
            Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
