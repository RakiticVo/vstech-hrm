import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_cubit.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_state.dart';

/// Spacious dialog showing a month calendar grid mapped to real API shift schedules.
class ShiftMonthGridDialog extends StatefulWidget {
  const ShiftMonthGridDialog({
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
    required ShiftScheduleCubit cubit,
    required ValueChanged<DateTime> onDatePicked,
  }) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => BlocProvider.value(
          value: cubit,
          child: ShiftMonthGridDialog(
            currentMonth: currentMonth,
            selectedDate: selectedDate,
            onDatePicked: onDatePicked,
          ),
        ),
      ),
    );
  }

  @override
  State<ShiftMonthGridDialog> createState() => _ShiftMonthGridDialogState();
}

class _ShiftMonthGridDialogState extends State<ShiftMonthGridDialog> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month);
    unawaited(context.read<ShiftScheduleCubit>().fetchShiftsForMonth(_displayedMonth));
  }

  void _prevMonth() {
    setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1));
    unawaited(context.read<ShiftScheduleCubit>().fetchShiftsForMonth(_displayedMonth));
  }

  void _nextMonth() {
    setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1));
    unawaited(context.read<ShiftScheduleCubit>().fetchShiftsForMonth(_displayedMonth));
  }

  MyShiftDayEntity? _findShift(List<MyShiftDayEntity> shifts, DateTime date) =>
      shifts.where((s) => s.date.year == date.year && s.date.month == date.month && s.date.day == date.day).firstOrNull;

  Color _getShiftDotColor(MyShiftDayEntity? shift) {
    if (shift == null || !shift.hasShift) return const Color(0xFF94A3B8);
    if (!AppColorUtils.isDefaultOrWhite(shift.color)) {
      final parsed = AppColorUtils.parseHex(shift.color);
      if (parsed != null) return parsed;
    }
    return shift.isOvernight ? const Color(0xFF7C3AED) : const Color(0xFF0F766E);
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          4.gapW,
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);
    final firstWeekday = DateTime(_displayedMonth.year, _displayedMonth.month).weekday;
    final leadEmptyDays = firstWeekday - 1;

    return BlocBuilder<ShiftScheduleCubit, ShiftScheduleState>(
      builder: (context, state) {
        final monthKey = '${_displayedMonth.year}-${_displayedMonth.month}';
        final monthShifts = state.monthlyShiftsCache[monthKey] ??
            (state.selectedDate.year == _displayedMonth.year &&
                    state.selectedDate.month == _displayedMonth.month
                ? state.myShifts
                : const <MyShiftDayEntity>[]);

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: colors.cardBackground,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      AppIcon(AppIcons.calendar, color: colors.tealPrimary, size: 22),
                      8.gapW,
                      Text(
                        l10n.shiftScheduleTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const AppIcon(AppIcons.close, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  8.gapH,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.tealPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: AppIcon(AppIcons.chevronLeft, size: 18, color: colors.tealPrimary),
                          visualDensity: VisualDensity.compact,
                          onPressed: _prevMonth,
                        ),
                        Text(
                          l10n.timesheetMonthDisplay(_displayedMonth.month, _displayedMonth.year),
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: colors.tealPrimary,
                          ),
                        ),
                        IconButton(
                          icon: AppIcon(AppIcons.chevronRight, size: 18, color: colors.tealPrimary),
                          visualDensity: VisualDensity.compact,
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ),
                  12.gapH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu, l10n.dayFri, l10n.daySat, l10n.daySun]
                        .map((d) => Expanded(
                              child: Center(
                                child: Text(d, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textSecondary)),
                              ),
                            ))
                        .toList(),
                  ),
                  8.gapH,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leadEmptyDays + daysInMonth,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (ctx, idx) {
                      if (idx < leadEmptyDays) return const SizedBox.shrink();
                      final day = idx - leadEmptyDays + 1;
                      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
                      final isSelected = date.year == widget.selectedDate.year &&
                          date.month == widget.selectedDate.month &&
                          date.day == widget.selectedDate.day;
                      final isToday = date.isAtSameMomentAs(today);

                      final shift = _findShift(monthShifts, date);
                      final hasShift = shift != null && shift.hasShift;
                      final shiftColor = _getShiftDotColor(shift);
                      final hasCustom = hasShift && !AppColorUtils.isDefaultOrWhite(shift.color);

                      final cellBg = isSelected
                          ? (hasCustom ? shiftColor : colors.tealPrimary)
                          : (isToday
                              ? colors.tealPrimary.withValues(alpha: 0.12)
                              : (hasCustom ? shiftColor.withValues(alpha: 0.14) : colors.surface));
                      final cellBorder = isSelected
                          ? cellBg
                          : (isToday ? colors.tealPrimary : (hasCustom ? shiftColor.withValues(alpha: 0.45) : colors.border));
                      final dayColor = isSelected
                          ? Colors.white
                          : (isToday ? colors.tealPrimary : (hasCustom ? shiftColor : colors.textPrimary));

                      return InkWell(
                        onTap: () {
                          widget.onDatePicked(date);
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cellBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: cellBorder, width: isToday ? 1.5 : 1.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: isSelected || isToday || hasCustom
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: dayColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                width: 6,
                                height: 6,
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
                  14.gapH,
                  const Divider(height: 1),
                  10.gapH,
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildLegendItem(l10n.shiftSourceScheduled, const Color(0xFF0F766E)),
                      _buildLegendItem(l10n.shiftOvernightBadge, const Color(0xFF7C3AED)),
                      _buildLegendItem(l10n.shiftSourceOff, const Color(0xFF94A3B8)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
