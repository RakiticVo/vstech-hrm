import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
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
            title: 'Lương & Thu nhập',
            subtitle: 'Kỳ lương Tháng 09/2026',
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
                    child: const Row(
                      children: [
                        Icon(Symbols.star, size: 14, color: Color(0xFFFFF8EC)),
                        SizedBox(width: 4),
                        Text(
                          'Thưởng',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFF8EC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
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
                // Saigon Tile Hero Card
                _buildHeroTileCard(colors),
                const SizedBox(height: 20),

                // Breakdown section
                Text(
                  'Chi tiết thu nhập & khấu trừ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 11),
                PayrollBreakdownCard(isSalaryVisible: _isSalaryVisible),
                const SizedBox(height: 20),

                // History section
                Text(
                  'Lịch sử kỳ lương',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 11),
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
                      const Text(
                        'LƯƠNG THỰC NHẬN (NET)',
                        style: TextStyle(
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
                        child: const Text(
                          'Tháng 9 2026',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFF8EC),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                  const SizedBox(height: 2),
                  const Text(
                    'VND · Trả ngày 05/10/2026',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFF8EC),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      label: const Text(
                        'Xem phiếu lương',
                        style: TextStyle(
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
      ('Tháng 8 2026', 'Đã chuyển Techcombank · 05/09', '24.850.000 ₫'),
      ('Tháng 7 2026', 'Đã chuyển Techcombank · 05/08', '24.200.000 ₫'),
      ('Tháng 6 2026', 'Đã chuyển Techcombank · 05/07', '24.200.000 ₫'),
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
                            const SizedBox(height: 2),
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
                      const SizedBox(width: 6),
                      Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
