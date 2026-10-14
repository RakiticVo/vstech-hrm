import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_account_timesheet_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_daily_log_card.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_metric_tiles.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_punch_card.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_my_shift_schedule_usecase.dart';

/// Screen 05: Primary Attendance Tab including Clock-in Punch and Daily Log views.
class AttendanceScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isCheckedIn = false;
  bool _hasCheckedOut = false;
  String _inTime = '—';
  String _outTime = '—';
  String? _lateMinutesText;
  String? _overtimeText;
  String? _shiftName;
  String? _shiftTime;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAttendanceData());
  }

  Future<void> _loadAttendanceData() async {
    final res = await sl<GetTodayAttendanceUseCase>()();
    if (!mounted) return;
    res.fold((_) {}, (today) {
      setState(() {
        _isCheckedIn = today.hasCheckedIn;
        _hasCheckedOut = today.hasCheckedOut;
        _inTime = today.checkInTime ?? '—';
        _outTime = today.checkOutTime ?? '—';
        if (today.shiftName?.isNotEmpty == true) {
          _shiftName = today.shiftName;
          if (today.shiftStart?.isNotEmpty == true && today.shiftEnd?.isNotEmpty == true) {
            _shiftTime = '${today.shiftStart} - ${today.shiftEnd}';
          }
        }
        if (today.lateMinutes > 0) {
          _lateMinutesText = context.l10n.statusLateMinutes(today.lateMinutes.toString());
        } else if (today.classification == AttendanceClassification.late) {
          _lateMinutesText = context.l10n.statusLateMinutes('15');
        } else {
          _lateMinutesText = context.l10n.zeroMinutes;
        }
      });
    });

    if (sl.isRegistered<GetMyShiftScheduleUseCase>()) {
      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final myShiftRes = await sl<GetMyShiftScheduleUseCase>()(from: todayStr, to: todayStr);
      if (!mounted) return;
      myShiftRes.fold((_) {}, (shifts) {
        final todayShift = shifts.firstOrNull;
        if (todayShift != null && mounted) {
          setState(() {
            if (todayShift.hasShift) {
              _shiftName = todayShift.shiftName?.isNotEmpty == true ? todayShift.shiftName! : 'Ca ${todayShift.shiftCode}';
              final sStart = todayShift.startHour?.isNotEmpty == true ? todayShift.startHour! : '08:00';
              final sEnd = todayShift.endHour?.isNotEmpty == true ? todayShift.endHour! : '17:00';
              _shiftTime = '$sStart - $sEnd';
            } else {
              _shiftName = context.l10n.noShiftAssigned;
              _shiftTime = null;
            }
          });
        }
      });
    }

    if (sl.isRegistered<GetAccountTimesheetUseCase>()) {
      final now = DateTime.now();
      final monthStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
      final tsRes = await sl<GetAccountTimesheetUseCase>()(monthYear: monthStr);
      if (!mounted) return;
      tsRes.fold((_) {}, (items) {
        final todayItem = items.where((it) =>
            it.workDate.year == now.year &&
            it.workDate.month == now.month &&
            it.workDate.day == now.day).firstOrNull;
        final ot = todayItem?.overtime ?? 0.0;
        if (ot > 0) {
          setState(() {
            _overtimeText = '${ot % 1 == 0 ? ot.toInt() : ot.toStringAsFixed(1)}h';
          });
        }
      });
    }
  }

  Future<void> _togglePunch() async {
    final nextType = (_isCheckedIn && !_hasCheckedOut)
        ? AttendanceType.checkOut
        : AttendanceType.checkIn;
    await context.push<bool>(
      AppRoutes.checkInCamera,
      extra: nextType,
    );
    if (mounted) {
      await _loadAttendanceData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final now = DateTime.now();
    final todayStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: l10n.attendance,
            subtitle: '$todayStr · ${l10n.attendanceMonthSummaryTitle(now.month)}',
            trailing: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => context.push(AppRoutes.calendar),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EC).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppIcon(AppIcons.calendar, size: 14, color: Color(0xFFFFF8EC)),
                    5.gapW,
                    Text(
                      l10n.calendarScreenTitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFFF8EC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadAttendanceData,
              child: ListView(
                padding: context.paddingCustom(horizontal: 16, vertical: 12),
                children: [
            // Part 1: Main Clock-in Card
            AttendancePunchCard(
              isCheckedIn: _isCheckedIn && !_hasCheckedOut,
              hasCheckedOut: _hasCheckedOut,
              checkInTime: _inTime,
              checkOutTime: _outTime,
              shiftName: _shiftName,
              shiftTime: _shiftTime,
              onPunchPressed: _togglePunch,
            ),
            14.gapH,

            // 4 Metric Tiles
            AttendanceMetricTiles(
              inTime: _inTime,
              outTime: _outTime,
              lateMinutesText: _lateMinutesText,
              overtimeText: _overtimeText,
            ),
            20.gapH,

            // Part 2: Daily Logs & link to Holidays
                  const AttendanceDailyLogCard(),
                  20.gapH,
                  12.gapH,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
