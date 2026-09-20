import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';

/// Screen for Direct Managers to approve or reject subordinate requests.
class ApprovalsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          const TileHeaderBanner(
            title: 'Phê duyệt yêu cầu',
            subtitle: 'Phê duyệt cấp 1 (Quản lý trực tiếp)',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('Tất cả (3)', 0, colors),
                const SizedBox(width: 8),
                _buildFilterChip('Nghỉ phép (2)', 1, colors),
                const SizedBox(width: 8),
                _buildFilterChip('Tăng ca (1)', 2, colors),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildApprovalCard(
                  employeeName: 'Lê Hoàng Nam',
                  employeeRole: 'Lập trình viên Flutter',
                  requestType: 'Nghỉ phép năm',
                  timeRange: '23/09/2026 - 24/09/2026 (2 ngày)',
                  reason: 'Việc gia đình có tang',
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _buildApprovalCard(
                  employeeName: 'Phạm Thị Lan',
                  employeeRole: 'Kiểm thử phần mềm (QA)',
                  requestType: 'Nghỉ phép năm',
                  timeRange: '25/09/2026 (1 ngày)',
                  reason: 'Khám sức khỏe định kỳ',
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _buildApprovalCard(
                  employeeName: 'Đặng Minh Quân',
                  employeeRole: 'Kỹ sư Backend',
                  requestType: 'Đề xuất tăng ca (OT)',
                  timeRange: '22/09/2026 (18:00 - 21:00)',
                  reason: 'Fix issue production release',
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index, AppColorsExtension colors) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryIndigo : colors.cardSecondary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMicro(
            color: isSelected ? Colors.white : colors.textSecondary,
          ).copyWith(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildApprovalCard({
    required String employeeName,
    required String employeeRole,
    required String requestType,
    required String timeRange,
    required String reason,
    required AppColorsExtension colors,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colors.primaryIndigo.withValues(alpha: 0.1),
                child: Text(
                  employeeName.substring(0, 1),
                  style: TextStyle(color: colors.primaryIndigo, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName,
                      style: AppTextStyles.bodyMedium(color: colors.textPrimary).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      employeeRole,
                      style: AppTextStyles.bodySmall(color: colors.textTertiary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.accentAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  requestType,
                  style: AppTextStyles.labelMicro(color: colors.accentAmberDark).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            timeRange,
            style: AppTextStyles.bodyMedium(color: colors.textPrimary).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text('Lý do: $reason', style: AppTextStyles.bodySmall(color: colors.textSecondary)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã từ chối đơn của $employeeName')),
                    );
                  },
                  icon: Icon(Symbols.close, size: 18, color: colors.brickRed),
                  label: Text('Từ chối', style: TextStyle(color: colors.brickRed)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.brickRed.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã phê duyệt đơn của $employeeName')),
                    );
                  },
                  icon: const Icon(Symbols.check, size: 18, color: Colors.white),
                  label: const Text('Phê duyệt', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.pineGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
