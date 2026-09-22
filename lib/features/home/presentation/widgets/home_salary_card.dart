import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Monthly Net Salary Card with privacy toggle eye button.
/// Follows DESIGN.md §7 & Phone.dc.html lines 200–213.
class HomeSalaryCard extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeSalaryCard> createState() => _HomeSalaryCardState();
}

class _HomeSalaryCardState extends State<HomeSalaryCard> {
  bool _isSalaryRevealed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final amountText = _isSalaryRevealed ? '25.500.000 ₫' : '•••••••• ₫';
    final hintText = _isSalaryRevealed
        ? 'Gồm thưởng KPI 2.500.000 ₫ · Xem chi tiết'
        : 'Bấm vào mắt để xem · Xem phiếu lương';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.push(AppRoutes.payslipDetail),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Label + Month Chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LƯƠNG THỰC NHẬN THÁNG NÀY',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: colors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.cardSecondary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Th9',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.primaryIndigo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Amount row + Eye toggle button
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        amountText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          color: colors.textPrimary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () {
                        setState(() {
                          _isSalaryRevealed = !_isSalaryRevealed;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.cardSecondary,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          _isSalaryRevealed
                              ? Symbols.visibility
                              : Symbols.visibility_off,
                          size: 20,
                          color: colors.primaryIndigo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: colors.border),
                const SizedBox(height: 12),

                // Bottom row: Hint + chevron
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hintText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    Icon(
                      Symbols.chevron_right,
                      size: 18,
                      color: colors.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
