import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_daily_log_card.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_metric_tiles.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_month_summary_card.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_offline_queue_banner.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_punch_card.dart';

/// Screen 05: Primary Attendance Tab including Clock-in Punch and Daily Log views.
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isCheckedIn = false;
  bool _hasCheckedOut = false;
  String _inTime = '—';
  String _outTime = '—';
  String? _lateMinutesText;

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
        if (today.classification == AttendanceClassification.late) {
          _lateMinutesText = context.l10n.statusLateMinutes('15');
        } else {
          _lateMinutesText = context.l10n.zeroMinutes;
        }
      });
    });
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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text(
          l10n.attendance,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.offlineQueueTitle,
            onPressed: () => context.push(AppRoutes.offlineQueue),
            icon: AppIcon(AppIcons.sync, size: 20, color: colors.amberGold),
          ),
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.shiftSchedule),
            icon: AppIcon(AppIcons.shift, size: 16, color: colors.primaryIndigo),
            label: Text(
              l10n.shiftScheduleNav,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.primaryIndigo,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.workCalendarTooltip,
            onPressed: () => context.push(AppRoutes.calendar),
            icon: AppIcon(AppIcons.calendar, size: 18, color: colors.primaryIndigo),
          ),
          4.gapW,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAttendanceData,
        child: ListView(
          padding: context.paddingCustom(horizontal: 16, vertical: 12),
          children: [
            // Offline Pending Sync Banner
            const AttendanceOfflineQueueBanner(),

            // Part 1: Main Clock-in Card
            AttendancePunchCard(
              isCheckedIn: _isCheckedIn && !_hasCheckedOut,
              onPunchPressed: _togglePunch,
            ),
            14.gapH,

            // 4 Metric Tiles
            AttendanceMetricTiles(
              inTime: _inTime,
              outTime: _outTime,
              lateMinutesText: _lateMinutesText,
            ),
            20.gapH,

            // Monthly Summary Header & Donut Card
            Text(
              l10n.attendanceMonthSummaryTitle(DateTime.now().month),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            10.gapH,
            AttendanceMonthSummaryCard(
              present: _isCheckedIn ? 1 : 0,
            ),
            24.gapH,

            // Part 2: Daily Logs & link to Holidays
            const AttendanceDailyLogCard(),
            20.gapH,
            12.gapH,
          ],
        ),
      ),
    );
  }
}
