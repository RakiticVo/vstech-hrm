import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_attendance_history_usecase.dart';

/// Daily attendance logs list and holidays link connected to live attendance history API.
class AttendanceDailyLogCard extends StatefulWidget {
  const AttendanceDailyLogCard({super.key});

  @override
  State<AttendanceDailyLogCard> createState() => _AttendanceDailyLogCardState();
}

class _AttendanceDailyLogCardState extends State<AttendanceDailyLogCard> {
  List<AttendanceRecordEntity> _records = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadHistory());
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final result = await sl<GetAttendanceHistoryUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (data) => setState(() {
        _isLoading = false;
        _records = data;
      }),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.dailyLogSectionTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () => context.push(AppRoutes.holidays),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  l10n.holidaysLink,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryIndigo,
                  ),
                ),
              ),
            ),
          ],
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
                        final isLate = rec.classification == AttendanceClassification.late;
                        final statusColor = isLate ? colors.accentAmber : colors.pineGreen;
                        final statusText = isLate ? 'Đi muộn' : 'Đúng giờ';
                        final timeStr = DateFormat('HH:mm').format(rec.timestamp);

                        return Padding(
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
                                      timeStr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
