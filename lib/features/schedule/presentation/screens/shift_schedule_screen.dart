import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/shift_schedule_mock_datasource.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_detail_card.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_month_grid_dialog.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_week_selector.dart';

/// Screen displaying the employee's weekly and monthly shift schedule.
class ShiftScheduleScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ShiftScheduleScreen> createState() => _ShiftScheduleScreenState();
}

class _ShiftScheduleScreenState extends State<ShiftScheduleScreen> {
  late final List<ShiftScheduleEntity> _weekShifts;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _weekShifts = ShiftScheduleMockDatasource.getWeekShifts();
    _selectedDate = DateTime(2026, 9, 22); // Default to today (Tuesday)
  }

  ShiftScheduleEntity get _selectedShift {
    return _weekShifts.firstWhere(
      (s) =>
          s.date.year == _selectedDate.year &&
          s.date.month == _selectedDate.month &&
          s.date.day == _selectedDate.day,
      orElse: () => _weekShifts.first,
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _openMonthGrid() {
    ShiftMonthGridDialog.show(
      context,
      currentMonth: DateTime(2026, 9),
      selectedDate: _selectedDate,
      onDatePicked: (date) {
        setState(() => _selectedDate = date);
      },
    );
  }

  Widget _buildWeeklyStatsCard(BuildContext context, AppColorsExtension colors) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.tealPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.tealPrimary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.tealPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Symbols.date_range,
              color: Colors.white,
              size: 20,
            ),
          ),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.weekStatsTitle('39', '21/09 — 27/09/2026'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                2.gapH,
                Text(
                  l10n.weekStatsSummary(5, 40, 2),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.tealPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _openMonthGrid,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: colors.tealPrimary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.viewMonth, style: const TextStyle(fontSize: 12)),
                const Icon(Symbols.chevron_right, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final selectedShift = _selectedShift;
    final dateStr = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        title: Text(l10n.shiftScheduleTitle),
        backgroundColor: colors.cardBackground,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.viewMonthTooltip,
            icon: const Icon(Symbols.calendar_month),
            onPressed: _openMonthGrid,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeeklyStatsCard(context, colors),
            8.gapH,
            ShiftWeekSelector(
              weekShifts: _weekShifts,
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Icon(Symbols.event_note, size: 18, color: colors.tealPrimary),
                  6.gapW,
                  Text(
                    l10n.shiftDetailHeader(selectedShift.dayOfWeek, dateStr),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            ShiftDetailCard(shift: selectedShift),
            24.gapH,
          ],
        ),
      ),
    );
  }
}
