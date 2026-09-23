import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';

/// 7-day capsule selector representing days of the current week.
class ShiftWeekSelector extends StatelessWidget {
  const new({
    required this.weekShifts,
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  final List<ShiftScheduleEntity> weekShifts;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        border: Border(
          bottom: BorderSide(color: colors.border.withValues(alpha: 0.6)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekShifts.map((shift) {
          final isSelected = _isSameDay(shift.date, selectedDate);
          final isToday = _isSameDay(shift.date, DateTime(2026, 9, 22));

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                onTap: () => onDateSelected(shift.date),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.tealPrimary
                        : (isToday
                            ? colors.tealPrimary.withValues(alpha: 0.1)
                            : colors.cardSecondary.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colors.tealPrimary
                          : (isToday
                              ? colors.tealPrimary.withValues(alpha: 0.4)
                              : colors.border.withValues(alpha: 0.5)),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colors.tealPrimary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        shift.dayOfWeek,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isToday
                                  ? colors.tealPrimary
                                  : colors.textSecondary),
                        ),
                      ),
                      4.gapH,
                      Text(
                        '${shift.date.day}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : colors.textPrimary,
                        ),
                      ),
                      6.gapH,
                      // Shift indicator dot
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white
                              : (shift.isDayOff
                                  ? Colors.grey.shade400
                                  : shift.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
