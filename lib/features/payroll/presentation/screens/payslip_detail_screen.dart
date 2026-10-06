import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/secondary_button.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payslip_entity.dart';
import 'package:vstech_hrm/features/payroll/domain/usecases/get_payslip_detail_usecase.dart';
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
  String _signedAt = '';
  final String _verificationHash = 'SHA256: e7a9c24f8b1d30ac68';
  PayslipEntity? _payslip;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPayslip());
  }

  Future<void> _loadPayslip() async {
    if (!sl.isRegistered<GetPayslipDetailUseCase>()) return;
    final result = await sl<GetPayslipDetailUseCase>()(1);
    if (!mounted) return;
    result.fold((_) {}, (data) => setState(() => _payslip = data));
  }

  void _handleOpenSignPad() {
    unawaited(
      SignaturePadModal.show(
        context,
        onConfirmed: (strokes) {
          final now = DateTime.now();
          setState(() {
            _isSigned = true;
            _signatureStrokes = strokes;
            _signedAt = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
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
          'period': '${_payslip?.month ?? DateTime.now().month}/${DateTime.now().year}',
        },
      ),
    );
  }

  String _fmt(double amount, {bool isNegative = false}) {
    if (amount == 0) return '0 ₫';
    final str = NumberFormat('#,###', 'vi_VN').format(amount);
    return isNegative ? '-$str ₫' : '$str ₫';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    UserSession? user;
    try {
      final authState = context.watch<AuthCubit>().state;
      if (authState is Authenticated) user = authState.user;
    } catch (_) {
      if (sl.isRegistered<AuthCubit>()) {
        final authState = sl<AuthCubit>().state;
        if (authState is Authenticated) user = authState.user;
      }
    }
    final userName = user?.name ?? 'Nhân viên';
    final userCode = user?.employeeCode ?? (_payslip?.employeeCode ?? 'NV');

    final baseSalary = _payslip?.actualBaseSalary ?? 0;
    final allowance = (_payslip?.actualLunchFee ?? 0) + (_payslip?.actualAllowance ?? 0);
    final otSalary = _payslip?.actualOvertimeSalary ?? 0;
    final kpiSalary = _payslip?.actualKpiSalary ?? 0;
    final insurance = _payslip?.subtractionFund ?? 0;
    final tax = _payslip?.taxAddition ?? 0;
    final netSalary = _payslip?.sumPayAmount ?? 0;

    final incomes = [
      (l10n.basicSalaryLabel, _fmt(baseSalary)),
      (l10n.lunchAndTransportAllowance, _fmt(allowance)),
      (l10n.overtimePayLabel, _fmt(otSalary)),
      (l10n.kpiQuarterBonus(3), _fmt(kpiSalary)),
    ];

    final deductions = [
      (l10n.socialInsuranceDeduction, _fmt(insurance, isNegative: insurance > 0)),
      (l10n.personalIncomeTaxDeduction, _fmt(tax, isNegative: tax > 0)),
      (l10n.unionFeeDeduction, '-0 ₫'),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 20),
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
            icon: const AppIcon(AppIcons.dispute, size: 20),
            tooltip: l10n.disputeManageTitle,
            onPressed: () => context.push(AppRoutes.salaryDisputes),
          ),
          IconButton(
            icon: AppIcon(AppIcons.download, size: 20, color: colors.primaryIndigo),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.downloadingPdfSnackbar)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPayslip,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          children: [
            _buildEmployeeHeaderCard(colors, l10n, userName, userCode),
            20.gapH,

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
                    _fmt(netSalary),
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

            if (_isSigned)
              PayslipSignedCard(
                signerName: '$userName ($userCode)',
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
      ),
    );
  }

  Widget _buildEmployeeHeaderCard(AppColorsExtension colors, AppLocalizations l10n, String name, String code) {
    final period = '${_payslip?.month ?? DateTime.now().month}/${DateTime.now().year}';
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  period,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.pineGreen),
                ),
              ),
            ],
          ),
          4.gapH,
          Text(
            'Mã NV: $code',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
