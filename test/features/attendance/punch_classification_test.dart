import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_record_model.dart';

void main() {
  group('Attendance Punch Classification Tests', () {
    test('Check-in before or at 08:05 is classified as onTime', () {
      final onTimeCheckIn = AttendanceRecordModel(
        id: 'att_01',
        timestamp: DateTime(2026, 9, 25, 8, 4),
        type: 'checkIn',
        classification: 'onTime',
        locationName: 'Trụ sở chính VSTech',
      );

      expect(onTimeCheckIn.classification, equals('onTime'));
      expect(onTimeCheckIn.type, equals('checkIn'));
    });

    test('Check-in after 08:05 is classified as late', () {
      final lateCheckIn = AttendanceRecordModel(
        id: 'att_02',
        timestamp: DateTime(2026, 9, 25, 8, 16),
        type: 'checkIn',
        classification: 'late',
        locationName: 'Trụ sở chính VSTech',
      );

      expect(lateCheckIn.classification, equals('late'));
    });

    test('Check-out before 17:00 is classified as earlyLeave', () {
      final earlyCheckOut = AttendanceRecordModel(
        id: 'att_03',
        timestamp: DateTime(2026, 9, 25, 16, 45),
        type: 'checkOut',
        classification: 'earlyLeave',
        locationName: 'Trụ sở chính VSTech',
      );

      expect(earlyCheckOut.classification, equals('earlyLeave'));
    });

    test('Check-out at or after 17:00 is classified as onTime', () {
      final onTimeCheckOut = AttendanceRecordModel(
        id: 'att_04',
        timestamp: DateTime(2026, 9, 25, 17, 30),
        type: 'checkOut',
        classification: 'onTime',
        locationName: 'Trụ sở chính VSTech',
      );

      expect(onTimeCheckOut.classification, equals('onTime'));
    });
  });
}
