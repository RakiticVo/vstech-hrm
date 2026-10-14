import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/timesheet_detail_cards.dart';
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
  group('TimesheetTimeCard Late & Early Conditional Visibility Tests', () {
    testWidgets('hides Đi muộn and Về sớm when both are zero', (tester) async {
      final rec = AttendanceRecordEntity(
        id: '1',
        timestamp: DateTime(2026, 10, 12, 8, 0),
        type: AttendanceType.checkIn,
        classification: AttendanceClassification.onTime,
        locationName: 'Văn phòng',
        actualHours: 8.0,
        validHours: 8.0,
        lateHours: 0.0,
        earlyHours: 0.0,
        isConfirmed: true,
      );

      await tester.pumpWidget(_wrapWidget(TimesheetTimeCard(record: rec)));
      await tester.pumpAndSettle();

      expect(find.text('Đi muộn'), findsNothing);
      expect(find.text('Về sớm'), findsNothing);
      expect(find.text('8.0 giờ'), findsNWidgets(2));
    });

    testWidgets('shows Đi muộn and hides Về sớm when only late > 0', (tester) async {
      final rec = AttendanceRecordEntity(
        id: '2',
        timestamp: DateTime(2026, 10, 12, 8, 15),
        type: AttendanceType.checkIn,
        classification: AttendanceClassification.late,
        locationName: 'Văn phòng',
        actualHours: 7.75,
        validHours: 8.0,
        lateHours: 15.0,
        earlyHours: 0.0,
      );

      await tester.pumpWidget(_wrapWidget(TimesheetTimeCard(record: rec)));
      await tester.pumpAndSettle();

      expect(find.text('Đi muộn'), findsOneWidget);
      expect(find.text('15 phút'), findsOneWidget);
      expect(find.text('Về sớm'), findsNothing);
    });

    testWidgets('shows both Đi muộn and Về sớm when both > 0', (tester) async {
      final rec = AttendanceRecordEntity(
        id: '3',
        timestamp: DateTime(2026, 10, 12, 8, 20),
        type: AttendanceType.checkIn,
        classification: AttendanceClassification.late,
        locationName: 'Văn phòng',
        actualHours: 7.0,
        validHours: 7.0,
        lateHours: 20.0,
        earlyHours: 10.0,
      );

      await tester.pumpWidget(_wrapWidget(TimesheetTimeCard(record: rec)));
      await tester.pumpAndSettle();

      expect(find.text('Đi muộn'), findsOneWidget);
      expect(find.text('20 phút'), findsOneWidget);
      expect(find.text('Về sớm'), findsOneWidget);
      expect(find.text('10 phút'), findsOneWidget);
    });
  });

  group('TimesheetDayDetailSheet Late & Early Conditional Visibility Tests', () {
    testWidgets('hides Đi muộn and Về sớm when timesheet has 0 late and early', (tester) async {
      final timesheet = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 12),
        actualWorkTime: 8.0,
        validActualTime: 8.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: true,
        late: 0.0,
        early: 0.0,
        checkinTime: '08:00',
        checkoutTime: '17:00',
      );

      await tester.pumpWidget(
        _wrapWidget(TimesheetDayDetailSheet(date: DateTime(2026, 10, 12), timesheet: timesheet)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Đi muộn'), findsNothing);
      expect(find.text('Về sớm'), findsNothing);
      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('17:00'), findsOneWidget);
    });

    testWidgets('shows Đi muộn and hides Về sớm when late > 0', (tester) async {
      final timesheet = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 12),
        actualWorkTime: 7.5,
        validActualTime: 8.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: true,
        late: 30.0,
        early: 0.0,
        checkinTime: '08:30',
        checkoutTime: '17:00',
      );

      await tester.pumpWidget(
        _wrapWidget(TimesheetDayDetailSheet(date: DateTime(2026, 10, 12), timesheet: timesheet)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Đi muộn'), findsOneWidget);
      expect(find.text('30 phút'), findsOneWidget);
      expect(find.text('Về sớm'), findsNothing);
    });

    testWidgets('shows Nghỉ phép and Tăng ca when timesheet has leaveTime and overtime', (tester) async {
      final rec = AttendanceRecordEntity(
        id: '1',
        timestamp: DateTime(2026, 10, 12, 8, 0),
        type: AttendanceType.checkIn,
        classification: AttendanceClassification.onTime,
        locationName: 'Văn phòng',
        actualHours: 8.0,
        validHours: 8.0,
      );
      final ts = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 12),
        actualWorkTime: 8.0,
        validActualTime: 8.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 4.0,
        overtime: 2.0,
        overtimeScale: 1.5,
        isConfirmed: true,
      );

      await tester.pumpWidget(_wrapWidget(TimesheetTimeCard(record: rec, timesheet: ts)));
      await tester.pumpAndSettle();

      expect(find.text('Nghỉ phép'), findsOneWidget);
      expect(find.text('4.0h (0.5 ngày)'), findsOneWidget);
      expect(find.text('Tăng ca'), findsOneWidget);
      expect(find.text('+2.0h'), findsOneWidget);
    });

    testWidgets('hides Nghỉ phép and Tăng ca when timesheet has 0 leaveTime and 0 overtime', (tester) async {
      final rec = AttendanceRecordEntity(
        id: '1',
        timestamp: DateTime(2026, 10, 12, 8, 0),
        type: AttendanceType.checkIn,
        classification: AttendanceClassification.onTime,
        locationName: 'Văn phòng',
        actualHours: 8.0,
        validHours: 8.0,
      );
      final ts = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 12),
        actualWorkTime: 8.0,
        validActualTime: 8.0,
        lunch: 0.0,
        extendedTime: 0.0,
        leaveTime: 0.0,
        overtime: 0.0,
        overtimeScale: 1.0,
        isConfirmed: true,
      );

      await tester.pumpWidget(_wrapWidget(TimesheetTimeCard(record: rec, timesheet: ts)));
      await tester.pumpAndSettle();

      expect(find.text('Nghỉ phép'), findsNothing);
      expect(find.text('Tăng ca'), findsNothing);
    });
  });
}
