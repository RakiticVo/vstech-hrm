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
/// Follows DESIGN.md §6 & Phone.dc.html lines 112–141.
class HomeBalanceCard extends StatelessWidget {
  const HomeBalanceCard({
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

  String _computedWorkedHours() {
    if (workedHours != null) return workedHours!;
    final att = todayAttendance;
    if (att == null || !att.hasCheckedIn || att.checkInTime == null) {
      return '0h 00m';
    }
    try {
      final parts = att.checkInTime!.split(':');
      if (parts.length >= 2) {
        final now = DateTime.now();
        final inTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
        final endTime = (att.hasCheckedOut && att.checkOutTime != null)
            ? DateTime(now.year, now.month, now.day, int.parse(att.checkOutTime!.split(':')[0]), int.parse(att.checkOutTime!.split(':')[1]))
            : now;
        final diff = endTime.difference(inTime);
        if (!diff.isNegative) {
          final hours = diff.inHours;
          final mins = diff.inMinutes.remainder(60);
          return '${hours}h ${mins.toString().padLeft(2, '0')}m';
        }
      }
    } on Object {
      // Fallback
    }
    return '0h 00m';
  }

  double _computedPercentage() {
    if (workedPercentage != null) return workedPercentage!;
    final att = todayAttendance;
    if (att == null || !att.hasCheckedIn || att.checkInTime == null) {
      return 0;
    }
    try {
      final parts = att.checkInTime!.split(':');
      if (parts.length >= 2) {
        final now = DateTime.now();
        final inTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
        final endTime = (att.hasCheckedOut && att.checkOutTime != null)
            ? DateTime(now.year, now.month, now.day, int.parse(att.checkOutTime!.split(':')[0]), int.parse(att.checkOutTime!.split(':')[1]))
            : now;
        final diff = endTime.difference(inTime);
        final ratio = diff.inMinutes / (8.0 * 60.0);
        return ratio.clamp(0.0, 1.0);
      }
    } on Object {
      // Fallback
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final displayHours = _computedWorkedHours();
    final displayPercentage = _computedPercentage();
    final displayCheckIn = checkInTime ?? todayAttendance?.checkInTime ?? '--:--';
    final displayCheckOut = checkOutTime ?? todayAttendance?.checkOutTime ?? '--:--';
    final displayShiftComplete = isShiftComplete ?? todayAttendance?.hasCheckedOut ?? false;
    final displayShiftName = shiftName ?? todayAttendance?.shiftName ?? l10n.todayShiftDefault;

    final cardPadding = context.custom(compact: 14, normal: 18, expanded: 22);
    final ringSize = context.custom(compact: 68, normal: 80, expanded: 88);
    final hoursFontSize = context.custom(compact: 32, normal: 38, expanded: 42);

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
          // Top section: Left metrics + Right progress ring
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
                    Text(
                      displayHours,
                      style: TextStyle(
                        fontSize: hoursFontSize.toDouble(),
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.6,
                        height: 1,
                        color: colors.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    5.gapH,
                    InkWell(
                      onTap: () => context.push(AppRoutes.shiftSchedule),
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              displayShiftName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall(color: colors.tealPrimary).copyWith(
                                fontWeight: FontWeight.w700,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                          4.gapW,
                          AppIcon(AppIcons.chevronRight, size: 16, color: colors.tealPrimary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              14.gapW,
              // Circular progress ring
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

          // Bottom section: Check-in / Check-out / CTA button
          HomeBalanceBottomRow(
            checkInTime: displayCheckIn,
            checkOutTime: displayCheckOut,
            isShiftComplete: displayShiftComplete,
            onPunchPressed: onPunchPressed,
          ),
        ],
      ),
    );
  }
}
