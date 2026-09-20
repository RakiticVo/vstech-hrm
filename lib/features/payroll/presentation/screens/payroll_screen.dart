import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';

/// Screen displaying payroll details with salary obfuscation toggle.
class PayrollScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  bool _isSalaryVisible = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: 'Phiếu lương & Thu nhập',
            subtitle: 'Kỳ lương Tháng 08/2026',
            trailing: IconButton(
              icon: Icon(
                _isSalaryVisible ? Symbols.visibility_off : Symbols.visibility,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => setState(() => _isSalaryVisible = !_isSalaryVisible),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildNetSalaryCard(colors),
                const SizedBox(height: 16),
                _buildBreakdownSection(colors),
                const SizedBox(height: 16),
                _buildSecurityDisclaimer(colors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetSalaryCard(AppColorsExtension colors) {
    final displayAmount = _isSalaryVisible ? '24.850.000 đ' : '•••••••• đ';

    return AppCard(
      backgroundColor: colors.primaryIndigo,
      borderColor: colors.primaryIndigo,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LƯƠNG THỰC NHẬN (NET)',
                style: AppTextStyles.labelMicro(
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.pineGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'ĐÃ THANH TOÁN',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            displayAmount,
            style: AppTextStyles.headlineMedium(color: Colors.white).copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đã chuyển khoản ngày 05/09/2026 qua Techcombank',
            style: AppTextStyles.bodySmall(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection(AppColorsExtension colors) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHI TIẾT THU NHẬP & KHẤU TRỪ',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 14),
          _buildSalaryRow('Lương cơ bản', '22.000.000 đ', colors),
          const SizedBox(height: 10),
          _buildSalaryRow('Phụ cấp ăn trưa & đi lại', '1.500.000 đ', colors),
          const SizedBox(height: 10),
          _buildSalaryRow('Thưởng hiệu quả công việc', '3.200.000 đ', colors, isBonus: true),
          const Divider(height: 24),
          _buildSalaryRow('BHXH, BHYT, BHTN (10.5%)', '-1.450.000 đ', colors, isDeduction: true),
          const SizedBox(height: 10),
          _buildSalaryRow('Thuế TNCN', '-400.000 đ', colors, isDeduction: true),
        ],
      ),
    );
  }

  Widget _buildSalaryRow(
    String label,
    String value,
    AppColorsExtension colors, {
    bool isBonus = false,
    bool isDeduction = false,
  }) {
    final displayValue = _isSalaryVisible ? value : '•••••• đ';
    final textColor = isDeduction
        ? colors.brickRed
        : (isBonus ? colors.pineGreen : colors.textPrimary);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall(color: colors.textSecondary)),
        Text(
          displayValue,
          style: AppTextStyles.bodyMedium(color: textColor).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityDisclaimer(AppColorsExtension colors) {
    return Row(
      children: [
        Icon(Symbols.lock, size: 16, color: colors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Thông tin thu nhập là bí mật nội bộ theo quy định bảo mật VSTech.',
            style: AppTextStyles.bodySmall(color: colors.textTertiary),
          ),
        ),
      ],
    );
  }
}
