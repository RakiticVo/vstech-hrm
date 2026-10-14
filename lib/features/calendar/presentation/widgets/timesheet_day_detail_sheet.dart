import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/timesheet_day_slips_card.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

class TimesheetDayDetailSheet extends StatelessWidget {
  const TimesheetDayDetailSheet({
    required this.date,
    this.timesheet,
    this.leaves = const [],
    this.overtimes = const [],
    this.corrections = const [],
    super.key,
  });

  final DateTime date;
  final AccountTimesheetEntity? timesheet;
  final List<LeaveItemEntity> leaves;
  final List<OvertimeItemEntity> overtimes;
  final List<CorrectionItemEntity> corrections;

  static void show(
    BuildContext context, {
    required DateTime date,
    AccountTimesheetEntity? timesheet,
    List<LeaveItemEntity> leaves = const [],
    List<OvertimeItemEntity> overtimes = const [],
    List<CorrectionItemEntity> corrections = const [],
  }) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => TimesheetDayDetailSheet(
          date: date,
          timesheet: timesheet,
          leaves: leaves,
          overtimes: overtimes,
          corrections: corrections,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dateFormatted = DateFormat('dd/MM/yyyy').format(date);
    final isConfirmed = timesheet?.isConfirmed ?? false;
    final isRejected = timesheet?.isRejected ?? false;
    final lateMinutes = timesheet?.late ?? 0.0;
    final earlyMinutes = timesheet?.early ?? 0.0;
    final isLateWarning = timesheet?.lateWarning ?? (lateMinutes > 0);
    final isEarlyWarning = timesheet?.earlyWarning ?? (earlyMinutes > 0);
    final normLate = lateMinutes > 0 && lateMinutes < 5.0 ? (lateMinutes * 60).roundToDouble() : lateMinutes;
    final normEarly = earlyMinutes > 0 && earlyMinutes < 5.0 ? (earlyMinutes * 60).roundToDouble() : earlyMinutes;
    final leaveHours = timesheet?.leaveTime ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          16.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.timesheetDetailTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isRejected
                      ? colors.error.withValues(alpha: 0.15)
                      : (isConfirmed
                          ? colors.pineGreen.withValues(alpha: 0.12)
                          : colors.accentAmber.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
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
              ),
            ],
          ),
          16.gapH,
          _buildRow(colors, l10n.timesheetWorkDate, dateFormatted),
          _buildDivider(colors),
          _buildRow(
            colors,
            l10n.timesheetCheckIn,
            _formatTime(timesheet?.checkinTime),
            highlightColor: colors.pineGreen,
          ),
          _buildDivider(colors),
          _buildRow(
            colors,
            l10n.timesheetCheckOut,
            _formatTime(timesheet?.checkoutTime),
            highlightColor: colors.accentAmber,
          ),
          _buildDivider(colors),
          _buildRow(
            colors,
            l10n.timesheetActualHours,
            '${timesheet?.actualWorkTime.toStringAsFixed(1) ?? '0.0'}h',
          ),
          _buildDivider(colors),
          _buildRow(
            colors,
            l10n.timesheetValidHours,
            '${((isRejected || !isConfirmed) ? 0.0 : (timesheet?.validActualTime ?? 0.0)).toStringAsFixed(1)}h',
            highlightColor: isRejected ? colors.error : colors.primaryIndigo,
          ),
          if (isRejected && (timesheet?.rejectReason?.isNotEmpty ?? false)) ...[
            _buildDivider(colors),
            _buildRow(
              colors,
              l10n.timesheetRejectReason,
              timesheet!.rejectReason!,
              highlightColor: colors.error,
            ),
          ],
          if (isLateWarning || normLate > 0) ...[
            _buildDivider(colors),
            _buildRow(
              colors,
              l10n.timesheetLate,
              normLate > 0 ? '${normLate.toInt()} phút' : 'Có cảnh báo',
              highlightColor: colors.accentAmber,
            ),
          ],
          if (isEarlyWarning || normEarly > 0) ...[
            _buildDivider(colors),
            _buildRow(
              colors,
              l10n.timesheetEarly,
              normEarly > 0 ? '${normEarly.toInt()} phút' : 'Có cảnh báo',
              highlightColor: colors.accentAmber,
            ),
          ],
          if (leaveHours > 0) ...[
            _buildDivider(colors),
            _buildRow(
              colors,
              l10n.timesheetLeaveHours,
              '${leaveHours.toStringAsFixed(1)}h (${(leaveHours / 8.0).toStringAsFixed(1)} ngày)',
              highlightColor: const Color(0xFF8B5CF6),
            ),
          ],
          if ((timesheet?.overtime ?? 0) > 0) ...[
            _buildDivider(colors),
            _buildRow(
              colors,
              l10n.timesheetOvertimeHours,
              '+${timesheet!.overtime.toStringAsFixed(1)}h',
              highlightColor: colors.accentAmber,
            ),
          ],
          if ((timesheet?.lunch ?? 0) > 0) ...[
            _buildDivider(colors),
            _buildRow(
              colors,
              l10n.timesheetLunchLabel,
              timesheet!.lunch.toStringAsFixed(0),
            ),
          ],
          if (timesheet?.note != null && timesheet!.note!.isNotEmpty) ...[
            _buildDivider(colors),
            _buildRow(colors, l10n.timesheetNoteLabel, timesheet!.note!),
          ],
          TimesheetDaySlipsCard(
            date: date,
            leaves: leaves,
            overtimes: overtimes,
            corrections: corrections,
            showSubmitCorrection: (timesheet == null ||
                    timesheet!.isRejected ||
                    timesheet!.validActualTime < 8.0) &&
                date.isBefore(DateTime.now()),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    AppColorsExtension colors,
    String label,
    String value, {
    Color? highlightColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: highlightColor ?? colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty || time == '00:00:00' || time == '00:00' || time == '--:--' || time == '—') {
      return '--:--';
    }
    final trimmed = time.trim();
    if (trimmed.length >= 5 && trimmed.contains(':')) {
      final parts = trimmed.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
    }
    return trimmed;
  }

  Widget _buildDivider(AppColorsExtension colors) {
    return Divider(height: 1, color: colors.border.withValues(alpha: 0.5));
  }
}
