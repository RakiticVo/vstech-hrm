import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/my_referrals_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/referral_form_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/referral_success_screen.dart';
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

  group('Phase 4 Recruitment & Candidate Referral Tests', () {
    testWidgets('ReferralFormScreen validates inputs and triggers duplicate 6-month error',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const ReferralFormScreen()));
      await tester.pumpAndSettle();

      // Check form fields
      expect(find.text('Giới thiệu ứng viên'), findsOneWidget);
      expect(find.text('Họ và tên ứng viên'), findsOneWidget);
      expect(find.text('Số điện thoại'), findsOneWidget);
      expect(find.text('Email liên hệ'), findsOneWidget);

      // Enter fields with duplicate phone trigger (ends with 9999)
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Nguyễn Văn Trùng',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '0912349999',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'trung@example.com',
      );
      await tester.pumpAndSettle();

      // Tap submit button
      await tester.tap(find.text('Gửi hồ sơ giới thiệu'));
      await tester.pumpAndSettle();

      // Expect duplicate error banner
      expect(
        find.text('Ứng viên này đã có hồ sơ trong hệ thống trong vòng 6 tháng qua'),
        findsOneWidget,
      );
    });

    testWidgets('ReferralSuccessScreen renders tracking code and referral bonus alert',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapWithApp(
          const ReferralSuccessScreen(
            trackingCode: 'REF-2026-0812',
            candidateName: 'Trần Anh Khoa',
            position: 'Quản lý cửa hàng',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gửi giới thiệu thành công'), findsOneWidget);
      expect(find.text('REF-2026-0812'), findsOneWidget);
      expect(find.text('Trần Anh Khoa'), findsOneWidget);
      expect(find.text('Quản lý cửa hàng'), findsOneWidget);
      expect(
        find.text('Thưởng giới thiệu: 3.000.000 ₫ (khi ứng viên qua thử việc)'),
        findsOneWidget,
      );
      expect(find.text('Xem ứng viên tôi đã giới thiệu'), findsOneWidget);
    });

    testWidgets('MyReferralsScreen displays hero card, filter chips, and candidate pipeline list',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const MyReferralsScreen()));
      await tester.pumpAndSettle();

      // Check title and hero banner
      expect(find.text('Ứng viên tôi đã giới thiệu'), findsOneWidget);
      expect(find.text('Link & Mã QR giới thiệu của bạn'), findsOneWidget);
      expect(find.text('Sao chép link'), findsOneWidget);
      expect(find.text('Chia sẻ QR'), findsOneWidget);

      // Check candidates
      expect(find.text('Trần Anh Khoa'), findsOneWidget);
      expect(find.text('REF-2026-0812'), findsOneWidget);
      expect(find.text('Lê Hoàng Yến'), findsOneWidget);
      expect(find.text('Nguyễn Quốc Bảo'), findsOneWidget);
      expect(find.text('Phạm Minh Tuấn'), findsOneWidget);

      // Tap filter chip for 'Đã nhận thưởng (1)'
      await tester.tap(find.text('Đã nhận thưởng (1)'));
      await tester.pumpAndSettle();

      // Only Lê Hoàng Yến should be shown
      expect(find.text('Lê Hoàng Yến'), findsOneWidget);
      expect(find.text('Trần Anh Khoa'), findsNothing);
    });
  });
}
