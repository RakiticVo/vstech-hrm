import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';

class RiskAlertCard extends StatelessWidget {
  const new({
    required this.alert,
    required this.onAssignToHr,
    super.key,
  });

  final RiskAlertEntity alert;
  final VoidCallback onAssignToHr;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final (tierColor, tierLabel) = switch (alert.tier) {
      RiskTier.critical => (
          const Color(0xFFDC2626),
          l10n.riskTierCritical.toUpperCase()
        ),
      RiskTier.high => (
          const Color(0xFFD97706),
          l10n.riskTierHigh.toUpperCase()
        ),
      RiskTier.medium => (
          colors.primary,
          l10n.riskTierMedium.toUpperCase()
        ),
    };

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: colors.borderSubtle),
          right: BorderSide(color: colors.borderSubtle),
          bottom: BorderSide(color: colors.borderSubtle),
          left: BorderSide(color: tierColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.w(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tierLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        fontSize: 10,
                      ),
                    ),
                    AppGap.h4,
                    Text(
                      alert.title,
                      style: AppTextStyles.bodyBold.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              AppGap.w8,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(8),
                  vertical: context.h(4),
                ),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alert.metricValue,
                  style: AppTextStyles.caption.copyWith(
                    color: tierColor,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          AppGap.h8,
          Text(
            alert.description,
            style: AppTextStyles.caption.copyWith(
              color: colors.textSecondary,
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppGap.h12,
          Row(
            children: [
              _MetaChip(
                icon: Icons.location_on_outlined,
                label: alert.branch,
              ),
              AppGap.w8,
              _MetaChip(
                icon: Icons.access_time_rounded,
                label: alert.detectedTimeText,
              ),
            ],
          ),
          AppGap.h12,
          if (alert.isAssignedToHr)
            Container(
              height: context.h(40),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Đã giao việc cho HR xử lý',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            )
          else
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAssignToHr,
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  height: context.h(42),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: tierColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_alt_1_outlined,
                        color: tierColor,
                        size: 16,
                      ),
                      AppGap.w8,
                      Text(
                        l10n.riskAssignHr,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: tierColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(8),
        vertical: context.h(4),
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colors.textSecondary),
          AppGap.w4,
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
