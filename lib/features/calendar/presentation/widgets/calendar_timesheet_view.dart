import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_account_timesheet_usecase.dart';
import 'package:vstech_hrm/features/calendar/presentation/cubit/timesheet_calendar_cubit.dart';
import 'package:vstech_hrm/features/calendar/presentation/cubit/timesheet_calendar_state.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_legend_row.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_month_grid_card.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_summary_card.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/timesheet_day_detail_sheet.dart';

/// 5-Color Monthly Timesheet Calendar & dynamic Summary backed by GET /api/Account/timesheet.
class CalendarTimesheetView extends StatelessWidget {
  const CalendarTimesheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = TimesheetCalendarCubit(
          getAccountTimesheetUseCase: sl<GetAccountTimesheetUseCase>(),
        );
        unawaited(cubit.loadTimesheet());
        return cubit;
      },
      child: const _CalendarTimesheetBody(),
    );
  }
}

class _CalendarTimesheetBody extends StatelessWidget {
  const _CalendarTimesheetBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocBuilder<TimesheetCalendarCubit, TimesheetCalendarState>(
      builder: (context, state) {
        final cubit = context.read<TimesheetCalendarCubit>();

        return RefreshIndicator(
          onRefresh: cubit.loadTimesheet,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              CalendarMonthGridCard(
                selectedMonth: state.selectedMonth,
                isLoading: state.isLoading,
                hasError: state.hasError,
                dayMap: state.dayMap,
                onPreviousMonth: cubit.previousMonth,
                onNextMonth: cubit.nextMonth,
                onRetry: cubit.loadTimesheet,
                onDayTap: (date, timesheet) {
                  TimesheetDayDetailSheet.show(context, date: date, timesheet: timesheet);
                },
              ),
              14.gapH,
              const CalendarLegendRow(),
              20.gapH,
              Text(
                l10n.attendanceMonthSummaryTitle(state.selectedMonth.month),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: colors.textPrimary,
                ),
              ),
              11.gapH,
              CalendarSummaryCard(
                payableWorkdaysText: '${state.payableWorkdays.toStringAsFixed(1)} ngày',
                totalWorkHoursText: '${state.totalWorkHours.toStringAsFixed(1)} giờ',
                cumulativeOvertimeText: '${state.cumulativeOvertime.toStringAsFixed(1)} giờ',
                paidLeaveDaysText: '${state.paidLeaveDays.toStringAsFixed(1)} ngày',
                lateEarlyArrivalsText: '${state.lateEarlyArrivalsCount} lần',
              ),
            ],
          ),
        );
      },
    );
  }
}
