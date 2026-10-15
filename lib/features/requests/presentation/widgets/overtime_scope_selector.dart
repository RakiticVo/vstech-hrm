import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Segmented scope selector for personal vs subordinate proxy overtime tickets.
class OvertimeScopeSelector extends StatelessWidget {
  const new({
    required this.selectedScope,
    required this.onScopeChanged,
    required this.personalLabel,
    required this.proxyLabel,
    super.key,
  });

  final String selectedScope;
  final ValueChanged<String> onScopeChanged;
  final String personalLabel;
  final String proxyLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        _buildChip('personal', personalLabel, colors),
        8.gapW,
        _buildChip('proxy', proxyLabel, colors),
      ],
    );
  }

  Widget _buildChip(String scope, String label, AppColorsExtension colors) {
    final active = selectedScope == scope;
    return GestureDetector(
      onTap: () => onScopeChanged(scope),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5.5),
        decoration: BoxDecoration(
          color: active ? colors.tealPrimary : colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? colors.tealPrimary : colors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
