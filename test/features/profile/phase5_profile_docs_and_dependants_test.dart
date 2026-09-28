import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/dependant_new_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/dependants_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/document_management_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/profile_edit_screen.dart';
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

  group('Phase 5 Profile Edit, Documents & Dependants Tests', () {
    testWidgets('ProfileEditScreen free edit and sensitive HR review queue', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const ProfileEditScreen()));
      await tester.pumpAndSettle();

      // Check header and sections
      expect(find.text('Chỉnh sửa hồ sơ'), findsOneWidget);
      expect(find.text('Thông tin liên hệ (Cập nhật ngay)'), findsOneWidget);
      expect(find.text('Thông tin định danh & Ngân hàng (Cần HR duyệt)'), findsOneWidget);

      // Modify sensitive field (bank account)
      final bankAccountField = find.widgetWithText(TextFormField, '0071001234821');
      expect(bankAccountField, findsOneWidget);
      await tester.enterText(bankAccountField, '999988887777');
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Lưu thay đổi'));
      await tester.pumpAndSettle();

      // Sensitive change queued for HR
      expect(find.text('Chờ HR duyệt'), findsOneWidget);
      expect(find.textContaining('PR-REQ-2026-042'), findsWidgets);
    });

    testWidgets('DocumentManagementScreen displays expiring alert and watermark contract modal',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const DocumentManagementScreen()));
      await tester.pumpAndSettle();

      // Check expiring document alert
      expect(find.text('Cảnh báo giấy tờ sắp hết hạn'), findsOneWidget);
      expect(find.textContaining('hết hạn sau 15 ngày'), findsOneWidget);

      // Check contracts & legal docs
      expect(find.text('HĐLĐ Xác định thời hạn 24 tháng'), findsOneWidget);
      expect(find.text('Căn cước công dân gắn chip'), findsOneWidget);

      // Tap contract to open watermark viewer
      await tester.tap(find.text('HĐLĐ Xác định thời hạn 24 tháng'));
      await tester.pumpAndSettle();

      // Check digital contract viewer and watermark
      expect(find.text('Hợp đồng lao động điện tử'), findsOneWidget);
      expect(find.textContaining('BẢN SAO ĐIỆN TỬ - NV-04821'), findsOneWidget);
      expect(find.text('Tải về PDF'), findsOneWidget);
    });

    testWidgets('DependantsScreen displays tax relief summary and dependant cards',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const DependantsScreen()));
      await tester.pumpAndSettle();

      // Check summary card
      expect(find.text('Giảm trừ gia cảnh (TNCN)'), findsOneWidget);
      expect(find.text('2 người'), findsOneWidget);
      expect(find.text('8.800.000 ₫'), findsWidgets);

      // Check dependants list
      expect(find.text('Nguyễn Minh Khang'), findsOneWidget);
      expect(find.text('Trần Thị Mai'), findsOneWidget);
      expect(find.text('Đăng ký người phụ thuộc mới'), findsOneWidget);
    });

    testWidgets('DependantNewScreen validates disclaimer and submits registration',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const DependantNewScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Đăng ký người phụ thuộc'), findsOneWidget);

      // Enter form details
      await tester.enterText(find.byType(TextFormField).at(0), 'Nguyễn Minh Quân');
      await tester.enterText(find.byType(TextFormField).at(1), '15/10/2022');
      await tester.enterText(find.byType(TextFormField).at(2), 'GKS: 88/2022/TPHCM');
      await tester.pumpAndSettle();

      // Attempt to submit without checking disclaimer
      await tester.tap(find.text('Gửi hồ sơ đăng ký'));
      await tester.pumpAndSettle();

      expect(
        find.text('Vui lòng xác nhận cam kết trước khi gửi hồ sơ'),
        findsOneWidget,
      );

      // Check disclaimer checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Re-submit
      await tester.tap(find.text('Gửi hồ sơ đăng ký'));
      await tester.pumpAndSettle();

      // Confirmation snackbar shown
      expect(
        find.text('Đã gửi hồ sơ đăng ký người phụ thuộc đến phòng Nhân sự'),
        findsOneWidget,
      );
    });
  });
}
