import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_enrollment_model.dart';
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
  group('AccountEnrollmentModel lateWarning and earlyWarning parsing', () {
    test('parses lateWarning and earlyWarning from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 1834448,
        'enrollDate': '2026-10-12',
        'shiftName': 'Ca Sản Xuất A',
        'department': 'Phân xưởng 1',
        'checkinTime': '01:15:00',
        'checkoutTime': '09:45:00',
        'late': 15.0,
        'early': 10.0,
        'lateWarning': true,
        'earlyWarning': true,
        'actualTime': 7.5,
      };

      final model = AccountEnrollmentModel.fromJson(json);
      expect(model.id, 1834448);
      expect(model.lateWarning, isTrue);
      expect(model.earlyWarning, isTrue);
      expect(model.lateHours, 15.0);
      expect(model.earlyHours, 10.0);

      final records = model.toAttendanceRecords();
      expect(records.length, 2);

      // Check-out record
      final outRecord = records.firstWhere((r) => r.type == 'checkOut');
      expect(outRecord.classification, 'earlyLeave');
      expect(outRecord.earlyWarning, isTrue);

      // Check-in record
      final inRecord = records.firstWhere((r) => r.type == 'checkIn');
      expect(inRecord.classification, 'late');
      expect(inRecord.lateWarning, isTrue);
    });

    test('respects false lateWarning and earlyWarning flags', () {
      final json = <String, dynamic>{
        'id': 1834449,
        'enrollDate': '2026-10-12',
        'shiftName': 'Ca Hành Chính',
        'checkinTime': '01:00:00',
        'checkoutTime': '10:00:00',
        'late': 0.0,
        'early': 0.0,
        'lateWarning': false,
        'earlyWarning': false,
      };

      final model = AccountEnrollmentModel.fromJson(json);
      expect(model.lateWarning, isFalse);
      expect(model.earlyWarning, isFalse);

      final records = model.toAttendanceRecords();
      final inRecord = records.firstWhere((r) => r.type == 'checkIn');
      expect(inRecord.classification, 'onTime');
      expect(inRecord.lateWarning, isFalse);
    });
  });

  group('TimesheetOverviewCard lateWarning and earlyWarning widget rendering', () {
    testWidgets('renders late status when record.lateWarning is true', (tester) async {
      final rec = AttendanceRecordEntity(
        id: '1',
        timestamp: DateTime(2026, 10, 12, 8, 15),
        type: AttendanceType.checkIn,
        classification: AttendanceClassification.onTime,
        locationName: 'Xưởng 1',
        lateWarning: true,
        lateHours: 15,
      );

      await tester.pumpWidget(_wrapWidget(TimesheetOverviewCard(record: rec)));
      await tester.pumpAndSettle();

      expect(find.text('Đi muộn (15 phút)'), findsOneWidget);
    });

    testWidgets('renders early status when record.earlyWarning is true', (tester) async {
      final rec = AttendanceRecordEntity(
        id: '2',
        timestamp: DateTime(2026, 10, 12, 16, 45),
        type: AttendanceType.checkOut,
        classification: AttendanceClassification.onTime,
        locationName: 'Xưởng 1',
        earlyWarning: true,
        earlyHours: 15,
      );

      await tester.pumpWidget(_wrapWidget(TimesheetOverviewCard(record: rec)));
      await tester.pumpAndSettle();

      expect(find.text('Về sớm (15 phút)'), findsOneWidget);
    });
  });

  group('TimesheetDayDetailSheet lateWarning and earlyWarning widget rendering', () {
    testWidgets('renders warning indicator when timesheet.lateWarning is true', (tester) async {
      final ts = AccountTimesheetEntity(
        workDate: DateTime(2026, 10, 12),
        actualWorkTime: 7.5,
        validActualTime: 7.5,
        lunch: 0,
        extendedTime: 0,
        leaveTime: 0,
        overtime: 0,
        overtimeScale: 1,
        isConfirmed: false,
        late: 15,
        lateWarning: true,
      );

      await tester.pumpWidget(
        _wrapWidget(
          TimesheetDayDetailSheet(date: DateTime(2026, 10, 12), timesheet: ts),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15 phút'), findsOneWidget);
    });
  });
}
