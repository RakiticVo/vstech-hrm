import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_account_timesheet_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_attendance_history_usecase.dart';
import 'package:vstech_hrm/features/calendar/presentation/cubit/timesheet_calendar_cubit.dart';
import 'package:vstech_hrm/features/calendar/presentation/cubit/timesheet_calendar_state.dart';

class MockGetAccountTimesheetUseCase extends Mock implements GetAccountTimesheetUseCase {}

class MockGetAttendanceHistoryUseCase extends Mock implements GetAttendanceHistoryUseCase {}

void main() {
  late MockGetAccountTimesheetUseCase mockUseCase;
  late TimesheetCalendarCubit cubit;

  final testDate = DateTime(2026, 10, 1);
  final sampleItems = [
    AccountTimesheetEntity(
      workDate: DateTime(2026, 10, 5),
      actualWorkTime: 8.5,
      validActualTime: 8.0,
      lunch: 1.0,
      extendedTime: 0.0,
      leaveTime: 0.0,
      overtime: 1.5,
      overtimeScale: 1.5,
      isConfirmed: true,
      note: 'Đúng giờ',
    ),
    AccountTimesheetEntity(
      workDate: DateTime(2026, 10, 6),
      actualWorkTime: 4.0,
      validActualTime: 4.0,
      lunch: 0.0,
      extendedTime: 0.0,
      leaveTime: 4.0,
      overtime: 0.0,
      overtimeScale: 1.0,
      isConfirmed: true,
      note: 'Nửa ngày phép',
    ),
  ];

  setUp(() {
    mockUseCase = MockGetAccountTimesheetUseCase();
    cubit = TimesheetCalendarCubit(
      getAccountTimesheetUseCase: mockUseCase,
      initialMonth: testDate,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('TimesheetCalendarCubit Tests', () {
    test('initial state has correct selectedMonth and initial status', () {
      expect(cubit.state.selectedMonth.year, equals(2026));
      expect(cubit.state.selectedMonth.month, equals(10));
      expect(cubit.state.status, equals(TimesheetStatus.initial));
      expect(cubit.state.items, isEmpty);
    });

    test('loadTimesheet emits success and computes metrics correctly', () async {
      when(() => mockUseCase.call(monthYear: any(named: 'monthYear')))
          .thenAnswer((_) async => right(sampleItems));

      await cubit.loadTimesheet();

      expect(cubit.state.status, equals(TimesheetStatus.success));
      expect(cubit.state.items.length, equals(2));
      expect(cubit.state.dayMap.containsKey(5), isTrue);
      expect(cubit.state.dayMap.containsKey(6), isTrue);

      // Total valid hours: 8.0 + 4.0 = 12.0
      expect(cubit.state.totalWorkHours, equals(12.0));
      // Overtime: 1.5
      expect(cubit.state.cumulativeOvertime, equals(1.5));
      // Leave: 4.0 / 8.0 = 0.5 days
      expect(cubit.state.paidLeaveDays, equals(0.5));
      // Payable workdays: (8.0/8.0) + (4.0/8.0 + 4.0/8.0) = 1.0 + 1.0 = 2.0 days
      expect(cubit.state.payableWorkdays, equals(2.0));
    });

    test('loadTimesheet emits failure when use case returns ServerFailure', () async {
      when(() => mockUseCase.call(monthYear: any(named: 'monthYear')))
          .thenAnswer((_) async => left(const ServerFailure(message: 'Lỗi máy chủ')));

      await cubit.loadTimesheet();

      expect(cubit.state.status, equals(TimesheetStatus.failure));
      expect(cubit.state.errorMessage, equals('Lỗi máy chủ'));
    });

    test('previousMonth and nextMonth update selectedMonth and reload', () async {
      when(() => mockUseCase.call(monthYear: any(named: 'monthYear')))
          .thenAnswer((_) async => right([]));

      await cubit.previousMonth();
      expect(cubit.state.selectedMonth.month, equals(9));

      await cubit.nextMonth();
      expect(cubit.state.selectedMonth.month, equals(10));
    });

    test('loadTimesheet merges enrollments and preserves checkinTime, late, early on day 10', () async {
      final mockHist = MockGetAttendanceHistoryUseCase();
      final cubitWithHist = TimesheetCalendarCubit(
        getAccountTimesheetUseCase: mockUseCase,
        getAttendanceHistoryUseCase: mockHist,
        initialMonth: testDate,
      );

      when(() => mockUseCase.call(monthYear: any(named: 'monthYear')))
          .thenAnswer((_) async => right([]));
      when(() => mockHist.call(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async => right([
                AttendanceRecordEntity(
                  id: '101_in',
                  timestamp: DateTime(2026, 10, 10, 8, 24),
                  type: AttendanceType.checkIn,
                  classification: AttendanceClassification.late,
                  locationName: 'Trụ sở chính',
                  checkinTime: '08:24',
                  checkoutTime: '17:30',
                  lateHours: 24,
                ),
              ]));

      await cubitWithHist.loadTimesheet();

      expect(cubitWithHist.state.dayMap.containsKey(10), isTrue);
      final day10 = cubitWithHist.state.dayMap[10]!;
      expect(day10.checkinTime, equals('08:24'));
      expect(day10.checkoutTime, equals('17:30'));
      expect(day10.late, equals(24));
      expect(day10.early, equals(0));
      expect(day10.isConfirmed, isFalse);
      expect(day10.validActualTime, equals(0.0));
      await cubitWithHist.close();
    });
  });
}
