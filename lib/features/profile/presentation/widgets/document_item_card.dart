import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Item representation for a legal document or contract.
class DocumentItemModel {
  const DocumentItemModel({
    required this.title,
    required this.code,
    required this.effectiveDate,
    required this.iconName,
    this.statusLabel = 'Hiệu lực',
    this.statusType = AppStatusType.approved,
    this.isExpiringSoon = false,
    this.isContract = false,
  });

  final String title;
  final String code;
  final String effectiveDate;
  final String iconName;
  final String statusLabel;
  final AppStatusType statusType;
  final bool isExpiringSoon;
  final bool isContract;
}

/// Card widget to display a single document with metadata and actions.
class DocumentItemCard extends StatelessWidget {
  const DocumentItemCard({
    required this.item,
    required this.onTap,
    super.key,
  });

  final DocumentItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isExpiringSoon ? colors.error : colors.border,
          width: item.isExpiringSoon ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.isExpiringSoon
                        ? colors.error.withValues(alpha: 0.12)
                        : colors.primaryIndigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: AppIcon(
                      item.iconName,
                      color: item.isExpiringSoon ? colors.error : colors.primaryIndigo,
                      size: 24,
                    ),
                  ),
                ),
                14.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          8.gapW,
                          StatusChip(
                            label: item.statusLabel,
                            type: item.statusType,
                          ),
                        ],
                      ),
                      4.gapH,
                      Text(
                        'Số: ${item.code} · ${item.effectiveDate}',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                8.gapW,
                AppIcon(
                  AppIcons.chevronRight,
                  size: 20,
                  color: colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
