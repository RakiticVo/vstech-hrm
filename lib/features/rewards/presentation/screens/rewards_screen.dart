import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 15: Rewards, Recognition, and KPI Bonuses.
class RewardsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final history = [
      ('Tháng 9 2026', 'KPI quý 3 + thưởng tháng', '+2.500.000 ₫'),
      ('Tháng 8 2026', 'Thưởng chuyên cần', '+500.000 ₫'),
      ('Tháng 7 2026', 'Thưởng sáng kiến', '+1.000.000 ₫'),
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
          context.l10n.rewardsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Amber Star Hero Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.accentAmber, const Color(0xFFD97706)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.star, color: Colors.white, size: 26),
                ),
                10.gapH,
                Text(
                  context.l10n.rewardMonthHeader,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                4.gapH,
                const Text(
                  '+2.500.000',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                2.gapH,
                Text(
                  context.l10n.paidWithMonthSalary,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                ),
              ],
            ),
          ),
          18.gapH,

          // 4 Stats Cards (2x2)
          Row(
            children: [
              Expanded(child: _buildStatTile(context.l10n.monthlyBonusStat, '1.000.000', colors)),
              10.gapW,
              Expanded(child: _buildStatTile(context.l10n.kpiBonusStat, '1.500.000', colors)),
            ],
          ),
          10.gapH,
          Row(
            children: [
              Expanded(child: _buildStatTile(context.l10n.yearTotalBonusStat, '11.300.000', colors)),
              10.gapW,
              Expanded(child: _buildStatTile(context.l10n.internalRecognitionStat, '4 lần', colors)),
            ],
          ),
          22.gapH,

          // Vì sao bạn nhận thưởng
          Text(
            context.l10n.whyReceivedBonus,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
          10.gapH,
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.pineGreen.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Symbols.check, size: 18, color: colors.pineGreen),
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đạt KPI quý 3 — 112%',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                      ),
                      4.gapH,
                      Text(
                        'Doanh thu cửa hàng và mức hài lòng khách hàng đều vượt mục tiêu tháng 7–9. Người xác nhận: Lê Thu Hà.',
                        style: TextStyle(fontSize: 12.5, color: colors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          22.gapH,

          // Lịch sử thưởng
          Text(
            context.l10n.bonusHistoryTitle,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
          10.gapH,
          ...history.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: colors.border),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.$1, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(h.$2, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                        ],
                      ),
                      Text(
                        h.$3,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: colors.pineGreen,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: colors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
