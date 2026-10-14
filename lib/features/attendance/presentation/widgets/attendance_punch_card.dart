import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Clock-in / Clock-out interactive card on the Attendance Screen.
/// Prominently displays live ticking worked hours as the primary hero element
/// when the employee is on shift, keeping check-in and clock times as context.
class AttendancePunchCard extends StatefulWidget {
  const new({
    required this.isCheckedIn,
    required this.onPunchPressed,
    this.hasCheckedOut = false,
    this.displayTime,
    this.checkInTime,
    this.checkOutTime,
    this.shiftName,
    this.shiftTime,
    super.key,
  });

  final bool isCheckedIn;
  final bool hasCheckedOut;
  final VoidCallback onPunchPressed;
  final String? displayTime;
  final String? checkInTime;
  final String? checkOutTime;
  final String? shiftName;
  final String? shiftTime;

  @override
  State<AttendancePunchCard> createState() => _AttendancePunchCardState();
}

class _AttendancePunchCardState extends State<AttendancePunchCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(AttendancePunchCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCheckedIn != widget.isCheckedIn ||
        oldWidget.hasCheckedOut != widget.hasCheckedOut ||
        oldWidget.checkInTime != widget.checkInTime) {
      _startTimerIfNeeded();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerIfNeeded() {
    if (widget.isCheckedIn) {
      _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  DateTime? _parseTime(String? raw) {
    if (raw == null || raw.isEmpty || raw == '—' || raw == '--:--') return null;
    final trimmed = raw.trim();
    final now = DateTime.now();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return DateTime(now.year, now.month, now.day, iso.hour, iso.minute, iso.second);
    final parts = (trimmed.contains('T') ? trimmed.split('T')[1] : trimmed).split(':');
    if (parts.length >= 2) {
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final s = parts.length > 2 ? (int.tryParse(parts[2].split('.')[0]) ?? 0) : 0;
      if (h != null && m != null) return DateTime(now.year, now.month, now.day, h, m, s);
    }
    return null;
  }

  Duration _calculateDuration() {
    final parsedIn = _parseTime(widget.checkInTime);
    if (parsedIn == null) return Duration.zero;
    final now = DateTime.now();
    final endTime = (widget.hasCheckedOut && widget.checkOutTime != null)
        ? (_parseTime(widget.checkOutTime) ?? now)
        : now;
    var diff = endTime.difference(parsedIn);
    if (diff.isNegative && diff.inHours.abs() >= 5) {
      diff = endTime.difference(parsedIn.subtract(const Duration(hours: 7)));
    }
    return diff.isNegative ? Duration.zero : diff;
  }

  String _formatHeroTime(String timeStr) {
    if (widget.isCheckedIn) {
      final diff = _calculateDuration();
      final m = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '${diff.inHours}h ${m}m ${s}s';
    }
    if (widget.hasCheckedOut) {
      final diff = _calculateDuration();
      final m = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
      return '${diff.inHours}h ${m}m';
    }
    return timeStr;
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    const weekdays = ['', 'Hai', 'Ba', 'Tư', 'Năm', 'Sáu', 'Bảy', 'Chủ Nhật'];
    final weekdayName = weekdays[now.weekday];
    return 'Thứ $weekdayName, ${now.day} tháng ${now.month}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final timeStr = widget.displayTime ?? DateFormat('HH:mm').format(DateTime.now());
    final heroDisplay = _formatHeroTime(timeStr);

    final heroLabel = widget.isCheckedIn ? l10n.todayWorkedHours : (widget.hasCheckedOut ? 'TỔNG GIỜ LÀM HÔM NAY' : 'GIỜ HIỆN TẠI');
    final badgeColor = widget.isCheckedIn ? colors.pineGreen : (widget.hasCheckedOut ? colors.primaryIndigo : colors.accentAmber);
    final badgeText = widget.isCheckedIn
        ? '${l10n.statusWorking} · Vào: ${widget.checkInTime ?? '--:--'}'
        : (widget.hasCheckedOut
            ? 'Đã hoàn thành ca · ${widget.checkInTime ?? '--:--'} - ${widget.checkOutTime ?? '--:--'}'
            : l10n.statusNotCheckedIn);
    final isWorking = widget.isCheckedIn && !widget.hasCheckedOut;
    final ctaText = isWorking ? l10n.clockOutCta : l10n.clockInCta;
    final ctaBgColor = isWorking ? const Color(0xFFF59E0B) : const Color(0xFF0F766E);
    final ctaFgColor = isWorking ? const Color(0xFF1C1408) : const Color(0xFFFFF8EC);

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
            _formatCurrentDate(),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textSecondary),
          ),
          6.gapH,
          InkWell(
            onTap: () => context.push(AppRoutes.shiftSchedule),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: colors.tealPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.tealPrimary.withValues(alpha: 0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.badge_outlined, size: 14, color: colors.tealPrimary),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.shiftName ?? l10n.todayShiftDefault,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.tealPrimary),
                        ),
                        if (widget.shiftTime != null)
                          Text(
                            widget.shiftTime!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colors.tealPrimary.withValues(alpha: 0.85),
                            ),
                          ),
                      ],
                    ),
                  ),
                  4.gapW,
                  AppIcon(AppIcons.chevronRight, size: 13, color: colors.tealPrimary),
                ],
              ),
            ),
          ),
          8.gapH,

          // Primary Focus: Hero Header Label
          Text(
            heroLabel,
            style: AppTextStyles.labelMicro(color: colors.textSecondary).copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          4.gapH,

          // Main Hero Display: Live Worked Hours Counter (or Current Clock if not clocked in)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              heroDisplay,
              style: TextStyle(
                fontSize: context.custom(compact: 38, normal: 46, expanded: 50).toDouble(),
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                color: widget.isCheckedIn ? colors.pineGreen : colors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          8.gapH,

          // Status & Check-in Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                6.gapW,
                Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
          ),
          8.gapH,

          // Current clock reference info
          Text(
            widget.isCheckedIn
                ? 'Đồng hồ hệ thống: $timeStr'
                : (widget.hasCheckedOut ? 'Ca đã kết thúc thành công' : l10n.shiftPromptArrive),
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          16.gapH,

          // Action CTA button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ctaBgColor,
                foregroundColor: ctaFgColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: widget.onPunchPressed,
              icon: AppIcon(AppIcons.faceScan, size: 22, color: ctaFgColor),
              label: Text(
                ctaText,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
