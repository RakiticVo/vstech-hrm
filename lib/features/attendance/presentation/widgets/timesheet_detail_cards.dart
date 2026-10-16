import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/timesheet_detail_entity.dart';

export 'timesheet_slips_card.dart';

/// Overview card displaying shift, punch type, and attendance status matching the daily log.
class TimesheetOverviewCard extends StatelessWidget {
  const new({
    required this.record,
    this.detail,
    this.timesheet,
    super.key,
  });

  final AttendanceRecordEntity record;
  final TimesheetDetailEntity? detail;
  final AccountTimesheetEntity? timesheet;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final shift = timesheet?.note ?? record.shiftName ?? detail?.shiftName ?? record.note ?? 'Ca chuẩn';

    final rawLate = (timesheet != null && timesheet!.late > 0)
        ? timesheet!.late
        : (record.lateHours > 0 ? record.lateHours : (detail?.lateHours ?? 0.0));
    final rawEarly = (timesheet != null && timesheet!.early > 0)
        ? timesheet!.early
        : (record.earlyHours > 0 ? record.earlyHours : (detail?.earlyHours ?? 0.0));
    final lateMins = rawLate > 0 && rawLate < 5.0 ? (rawLate * 60).roundToDouble() : rawLate;
    final earlyMins = rawEarly > 0 && rawEarly < 5.0 ? (rawEarly * 60).roundToDouble() : rawEarly;

