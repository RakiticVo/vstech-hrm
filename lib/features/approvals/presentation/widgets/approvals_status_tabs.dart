import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 3-tab segmented selector for approval statuses: Pending, Processed, All.
class ApprovalsStatusTabs extends StatelessWidget {
  const new({
    required this.selectedTab,
    required this.pendingCount,
    required this.processedCount,
    required this.totalCount,
    required this.onTabChanged,
    super.key,
  });

  final int selectedTab;
  final int pendingCount;
  final int processedCount;
  final int totalCount;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Row(
        children: [
          _buildItem(0, '${l10n.statusPending} ($pendingCount)', colors),
          8.gapW,
          _buildItem(1, 'Đã xử lý ($processedCount)', colors),
          8.gapW,
          _buildItem(2, '${l10n.approvalTypeFilterAll} ($totalCount)', colors),
        ],
      ),
    );
  }

  Widget _buildItem(int index, String label, AppColorsExtension colors) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTabChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryIndigo : colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? colors.primaryIndigo : colors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
