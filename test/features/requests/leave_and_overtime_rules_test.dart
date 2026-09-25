import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 0 Overtime & Comp-off Business Rules Tests', () {
    test('Overtime rates correctly identified based on day type', () {
      double getRate(DateTime date, {bool isHoliday = false}) {
        if (isHoliday) return 3.0; // 300%
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          return 2.0; // 200%
        }
        return 1.5; // 150%
      }

      final weekday = DateTime(2026, 9, 25); // Friday
      final weekend = DateTime(2026, 9, 27); // Sunday
      final holiday = DateTime(2026, 9, 2); // National Day

      expect(getRate(weekday), equals(1.5));
      expect(getRate(weekend), equals(2.0));
      expect(getRate(holiday, isHoliday: true), equals(3.0));
    });

    test('40h monthly overtime cap validation blocks requests that exceed 40 hours', () {
      bool isOvertimeAllowed(double currentAccumulated, double requestedHours) {
        return (currentAccumulated + requestedHours) <= 40.0;
      }

      // Current accumulated: 28.5h
      const current = 28.5;
      expect(isOvertimeAllowed(current, 3.5), isTrue); // 32.0 <= 40
      expect(isOvertimeAllowed(current, 11.5), isTrue); // 40.0 <= 40
      expect(isOvertimeAllowed(current, 12.0), isFalse); // 40.5 > 40
    });

    test('Comp-off conversion formula equates 8 OT hours to 1 leave day', () {
      double convertOtToCompOffDays(double otHours) {
        return otHours / 8.0;
      }

      expect(convertOtToCompOffDays(8.0), equals(1.0));
      expect(convertOtToCompOffDays(16.0), equals(2.0));
      expect(convertOtToCompOffDays(4.0), equals(0.5));
      expect(convertOtToCompOffDays(24.0), equals(3.0));
    });
  });
}
