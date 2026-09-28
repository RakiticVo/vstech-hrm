import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payslip_detail_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payslip_lock_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/salary_dispute_new_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/salary_dispute_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/widgets/payslip_signed_card.dart';
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

  group('Phase 2 Payslip Security, Signing & Dispute Tests', () {
    testWidgets('PayslipLockScreen renders security header and 6-digit keypad', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const PayslipLockScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Xác thực bảo mật'), findsOneWidget);
      expect(find.text('Nhập mã PIN 6 số hoặc xác thực sinh trắc học để xem phiếu lương'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Quên mã PIN?'), findsOneWidget);
    });

    testWidgets('PayslipDetailScreen renders breakdown, sign and dispute buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const PayslipDetailScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Phiếu lương'), findsOneWidget);
      expect(find.text('Lương cơ bản'), findsOneWidget);
      expect(find.text('Tăng ca 12h (x1.5)'), findsOneWidget);
      expect(find.text('BHXH, BHYT, BHTN (10.5%)'), findsOneWidget);
      expect(find.text('25.500.000 ₫'), findsWidgets);
      expect(find.text('Ký xác nhận phiếu lương'), findsOneWidget);
      expect(find.text('Khiếu nại bảng lương'), findsOneWidget);
    });

    testWidgets('PayslipSignedCard displays verified badge, signer, timestamp and hash', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const Scaffold(
            body: PayslipSignedCard(
              signerName: 'Nguyễn Minh Tuấn (NV-04821)',
              signedAt: '05/10/2026 14:22:08',
              verificationHash: 'SHA256: e7a9c24f8b1d30ac68',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Đã ký điện tử'), findsOneWidget);
      expect(find.text('Người ký: Nguyễn Minh Tuấn (NV-04821)'), findsOneWidget);
      expect(find.text('Thời gian ký: 05/10/2026 14:22:08'), findsOneWidget);
      expect(find.text('Mã băm xác thực: SHA256: e7a9c24f8b1d30ac68'), findsOneWidget);
    });

    testWidgets('SalaryDisputeNewScreen calculates discrepancy dynamically', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapWithApp(
          const SalaryDisputeNewScreen(
            prefilledItem: 'Lương tăng ca 150%',
            prefilledCurrentAmount: 1800000,
            periodMonth: '09/2026',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tạo khiếu nại lương'), findsOneWidget);
      expect(find.text('Tháng 09/2026'), findsOneWidget);
      expect(find.text('1.800.000 ₫'), findsOneWidget);

      // Enter expected amount: 2450000
      final expectedInput = find.byType(TextFormField).first;
      await tester.enterText(expectedInput, '2450000');
      await tester.pumpAndSettle();

      expect(find.text('Chênh lệch đề xuất'), findsOneWidget);
      expect(find.text('+650.000 ₫'), findsOneWidget);
      expect(find.text('Gửi khiếu nại'), findsOneWidget);
    });

    testWidgets('SalaryDisputeScreen renders disputes list and allows tab filtering', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const SalaryDisputeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Quản lý Khiếu nại lương'), findsOneWidget);
      expect(find.text('KN-2026-0418'), findsOneWidget);
      expect(find.text('+650.000 ₫'), findsOneWidget);
      expect(find.text('+200.000 ₫'), findsOneWidget);

      // Filter to Pending
      await tester.tap(find.widgetWithText(ChoiceChip, 'Đang đối soát'));
      await tester.pumpAndSettle();
      expect(find.text('KN-2026-0418'), findsOneWidget);
      expect(find.text('KN-2026-0390'), findsNothing);
    });
  });
}
