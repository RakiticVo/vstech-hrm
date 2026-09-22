import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 14: Detailed Electronic Payslip (Phiếu Lương).
class PayslipDetailScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final incomes = [
      (context.l10n.basicSalaryLabel, '20.000.000 ₫'),
      (context.l10n.lunchAndTransportAllowance, '1.200.000 ₫'),
      (context.l10n.overtimePayLabel, '1.800.000 ₫'),
      (context.l10n.kpiQuarterBonus(3), '2.500.000 ₫'),
    ];

    final deductions = [
      (context.l10n.socialInsuranceDeduction, '-2.135.000 ₫'),
      (context.l10n.personalIncomeTaxDeduction, '-865.000 ₫'),
      (context.l10n.unionFeeDeduction, '-0 ₫'),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.payslipTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Symbols.download, color: colors.primaryIndigo),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.downloadingPdfSnackbar)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Employee Header Card
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.primaryIndigo,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'MT',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFF8EC),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nguyễn Minh Tuấn',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NV-04821 · Vận hành',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                14.gapH,
                Divider(height: 1, color: colors.border),
                12.gapH,
                Text(
                  context.l10n.payslipNetSalaryMonth('9', '2026'),
                  style: TextStyle(fontSize: 11.5, color: colors.textSecondary, fontWeight: FontWeight.w600),
                ),
                4.gapH,
                Text(
                  '25.500.000 ₫',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: colors.pineGreen,
                    letterSpacing: -0.5,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          20.gapH,

          // Thu nhập
          Text(
            context.l10n.incomeSectionTitle,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
          10.gapH,
          _buildItemCard(incomes, colors.textPrimary, colors),
          20.gapH,

          // Khoản trừ
          Text(
            context.l10n.deductionSectionTitle,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
          10.gapH,
          _buildItemCard(deductions, colors.error, colors),
          20.gapH,

          // Lương thực nhận Footer Card
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.pineGreen.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.netSalaryLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  '25.500.000 ₫',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colors.pineGreen,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(List<(String, String)> items, Color valueColor, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[i].$1,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    items[i].$2,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: valueColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            if (i < items.length - 1)
              Divider(height: 1, color: colors.border.withValues(alpha: 0.6)),
          ],
        ],
      ),
    );
  }
}
