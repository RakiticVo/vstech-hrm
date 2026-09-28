import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen E3: Extra Hours Balance & Comp-off (Làm thêm & Nghỉ bù).
class ExtraHoursScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.extraHoursBalanceTitle,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Main Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.accentAmber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Symbols.timer, color: colors.accentAmber, size: 24),
                      ),
                      12.gapW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.otMonthlyApprovedHeader('28.5'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              l10n.otMonthlyCapWarning('28.5'),
                              style: TextStyle(fontSize: 11.5, color: colors.accentAmber),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.gapH,
                  Divider(height: 1, color: colors.border),
                  14.gapH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryStat(l10n.extraHoursMonth, '28.5h', colors.textPrimary, colors),
                      ),
                      12.gapW,
                      Expanded(
                        child: _buildSummaryStat(l10n.extraHoursQuarter, '64.0h', colors.textPrimary, colors),
                      ),
                    ],
                  ),
                  12.gapH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryStat(l10n.extraHoursPayable, '12.5h', colors.pineGreen, colors),
                      ),
                      12.gapW,
                      Expanded(
                        child: _buildSummaryStat(l10n.extraHoursConvertedCompOff, '16.0h', colors.primaryIndigo, colors),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            16.gapH,

            // Conversion Policy Banner (8h OT = 1 Comp-off day)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primaryIndigo.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.primaryIndigo.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Symbols.info, color: colors.primaryIndigo, size: 22),
                  12.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.compOffConversionRule,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        2.gapH,
                        Text(
                          l10n.leaveTypeCompOff,
                          style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.gapH,

            // Quick Action: Apply OT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: colors.primaryIndigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: () => context.push(AppRoutes.overtimeCreate),
                icon: const Icon(Symbols.schedule, size: 20),
                label: Text(
                  l10n.createOvertimeBtn,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color valColor, AppColorsExtension colors) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: valColor)),
        4.gapH,
        Text(label, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
      ],
    );
  }
}
