import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payroll_breakdown_card.dart';

/// Screen displaying payroll overview, Saigon tile hero card, breakdown, and history.
/// Follows DESIGN.md §3, §6 & Phone.dc.html lines 548–586.
class PayrollScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  bool _isSalaryVisible = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: context.l10n.payrollTitle,
            subtitle: context.l10n.payrollPeriodSubtitle('09', '2026'),
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
                        const Icon(Symbols.star, size: 14, color: Color(0xFFFFF8EC)),
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
                  icon: Icon(
                    _isSalaryVisible ? Symbols.visibility : Symbols.visibility_off,
                    color: const Color(0xFFFFF8EC),
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isSalaryVisible = !_isSalaryVisible),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                _buildHeroTileCard(colors),
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
                PayrollBreakdownCard(isSalaryVisible: _isSalaryVisible),
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
        ],
      ),
    );
  }

  Widget _buildHeroTileCard(AppColorsExtension colors) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternColor = isDark
        ? const Color(0xFF2DD4BF).withValues(alpha: 0.16)
        : const Color(0xFFFFF8EC).withValues(alpha: 0.19);

    final displayNet = _isSalaryVisible ? '25.500.000' : '••••••••';

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: ColoredBox(
        color: colors.primaryIndigo,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: TilePatternPainter(
                  backgroundColor: colors.primaryIndigo,
                  patternColor: patternColor,
                  tileSize: 46,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.payrollNetSalaryTitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                          color: Color(0xFFFFF8EC),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8EC).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.l10n.payrollPeriodSubtitle('9', '2026'),
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFF8EC),
                          ),
                        ),
                      ),
                    ],
                  ),
                  6.gapH,
                  Text(
                    displayNet,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.3,
                      color: Color(0xFFFFF8EC),
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  2.gapH,
                  Text(
                    context.l10n.payrollPayDate('05/10/2026'),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFF8EC),
                    ),
                  ),
                  16.gapH,
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accentAmber,
                        foregroundColor: const Color(0xFF1C1408),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => context.push(AppRoutes.payslipDetail),
                      icon: const Icon(Symbols.description, size: 18, weight: 700),
                      label: Text(
                        context.l10n.viewPayslipButton,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(AppColorsExtension colors) {
    final history = [
      (
        context.l10n.payrollPeriodSubtitle('8', '2026'),
        context.l10n.salaryTransferredTo('Techcombank', '05/09'),
        '24.850.000 ₫',
      ),
      (
        context.l10n.payrollPeriodSubtitle('7', '2026'),
        context.l10n.salaryTransferredTo('Techcombank', '05/08'),
        '24.200.000 ₫',
      ),
      (
        context.l10n.payrollPeriodSubtitle('6', '2026'),
        context.l10n.salaryTransferredTo('Techcombank', '05/07'),
        '24.200.000 ₫',
      ),
    ];

    return Column(
      children: history
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
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
                              item.$1,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            2.gapH,
                            Text(
                              item.$2,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _isSalaryVisible ? item.$3 : '•••••• ₫',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      6.gapW,
                      Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
