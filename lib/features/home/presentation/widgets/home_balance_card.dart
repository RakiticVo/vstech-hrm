import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_ring_progress_painter.dart';

/// Primary "Balance" Card showing worked hours today, progress ring,
/// in/out times, and primary Amber check-in CTA button.
/// Follows DESIGN.md §6 & Phone.dc.html lines 112–141.
class HomeBalanceCard extends StatelessWidget {
  const new({
    this.workedHours = '6h 12m',
    this.shiftName,
    this.workedPercentage = 0.69,
    this.checkInTime = '08:24',
    this.checkOutTime = '--:--',
    this.isShiftComplete = false,
    super.key,
  });

  final String workedHours;
  final String? shiftName;
  final double workedPercentage;
  final String checkInTime;
  final String checkOutTime;
  final bool isShiftComplete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    // Responsive dimensions
    final cardPadding = context.custom(compact: 14, normal: 18, expanded: 22);
    final ringSize = context.custom(compact: 68, normal: 80, expanded: 88);
    final hoursFontSize = context.custom(compact: 32, normal: 38, expanded: 42);
    final displayShiftName = shiftName ?? l10n.todayShiftDefault;

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
                      workedHours,
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
                          Text(
                            displayShiftName,
                            style: AppTextStyles.bodySmall(color: colors.textSecondary).copyWith(
                              fontWeight: FontWeight.w700,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                          4.gapW,
                          Icon(Symbols.chevron_right, size: 16, color: colors.textSecondary),
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
                    percentage: workedPercentage,
                    trackColor: colors.cardSecondary,
                    progressColor: colors.accentAmber,
                    strokeWidth: context.custom(compact: 7.5, normal: 9, expanded: 10),
                  ),
                  child: Center(
                    child: Text(
                      '${(workedPercentage * 100).round()}%',
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
          Row(
            children: [
              // In Time
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.shiftCheckInLabel,
                      style: AppTextStyles.labelMicro(color: colors.textSecondary).copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    2.gapH,
                    Text(
                      checkInTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

              // Out Time
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.shiftCheckOutLabel,
                      style: AppTextStyles.labelMicro(color: colors.textSecondary).copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    2.gapH,
                    Text(
                      checkOutTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: checkOutTime == '--:--'
                            ? colors.textTertiary
                            : colors.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

              // Amber CTA Button
              Expanded(
                flex: 15,
                child: SizedBox(
                  height: context.custom(compact: 42, normal: 46, expanded: 50).toDouble(),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentAmber,
                      foregroundColor: const Color(0xFF1C1408),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => context.push(
                      AppRoutes.checkInCamera,
                      extra: isShiftComplete
                          ? AttendanceType.checkOut
                          : AttendanceType.checkIn,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Symbols.face, size: 18, weight: 600),
                        6.gapW,
                        Text(
                          isShiftComplete ? l10n.shiftDoneCta : l10n.shiftCheckOutCta,
                          style: TextStyle(
                            fontSize: context.custom(compact: 11.5, normal: 13, expanded: 14),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
