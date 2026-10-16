import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_timesheet_model.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/calendar/presentation/cubit/timesheet_calendar_state.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_month_grid_card.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/timesheet_day_detail_sheet.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

Widget _wrapWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('vi'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  group('Rejected Timesheet Entity & Model Tests', () {
    test('AccountTimesheetEntity identifies rejected timesheet and extracts reason', () {
      final entity = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 7),
        actualWorkTime: 8.0,
        validActualTime: 0.0,
        lunch: 1.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: false,
        note: '[Từ chối bởi NV0001] Quên quẹt thẻ ra về | Ca hành chính',
      );

      expect(entity.isRejected, isTrue);
      expect(entity.rejectReason, equals('Quên quẹt thẻ ra về'));
    });

    test('AccountTimesheetModel.toEntity sets validActualTime to 0.0 when rejected', () {
      final model = AccountTimesheetModel(
        workDate: '2026-10-07',
        actualWorkTime: 8.0,
        validActualTime: 8.0, // Server returns 8.0 before rejection handling
        lunch: 1.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: false,
        note: '[Từ chối bởi NV0001] Không có dữ liệu vân tay',
      );

      final entity = model.toEntity();
      expect(entity.isRejected, isTrue);
      expect(entity.actualWorkTime, equals(8.0));
      expect(entity.validActualTime, equals(0.0));
    });

    test('TimesheetCalendarState excludes rejected timesheets from payableWorkdays', () {
      final normal = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 6),
        actualWorkTime: 8.0,
        validActualTime: 8.0,
        lunch: 1.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: true,
      );

      final rejected = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 7),
        actualWorkTime: 8.0,
        validActualTime: 0.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: false,
        note: '[Từ chối bởi NV0001] Bị từ chối',
      );

      final state = TimesheetCalendarState(
        selectedMonth: DateTime(2026, 10, 1),
        items: [normal, rejected],
      );

      // Only normal day is payable (1.0 day, 8.0h), rejected day is NOT payable
      expect(state.payableWorkdays, equals(1.0));
      expect(state.totalWorkHours, equals(8.0));
    });
  });

  group('Rejected Day UI Widget Tests', () {
    testWidgets('CalendarMonthGridCard colors day 7 as red (not green) when rejected', (tester) async {
      final rejected = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 7),
        actualWorkTime: 8.0,
        validActualTime: 0.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: false,
        note: '[Từ chối bởi QL] Quên chấm công',
      );

      await tester.pumpWidget(
        _wrapWidget(
          CalendarMonthGridCard(
            selectedMonth: DateTime(2026, 10, 1),
            isLoading: false,
            hasError: false,
            dayMap: {7: rejected},
            onPreviousMonth: () {},
            onNextMonth: () {},
            onDayTap: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('TimesheetDayDetailSheet shows Đã từ chối badge, 0.0h valid hours, and reject reason', (tester) async {
      final rejected = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 7),
        actualWorkTime: 8.0,
        validActualTime: 0.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: false,
        note: '[Từ chối bởi NV0001] Quên quẹt thẻ ra về',
        checkinTime: '08:00',
        checkoutTime: '17:00',
      );

      await tester.pumpWidget(
        _wrapWidget(
          TimesheetDayDetailSheet(
            date: DateTime(2026, 10, 7),
            timesheet: rejected,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Đã từ chối'), findsOneWidget);
      expect(find.text('8.0h'), findsOneWidget); // Actual hours worked
      expect(find.text('0.0h'), findsOneWidget); // Valid hours
      expect(find.text('Lý do từ chối'), findsOneWidget);
      expect(find.text('Quên quẹt thẻ ra về'), findsOneWidget);
    });

    testWidgets('TimesheetDayDetailSheet shows Chờ xác nhận badge and 0.0h valid hours when isConfirmed is false', (tester) async {
      final unconfirmed = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 10),
        actualWorkTime: 8.0,
        validActualTime: 0.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: false,
        note: 'Ca chuẩn',
        checkinTime: '08:00',
        checkoutTime: '17:00',
      );

      await tester.pumpWidget(
        _wrapWidget(
          TimesheetDayDetailSheet(
            date: DateTime(2026, 10, 10),
            timesheet: unconfirmed,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Chưa xác nhận'), findsOneWidget);
      expect(find.text('8.0h'), findsOneWidget); // Actual hours worked
      expect(find.text('0.0h'), findsOneWidget); // Valid hours must be 0.0h when unconfirmed
    });
  });
}
