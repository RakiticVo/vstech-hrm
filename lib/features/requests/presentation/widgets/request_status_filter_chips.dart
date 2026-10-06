import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Reusable horizontal scrollable status filter chips for request management screens.
class RequestStatusFilterChips extends StatelessWidget {
  const new({
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.options,
    required this.colors,
    super.key,
  });

  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final List<(String, String)> options;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final opt = options[index];
          final isSelected = selectedStatus == opt.$1;
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onStatusChanged(opt.$1),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
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
