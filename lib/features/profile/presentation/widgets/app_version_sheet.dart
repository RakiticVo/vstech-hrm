import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/constants/environment.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// BottomSheet displaying App version, runtime environment, and build details.
class AppVersionSheet extends StatelessWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AppVersionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDev = EnvConfig.isDev;
    final isMock = EnvConfig.useMockData;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          18.gapH,
          Text(
            context.l10n.systemInfoTitle,
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          6.gapH,
          Text(
            'VSTech HRM Mobile',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          6.gapH,
          Text(
            context.l10n.systemDesc,
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          16.gapH,
          AppCard(
            child: Column(
              children: [
                _buildInfoRow(context.l10n.appVersionLabel, '1.0.0+1 (Phase 0/1/2)', colors),
                Divider(height: 16, color: colors.border.withValues(alpha: 0.5)),
                _buildInfoRow(
                  context.l10n.runtimeEnvLabel,
                  isDev ? 'Development (dev)' : 'Production (prod)',
                  colors,
                  valueColor: isDev ? colors.amberInk : colors.success,
                ),
                Divider(height: 16, color: colors.border.withValues(alpha: 0.5)),
                _buildInfoRow(
                  context.l10n.dataEngineLabel,
                  isMock ? 'Standalone Mock Engine' : 'Live Backend API',
                  colors,
                  valueColor: isMock ? colors.tealPrimary : colors.success,
                ),
                Divider(height: 16, color: colors.border.withValues(alpha: 0.5)),
                _buildInfoRow(context.l10n.uiFontLabel, 'Source Sans 3 / Gạch bông', colors),
              ],
            ),
          ),
          20.gapH,
          PrimaryButton(
            text: context.l10n.checkUpdatesButton,
            icon: Symbols.update,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.appUpToDateSnackbar),
                  backgroundColor: colors.tealPrimary,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    AppColorsExtension colors, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall(color: colors.textSecondary)),
        Text(
          value,
          style: AppTextStyles.bodySmall(color: valueColor ?? colors.textPrimary)
              .copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
