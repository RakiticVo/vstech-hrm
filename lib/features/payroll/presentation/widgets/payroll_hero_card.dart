import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payslip_entity.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payslip_auth_dialog.dart';

/// Hero tile card displaying net salary, pay date, and view payslip action.
class PayrollHeroCard extends StatelessWidget {
  const new({
    required this.isSalaryVisible,
    this.payslip,
    super.key,
  });

  final bool isSalaryVisible;
  final PayslipEntity? payslip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternColor = isDark
        ? const Color(0xFF2DD4BF).withValues(alpha: 0.16)
        : const Color(0xFFFFF8EC).withValues(alpha: 0.19);

    final netAmount = payslip?.sumPayAmount ?? 0;
    final formattedAmount = NumberFormat('#,###', 'vi_VN').format(netAmount);
    final displayNet = isSalaryVisible
        ? (netAmount > 0 ? '$formattedAmount ₫' : '0 ₫')
        : '••••••••';

    final periodMonth = payslip != null ? payslip!.month : '${DateTime.now().month}';

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
                      Flexible(
                        child: Text(
                          context.l10n.payrollNetSalaryTitle,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFFFFF8EC),
                          ),
                        ),
                      ),
                      8.gapW,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8EC).withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFFFF8EC).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppIcon(AppIcons.calendar, size: 12, color: Color(0xFFFFF8EC)),
                            4.gapW,
                            Text(
                              context.l10n.timesheetMonthDisplay(
                                int.tryParse(periodMonth) ?? DateTime.now().month,
                                DateTime.now().year,
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFFFF8EC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  6.gapH,
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      displayNet,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.3,
                        color: Color(0xFFFFF8EC),
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
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
                      onPressed: () => PayslipAuthDialog.show(
                        context,
                        onAuthenticated: () => context.push(AppRoutes.payslipDetail),
                      ),
                      icon: const AppIcon(AppIcons.payslip, size: 18, color: Color(0xFF1C1408)),
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
}
