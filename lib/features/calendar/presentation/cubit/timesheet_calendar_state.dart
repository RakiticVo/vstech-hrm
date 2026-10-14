import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';

enum TimesheetStatus { initial, loading, success, failure }

class TimesheetCalendarState extends Equatable {
  const new({
    required this.selectedMonth,
    this.status = TimesheetStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  final DateTime selectedMonth;
  final TimesheetStatus status;
  final List<AccountTimesheetEntity> items;
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

  /// Count of late/early arrival occurrences.
  int get lateEarlyArrivalsCount {
    return items.where((i) => i.isLate || i.isEarly).length;
  }

  /// Count of incomplete / missing hour days on past weekdays.
  int get incompleteDaysCount {
    return items.where((i) => (i.validActualTime > 0 || i.actualWorkTime > 0) && (i.validActualTime < 8.0 && i.actualWorkTime < 8.0)).length;
  }

  TimesheetCalendarState copyWith({
    DateTime? selectedMonth,
    TimesheetStatus? status,
    List<AccountTimesheetEntity>? items,
    String? errorMessage,
  }) {
    return TimesheetCalendarState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedMonth, status, items, errorMessage];
}
