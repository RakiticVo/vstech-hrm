import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_timesheet_model.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_account_timesheet_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_attendance_history_usecase.dart';
import 'package:vstech_hrm/features/calendar/presentation/cubit/timesheet_calendar_state.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_requests_usecase.dart';

class TimesheetCalendarCubit extends Cubit<TimesheetCalendarState> {
  new({
    required this.getAccountTimesheetUseCase,
    GetAttendanceHistoryUseCase? getAttendanceHistoryUseCase,
    GetCorrectionRequestsUseCase? getCorrectionRequestsUseCase,
    DateTime? initialMonth,
  })  : _getAttendanceHistoryUseCase = getAttendanceHistoryUseCase ??
            (sl.isRegistered<GetAttendanceHistoryUseCase>() ? sl<GetAttendanceHistoryUseCase>() : null),
        _getCorrectionRequestsUseCase = getCorrectionRequestsUseCase ??
            (sl.isRegistered<GetCorrectionRequestsUseCase>() ? sl<GetCorrectionRequestsUseCase>() : null),
        super(
          TimesheetCalendarState(
            selectedMonth: DateTime(
              (initialMonth ?? DateTime.now()).year,
              (initialMonth ?? DateTime.now()).month,
            ),
          ),
        );

  final GetAccountTimesheetUseCase getAccountTimesheetUseCase;
  final GetAttendanceHistoryUseCase? _getAttendanceHistoryUseCase;
  final GetCorrectionRequestsUseCase? _getCorrectionRequestsUseCase;

  Future<void> loadTimesheet([DateTime? targetMonth]) async {
    final month = targetMonth ?? state.selectedMonth;
    final normalizedMonth = DateTime(month.year, month.month);

    emit(state.copyWith(
      selectedMonth: normalizedMonth,
      status: TimesheetStatus.loading,
    ));

    final monthStr =
        '${normalizedMonth.year}-${normalizedMonth.month.toString().padLeft(2, '0')}-01';

    // 1. Fetch timesheet items
    final timesheetResult = await getAccountTimesheetUseCase(monthYear: monthStr);

    Failure? timesheetFailure;
    var rawItems = <AccountTimesheetEntity>[];
    timesheetResult.fold(
      (f) => timesheetFailure = f,
      (items) => rawItems = items,
    );

    // 2. Fetch attendance history (enrollments / punches)
    var enrollments = <AttendanceRecordEntity>[];
    if (_getAttendanceHistoryUseCase != null) {
      final daysInMonth = DateTime(normalizedMonth.year, normalizedMonth.month + 1, 0).day;
      final start = DateTime(normalizedMonth.year, normalizedMonth.month);
      final end = DateTime(normalizedMonth.year, normalizedMonth.month, daysInMonth, 23, 59, 59);
      final histRes = await _getAttendanceHistoryUseCase(from: start, to: end);
      histRes.fold((_) {}, (list) => enrollments = list);
    }

    final failure = timesheetFailure;
    if (failure != null && enrollments.isEmpty) {
      emit(state.copyWith(
        status: TimesheetStatus.failure,
        errorMessage: failure.message,
      ));
      return;
    }

    // 3. Fetch correction requests
    var corrections = <CorrectionItemEntity>[];
    if (_getCorrectionRequestsUseCase != null) {
      final corRes = await _getCorrectionRequestsUseCase(month: monthStr);
      corRes.fold((_) {}, (list) => corrections = list.where((c) => c.isApproved).toList());
    }

    // 4. Merge by day
    final mergedMap = <int, AccountTimesheetEntity>{};

    for (final item in rawItems) {
      if (item.workDate.year == normalizedMonth.year && item.workDate.month == normalizedMonth.month) {
        mergedMap[item.workDate.day] = item;
      }
    }

    // Merge enrollments (actual punches)
    for (final enc in enrollments) {
      if (enc.timestamp.year == normalizedMonth.year && enc.timestamp.month == normalizedMonth.month) {
        final day = enc.timestamp.day;
        final actual = enc.actualHours > 0 ? enc.actualHours : 8.0;
        final existing = mergedMap[day];
        if (existing == null) {
          mergedMap[day] = AccountTimesheetEntity(
            workDate: DateTime(normalizedMonth.year, normalizedMonth.month, day),
            actualWorkTime: actual,
            validActualTime: 0,
            lunch: 0,
            extendedTime: 0,
            leaveTime: 0,
            overtime: 0,
            overtimeScale: 1,
            isConfirmed: false,
            late: enc.lateHours,
            early: enc.earlyHours,
            checkinTime: enc.checkinTime,
            checkoutTime: enc.checkoutTime,
            note: enc.shiftName,
          );
        } else {
          final isRej = existing.isRejected;
          final isConf = existing.isConfirmed;
          mergedMap[day] = existing.copyWith(
            actualWorkTime: existing.actualWorkTime > 0 ? existing.actualWorkTime : actual,
            validActualTime: (isRej || !isConf) ? 0.0 : existing.validActualTime,
            late: enc.lateHours > 0 ? enc.lateHours : existing.late,
            early: enc.earlyHours > 0 ? enc.earlyHours : existing.early,
            checkinTime: enc.checkinTime ?? existing.checkinTime,
            checkoutTime: enc.checkoutTime ?? existing.checkoutTime,
            note: existing.note ?? enc.shiftName,
          );
        }
      }
    }

    // Merge corrections
    for (final cor in corrections) {
      if (cor.workDate != null) {
        final d = AccountTimesheetModel.parseWorkDate(cor.workDate);
        if (d.year == normalizedMonth.year && d.month == normalizedMonth.month) {
          final day = d.day;
          final existing = mergedMap[day];
          final confirmed = cor.confirmedWorktime ?? cor.worktime ?? 8;
          if (existing != null) {
            mergedMap[day] = existing.copyWith(
              actualWorkTime: existing.actualWorkTime > 0 ? existing.actualWorkTime : confirmed,
              validActualTime: confirmed,
              isConfirmed: true,
            );
          }
        }
      }
    }

    final mergedList = mergedMap.values.toList()
      ..sort((a, b) => a.workDate.compareTo(b.workDate));

    emit(state.copyWith(
      status: TimesheetStatus.success,
      items: mergedList,
    ));
  }

  Future<void> previousMonth() async {
    final prev = DateTime(state.selectedMonth.year, state.selectedMonth.month - 1);
    await loadTimesheet(prev);
  }

  Future<void> nextMonth() async {
    final next = DateTime(state.selectedMonth.year, state.selectedMonth.month + 1);
    await loadTimesheet(next);
  }
}
