import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/constants/environment.dart';
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
          const SizedBox(height: 18),
          Text(
            'THÔNG TIN HỆ THỐNG',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 6),
          Text(
            'VSTech HRM Mobile',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Hệ thống quản trị nguồn nhân lực B2B SaaS • Phân hệ Nhân viên & Quản lý.',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                _buildInfoRow('Phiên bản ứng dụng', '1.0.0+1 (Phase 0/1/2)', colors),
                Divider(height: 16, color: colors.border.withValues(alpha: 0.5)),
                _buildInfoRow(
                  'Môi trường kết nối',
                  isDev ? 'Development (dev)' : 'Production (prod)',
                  colors,
                  valueColor: isDev ? colors.amberInk : colors.success,
                ),
                Divider(height: 16, color: colors.border.withValues(alpha: 0.5)),
                _buildInfoRow(
                  'Động cơ dữ liệu',
                  isMock ? 'Standalone Mock Engine' : 'Live Backend API',
                  colors,
                  valueColor: isMock ? colors.tealPrimary : colors.success,
                ),
                Divider(height: 16, color: colors.border.withValues(alpha: 0.5)),
                _buildInfoRow('Ngôn ngữ UI & Font', 'Source Sans 3 / Gạch bông', colors),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Kiểm tra cập nhật',
            icon: Symbols.update,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ứng dụng đang ở phiên bản mới nhất (v1.0.0)!'),
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
