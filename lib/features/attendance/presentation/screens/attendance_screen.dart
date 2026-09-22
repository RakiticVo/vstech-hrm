import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_daily_log_card.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_month_summary_card.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_offline_queue_banner.dart';

/// Screen 05: Primary Attendance Tab including both Clock-in Punch and Daily Log views.
class AttendanceScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isCheckedIn = false;
  String _inTime = '—';
  String _outTime = '—';

  void _togglePunch() {
    setState(() {
      if (!_isCheckedIn) {
        _isCheckedIn = true;
        _inTime = '07:42';
      } else {
        _outTime = '17:35';
      }
    });
    unawaited(
      context.push(
        AppRoutes.checkInCamera,
        extra: _isCheckedIn ? AttendanceType.checkOut : AttendanceType.checkIn,
      ),
    );
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
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.shiftSchedule),
            icon: Icon(Symbols.schedule, size: 16, color: colors.primaryIndigo),
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
            icon: Icon(Symbols.calendar_today, size: 18, color: colors.primaryIndigo),
          ),
          4.gapW,
        ],
      ),
      body: ListView(
        padding: context.paddingCustom(horizontal: 16, vertical: 12),
        children: [
          // Offline Pending Sync Banner
          const AttendanceOfflineQueueBanner(),

          // Part 1: Main Clock-in Card
          _buildPunchCard(colors),
          14.gapH,

          // 4 Metric Tiles
          _buildMetricTiles(colors),
          20.gapH,

          // Tổng hợp tháng 9 Header & Donut Card
          Text(
            l10n.attendanceMonthSummaryTitle(9),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          10.gapH,
          const AttendanceMonthSummaryCard(),
          24.gapH,

          // Part 2: Nhật ký từng ngày & link Ngày lễ
          const AttendanceDailyLogCard(),
          20.gapH,

          // Outlined CTA: Gửi yêu cầu sửa công
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primaryIndigo,
              side: BorderSide(color: colors.primaryIndigo, width: 1.5),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => context.push(AppRoutes.attendanceCorrection),
            icon: const Icon(Symbols.edit, size: 18),
            label: Text(
              l10n.sendCorrectionRequest,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
          ),
          12.gapH,
        ],
      ),
    );
  }

  Widget _buildPunchCard(AppColorsExtension colors) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'Thứ Tư, 16 tháng 9',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textSecondary),
          ),
          4.gapH,
          Text(
            '07:42',
            style: TextStyle(
              fontSize: context.custom(compact: 38, normal: 46, expanded: 50).toDouble(),
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: colors.textPrimary,
            ),
          ),
          6.gapH,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _isCheckedIn
                  ? colors.pineGreen.withValues(alpha: 0.12)
                  : colors.accentAmber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _isCheckedIn ? colors.pineGreen : colors.accentAmber,
                    shape: BoxShape.circle,
                  ),
                ),
                6.gapW,
                Text(
                  _isCheckedIn ? l10n.statusCheckedIn : l10n.statusNotCheckedIn,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _isCheckedIn ? colors.pineGreen : const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
          ),
          12.gapH,
          Text(
            l10n.shiftPromptArrive,
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          18.gapH,
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: const Color(0xFF1C1408),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _togglePunch,
              icon: const Icon(Symbols.power_settings_new, size: 22),
              label: Text(
                _isCheckedIn ? l10n.clockOutCta : l10n.clockInCta,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
          12.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.location_on, size: 15, color: colors.textTertiary),
              4.gapW,
              Text(
                l10n.hcmOfficeVerified,
                style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTiles(AppColorsExtension colors) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTile(l10n.timeIn, _inTime, colors.textPrimary, colors),
              10.gapH,
              _buildTile(l10n.lateMinutes, l10n.zeroMinutes, colors.pineGreen, colors),
            ],
          ),
        ),
        10.gapW,
        Expanded(
          child: Column(
            children: [
              _buildTile(l10n.timeOut, _outTime, colors.textPrimary, colors),
              10.gapH,
              _buildTile(l10n.overtimeLabel, '—', colors.textSecondary, colors),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String label, String value, Color valueColor, AppColorsExtension colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.5, color: colors.textSecondary)),
          4.gapH,
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: valueColor),
          ),
        ],
      ),
    );
  }
}
