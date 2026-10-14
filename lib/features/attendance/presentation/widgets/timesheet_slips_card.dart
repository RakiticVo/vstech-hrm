import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/timesheet_detail_entity.dart';

/// Extra slips attached to the timesheet (Overtime, Leave, Business, Explanation).
class TimesheetSlipsCard extends StatelessWidget {
  const new({required this.detail, super.key});

  final TimesheetDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detail.overtimeSlip != null)
            _item(colors, l10n.timesheetOvertimeSlip, detail.overtimeSlip!),
          if (detail.confirmRequestId != null) ...[
            8.gapH,
            _item(colors, l10n.timesheetExplanationSlip, '#${detail.confirmRequestId}'),
          ],
          if (detail.leaveSlip != null) ...[
            8.gapH,
            _item(colors, l10n.timesheetLeaveSlip, detail.leaveSlip!),
          ],
          if (detail.businessSlip != null) ...[
            8.gapH,
            _item(colors, l10n.timesheetBusinessSlip, detail.businessSlip!),
          ],
        ],
      ),
    );
  }

  Widget _item(AppColorsExtension colors, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
      ],
    );
  }
}
