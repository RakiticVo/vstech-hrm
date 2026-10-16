import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payslip_entity.dart';

class PayrollBreakdownCard extends StatelessWidget {
  const PayrollBreakdownCard({
    required this.isSalaryVisible,
    this.payslip,
    super.key,
  });

  final bool isSalaryVisible;
  final PayslipEntity? payslip;

  String _formatCurrency(double amount, {bool isDeduction = false}) {
    if (amount == 0) return '0 ₫';
    final formatted = NumberFormat('#,###', 'vi_VN').format(amount);
    return isDeduction ? '-$formatted ₫' : '$formatted ₫';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final baseSalary = payslip?.actualBaseSalary ?? 0;
    final allowance = (payslip?.actualLunchFee ?? 0) + (payslip?.actualAllowance ?? 0);
    final kpi = payslip?.actualKpiSalary ?? 0;
    final insurance = payslip?.subtractionFund ?? 0;
    final tax = payslip?.taxAddition ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          _buildRow(context.l10n.basicSalaryLabel, _formatCurrency(baseSalary), colors.textPrimary, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.lunchAndTransportAllowance, _formatCurrency(allowance), colors.textPrimary, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.kpiQuarterBonus(3), _formatCurrency(kpi), colors.pineGreen, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.socialInsuranceDeduction, _formatCurrency(insurance, isDeduction: insurance > 0), colors.error, colors),
          _buildDivider(colors),
          _buildRow(context.l10n.personalIncomeTaxDeduction, _formatCurrency(tax, isDeduction: tax > 0), colors.error, colors),
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
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
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
