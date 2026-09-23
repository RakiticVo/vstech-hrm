import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class PayrollBreakdownCard extends StatelessWidget {
  const new({
    required this.isSalaryVisible,
    super.key,
  });

  final bool isSalaryVisible;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          _buildRow(context.l10n.basicSalaryLabel, '22.000.000 ₫', colors.textPrimary, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.lunchAndTransportAllowance, '1.500.000 ₫', colors.textPrimary, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.kpiQuarterBonus(3), '+2.500.000 ₫', colors.pineGreen, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.socialInsuranceDeduction, '-1.760.000 ₫', colors.error, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.personalIncomeTaxDeduction, '-740.000 ₫', colors.error, colors),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String amount, Color color, AppColorsExtension colors) {
    final displayAmount = isSalaryVisible ? amount : '•••••• ₫';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          Text(
            displayAmount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(AppColorsExtension colors) {
    return Divider(height: 1, color: colors.border.withValues(alpha: 0.6));
  }
}
