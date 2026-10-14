import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payslip_entity.dart';
import 'package:vstech_hrm/features/payroll/domain/usecases/get_payslip_detail_usecase.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payroll_breakdown_card.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payroll_hero_card.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payslip_auth_dialog.dart';

/// Screen displaying payroll overview, Saigon tile hero card, breakdown, and history.
class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  bool _isSalaryVisible = true;
  PayslipEntity? _payslip;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPayslip());
  }

  Future<void> _loadPayslip() async {
    final result = await sl<GetPayslipDetailUseCase>()(1);
    if (!mounted) return;
    result.fold((_) {}, (payslip) {
      setState(() => _payslip = payslip);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentMonth = _payslip?.month ?? '${DateTime.now().month}';

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: context.l10n.payrollTitle,
            subtitle: context.l10n.payrollPeriodSubtitle(currentMonth, '${DateTime.now().year}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => context.push(AppRoutes.rewards),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EC).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const AppIcon(AppIcons.bonus, size: 14, color: Color(0xFFFFF8EC)),
                        4.gapW,
                        Text(
                          context.l10n.rewardsAction,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFF8EC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                6.gapW,
                IconButton(
                  icon: AppIcon(
                    _isSalaryVisible ? AppIcons.eye : AppIcons.eyeOff,
                    color: const Color(0xFFFFF8EC),
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isSalaryVisible = !_isSalaryVisible),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadPayslip,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                children: [
                  PayrollHeroCard(
                    isSalaryVisible: _isSalaryVisible,
                    payslip: _payslip,
                  ),
                  20.gapH,
                  Text(
                    context.l10n.incomeAndDeductionBreakdown,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: colors.textPrimary,
                    ),
                  ),
                  11.gapH,
                  PayrollBreakdownCard(
                    isSalaryVisible: _isSalaryVisible,
                    payslip: _payslip,
                  ),
                  20.gapH,
                  Text(
                    context.l10n.salaryHistoryTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: colors.textPrimary,
                    ),
                  ),
                  11.gapH,
                  _buildHistoryList(colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(AppColorsExtension colors) {
    if (_payslip == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Center(
          child: Text(
            'Chưa có lịch sử bảng lương',
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => PayslipAuthDialog.show(
        context,
        onAuthenticated: () => context.push(AppRoutes.payslipDetail),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.payrollPeriodSubtitle(_payslip!.month, '${DateTime.now().year}'),
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  2.gapH,
                  Text(
                    'Đã thanh toán qua ngân hàng',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            6.gapW,
            AppIcon(AppIcons.chevronRight, size: 18, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}
