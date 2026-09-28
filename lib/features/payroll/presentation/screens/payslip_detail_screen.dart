import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/secondary_button.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payslip_breakdown_items.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payslip_signed_card.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/signature_pad_modal.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

/// Screen 14: Detailed Electronic Payslip (Phiếu Lương) with Signing & Dispute.
class PayslipDetailScreen extends StatefulWidget {
  const PayslipDetailScreen({super.key});

  @override
  State<PayslipDetailScreen> createState() => _PayslipDetailScreenState();
}

class _PayslipDetailScreenState extends State<PayslipDetailScreen> {
  bool _isSigned = false;
  List<List<Offset>>? _signatureStrokes;
  String _signedAt = '05/10/2026 14:22:08';
  final String _verificationHash = 'SHA256: e7a9c24f8b1d30ac68';

  void _handleOpenSignPad() {
    unawaited(
      SignaturePadModal.show(
        context,
        onConfirmed: (strokes) {
          setState(() {
            _isSigned = true;
            _signatureStrokes = strokes;
            _signedAt = '28/09/2026 10:30:15';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã ký xác nhận phiếu lương thành công!')),
          );
        },
      ),
    );
  }

  void _handleDisputeLine(String itemName, String amountStr) {
    final numeric = int.tryParse(amountStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 1000000;
    unawaited(
      context.push(
        AppRoutes.salaryDisputeNew,
        extra: {
          'item': itemName,
          'amount': numeric,
          'period': '09/2026',
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final incomes = [
      (l10n.basicSalaryLabel, '20.000.000 ₫'),
      (l10n.lunchAndTransportAllowance, '1.200.000 ₫'),
      (l10n.overtimePayLabel, '1.800.000 ₫'),
      (l10n.kpiQuarterBonus(3), '2.500.000 ₫'),
    ];

    final deductions = [
      (l10n.socialInsuranceDeduction, '-2.135.000 ₫'),
      (l10n.personalIncomeTaxDeduction, '-865.000 ₫'),
      (l10n.unionFeeDeduction, '-0 ₫'),
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
          l10n.payslipTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.assignment_late),
            tooltip: l10n.disputeManageTitle,
            onPressed: () => context.push(AppRoutes.salaryDisputes),
          ),
          IconButton(
            icon: Icon(Symbols.download, color: colors.primaryIndigo),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.downloadingPdfSnackbar)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          // Employee Header Card
          _buildEmployeeHeaderCard(colors, l10n),
          20.gapH,

          // Incomes section
          Text(
            l10n.incomeSectionTitle,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
          10.gapH,
          PayslipBreakdownItems(
            items: incomes,
            valueColor: colors.textPrimary,
            onDisputeLine: _handleDisputeLine,
          ),
          20.gapH,

          // Deductions section
          Text(
            l10n.deductionSectionTitle,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
          10.gapH,
          PayslipBreakdownItems(
            items: deductions,
            valueColor: colors.error,
            onDisputeLine: _handleDisputeLine,
          ),
          20.gapH,

          // Net Salary Footer Card
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
                  l10n.netSalaryLabel,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
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
          20.gapH,

          // Signature Section
          if (_isSigned)
            PayslipSignedCard(
              signerName: 'Nguyễn Minh Tuấn (NV-04821)',
              signedAt: _signedAt,
              verificationHash: _verificationHash,
              signatureStrokes: _signatureStrokes,
            )
          else ...[
            PrimaryButton(
              text: l10n.signPayslipBtn,
              onPressed: _handleOpenSignPad,
            ),
            12.gapH,
            SecondaryButton(
              text: l10n.disputePayslipBtn,
              onPressed: () => context.push(AppRoutes.salaryDisputeNew),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmployeeHeaderCard(AppColorsExtension colors, AppLocalizations l10n) {
    return Container(
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFFFFF8EC)),
                  ),
                ),
              ),
              12.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nguyễn Minh Tuấn',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NV-04821 · Vận hành',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary),
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
            l10n.payslipNetSalaryMonth('9', '2026'),
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
    );
  }
}
