import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 3 category shortcut tiles opening Leave, OT and Correction management screens.
class RequestsCategoryTiles extends StatelessWidget {
  const RequestsCategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _buildTile(
              label: l10n.quickActionLeave,
              icon: Symbols.beach_access,
              color: colors.pineGreen,
              onTap: () => context.push(AppRoutes.leaveManage),
              colors: colors,
            ),
          ),
          8.gapW,
          Expanded(
            child: _buildTile(
              label: l10n.quickActionOvertime,
              icon: Symbols.schedule,
              color: colors.accentAmber,
              onTap: () => context.push(AppRoutes.overtimeManage),
              colors: colors,
            ),
          ),
          8.gapW,
          Expanded(
            child: _buildTile(
              label: l10n.quickActionCorrection,
              icon: Symbols.edit_calendar,
              color: colors.primaryIndigo,
              onTap: () => context.push(AppRoutes.correctionManage),
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required AppColorsExtension colors,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            6.gapH,
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
