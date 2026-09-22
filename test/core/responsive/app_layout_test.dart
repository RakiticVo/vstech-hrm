import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';

void main() {
  group('AppLayout and Extensions Tests', () {
    testWidgets('AppLayout.wp and hp calculate correct percentages', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                expect(AppLayout.wp(context, 50), equals(200.0));
                expect(context.wp(25), equals(100.0));
                expect(AppLayout.hp(context, 10), equals(80.0));
                expect(context.hp(50), equals(400.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('AppLayout.custom resolves based on screen category', (tester) async {
      // Test compact screen (< 360dp)
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(320, 600)),
            child: Builder(
              builder: (context) {
                expect(context.isSmallScreen, isTrue);
                expect(context.isLargeScreen, isFalse);
                expect(context.screenType, equals(DeviceScreenType.compact));

                final val = context.custom(
                  normal: 16,
                  compact: 12,
                  expanded: 24,
                );
                expect(val, equals(12.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // Test normal screen (360 - 414dp)
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(390, 844)),
            child: Builder(
              builder: (context) {
                expect(context.isSmallScreen, isFalse);
                expect(context.isLargeScreen, isFalse);
                expect(context.screenType, equals(DeviceScreenType.normal));

                final val = context.custom(
                  normal: 16,
                  compact: 12,
                  expanded: 24,
                );
                expect(val, equals(16.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    test('AppLayoutNumX extensions create SizedBox with correct dimensions', () {
      final gapW = 16.gapW;
      expect(gapW.width, equals(16.0));
      expect(gapW.height, isNull);

      final gapH = 24.gapH;
      expect(gapH.height, equals(24.0));
      expect(gapH.width, isNull);
    });
  });
}
