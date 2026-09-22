import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Reusable month filter button that opens a bottom sheet to select month.
/// Used across Request Center, Leave, Overtime, and Attendance Correction screens.
class MonthPickerButton extends StatelessWidget {
  const new({
    required this.selectedMonth,
    required this.onMonthChanged,
    this.availableMonths,
    this.isCompact = false,
    super.key,
  });

  final String selectedMonth;
  final ValueChanged<String> onMonthChanged;
  final List<String>? availableMonths;
  final bool isCompact;

  List<String> _resolveMonths(BuildContext context) {
    if (availableMonths != null && availableMonths!.isNotEmpty) {
      return availableMonths!;
    }
    final allLabel = context.l10n.filterAll;
    return [
      'Tháng 9, 2026',
      'Tháng 8, 2026',
      'Tháng 7, 2026',
      'Tháng 6, 2026',
      allLabel,
    ];
  }

  void _showMonthPicker(BuildContext context) {
    final colors = context.colors;
    final months = _resolveMonths(context);
    final allLabel = context.l10n.filterAll;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.selectMonthToView,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Symbols.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                12.gapH,
                ...months.map((m) {
                  final isSelected = selectedMonth == m;
                  final isAll = m == allLabel || m == 'Tất cả' || m == 'All';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.pop(ctx);
                        onMonthChanged(m);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primaryIndigo.withValues(alpha: 0.08)
                              : colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? colors.primaryIndigo : colors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isAll ? Symbols.all_inclusive : Symbols.calendar_month,
                                  size: 18,
                                  color: isSelected ? colors.primaryIndigo : colors.textSecondary,
                                ),
                                10.gapW,
                                Text(
                                  m,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    color: isSelected ? colors.primaryIndigo : colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            if (isSelected)
                              Icon(Symbols.check, size: 18, color: colors.primaryIndigo),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final allLabel = context.l10n.filterAll;
    final isAll = selectedMonth == allLabel || selectedMonth == 'Tất cả' || selectedMonth == 'All';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showMonthPicker(context),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 10 : 12,
            vertical: isCompact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAll ? Symbols.all_inclusive : Symbols.calendar_month,
                size: 16,
                color: colors.primaryIndigo,
              ),
              6.gapW,
              Text(
                selectedMonth,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 12.5,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              4.gapW,
              Icon(Symbols.expand_more, size: 16, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
