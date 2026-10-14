import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_timesheet_view.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_cubit.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_state.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/department_roster_tab_view.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_month_grid_dialog.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_schedule_tab_view.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

/// Screen displaying the unified schedule hub:
/// - Personal Shifts (Week capsules & details)
/// - Department Daily Roster (for Managers)
/// - Monthly Timesheet Calendar
class ShiftScheduleScreen extends StatefulWidget {
  const new({this.initialTab = 0, super.key});

  final int initialTab;

  @override
  State<ShiftScheduleScreen> createState() => _ShiftScheduleScreenState();
}

class _ShiftScheduleScreenState extends State<ShiftScheduleScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  bool _checkIsManager() {
    final state = sl<AuthCubit>().state;
    if (state is Authenticated) {
      return state.user.canApprove || state.role.isManager;
    }
    return false;
  }

  void _openMonthGrid(BuildContext context, ShiftScheduleState state) {
    ShiftMonthGridDialog.show(
      context,
      currentMonth: DateTime(state.selectedDate.year, state.selectedDate.month),
      selectedDate: state.selectedDate,
      cubit: context.read<ShiftScheduleCubit>(),
      onDatePicked: (date) {
        context.read<ShiftScheduleCubit>().selectDate(
              date,
              isManager: _checkIsManager(),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isManager = _checkIsManager();

    return BlocProvider(
      create: (_) {
        final cubit = sl<ShiftScheduleCubit>();
        unawaited(cubit.loadMyShifts());
        if (isManager) {
          unawaited(cubit.loadDepartmentRoster());
        }
        return cubit;
      },
      child: BlocBuilder<ShiftScheduleCubit, ShiftScheduleState>(
        builder: (context, state) {
          final colors = context.colors;
          final l10n = context.l10n;

          return Scaffold(
            backgroundColor: colors.pageBackground,
            appBar: AppBar(
              title: Text(l10n.calendarScreenTitle),
              backgroundColor: colors.cardBackground,
              foregroundColor: colors.textPrimary,
              elevation: 0,
            ),
            body: Column(
              children: [
                _buildSegmentedTab(colors, l10n, isManager),
                Expanded(
                  child: _buildBody(context, state, isManager),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ShiftScheduleState state,
    bool isManager,
  ) {
    if (isManager) {
      if (_selectedTab == 0) {
        return _buildPersonalTabView(context, state, isManager);
      } else if (_selectedTab == 1) {
        return const DepartmentRosterTabView();
      } else {
        return const CalendarTimesheetView();
      }
    } else {
      if (_selectedTab == 0) {
        return _buildPersonalTabView(context, state, isManager);
      } else {
        return const CalendarTimesheetView();
      }
    }
  }

  Widget _buildPersonalTabView(
    BuildContext context,
    ShiftScheduleState state,
    bool isManager,
  ) {
    final cubit = context.read<ShiftScheduleCubit>();
    if (state.weekShifts.isEmpty && state.personalStatus == ScheduleLoadingStatus.loading) {
      return Center(
        child: CircularProgressIndicator(color: context.colors.tealPrimary),
      );
    }

    final selectedShift = state.selectedShift ??
        (state.weekShifts.isNotEmpty ? state.weekShifts.first : null);

    if (selectedShift == null) {
      return const SizedBox.shrink();
    }

    return ShiftScheduleTabView(
      weekShifts: state.weekShifts,
      selectedDate: state.selectedDate,
      selectedShift: selectedShift,
      onDateSelected: (d) => cubit.selectDate(d, isManager: isManager),
      onOpenMonthGrid: () => _openMonthGrid(context, state),
    );
  }

  Widget _buildSegmentedTab(
    AppColorsExtension colors,
    AppLocalizations l10n,
    bool isManager,
  ) {
    final tabLabels = isManager
        ? [l10n.shiftTabPersonal, l10n.shiftTabDepartment, l10n.shiftTabTimesheet]
        : [l10n.shiftScheduleNav, l10n.shiftTabTimesheet];

    return Container(
      color: colors.cardBackground,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          children: List.generate(tabLabels.length, (idx) {
            final isSelected = _selectedTab == idx;
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedTab = idx),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.tealPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabLabels[idx],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : colors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
