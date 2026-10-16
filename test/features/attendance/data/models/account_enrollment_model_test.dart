import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_enrollment_model.dart';

void main() {
  group('AccountEnrollmentModel Tests', () {
    test('fromJson parses standard keys and normalizes minutes when in hours', () {
      final json = <String, dynamic>{
        'id': 1001,
        'enrollDate': '2026-10-10',
        'shiftName': 'Ca Hành Chính',
        'department': 'Phòng Kinh Doanh',
        'checkinTime': '08:24:00',
        'checkoutTime': '17:30:00',
        'late': 0.25, // 0.25 hours = 15 minutes
        'early': 0.0,
        'actualTime': 8.0,
      };

      final model = AccountEnrollmentModel.fromJson(json);

      expect(model.id, equals(1001));
      expect(model.enrollDate, equals('2026-10-10'));
      expect(model.checkinTime, equals('08:24:00'));
      expect(model.checkoutTime, equals('17:30:00'));
      expect(model.lateHours, equals(15.0)); // normalized to 15 mins
      expect(model.earlyHours, equals(0.0));
      expect(model.actualTime, equals(8.0));
    });

    test('fromJson parses alternate keys and keeps minute values >= 5.0', () {
      final json = <String, dynamic>{
        'id': 1002,
        'date': '2026-10-10',
        'shiftName': 'Ca Chiều',
        'location': 'Xưởng 1',
        'checkInTime': '13:45',
        'checkOutTime': '21:30',
        'lateMinutes': 25,
        'earlyMinutes': 10,
        'actualWorkTime': 7.5,
      };

      final model = AccountEnrollmentModel.fromJson(json);

      expect(model.id, equals(1002));
      expect(model.enrollDate, equals('2026-10-10'));
      expect(model.department, equals('Xưởng 1'));
      expect(model.checkinTime, equals('13:45'));
      expect(model.checkoutTime, equals('21:30'));
      expect(model.lateHours, equals(25.0));
      expect(model.earlyHours, equals(10.0));
      expect(model.actualTime, equals(7.5));
    });

    test('toAttendanceRecords anchors both in and out timestamps strictly to workDate', () {
      const model = AccountEnrollmentModel(
        id: 1003,
        enrollDate: '2026-10-10',
        shiftName: 'Ca Ngày',
        department: 'Trụ sở chính',
        checkinTime: '08:15:00',
        checkoutTime: '17:30:00',
        lateHours: 15,
        actualTime: 8,
      );

      final records = model.toAttendanceRecords();

      expect(records.length, equals(2));

      final outRec = records.firstWhere((r) => r.type == 'checkOut');
      expect(outRec.timestamp.year, equals(2026));
      expect(outRec.timestamp.month, equals(10));
      expect(outRec.timestamp.day, equals(10));
      expect(outRec.checkinTime, isNotNull);
      expect(outRec.checkoutTime, isNotNull);
      expect(outRec.lateHours, equals(15.0));

      final inRec = records.firstWhere((r) => r.type == 'checkIn');
      expect(inRec.timestamp.year, equals(2026));
      expect(inRec.timestamp.month, equals(10));
      expect(inRec.timestamp.day, equals(10));
      expect(inRec.checkinTime, isNotNull);
      expect(inRec.lateHours, equals(15.0));
    });

    test('toAttendanceRecords creates only checkin record when checkout is missing or 00:00:00', () {
      const model = AccountEnrollmentModel(
        id: 1004,
        enrollDate: '2026-10-10',
        shiftName: 'Ca Sáng',
        checkinTime: '08:00:00',
        checkoutTime: '00:00:00',
      );

      final records = model.toAttendanceRecords();

      expect(records.length, equals(1));
      expect(records.first.type, equals('checkIn'));
      expect(records.first.timestamp.day, equals(10));
      expect(records.first.checkoutTime, isNull);
    });
  });
}
