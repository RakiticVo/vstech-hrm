import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_validation_helper.dart';

void main() {
  group('Phase 0 Overtime & Comp-off Business Rules Tests', () {
    test('Overtime rates correctly identified based on day type', () {
      double getRate(DateTime date, {bool isHoliday = false}) {
        if (isHoliday) return 3; // 300%
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          return 2; // 200%
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
      expect(isOvertimeAllowed(current, 12), isFalse); // 40.5 > 40
    });

    test('Comp-off conversion formula equates 8 OT hours to 1 leave day', () {
      double convertOtToCompOffDays(double otHours) {
        return otHours / 8;
      }

      expect(convertOtToCompOffDays(8), equals(1.0));
      expect(convertOtToCompOffDays(16), equals(2.0));
      expect(convertOtToCompOffDays(4), equals(0.5));
      expect(convertOtToCompOffDays(24), equals(3.0));
    });

    test('Manager proxy overtime creation skips maxHourOvertime validation', () {
      const type = OvertimeTypeEntity(code: 'OT_WEEKDAY', name: 'Tăng ca ngày thường');
      const validInfo = ValidMaxHourEntity(maxHour: 4.0, isLock: false);

      // Normal employee request: 6h > 4h maxHour -> blocked
      final employeeErr = OvertimeValidationHelper.validateSubmission(
        selectedType: type,
        reason: 'Làm bù dự án',
        length: 6.0,
        validInfo: validInfo,
        skipMaxHour: false,
      );
      expect(employeeErr, isNotNull);
      expect(employeeErr, contains('vượt quá giới hạn tối đa cho phép'));

      // Manager proxy request (skipMaxHour = true): 6h > 4h maxHour -> allowed!
      final managerErr = OvertimeValidationHelper.validateSubmission(
        selectedType: type,
        reason: 'Quản lý duyệt dự án đặc biệt',
        length: 6.0,
        validInfo: validInfo,
        skipMaxHour: true,
      );
      expect(managerErr, isNull);

      // If timesheet is locked, both are blocked
      const lockedInfo = ValidMaxHourEntity(maxHour: 18.0, isLock: true, message: 'Kỳ công đã đóng');
      final lockedErr = OvertimeValidationHelper.validateSubmission(
        selectedType: type,
        reason: 'Quản lý tạo',
        length: 2.0,
        validInfo: lockedInfo,
        skipMaxHour: true,
      );
      expect(lockedErr, equals('Kỳ công đã đóng'));
    });
  });
}
