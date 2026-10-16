import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('vi')],
    locale: const Locale('vi'),
    home: child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 3 Rewards, Commission & Targets 3-Tab Tests', () {
    testWidgets('RewardsScreen renders 3 tabs and displays bonus tab initially', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const RewardsScreen()));
      await tester.pumpAndSettle();

      // Check tab titles
      expect(find.text('Thưởng'), findsWidgets);
      expect(find.text('Hoa hồng'), findsOneWidget);
      expect(find.text('Chỉ tiêu'), findsOneWidget);

      // Check initial Bonus tab contents
      expect(find.text('+2.500.000'), findsOneWidget);
      expect(find.text('Đạt KPI quý 3 — 112%'), findsOneWidget);
      expect(find.text('Lịch sử thưởng'), findsOneWidget);
    });

    testWidgets('RewardsScreen switches to Commission tab and displays 3 sources', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const RewardsScreen()));
      await tester.pumpAndSettle();

      // Tap Commission Tab
      await tester.tap(find.text('Hoa hồng'));
      await tester.pumpAndSettle();

      // Check Commission tab contents
      expect(find.text('Tổng hoa hồng tháng 09/2026'), findsOneWidget);
      expect(find.text('14.850.000 ₫'), findsOneWidget);
      expect(find.text('Bán hàng trực tiếp'), findsWidgets);
      expect(find.text('Doanh số nhóm'), findsWidgets);
      expect(find.text('Tái tục hợp đồng'), findsWidgets);
      expect(find.text('HĐ-2026-0819'), findsOneWidget);
    });

    testWidgets('RewardsScreen switches to Targets tab and displays progress and tiers', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const RewardsScreen()));
      await tester.pumpAndSettle();

      // Tap Targets Tab
      await tester.tap(find.text('Chỉ tiêu'));
      await tester.pumpAndSettle();

      // Check Targets tab contents
      expect(find.text('Chỉ tiêu cá nhân tháng này'), findsOneWidget);
      expect(find.text('90%'), findsOneWidget);
      expect(find.text('Chỉ tiêu đội nhóm chi nhánh'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
      expect(find.text('Các mốc thưởng bậc thang'), findsOneWidget);
      expect(find.text('Đã đạt mốc'), findsOneWidget);
      expect(find.text('Còn thiếu 20.000.000 ₫'), findsOneWidget);
      expect(find.text('Mục tiêu kế tiếp'), findsOneWidget);
    });
  });
}
