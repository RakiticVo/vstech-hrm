import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Tab 2: Commission breakdown by 3 sources with Day/Week/Month rollup.
class RewardsCommissionTab extends StatefulWidget {
  const RewardsCommissionTab({super.key});

  @override
  State<RewardsCommissionTab> createState() => _RewardsCommissionTabState();
}

class _RewardsCommissionTabState extends State<RewardsCommissionTab> {
  int _selectedFilterIndex = 2; // Default: Month

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final filterLabels = [
      l10n.commissionFilterDay,
      l10n.commissionFilterWeek,
      l10n.commissionFilterMonth,
    ];

    final transactions = [
      _CommissionItem(
        code: 'HĐ-2026-0819',
        customer: 'Công ty CP Đầu tư Á Châu',
        dealValue: '180.000.000 ₫',
        rate: '5.0%',
        payout: '+9.000.000 ₫',
        type: l10n.commissionSourceDirect,
        date: '25/09/2026',
      ),
      _CommissionItem(
        code: 'HĐ-2026-0792',
        customer: 'Chi nhánh Quận 1 (Chỉ tiêu nhóm)',
        dealValue: '365.000.000 ₫',
        rate: '1.0%',
        payout: '+3.650.000 ₫',
        type: l10n.commissionSourceTeam,
        date: '22/09/2026',
      ),
      _CommissionItem(
        code: 'HĐ-2026-0750',
        customer: 'Tập đoàn VinaRetail (Tái tục năm 2)',
        dealValue: '100.000.000 ₫',
        rate: '2.2%',
        payout: '+2.200.000 ₫',
        type: l10n.commissionSourceRenewal,
        date: '18/09/2026',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // Filter segmented toggle: Day / Week / Month
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: List.generate(filterLabels.length, (index) {
              final isSelected = _selectedFilterIndex == index;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primaryIndigo : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        filterLabels[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        16.gapH,

        // Commission Summary Hero Card
        Container(
          decoration: BoxDecoration(
            color: colors.primaryIndigo,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.commissionTotalTitle('09/2026'),
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFFFFF8EC)),
              ),
              6.gapH,
              const Text(
                '14.850.000 ₫',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFF8EC),
                  letterSpacing: -0.8,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              4.gapH,
              Text(
                l10n.commissionContractsCount(3),
                style: const TextStyle(fontSize: 12, color: Color(0xFFFFF8EC)),
              ),
            ],
          ),
        ),
        16.gapH,

        // 3 Source Breakdown Cards
        Row(
          children: [
            Expanded(child: _buildSourceTile(l10n.commissionSourceDirect, '9.000.000 ₫', '60%', colors)),
            10.gapW,
            Expanded(child: _buildSourceTile(l10n.commissionSourceTeam, '3.650.000 ₫', '25%', colors)),
          ],
        ),
        10.gapH,
        _buildSourceTile(l10n.commissionSourceRenewal, '2.200.000 ₫', '15%', colors),
        22.gapH,

        // Transaction History List
        Text(
          'Giao dịch phát sinh hoa hồng',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
        ),
        10.gapH,
        ...transactions.map((tx) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primaryIndigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tx.code,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: colors.primaryIndigo,
                            ),
                          ),
                        ),
                        Text(
                          tx.payout,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: colors.pineGreen,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    8.gapH,
                    Text(
                      tx.customer,
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
                    ),
                    4.gapH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${tx.type} · ${tx.rate}',
                          style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                        ),
                        Text(
                          tx.date,
                          style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSourceTile(String title, String amount, String share, AppColorsExtension colors) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: colors.textSecondary),
                ),
              ),
              Text(
                share,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: colors.primaryIndigo),
              ),
            ],
          ),
          6.gapH,
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
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

class _CommissionItem {
  const _CommissionItem({
    required this.code,
    required this.customer,
    required this.dealValue,
    required this.rate,
    required this.payout,
    required this.type,
    required this.date,
  });

  final String code;
  final String customer;
  final String dealValue;
  final String rate;
  final String payout;
  final String type;
  final String date;
}
