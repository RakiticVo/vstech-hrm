import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_balance_bottom_row.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_ring_progress_painter.dart';

/// Primary "Balance" Card showing worked hours today, progress ring,
/// in/out times, and primary Amber check-in CTA button.
/// Includes live real-time Timer ticking when employee is clocked in.
class HomeBalanceCard extends StatefulWidget {
  const new({
    this.todayAttendance,
    this.workedHours,
    this.shiftName,
    this.workedPercentage,
    this.checkInTime,
    this.checkOutTime,
    this.isShiftComplete,
    this.onPunchPressed,
    super.key,
  });

  final AttendanceTodayEntity? todayAttendance;
  final String? workedHours;
  final String? shiftName;
  final double? workedPercentage;
  final String? checkInTime;
  final String? checkOutTime;
  final bool? isShiftComplete;
  final VoidCallback? onPunchPressed;

  @override
  State<HomeBalanceCard> createState() => _HomeBalanceCardState();
}

class _HomeBalanceCardState extends State<HomeBalanceCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _syncTimer();
  }

  @override
  void didUpdateWidget(HomeBalanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todayAttendance != widget.todayAttendance) {
      _syncTimer();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _syncTimer() {
    final att = widget.todayAttendance;
    final isWorking = att != null && att.hasCheckedIn && !att.hasCheckedOut;
    if (isWorking) {
      _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  DateTime? _parseTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
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

  Duration _calculateWorkedDuration() {
    final att = widget.todayAttendance;
    if (att == null || !att.hasCheckedIn || att.checkInTime == null) return Duration.zero;
    final inTime = _parseTime(att.checkInTime);
    if (inTime == null) return Duration.zero;
    final now = DateTime.now();
    final endTime = (att.hasCheckedOut && att.checkOutTime != null)
        ? (_parseTime(att.checkOutTime) ?? now)
        : now;
    var diff = endTime.difference(inTime);
    if (diff.isNegative && diff.inHours.abs() >= 5) {
      diff = endTime.difference(inTime.subtract(const Duration(hours: 7)));
    }
    return diff.isNegative ? Duration.zero : diff;
  }

  String _computedWorkedHours() {
    if (widget.workedHours != null) return widget.workedHours!;
    final att = widget.todayAttendance;
    if (att == null || !att.hasCheckedIn || att.checkInTime == null) {
      return '0h 00m';
    }

    final diff = _calculateWorkedDuration();
    final hours = diff.inHours;
    final mins = diff.inMinutes.remainder(60);
    final secs = diff.inSeconds.remainder(60);

    if (att.hasCheckedIn && !att.hasCheckedOut) {
      return '${hours}h ${mins.toString().padLeft(2, '0')}m ${secs.toString().padLeft(2, '0')}s';
    }
    return '${hours}h ${mins.toString().padLeft(2, '0')}m';
  }

  double _computedPercentage() {
    if (widget.workedPercentage != null) return widget.workedPercentage!;
    final diff = _calculateWorkedDuration();
    return (diff.inSeconds / (8.0 * 3600.0)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final displayHours = _computedWorkedHours();
    final displayPercentage = _computedPercentage();
    final displayCheckIn = widget.checkInTime ?? widget.todayAttendance?.checkInTime ?? '--:--';
    final displayCheckOut = widget.checkOutTime ?? widget.todayAttendance?.checkOutTime ?? '--:--';
    final displayShiftComplete = widget.isShiftComplete ?? widget.todayAttendance?.hasCheckedOut ?? false;
    final shiftStart = widget.todayAttendance?.shiftStart ?? '';
    final shiftEnd = widget.todayAttendance?.shiftEnd ?? '';
    final shiftHours = (shiftStart.isNotEmpty && shiftEnd.isNotEmpty) ? '$shiftStart - $shiftEnd' : null;
    final rawShift = widget.shiftName ?? widget.todayAttendance?.shiftName ?? l10n.todayShiftDefault;

    final cardPadding = context.custom(compact: 14, normal: 18, expanded: 22);
    final ringSize = context.custom(compact: 68, normal: 80, expanded: 88);
    final hoursFontSize = context.custom(compact: 28, normal: 34, expanded: 38);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(cardPadding.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.todayWorkedHours,
                      style: AppTextStyles.labelMicro(color: colors.textSecondary).copyWith(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    5.gapH,
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        displayHours,
                        style: TextStyle(
                          fontSize: hoursFontSize.toDouble(),
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.2,
                          height: 1,
                          color: colors.textPrimary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    7.gapH,
                    InkWell(
                      onTap: () => context.push(AppRoutes.shiftSchedule),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.tealPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.tealPrimary.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.badge_outlined, size: 14, color: colors.tealPrimary),
                            5.gapW,
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rawShift,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall(color: colors.tealPrimary).copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (shiftHours != null)
                                    Text(
                                      shiftHours,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySmall(
                                        color: colors.tealPrimary.withValues(alpha: 0.85),
                                      ).copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            2.gapW,
                            AppIcon(AppIcons.chevronRight, size: 14, color: colors.tealPrimary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              14.gapW,
              SizedBox(
                width: ringSize.toDouble(),
                height: ringSize.toDouble(),
                child: CustomPaint(
                  painter: HomeRingProgressPainter(
                    percentage: displayPercentage,
                    trackColor: colors.cardSecondary,
                    progressColor: colors.accentAmber,
                    strokeWidth: context.custom(compact: 7.5, normal: 9, expanded: 10),
                  ),
                  child: Center(
                    child: Text(
                      '${(displayPercentage * 100).round()}%',
                      style: TextStyle(
                        fontSize: context.custom(compact: 13, normal: 15, expanded: 16).toDouble(),
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          14.gapH,
          Divider(height: 1, color: colors.border),
          14.gapH,
          HomeBalanceBottomRow(
            checkInTime: displayCheckIn,
            checkOutTime: displayCheckOut,
            isShiftComplete: displayShiftComplete,
            onPunchPressed: widget.onPunchPressed,
          ),
        ],
      ),
    );
  }
}
