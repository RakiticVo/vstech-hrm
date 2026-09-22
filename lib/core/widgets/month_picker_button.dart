import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Reusable month filter button that opens a bottom sheet to select month.
/// Used across Request Center, Leave, Overtime, and Attendance Correction screens.
class MonthPickerButton extends StatelessWidget {
  const new({
    required this.selectedMonth,
    required this.onMonthChanged,
    this.availableMonths = const [
      'Tháng 9, 2026',
      'Tháng 8, 2026',
      'Tháng 7, 2026',
      'Tháng 6, 2026',
      'Tất cả',
    ],
    this.isCompact = false,
    super.key,
  });

  final String selectedMonth;
  final ValueChanged<String> onMonthChanged;
  final List<String> availableMonths;
  final bool isCompact;

  void _showMonthPicker(BuildContext context) {
    final colors = context.colors;

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
                    'Chọn tháng xem dữ liệu',
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
              const SizedBox(height: 12),
              ...availableMonths.map((m) {
                final isSelected = selectedMonth == m;
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
                                m == 'Tất cả' ? Symbols.all_inclusive : Symbols.calendar_month,
                                size: 18,
                                color: isSelected ? colors.primaryIndigo : colors.textSecondary,
                              ),
                              const SizedBox(width: 10),
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                selectedMonth == 'Tất cả' ? Symbols.all_inclusive : Symbols.calendar_month,
                size: 16,
                color: colors.primaryIndigo,
              ),
              const SizedBox(width: 6),
              Text(
                selectedMonth,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 12.5,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Symbols.expand_more, size: 16, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
