import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';

/// Card showing agreed salary, benefits, and social insurance contribution data.
class SocialInsuranceCard extends StatelessWidget {
  const new({required this.profile, super.key});

  final LaborProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final currencyFormat = NumberFormat('#,###', 'vi_VN');

    return Column(
      children: [
        // Agreed Salary & Benefits Card
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  children: [
                    Icon(Symbols.payments, size: 20, color: colors.amberGold),
                    8.gapW,
                    Text(
                      l10n.salaryAndBenefitsSection,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colors.border.withValues(alpha: 0.6)),
              _buildRow(
                l10n.agreedBaseSalary,
                '${currencyFormat.format(profile.agreedBaseSalary)} ₫ / tháng',
                colors,
              ),
              _buildRow(
                l10n.responsibilityAllowance,
                '${currencyFormat.format(profile.responsibilityAllowance)} ₫',
                colors,
              ),
              _buildRow(
                l10n.mealAllowance,
                '${currencyFormat.format(profile.mealAllowance)} ₫',
                colors,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                child: Text(
                  l10n.overtimeRateDescription,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: colors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
        16.gapH,

        // Social Insurance Card
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  children: [
                    Icon(Symbols.health_and_safety, size: 20, color: colors.pineGreen),
                    8.gapW,
                    Text(
                      l10n.socialInsuranceSection,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colors.border.withValues(alpha: 0.6)),
              _buildRow(l10n.socialInsuranceNumber, profile.socialInsuranceNumber, colors),
              _buildRow(l10n.hospitalRegistered, profile.hospitalRegistered, colors),
              _buildRow(
                l10n.insuranceSalaryLevel,
                '${currencyFormat.format(profile.insuranceSalaryLevel)} ₫',
                colors,
              ),
              _buildRow(l10n.insuranceStatus, profile.insuranceStatus, colors),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
