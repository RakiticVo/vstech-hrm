import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_timesheet_model.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

enum TimesheetStatus { initial, loading, success, failure }

class TimesheetCalendarState extends Equatable {
  const TimesheetCalendarState({
    required this.selectedMonth,
    this.status = TimesheetStatus.initial,
    this.items = const [],
    this.leaveRequests = const [],
    this.overtimeRequests = const [],
    this.correctionRequests = const [],
    this.errorMessage,
  });

  final DateTime selectedMonth;
  final TimesheetStatus status;
  final List<AccountTimesheetEntity> items;
  final List<LeaveItemEntity> leaveRequests;
  final List<OvertimeItemEntity> overtimeRequests;
  final List<CorrectionItemEntity> correctionRequests;
  final String? errorMessage;

  bool get isLoading => status == TimesheetStatus.loading;
  bool get hasError => status == TimesheetStatus.failure;

  /// Map of day number to AccountTimesheetEntity for fast O(1) lookup.
  Map<int, AccountTimesheetEntity> get dayMap {
    final map = <int, AccountTimesheetEntity>{};
    for (final item in items) {
      if (item.workDate.year == selectedMonth.year &&
          item.workDate.month == selectedMonth.month) {
        map[item.workDate.day] = item;
      }
    }
    return map;
  }

  /// Map of day number to leave requests.
  Map<int, List<LeaveItemEntity>> get leaveMap {
    final map = <int, List<LeaveItemEntity>>{};
    for (final req in leaveRequests) {
      final startStr = req.from ?? req.validFrom;
      if (startStr != null) {
        final d = AccountTimesheetModel.parseWorkDate(startStr);
        if (d.year == selectedMonth.year && d.month == selectedMonth.month) {
          map.putIfAbsent(d.day, () => []).add(req);
        }
      }
    }
    return map;
  }

  /// Map of day number to overtime requests.
  Map<int, List<OvertimeItemEntity>> get overtimeMap {
    final map = <int, List<OvertimeItemEntity>>{};
    for (final req in overtimeRequests) {
      if (req.date != null) {
        final d = AccountTimesheetModel.parseWorkDate(req.date);
        if (d.year == selectedMonth.year && d.month == selectedMonth.month) {
          map.putIfAbsent(d.day, () => []).add(req);
        }
      }
    }
    return map;
  }

  /// Map of day number to correction requests.
  Map<int, List<CorrectionItemEntity>> get correctionMap {
    final map = <int, List<CorrectionItemEntity>>{};
    for (final req in correctionRequests) {
      if (req.workDate != null) {
        final d = AccountTimesheetModel.parseWorkDate(req.workDate);
        if (d.year == selectedMonth.year && d.month == selectedMonth.month) {
          map.putIfAbsent(d.day, () => []).add(req);
        }
      }
    }
    return map;
  }

  /// Total payable workdays (sum of valid confirmed workdays + paid leave days).
  /// Strictly requires confirmation (isConfirmed == true and validActualTime > 0)
  /// so unconfirmed days are not counted toward payroll.
  double get payableWorkdays {
    return items.fold<double>(0, (acc, item) {
      if (item.isRejected || !item.isConfirmed) return acc;
      final validWork = item.validActualTime > 0 ? (item.validActualTime / 8.0) : 0.0;
      final leave = item.leaveTime / 8.0;
      return acc + validWork + leave;
    });
  }

  /// Total validated working hours (strictly confirmed).
  double get totalWorkHours {
    return items.fold<double>(0, (acc, item) {
      if (item.isRejected || !item.isConfirmed || item.validActualTime <= 0) return acc;
      return acc + item.validActualTime;
    });
  }

  /// Cumulative overtime hours.
  double get cumulativeOvertime {
    return items.fold<double>(0, (acc, item) => acc + item.overtime);
  }

  /// Total paid leave days.
  double get paidLeaveDays {
    return items.fold<double>(0, (acc, item) => acc + (item.leaveTime / 8.0));
  }

  /// Count of explanation / correction requests submitted this month.
  int get correctionCount => correctionRequests.length;

  /// Total work hours corrected / explained.
  double get correctionHours {
    return correctionRequests.fold<double>(
      0,
      (acc, c) => acc + (c.confirmedWorktime ?? c.worktime ?? 0.0),
    );
  }

  /// Count of late/early arrival occurrences.
  int get lateEarlyArrivalsCount {
    return items.where((i) => i.isLate || i.isEarly).length;
  }

  /// Count of incomplete / missing hour days on past weekdays.
  int get incompleteDaysCount {
    return items
        .where((i) =>
            (i.validActualTime > 0 || i.actualWorkTime > 0) &&
            (i.validActualTime < 8.0 && i.actualWorkTime < 8.0))
        .length;
  }

  TimesheetCalendarState copyWith({
    DateTime? selectedMonth,
    TimesheetStatus? status,
    List<AccountTimesheetEntity>? items,
    List<LeaveItemEntity>? leaveRequests,
    List<OvertimeItemEntity>? overtimeRequests,
    List<CorrectionItemEntity>? correctionRequests,
    String? errorMessage,
  }) {
    return TimesheetCalendarState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      status: status ?? this.status,
      items: items ?? this.items,
      leaveRequests: leaveRequests ?? this.leaveRequests,
      overtimeRequests: overtimeRequests ?? this.overtimeRequests,
      correctionRequests: correctionRequests ?? this.correctionRequests,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedMonth,
        status,
        items,
        leaveRequests,
        overtimeRequests,
        correctionRequests,
        errorMessage,
      ];
}
