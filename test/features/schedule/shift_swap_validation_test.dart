import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/features/schedule/presentation/widgets/shift_swap_modal.dart';

void main() {
  group('Shift Swap Eligibility & Article 109 Validation Tests', () {
    test('ColleagueSwapOption is valid when conflictReason is null', () {
      const option = ColleagueSwapOption(
        name: 'Phạm Thu Hương (NV0091)',
        shiftDesc: 'Ca Chiều (14:00 — 22:00) · Cùng chi nhánh HCM',
      );

      expect(option.isValid, isTrue);
      expect(option.conflictReason, isNull);
    });

    test('ColleagueSwapOption detects rest conflict (< 12 hours Art 109 BLLD 2019)', () {
      const conflictReason = 'Khoảng cách giữa hai ca < 12 giờ (Điều 109 BLLĐ 2019)';
      const option = ColleagueSwapOption(
        name: 'Trần Văn Nam (NV0089)',
        shiftDesc: 'Ca Đêm (22:00 — 06:00)',
        conflictReason: conflictReason,
      );

      expect(option.isValid, isFalse);
      expect(option.conflictReason, contains('12 giờ'));
      expect(option.conflictReason, contains('109'));
    });

    test('ColleagueSwapOption detects on-leave conflict', () {
      const conflictReason = 'Đồng nghiệp đang nghỉ phép vào ngày này';
      const option = ColleagueSwapOption(
        name: 'Lý Quốc Dũng (NV0054)',
        shiftDesc: 'Đang nghỉ phép',
        conflictReason: conflictReason,
      );

      expect(option.isValid, isFalse);
      expect(option.conflictReason, equals(conflictReason));
    });

    test('ColleagueSwapOption detects same-shift conflict', () {
      const conflictReason = 'Hai người đang cùng một ca làm việc';
      const option = ColleagueSwapOption(
        name: 'Nguyễn Thị Mai (NV0077)',
        shiftDesc: 'Ca Sáng (08:00 — 17:00)',
        conflictReason: conflictReason,
      );

      expect(option.isValid, isFalse);
      expect(option.conflictReason, equals(conflictReason));
    });
  });
}
