import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Model representing a tax-relief dependant.
class DependantItemModel {
  const DependantItemModel({
    required this.name,
    required this.relationship,
    required this.birthDate,
    required this.idNumber,
    required this.startMonth,
    required this.reliefAmount,
    this.status = 'Đang áp dụng',
    this.statusType = AppStatusType.approved,
  });

  final String name;
  final String relationship;
  final String birthDate;
  final String idNumber;
  final String startMonth;
  final String reliefAmount;
  final String status;
  final AppStatusType statusType;
}

/// Card showing dependant details and relief quota.
class DependantItemCard extends StatelessWidget {
  const DependantItemCard({
    required this.item,
    super.key,
  });

  final DependantItemModel item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.primaryIndigo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: AppIcon(
                        AppIcons.dependants,
                        color: colors.primaryIndigo,
                        size: 20,
                      ),
                    ),
                  ),
                  10.gapW,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        item.relationship,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StatusChip(label: item.status, type: item.statusType),
            ],
          ),
          12.gapH,
          Divider(height: 1, color: colors.border),
          10.gapH,
          _buildInfoRow('Ngày sinh', item.birthDate, colors),
          6.gapH,
          _buildInfoRow('CCCD/Giấy khai sinh', item.idNumber, colors),
          6.gapH,
          _buildInfoRow('Thời điểm tính', 'Từ tháng ${item.startMonth}', colors),
          10.gapH,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.pineGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mức giảm trừ gia cảnh:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  item.reliefAmount,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.pineGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppColorsExtension colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
