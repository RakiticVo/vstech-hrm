import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Clock-in / Clock-out interactive card on the Attendance Screen.
class AttendancePunchCard extends StatelessWidget {
  const AttendancePunchCard({
    required this.isCheckedIn,
    required this.onPunchPressed,
    this.displayTime,
    super.key,
  });

  final bool isCheckedIn;
  final VoidCallback onPunchPressed;
  final String? displayTime;

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
    final timeStr = displayTime ?? DateFormat('HH:mm').format(DateTime.now());

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
          4.gapH,
          Text(
            timeStr,
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
              color: isCheckedIn
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
                    color: isCheckedIn ? colors.pineGreen : colors.accentAmber,
                    shape: BoxShape.circle,
                  ),
                ),
                6.gapW,
                Text(
                  isCheckedIn ? l10n.statusCheckedIn : l10n.statusNotCheckedIn,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isCheckedIn ? colors.pineGreen : const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
          ),
          12.gapH,
          Text(
            isCheckedIn ? l10n.statusWorking : l10n.shiftPromptArrive,
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
              onPressed: onPunchPressed,
              icon: const AppIcon(AppIcons.faceScan, size: 22, color: Color(0xFF1C1408)),
              label: Text(
                isCheckedIn ? l10n.clockOutCta : l10n.clockInCta,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
          12.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(AppIcons.location, size: 15, color: colors.textTertiary),
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
}