    final isRejected = timesheet?.isRejected ?? false;
    final isLate = record.isLate || (timesheet?.isLate ?? false) || lateMins > 0;
    final isEarly = record.isEarly || (timesheet?.isEarly ?? false) || earlyMins > 0;
    final statusColor = isRejected ? colors.error : (isLate || isEarly ? colors.accentAmber : colors.pineGreen);
    final statusText = isRejected
        ? l10n.timesheetRejected
        : (isLate
            ? (lateMins > 0 ? 'Đi muộn (${lateMins.toInt()} phút)' : 'Đi muộn')
            : (isEarly ? (earlyMins > 0 ? 'Về sớm (${earlyMins.toInt()} phút)' : 'Về sớm') : 'Đúng giờ'));
    final statusIcon = isRejected
        ? Icons.cancel_outlined
        : (isLate ? Icons.access_time_rounded : (isEarly ? Icons.logout_rounded : Icons.check_circle_outline_rounded));
    final isConfirmed = timesheet?.isConfirmed ?? detail?.isConfirmed ?? record.isConfirmed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.badge_outlined, size: 18, color: colors.pineGreen),
              8.gapW,
              Text(l10n.timesheetShift, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
              const Spacer(),
              Text(shift, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            ],
          ),
          10.gapH,
          Row(
            children: [
              Icon(statusIcon, size: 18, color: statusColor),
              8.gapW,
              Text(l10n.classificationLabel, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          10.gapH,
          Row(
            children: [
              Icon(
                isRejected
                    ? Icons.highlight_off_rounded
                    : (isConfirmed ? Icons.verified_outlined : Icons.schedule_rounded),
                size: 18,
                color: isRejected
                    ? colors.error
                    : (isConfirmed ? colors.pineGreen : colors.accentAmber),
              ),
              8.gapW,
              Text(l10n.timesheetStatus, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
              const Spacer(),
              Text(
                isRejected
                    ? l10n.timesheetRejected
                    : (isConfirmed ? l10n.timesheetConfirmed : l10n.timesheetNotConfirmed),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isRejected
                      ? colors.error
                      : (isConfirmed ? colors.pineGreen : colors.accentAmber),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Work hours, in/out timestamps, and valid actual work credits.
class TimesheetTimeCard extends StatelessWidget {
  const new({
    required this.record,
    this.detail,
    this.timesheet,
    super.key,
  });

  final AttendanceRecordEntity record;
  final TimesheetDetailEntity? detail;
  final AccountTimesheetEntity? timesheet;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final isConfirmed = timesheet?.isConfirmed ?? detail?.isConfirmed ?? record.isConfirmed;
    final isRejected = timesheet?.isRejected ?? false;
    final checkIn = timesheet?.checkinTime ??
        record.checkinTime ??
        detail?.checkinTime ??
        DateFormat('HH:mm').format(record.timestamp);
    final checkOut = timesheet?.checkoutTime ?? record.checkoutTime ?? detail?.checkoutTime ?? '--:--';
    final actualHours = (timesheet != null && timesheet!.actualWorkTime > 0)
        ? timesheet!.actualWorkTime
        : (record.actualHours > 0 ? record.actualHours : (detail?.actualWorkTime ?? 0.0));
    final validHours = (!isConfirmed || isRejected)
        ? 0.0
        : ((timesheet != null && timesheet!.validActualTime > 0)
            ? timesheet!.validActualTime
            : (detail?.validActualTime ??
                (record.validHours > 0
                    ? record.validHours
                    : (actualHours > 0 ? (actualHours >= 7 ? 8.0 : actualHours) : 0.0))));
    final rawLate = (timesheet != null && timesheet!.late > 0)
        ? timesheet!.late
        : (record.lateHours > 0 ? record.lateHours : (detail?.lateHours ?? 0.0));
    final rawEarly = (timesheet != null && timesheet!.early > 0)
        ? timesheet!.early
        : (record.earlyHours > 0 ? record.earlyHours : (detail?.earlyHours ?? 0.0));
    final lateHours = rawLate > 0 && rawLate < 5.0 ? (rawLate * 60).roundToDouble() : rawLate;
    final earlyHours = rawEarly > 0 && rawEarly < 5.0 ? (rawEarly * 60).roundToDouble() : rawEarly;
    final leaveHours = timesheet?.leaveTime ?? 0.0;
    final overtimeHours = timesheet?.overtime ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCol(colors, l10n.timesheetCheckIn, checkIn, Icons.login_rounded, colors.pineGreen),
              ),
              Container(width: 1, height: 40, color: colors.border),
              Expanded(
                child: _buildCol(colors, l10n.timesheetCheckOut, checkOut, Icons.logout_rounded, colors.accentAmber),
              ),
            ],
          ),
          12.gapH,
          const Divider(height: 1),
          12.gapH,
          if (actualHours > 0) ...[
            _row(colors, l10n.timesheetActualHours, '${actualHours.toStringAsFixed(1)} giờ'),
            8.gapH,
          ],
          if (validHours > 0 || isRejected) ...[
            _row(
              colors,
              l10n.timesheetValidHours,
              '${validHours.toStringAsFixed(1)} giờ',
              highlight: isRejected ? colors.error : null,
            ),
            if (isRejected || lateHours > 0 || earlyHours > 0 || leaveHours > 0 || overtimeHours > 0) 8.gapH,
          ],
          if (isRejected && (timesheet?.rejectReason?.isNotEmpty ?? false)) ...[
            _row(
              colors,
              l10n.timesheetRejectReason,
              timesheet!.rejectReason!,
              highlight: colors.error,
            ),
            if (lateHours > 0 || earlyHours > 0 || leaveHours > 0 || overtimeHours > 0) 8.gapH,
          ],
          if (lateHours > 0) ...[
            _row(
              colors,
              l10n.timesheetLate,
              '${lateHours.toInt()} phút',
              highlight: colors.accentAmber,
            ),
            if (earlyHours > 0 || leaveHours > 0 || overtimeHours > 0) 8.gapH,
          ],
          if (earlyHours > 0) ...[
            _row(
              colors,
              l10n.timesheetEarly,
              '${earlyHours.toInt()} phút',
              highlight: colors.accentAmber,
            ),
            if (leaveHours > 0 || overtimeHours > 0) 8.gapH,
          ],
          if (leaveHours > 0) ...[
            _row(
              colors,
              l10n.timesheetLeaveHours,
              '${leaveHours.toStringAsFixed(1)}h (${(leaveHours / 8.0).toStringAsFixed(1)} ngày)',
              highlight: const Color(0xFF8B5CF6),
            ),
            if (overtimeHours > 0) 8.gapH,
          ],
          if (overtimeHours > 0)
            _row(
              colors,
              l10n.timesheetOvertimeHours,
              '+${overtimeHours.toStringAsFixed(1)}h',
              highlight: colors.accentAmber,
            ),
        ],
      ),
    );
  }

  Widget _buildCol(AppColorsExtension colors, String label, String time, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            5.gapW,
            Text(label, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
          ],
        ),
        4.gapH,
        Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary)),
      ],
    );
  }

  Widget _row(AppColorsExtension colors, String title, String val, {Color? highlight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
        Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: highlight ?? colors.textPrimary)),
      ],
    );
  }
}
