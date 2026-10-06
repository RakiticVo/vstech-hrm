import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_detail_card.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_month_grid_dialog.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_week_selector.dart';

enum ShiftViewState { normal, loading, error, unpublished }

/// Screen displaying the employee's weekly and monthly shift schedule with demo view states.
class ShiftScheduleScreen extends StatefulWidget {
  const ShiftScheduleScreen({super.key});

  @override
  State<ShiftScheduleScreen> createState() => _ShiftScheduleScreenState();
}

class _ShiftScheduleScreenState extends State<ShiftScheduleScreen> {
  List<ShiftScheduleEntity> _weekShifts = [];
  late DateTime _selectedDate;
  ShiftViewState _viewState = ShiftViewState.normal;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekShifts();
    unawaited(_loadShiftFromApi());
  }

  void _generateWeekShifts([String shiftName = 'Ca Hành chính', String start = '08:00', String end = '17:00']) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: now.weekday - 1));
    const dayNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    final list = <ShiftScheduleEntity>[];
    for (int i = 0; i < 7; i++) {
      final d = monday.add(Duration(days: i));
      final isSunday = i == 6;
      final isPast = d.isBefore(today);
      final isToday = d.year == today.year && d.month == today.month && d.day == today.day;

      final ShiftStatus status;
      if (isSunday) {
        status = ShiftStatus.dayOff;
      } else if (isPast) {
        status = ShiftStatus.completed;
      } else if (isToday) {
        status = ShiftStatus.active;
      } else {
        status = ShiftStatus.upcoming;
      }

      list.add(
        ShiftScheduleEntity(
          id: 'shift_${d.year}_${d.month}_${d.day}',
          date: d,
          dayOfWeek: dayNames[i],
          shiftName: isSunday ? 'Nghỉ tuần' : shiftName,
          startTime: isSunday ? '—' : start,
          endTime: isSunday ? '—' : end,
          breakTime: isSunday ? '—' : '12:00 — 13:00',
          branchName: 'Trụ sở chính VSTech',
          managerName: 'Trưởng bộ phận',
          status: status,
          color: isSunday
              ? const Color(0xFF94A3B8)
              : (isToday ? const Color(0xFF0F766E) : const Color(0xFF3B82F6)),
        ),
      );
    }
    setState(() => _weekShifts = list);
  }

  Future<void> _loadShiftFromApi() async {
    final res = await sl<GetTodayAttendanceUseCase>()();
    if (!mounted) return;
    res.fold((_) {}, (today) {
      _generateWeekShifts(today.shiftName, today.shiftStart, today.shiftEnd);
    });
  }

  ShiftScheduleEntity get _selectedShift {
    if (_weekShifts.isEmpty) {
      _generateWeekShifts();
    }
    return _weekShifts.firstWhere(
      (s) => s.date.year == _selectedDate.year && s.date.month == _selectedDate.month && s.date.day == _selectedDate.day,
      orElse: () => _weekShifts.first,
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _openMonthGrid() {
    final now = DateTime.now();
    ShiftMonthGridDialog.show(
      context,
      currentMonth: DateTime(now.year, now.month),
      selectedDate: _selectedDate,
      onDatePicked: (date) {
        if (date.month > now.month) {
          setState(() => _viewState = ShiftViewState.unpublished);
        } else {
          setState(() {
            _viewState = ShiftViewState.normal;
            _selectedDate = date;
          });
        }
      },
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
          PopupMenuButton<ShiftViewState>(
            icon: const AppIcon(AppIcons.filter, size: 20),
            tooltip: 'Demo View States',
            onSelected: (s) => setState(() => _viewState = s),
            itemBuilder: (_) => [
              const PopupMenuItem(value: ShiftViewState.normal, child: Text('Bình thường')),
              const PopupMenuItem(value: ShiftViewState.loading, child: Text('Đang tải (Loading)')),
              const PopupMenuItem(value: ShiftViewState.error, child: Text('Lỗi mạng (Retry)')),
              const PopupMenuItem(value: ShiftViewState.unpublished, child: Text('Chưa công bố (Ngày 25)')),
            ],
          ),
          IconButton(
            tooltip: l10n.shiftSwapsManageTitle,
            icon: AppIcon(AppIcons.shiftSwap, size: 20, color: colors.textPrimary),
            onPressed: () => context.push(AppRoutes.shiftSwaps),
          ),
          IconButton(
            tooltip: l10n.viewMonthTooltip,
            icon: AppIcon(AppIcons.calendar, size: 20, color: colors.textPrimary),
            onPressed: _openMonthGrid,
          ),
        ],
      ),
      body: switch (_viewState) {
        ShiftViewState.loading => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: colors.tealPrimary),
                16.gapH,
                Text(l10n.loadingState, style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ShiftViewState.error => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(AppIcons.offline, size: 54, color: colors.error),
                  14.gapH,
                  Text(l10n.errorStateTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                  6.gapH,
                  Text(l10n.networkError, textAlign: TextAlign.center, style: TextStyle(color: colors.textSecondary)),
                  18.gapH,
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: colors.tealPrimary, foregroundColor: Colors.white),
                    onPressed: () => setState(() => _viewState = ShiftViewState.normal),
                    icon: const AppIcon(AppIcons.sync, size: 18, color: Colors.white),
                    label: Text(l10n.shiftNetworkRetry, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ShiftViewState.unpublished => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(AppIcons.calendar, size: 54, color: colors.accentAmber),
                  14.gapH,
                  Text(l10n.shiftMonthUnpublished, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                  18.gapH,
                  OutlinedButton(
                    onPressed: () => setState(() => _viewState = ShiftViewState.normal),
                    child: Text(l10n.currentMonthSchedule, style: TextStyle(color: colors.tealPrimary, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ShiftViewState.normal => SingleChildScrollView(
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
                      AppIcon(AppIcons.shift, size: 18, color: colors.tealPrimary),
                      6.gapW,
                      Text(
                        l10n.shiftDetailHeader(selectedShift.dayOfWeek, dateStr),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colors.textPrimary),
                      ),
                    ],
                  ),
                ),
                ShiftDetailCard(shift: selectedShift),
                24.gapH,
              ],
            ),
          ),
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
            decoration: BoxDecoration(color: colors.tealPrimary, borderRadius: BorderRadius.circular(10)),
            child: const AppIcon(AppIcons.shift, color: Colors.white, size: 20),
          ),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.weekStatsTitle('39', '21/09 — 27/09/2026'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                2.gapH,
                Text(l10n.weekStatsSummary(5, 40, 2), style: TextStyle(fontSize: 12, color: colors.tealPrimary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          TextButton(
            onPressed: _openMonthGrid,
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact, foregroundColor: colors.tealPrimary),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.viewMonth, style: const TextStyle(fontSize: 12)),
                AppIcon(AppIcons.chevronRight, size: 16, color: colors.tealPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
