import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/shift_schedule_mock_datasource.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';

void main() {
  group('OfflineAttendanceService Tests', () {
    test('calculateSimilarity returns 1.0 for identical vectors', () {
      final v = [1.0, 2.0, 3.0];
      final sim = OfflineAttendanceService.calculateSimilarity(v, v);
      expect((sim - 1.0).abs() < 1e-5, isTrue);
    });

    test('calculateSimilarity returns 0.0 for orthogonal vectors', () {
      final v1 = [1.0, 0.0];
      final v2 = [0.0, 1.0];
      final sim = OfflineAttendanceService.calculateSimilarity(v1, v2);
      expect(sim, equals(0.0));
    });

    test('calculateSimilarity handles empty vectors safely', () {
      final sim = OfflineAttendanceService.calculateSimilarity([], []);
      expect(sim, equals(0.0));
    });

    test('defaultBaselineVector generates 128-dimensional embedding', () {
      final baseline = OfflineAttendanceService.defaultBaselineVector;
      expect(baseline.length, equals(128));
    });

    test('simulateScanVector achieves >= 85% similarity threshold', () {
      final baseline = OfflineAttendanceService.defaultBaselineVector;
      final simulated = OfflineAttendanceService.simulateScanVector(baseline);
      expect(simulated.length, equals(128));

      final similarity = OfflineAttendanceService.calculateSimilarity(baseline, simulated);
      expect(similarity >= OfflineAttendanceService.matchThreshold, isTrue);
    });
  });

  group('ShiftScheduleMockDatasource Tests', () {
    test('getWeekShifts returns 7 shifts representing full week', () {
      final shifts = ShiftScheduleMockDatasource.getWeekShifts();
      expect(shifts.length, equals(7));

      final days = shifts.map((s) => s.dayOfWeek).toList();
      expect(days, equals(['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']));
    });

    test('Sunday shift is configured as Day Off', () {
      final shifts = ShiftScheduleMockDatasource.getWeekShifts();
      final sunday = shifts.firstWhere((s) => s.dayOfWeek == 'CN');

      expect(sunday.isDayOff, isTrue);
      expect(sunday.status, equals(ShiftStatus.dayOff));
      expect(sunday.formattedTime, equals('Nghỉ tuần'));
    });

    test('Weekday shifts have valid start and end times', () {
      final shifts = ShiftScheduleMockDatasource.getWeekShifts();
      final tuesday = shifts.firstWhere((s) => s.dayOfWeek == 'T3');

      expect(tuesday.isDayOff, isFalse);
      expect(tuesday.startTime, equals('08:00'));
      expect(tuesday.endTime, equals('16:30'));
      expect(tuesday.status, equals(ShiftStatus.active));
    });
  });
}
