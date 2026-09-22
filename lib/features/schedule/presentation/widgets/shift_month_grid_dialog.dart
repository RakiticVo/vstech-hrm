import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Dialog showing a 30-day month calendar grid with color-coded shift dots.
class ShiftMonthGridDialog extends StatelessWidget {
  const new({
    required this.currentMonth,
    required this.selectedDate,
    required this.onDatePicked,
    super.key,
  });

  final DateTime currentMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDatePicked;

  static void show(
    BuildContext context, {
    required DateTime currentMonth,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDatePicked,
  }) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => ShiftMonthGridDialog(
          currentMonth: currentMonth,
          selectedDate: selectedDate,
          onDatePicked: onDatePicked,
        ),
      ),
    );
  }

  Color _getShiftColorForDay(int day) {
    // Deterministic mock pattern for September 2026
    final mod = day % 7;
    if (mod == 0) return Colors.grey.shade400; // Day off
    if (mod == 1 || mod == 2) return const Color(0xFF0F766E); // Ca sáng
    if (mod == 3) return const Color(0xFF6366F1); // Ca chiều
    if (mod == 4) return const Color(0xFFD97706); // Ca gãy
    if (mod == 5) return const Color(0xFF0F766E); // Ca hành chính
    return const Color(0xFF7C3AED); // Ca đêm
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );
    // Sep 1, 2026 is Tuesday (weekday = 2, where Monday = 1)
    final firstWeekday =
        DateTime(currentMonth.year, currentMonth.month).weekday;
    final leadEmptyDays = firstWeekday - 1;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Symbols.calendar_month, color: colors.tealPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lịch ca Tháng ${currentMonth.month}/${currentMonth.year}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Symbols.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                  .map(
                    (d) => SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Month grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leadEmptyDays + daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (ctx, idx) {
                if (idx < leadEmptyDays) {
                  return const SizedBox.shrink();
                }
                final day = idx - leadEmptyDays + 1;
                final date =
                    DateTime(currentMonth.year, currentMonth.month, day);
                final isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
                final isToday = day == 22 && currentMonth.month == 9;
                final shiftColor = _getShiftColorForDay(day);

                return InkWell(
                  onTap: () {
                    onDatePicked(date);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.tealPrimary
                          : (isToday
                              ? colors.tealPrimary.withValues(alpha: 0.15)
                              : null),
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: colors.tealPrimary, width: 1.2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.white : shiftColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Legend
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem('Sáng', const Color(0xFF0F766E)),
                _buildLegendItem('Chiều', const Color(0xFF6366F1)),
                _buildLegendItem('Gãy', const Color(0xFFD97706)),
                _buildLegendItem('Đêm', const Color(0xFF7C3AED)),
                _buildLegendItem('Nghỉ', Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
