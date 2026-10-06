import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Horizontal filter chips for approval categories.
class ApprovalsFilterChips extends StatelessWidget {
  const ApprovalsFilterChips({
    required this.options,
    required this.selectedKey,
    required this.onSelected,
    super.key,
  });

  final List<(String, String)> options;
  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => 8.gapW,
        itemBuilder: (ctx, idx) {
          final opt = options[idx];
          final isSelected = selectedKey == opt.$1;
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onSelected(opt.$1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.primaryIndigo : colors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? colors.primaryIndigo : colors.border,
                ),
              ),
              child: Text(
                opt.$2,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : colors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
