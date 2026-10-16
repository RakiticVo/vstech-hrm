import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';

/// Helper mapping raw API personal shifts into a 7-day week schedule list.
class ShiftWeekMapper {
  const ShiftWeekMapper._();

  static const List<String> _dayNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  static List<ShiftScheduleEntity> mapToWeekShifts(
    DateTime monday,
    List<MyShiftDayEntity> items,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final week = <ShiftScheduleEntity>[];

    for (var i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateOnly = DateTime(date.year, date.month, date.day);
      final isToday = dateOnly.isAtSameMomentAs(today);
      final isPast = dateOnly.isBefore(today);

      final matches = items.where((item) =>
          item.date.year == date.year &&
          item.date.month == date.month &&
          item.date.day == date.day);

      if (matches.isNotEmpty && matches.first.hasShift) {
        final match = matches.first;
        final ShiftStatus status;
        if (isToday) {
          status = ShiftStatus.active;
        } else if (isPast) {
          status = ShiftStatus.completed;
        } else {
          status = ShiftStatus.upcoming;
        }

        final fallbackColor = match.isOvernight
            ? const Color(0xFF7C3AED)
            : (match.isScheduled ? const Color(0xFF0F766E) : const Color(0xFF3B82F6));
        final shiftColor = AppColorUtils.parseHex(match.color) ?? fallbackColor;
        final shiftTextColor = AppColorUtils.parseHex(match.textColor);

        week.add(
          ShiftScheduleEntity(
            id: 'shift_${date.year}_${date.month}_${date.day}',
            date: date,
            dayOfWeek: _dayNames[i],
            shiftName: match.shiftName ?? 'Ca làm việc',
            startTime: match.startHour ?? '08:00',
            endTime: match.endHour ?? '17:00',
            status: status,
            color: shiftColor,
            textColor: shiftTextColor,
            shiftCode: match.shiftCode,
            source: match.source,
            isOvernight: match.isOvernight,
          ),
        );
      } else {
        week.add(
          ShiftScheduleEntity(
            id: 'shift_${date.year}_${date.month}_${date.day}',
            date: date,
            dayOfWeek: _dayNames[i],
            shiftName: i == 6 ? 'Nghỉ tuần' : 'Chưa có ca',
            startTime: '—',
            endTime: '—',
            status: ShiftStatus.dayOff,
            color: const Color(0xFF94A3B8),
          ),
        );
      }
    }
    return week;
  }

  static List<ShiftScheduleEntity> generateFallbackWeek(DateTime monday) {
    return List.generate(7, (i) {
      final d = monday.add(Duration(days: i));
      return ShiftScheduleEntity(
        id: 'shift_${d.year}_${d.month}_${d.day}',
        date: d,
        dayOfWeek: _dayNames[i],
        shiftName: i == 6 ? 'Nghỉ tuần' : 'Chưa có ca',
        startTime: '—',
        endTime: '—',
        status: ShiftStatus.dayOff,
        color: const Color(0xFF94A3B8),
      );
    });
  }
}
