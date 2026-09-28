import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Renders a list of income or deduction line items with inline dispute actions.
class PayslipBreakdownItems extends StatelessWidget {
  const PayslipBreakdownItems({
    required this.items,
    required this.valueColor,
    required this.onDisputeLine,
    super.key,
  });

  final List<(String, String)> items;
  final Color valueColor;
  final void Function(String itemName, String amount) onDisputeLine;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      items[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    items[i].$2,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: valueColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  4.gapW,
                  IconButton(
                    icon: Icon(
                      Symbols.flag,
                      size: 16,
                      color: colors.textTertiary,
                    ),
                    tooltip: 'Khiếu nại khoản mục này',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () => onDisputeLine(items[i].$1, items[i].$2),
                  ),
                ],
              ),
            ),
            if (i < items.length - 1)
              Divider(height: 1, color: colors.border.withValues(alpha: 0.6)),
          ],
        ],
      ),
    );
  }
}
extension on num {
  Widget get gapW => SizedBox(width: toDouble());
}
