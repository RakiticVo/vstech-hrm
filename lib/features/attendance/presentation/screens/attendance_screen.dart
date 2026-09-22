import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text(
          'Chấm công',
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
              'Lịch ca',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.primaryIndigo,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Lịch công',
            onPressed: () => context.push(AppRoutes.calendar),
            icon: Icon(Symbols.calendar_today, size: 18, color: colors.primaryIndigo),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // Offline Pending Sync Banner
          const AttendanceOfflineQueueBanner(),

          // Part 1: Main Clock-in Card
          _buildPunchCard(colors),
          const SizedBox(height: 14),

          // 4 Metric Tiles
          _buildMetricTiles(colors),
          const SizedBox(height: 20),

          // Tổng hợp tháng 9 Header & Donut Card
          Text(
            'Tổng hợp tháng 9',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const AttendanceMonthSummaryCard(),
          const SizedBox(height: 24),

          // Part 2: Nhật ký từng ngày & link Ngày lễ
          const AttendanceDailyLogCard(),
          const SizedBox(height: 20),

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
            label: const Text(
              'Gửi yêu cầu sửa công',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPunchCard(AppColorsExtension colors) {
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
          const SizedBox(height: 4),
          Text(
            '07:42',
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
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
                const SizedBox(width: 6),
                Text(
                  _isCheckedIn ? 'Đã chấm công vào' : 'Chưa chấm công',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _isCheckedIn ? colors.pineGreen : const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ca của bạn bắt đầu 08:00. Chấm công khi bạn đến.',
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
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
                _isCheckedIn ? 'CHẤM CÔNG RA' : 'CHẤM CÔNG VÀO',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.location_on, size: 15, color: colors.textTertiary),
              const SizedBox(width: 4),
              Text(
                'Văn phòng HCM - đã xác thực vị trí',
                style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTiles(AppColorsExtension colors) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTile('Giờ vào', _inTime, colors.textPrimary, colors),
              const SizedBox(height: 10),
              _buildTile('Đi muộn', '0 phút', colors.pineGreen, colors),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              _buildTile('Giờ ra', _outTime, colors.textPrimary, colors),
              const SizedBox(height: 10),
              _buildTile('Tăng ca', '—', colors.textSecondary, colors),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: valueColor),
          ),
        ],
      ),
    );
  }
}
