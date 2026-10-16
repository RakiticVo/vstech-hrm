import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_account_timesheet_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_attendance_history_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/daily_attendance_detail_sheet.dart';

/// Daily attendance logs list and holidays link connected to live attendance history API.
class AttendanceDailyLogCard extends StatefulWidget {
  const new({super.key});

  @override
  State<AttendanceDailyLogCard> createState() => _AttendanceDailyLogCardState();
}

class _AttendanceDailyLogCardState extends State<AttendanceDailyLogCard> {
  List<AttendanceRecordEntity> _records = [];
  Map<int, AccountTimesheetEntity> _timesheetMap = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadHistory());
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final result = await sl<GetAttendanceHistoryUseCase>()();

    var timesheets = <AccountTimesheetEntity>[];
    if (sl.isRegistered<GetAccountTimesheetUseCase>()) {
      final now = DateTime.now();
      final monthStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
      final tsResult = await sl<GetAccountTimesheetUseCase>()(monthYear: monthStr);
      tsResult.fold((_) {}, (items) => timesheets = items);
    }

    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (data) {
        final tsMap = <int, AccountTimesheetEntity>{};
        for (final ts in timesheets) {
          tsMap[ts.workDate.day] = ts;
        }

        final mapped = data.map((rec) {
          final ts = tsMap[rec.timestamp.day];
          if (ts != null) {
            final isConf = ts.isConfirmed && !ts.isRejected;
            return rec.copyWith(
              isConfirmed: ts.isConfirmed,
              validHours: isConf ? ts.validActualTime : 0.0,
              actualHours: rec.actualHours > 0 ? rec.actualHours : ts.actualWorkTime,
              lateHours: rec.lateHours > 0 ? rec.lateHours : ts.late,
              earlyHours: rec.earlyHours > 0 ? rec.earlyHours : ts.early,
            );
          }
          return rec;
        }).toList();

        setState(() {
          _isLoading = false;
          _records = mapped;
          _timesheetMap = tsMap;
        });
      },
    );
  }

  String _weekdayShort(int weekday) {
    const map = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return weekday >= 1 && weekday <= 7 ? map[weekday] : '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dailyLogSectionTitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        12.gapH,
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border),
          ),
          child: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(child: CircularProgressIndicator()),
                )
              : _records.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      child: Center(
                        child: Text(
                          'Chưa có dữ liệu chấm công',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _records.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        indent: 62,
                        color: colors.border.withValues(alpha: 0.6),
                      ),
                      itemBuilder: (ctx, index) {
                        final rec = _records[index];
                        final dayNum = rec.timestamp.day.toString();
                        final dayOfWeek = _weekdayShort(rec.timestamp.weekday);
                        final isLate = rec.isLate;
                        final isEarly = rec.isEarly;
                        final statusColor = (isLate || isEarly) ? colors.accentAmber : colors.pineGreen;
                        final statusText = isLate
                            ? (rec.lateHours > 0 ? 'Đi muộn ${rec.lateHours.toInt()} phút' : 'Đi muộn')
                            : isEarly
                                ? (rec.earlyHours > 0 ? 'Về sớm ${rec.earlyHours.toInt()} phút' : 'Về sớm')
                                : 'Đúng giờ';
                        final timeStr = DateFormat('HH:mm').format(rec.timestamp);
                        final prefix = rec.type.isCheckOut ? 'Ra: ' : 'Vào: ';
                        final confirmStatus = rec.isConfirmed ? 'Đã xác nhận' : 'Chờ xác nhận';
                        final workHours = rec.isConfirmed && rec.validHours > 0
                            ? '${rec.validHours.toStringAsFixed(1)}h'
                            : (rec.actualHours > 0 ? '${rec.actualHours.toStringAsFixed(1)}h' : '0.0h');
                        final detailText = '$prefix$timeStr • $workHours • $confirmStatus';

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => DailyAttendanceDetailSheet.show(
                            context,
                            record: rec,
                            timesheet: _timesheetMap[rec.timestamp.day],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayNum,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: statusColor,
                                          height: 1,
                                        ),
                                      ),
                                      2.gapH,
                                      Text(
                                        dayOfWeek,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: statusColor,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                14.gapW,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        statusText,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w800,
                                          color: statusColor,
                                        ),
                                      ),
                                      3.gapH,
                                      Text(
                                        detailText,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: colors.textSecondary.withValues(alpha: 0.6),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
