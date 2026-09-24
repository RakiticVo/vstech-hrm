import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

class RiskTierSummaryPills extends StatelessWidget {
  const new({
    required this.criticalCount,
    required this.highCount,
    required this.mediumCount,
    super.key,
  });

  final int criticalCount;
  final int highCount;
  final int mediumCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Row(
        children: [
          Expanded(
            child: _TierCard(
              count: criticalCount,
              label: l10n.riskTierCritical.toUpperCase(),
              textColor: const Color(0xFFDC2626),
              backgroundColor: const Color(0xFFFEF2F2),
              borderColor: const Color(0xFFFECACA),
            ),
          ),
          AppGap.w8,
          Expanded(
            child: _TierCard(
              count: highCount,
              label: l10n.riskTierHigh.toUpperCase(),
              textColor: const Color(0xFFD97706),
              backgroundColor: const Color(0xFFFFFBEB),
              borderColor: const Color(0xFFFDE68A),
            ),
          ),
          AppGap.w8,
          Expanded(
            child: _TierCard(
              count: mediumCount,
              label: l10n.riskTierMedium.toUpperCase(),
              textColor: colors.primary,
              backgroundColor: colors.surfaceContainer,
              borderColor: colors.borderSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const new({
    required this.count,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final int count;
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(10),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count.toString(),
            style: AppTextStyles.h2.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              height: 1.1,
            ),
          ),
          AppGap.h4,
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
