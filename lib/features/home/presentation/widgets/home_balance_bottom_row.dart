import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// Bottom row of HomeBalanceCard containing Check-in time, Check-out time,
/// and the primary Amber CTA punch button.
class HomeBalanceBottomRow extends StatelessWidget {
  const HomeBalanceBottomRow({
    required this.checkInTime,
    required this.checkOutTime,
    required this.isShiftComplete,
    this.onPunchPressed,
    super.key,
  });

  final String checkInTime;
  final String checkOutTime;
  final bool isShiftComplete;
  final VoidCallback? onPunchPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      children: [
        // In Time
        Expanded(
          flex: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.shiftCheckInLabel,
                style: AppTextStyles.labelMicro(color: colors.textSecondary).copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
          flex: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.shiftCheckOutLabel,
                style: AppTextStyles.labelMicro(color: colors.textSecondary).copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

        // Action CTA Button
        () {
          final isWorking = checkInTime != '--:--' && !isShiftComplete;
          final ctaText = isWorking ? l10n.clockOutCta : l10n.clockInCta;
          final ctaBgColor = isWorking ? const Color(0xFFF59E0B) : const Color(0xFF0F766E);
          final ctaFgColor = isWorking ? const Color(0xFF1C1408) : const Color(0xFFFFF8EC);

          return Expanded(
            flex: 17,
            child: SizedBox(
              height: context.custom(compact: 42, normal: 46, expanded: 50).toDouble(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ctaBgColor,
                  foregroundColor: ctaFgColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onPunchPressed ??
                    () => context.push(
                          AppRoutes.checkInCamera,
                          extra: isWorking
                              ? AttendanceType.checkOut
                              : AttendanceType.checkIn,
                        ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon(AppIcons.faceScan, size: 17, color: ctaFgColor),
                    4.gapW,
                    Flexible(
                      child: Text(
                        ctaText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.custom(compact: 11, normal: 12.5, expanded: 13.5),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }(),
      ],
    );
  }
}
