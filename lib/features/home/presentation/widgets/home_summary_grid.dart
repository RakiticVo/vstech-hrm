import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_attendance_history_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_valid_leave_plans_usecase.dart';

/// 2x2 Summary Metrics Grid (Ngày công, Phép còn, Tăng ca, Muộn/sớm)
/// Connects to real API endpoints for leave, overtime, and attendance metrics.
class HomeSummaryGrid extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeSummaryGrid> createState() => _HomeSummaryGridState();
}

class _HomeSummaryGridState extends State<HomeSummaryGrid> {
  String _workedDays = '0';
  final String _standardDays = '22';
  String _leaveLeft = '12';
  String _overtimeHours = '0';
  String _lateEarlyCount = '0 / 0';

  @override
  void initState() {
    super.initState();
    unawaited(_loadMetrics());
  }

  Future<void> _loadMetrics() async {
    final now = DateTime.now();
    final monthPrefix = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    var workedDays = 0;
    var lateCount = 0;
    var earlyCount = 0;

    // 1. Timesheet API summary
    if (sl.isRegistered<AttendanceRemoteDataSource>()) {
      final summary = await sl<AttendanceRemoteDataSource>().getTimesheetSummary(month: now);
      workedDays = summary['present'] ?? 0;
    }

    // 2. Attendance history for current month (unique days & late/early)
    if (sl.isRegistered<GetAttendanceHistoryUseCase>()) {
      final histRes = await sl<GetAttendanceHistoryUseCase>()();
      histRes.fold((_) {}, (records) {
        final currentMonthRecords = records.where((r) =>
            r.timestamp.month == now.month && r.timestamp.year == now.year);
        final uniqueDays = currentMonthRecords
            .map((r) => '${r.timestamp.year}-${r.timestamp.month}-${r.timestamp.day}')
            .toSet()
            .length;
        if (uniqueDays > workedDays) workedDays = uniqueDays;
        for (final r in currentMonthRecords) {
          if (r.classification == AttendanceClassification.late) {
            lateCount++;
          } else if (r.classification == AttendanceClassification.earlyLeave) {
            earlyCount++;
          }
        }
      });
    }

    // 3. Overtime total hours for current month
    if (sl.isRegistered<GetOvertimeRequestsUseCase>()) {
      final otResult = await sl<GetOvertimeRequestsUseCase>()();
      otResult.fold((_) {}, (list) {
        double totalOt = 0;
        for (final item in list) {
          final isCurMonth = item.date == null || item.date!.startsWith(monthPrefix);
          if (isCurMonth && (item.status == 1 || item.status == 0)) {
            totalOt += item.length ?? 0;
          }
        }
        setState(() => _overtimeHours = totalOt % 1 == 0 ? totalOt.toInt().toString() : totalOt.toStringAsFixed(1));
      });
    }

    // 4. Annual Leave Balance (Phép năm còn lại) via valid-leave-plan2
    var leaveLoaded = false;
    if (sl.isRegistered<GetValidLeavePlansUseCase>()) {
      final ymd = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final planResult = await sl<GetValidLeavePlansUseCase>()(execDate: ymd);
      planResult.fold((_) {}, (plans) {
        if (plans.isNotEmpty) {
          final annualPlan = plans.where((p) =>
              p.leaveCode.toUpperCase() == 'PN' ||
              p.leaveName.toLowerCase().contains('phép năm') ||
              p.leaveName.toLowerCase().contains('hàng năm')).firstOrNull ?? plans.first;
          final amt = annualPlan.amount;
          if (mounted) {
            setState(() {
              _leaveLeft = amt % 1 == 0 ? amt.toInt().toString() : amt.toStringAsFixed(1);
            });
            leaveLoaded = true;
          }
        }
      });
    }

    if (!leaveLoaded && sl.isRegistered<GetLeaveRequestsUseCase>()) {
      final leaveResult = await sl<GetLeaveRequestsUseCase>()();
      leaveResult.fold((_) {}, (list) {
        double usedLeaves = 0;
        for (final item in list) {
          if (item.status == 1) {
            usedLeaves += item.halfShiftType != null ? 0.5 : 1.0;
          }
        }
        final remaining = (12.0 - usedLeaves).clamp(0.0, 12.0);
        if (mounted) {
          setState(() => _leaveLeft = remaining % 1 == 0 ? remaining.toInt().toString() : remaining.toStringAsFixed(1));
        }
      });
    }

    // 5. Fallback today check-in
    final attResult = await sl<GetTodayAttendanceUseCase>()();
    attResult.fold((_) {}, (today) {
      if (today.hasCheckedIn && workedDays == 0) workedDays = 1;
      if (today.classification == AttendanceClassification.late && lateCount == 0) lateCount = 1;
    });

    if (mounted) {
      setState(() {
        _workedDays = workedDays.toString();
        _lateEarlyCount = '$lateCount / $earlyCount';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricWorkdays.toUpperCase(),
                mainValue: _workedDays,
                subValue: ' / $_standardDays',
                colors: colors,
              ),
            ),
            10.gapW,
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricLeaveBalance.toUpperCase(),
                mainValue: _leaveLeft,
                subValue: ' ${l10n.daysUnit}',
                colors: colors,
                mainColor: colors.tealPrimary,
              ),
            ),
          ],
        ),
        10.gapH,
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricOvertime.toUpperCase(),
                mainValue: _overtimeHours,
                subValue: l10n.hoursUnit,
                colors: colors,
              ),
            ),
            10.gapW,
            Expanded(
              child: _buildCard(
                context: context,
                label: l10n.metricLateEarly.toUpperCase(),
                mainValue: _lateEarlyCount,
                subValue: '',
                colors: colors,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String label,
    required String mainValue,
    required String subValue,
    required AppColorsExtension colors,
    Color? mainColor,
  }) {
    final horizontalPadding = context.custom(compact: 11, normal: 14, expanded: 16).toDouble();
    final verticalPadding = context.custom(compact: 10, normal: 13, expanded: 15).toDouble();
    final mainFontSize = context.custom(compact: 18, normal: 21, expanded: 24).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.custom(compact: 9.5, normal: 10.5, expanded: 11.5),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: colors.textSecondary,
              ),
            ),
          ),
          4.gapH,
          RichText(
            text: TextSpan(
              text: mainValue,
              style: TextStyle(
                fontSize: mainFontSize,
                fontWeight: FontWeight.w800,
                color: mainColor ?? colors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              children: [
                if (subValue.isNotEmpty)
                  TextSpan(
                    text: subValue,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
