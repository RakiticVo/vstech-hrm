import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';

/// Screen listing leave and overtime requests.
class RequestsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: 'Quản lý Đơn từ',
            subtitle: 'Nghỉ phép • Tăng ca • Chấm công bù',
            trailing: IconButton(
              icon: const Icon(Symbols.add_circle, color: Colors.white, size: 28),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mở biểu mẫu tạo đơn mới')),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Leave balance card
                _buildBalanceCard(colors),
                const SizedBox(height: 16),
                Text(
                  'YÊU CẦU GẦN ĐÂY',
                  style: AppTextStyles.labelMicro(color: colors.textTertiary),
                ),
                const SizedBox(height: 10),
                _buildRequestItem(
                  title: 'Nghỉ phép năm',
                  dateRange: '24/09/2026 - 25/09/2026 (2 ngày)',
                  reason: 'Việc gia đình',
                  status: AppStatusType.pending,
                  statusText: 'Chờ Quản lý duyệt',
                  colors: colors,
                ),
                const SizedBox(height: 10),
                _buildRequestItem(
                  title: 'Đề xuất tăng ca',
                  dateRange: '18/09/2026 (18:00 - 21:00)',
                  reason: 'Triển khai bản cập nhật hệ thống',
                  status: AppStatusType.approved,
                  statusText: 'Đã phê duyệt',
                  colors: colors,
                ),
                const SizedBox(height: 10),
                _buildRequestItem(
                  title: 'Giải trình quên chấm công',
                  dateRange: '15/09/2026 (Giờ vào 08:30)',
                  reason: 'Lỗi thiết bị quét vân tay',
                  status: AppStatusType.approved,
                  statusText: 'Đã duyệt',
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(AppColorsExtension colors) {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBalanceMetric('Phép năm khả dụng', '8.5', 'ngày', colors.primaryIndigo, colors),
          Container(width: 1, height: 40, color: colors.border),
          _buildBalanceMetric('Đã sử dụng', '3.5', 'ngày', colors.textSecondary, colors),
          Container(width: 1, height: 40, color: colors.border),
          _buildBalanceMetric('Tăng ca lũy kế', '12', 'giờ', colors.accentAmber, colors),
        ],
      ),
    );
  }

  Widget _buildBalanceMetric(
    String label,
    String value,
    String unit,
    Color valueColor,
    AppColorsExtension colors,
  ) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelMicro(color: colors.textTertiary)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTextStyles.headlineSmall(color: valueColor).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 2),
            Text(unit, style: AppTextStyles.labelMicro(color: colors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestItem({
    required String title,
    required String dateRange,
    required String reason,
    required AppStatusType status,
    required String statusText,
    required AppColorsExtension colors,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium(color: colors.textPrimary).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              StatusChip(label: statusText, type: status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            dateRange,
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Lý do: $reason',
            style: AppTextStyles.bodySmall(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}
