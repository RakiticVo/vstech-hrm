import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Saigon Tile aesthetic Dialog for selecting a month and year.
/// Replaces generic dropdowns across Request and Attendance screens.
class AppMonthPickerDialog extends StatefulWidget {
  const new({
    required this.initialMonth,
    this.allowAll = true,
    super.key,
  });

  final String initialMonth;
  final bool allowAll;

  /// Show the dialog and return the selected month string (e.g. "Tháng 10, 2026" or "Tất cả").
  static Future<String?> show(
    BuildContext context, {
    required String initialMonth,
    bool allowAll = true,
  }) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => AppMonthPickerDialog(
        initialMonth: initialMonth,
        allowAll: allowAll,
      ),
    );
  }

  /// Checks if a date string (ISO or DD/MM/YYYY) matches the selected month filter.
  static bool matchesMonth(String? dateStr, String selectedMonth, BuildContext context) {
    if (selectedMonth == 'Tất cả' || selectedMonth == context.l10n.filterAll) {
      return true;
    }
    if (dateStr == null || dateStr.isEmpty) return false;

    final parsedMonthYear = parseMonthYear(selectedMonth);
    if (parsedMonthYear == null) return true;

    final targetM = parsedMonthYear.month;
    final targetY = parsedMonthYear.year;

    // Pattern 1: ISO dates "2026-10-07" or "2026-10"
    final m2Digits = targetM.toString().padLeft(2, '0');
    if (dateStr.contains('$targetY-$m2Digits') || dateStr.contains('$targetY-$targetM-')) {
      return true;
    }

    // Pattern 2: Vietnamese / European dates "07/10/2026" or "10/2026"
    if (dateStr.contains('/$m2Digits/$targetY') || dateStr.contains('/$targetM/$targetY')) {
      return true;
    }
    if (dateStr.contains('$m2Digits/$targetY')) {
      return true;
    }

    // Pattern 3: Fallback if date contains range like "2026-10-06 - 2027-03-31"
    final yearMatch = dateStr.contains('$targetY');
    final monthIsoMatch = dateStr.contains('-$m2Digits-') || dateStr.contains('-$m2Digits ');
    final monthSlashMatch = dateStr.contains('/$m2Digits/') || dateStr.contains('/$m2Digits ');
    if (yearMatch && (monthIsoMatch || monthSlashMatch)) {
      return true;
    }

    return false;
  }

  /// Extracts month and year from a label like "Tháng 10, 2026".
  static ({int month, int year})? parseMonthYear(String label) {
    try {
      final clean = label.replaceAll('Tháng', '').replaceAll('Month', '').trim();
      final parts = clean.split(',');
      if (parts.length >= 2) {
        final m = int.tryParse(parts[0].trim());
        final y = int.tryParse(parts[1].trim());
        if (m != null && y != null) return (month: m, year: y);
      }
    } on Object {
      // Ignore
    }
    return null;
  }

  /// Returns the start and end of month formatted as "YYYY-MM-01" and "YYYY-MM-DD".
  static ({String from, String to})? getMonthDateRange(String label) {
    final parsed = parseMonthYear(label);
    if (parsed == null) {
      if (label.contains('Tất cả') || label.contains('All')) {
        final now = DateTime.now();
        return (from: '${now.year}-01-01', to: '${now.year}-12-31');
      }
      return null;
    }
    final y = parsed.year;
    final m = parsed.month;
    final lastDay = DateTime(y, m + 1, 0).day;
    final m2Digits = m.toString().padLeft(2, '0');
    final from = '$y-$m2Digits-01';
    final to = '$y-$m2Digits-${lastDay.toString().padLeft(2, '0')}';
    return (from: from, to: to);
  }

  @override
  State<AppMonthPickerDialog> createState() => _AppMonthPickerDialogState();
}

class _AppMonthPickerDialogState extends State<AppMonthPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;
  late bool _isAllSelected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final parsed = AppMonthPickerDialog.parseMonthYear(widget.initialMonth);
    if (parsed != null) {
      _selectedYear = parsed.year;
      _selectedMonth = parsed.month;
      _isAllSelected = false;
    } else {
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _isAllSelected = widget.initialMonth == 'Tất cả';
    }
  }

  void _onMonthTapped(int month) {
    setState(() {
      _selectedMonth = month;
      _isAllSelected = false;
    });
    Navigator.of(context).pop('Tháng $_selectedMonth, $_selectedYear');
  }

  void _onAllTapped() {
    setState(() => _isAllSelected = true);
    Navigator.of(context).pop(context.l10n.filterAll);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final now = DateTime.now();

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const AppIcon(AppIcons.chevronLeft, size: 20),
                  onPressed: () => setState(() => _selectedYear--),
                ),
                Text(
                  '$_selectedYear',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const AppIcon(AppIcons.chevronRight, size: 20),
                  onPressed: () => setState(() => _selectedYear++),
                ),
              ],
            ),
            12.gapH,

            // 3 x 4 Grid of 12 Months
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.1,
              ),
              itemCount: 12,
              itemBuilder: (ctx, index) {
                final month = index + 1;
                final isCurrent = now.year == _selectedYear && now.month == month;
                final isSelected = !_isAllSelected && _selectedMonth == month;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _onMonthTapped(month),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.pineGreen
                          : (isCurrent
                              ? colors.pineGreen.withValues(alpha: 0.1)
                              : colors.surface),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? colors.pineGreen
                            : (isCurrent ? colors.pineGreen : colors.border),
                        width: isSelected || isCurrent ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Tháng $month',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected || isCurrent ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isCurrent ? colors.pineGreen : colors.textPrimary),
                      ),
                    ),
                  ),
                );
              },
            ),
            16.gapH,

            // Bottom Actions: "Tất cả" & "Đóng"
            Row(
              children: [
                if (widget.allowAll)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(
                          color: _isAllSelected ? colors.primaryIndigo : colors.border,
                          width: _isAllSelected ? 1.5 : 1,
                        ),
                        backgroundColor: _isAllSelected
                            ? colors.primaryIndigo.withValues(alpha: 0.08)
                            : Colors.transparent,
                      ),
                      onPressed: _onAllTapped,
                      child: Text(
                        l10n.filterAll,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _isAllSelected ? colors.primaryIndigo : colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                if (widget.allowAll) 10.gapW,
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
