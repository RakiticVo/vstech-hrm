import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/capture_photo_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/day_one_guide_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/digital_contract_sign_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/document_upload_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/ocr_verification_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/offer_letter_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/onboarding_home_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/org_chart_intro_screen.dart';
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

  group('Phase 6 Full Candidate Onboarding Experience Tests', () {
    testWidgets('OnboardingHomeScreen renders countdown hero and 7 checklist steps', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const OnboardingHomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Hành trình Hội nhập'), findsOneWidget);
      expect(find.text('Chào mừng bạn gia nhập VSTECH!'), findsOneWidget);
      expect(find.text('Nguyễn Minh Tuấn'), findsOneWidget);
      expect(find.text('Còn 3 ngày nữa'), findsOneWidget);
      expect(find.text('Xem & Chấp thuận Thư mời nhận việc'), findsOneWidget);
      expect(find.text('Ký hợp đồng thử việc điện tử'), findsOneWidget);
      expect(find.text('Cẩm nang Ngày đầu tiên đi làm'), findsOneWidget);
      expect(find.text('Thực hiện bước tiếp theo'), findsOneWidget);
    });

    testWidgets('OfferLetterScreen displays probation salary and accepted status', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const OfferLetterScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Thư mời nhận việc (Offer)'), findsOneWidget);
      expect(find.text('Giám sát cửa hàng'), findsWidgets);
      expect(find.text('17.000.000 ₫ / tháng'), findsOneWidget);
      expect(find.text('14.450.000 ₫ / tháng'), findsOneWidget);
      expect(find.text('Đã chấp thuận Offer'), findsWidgets);
    });

    testWidgets('OrgChartIntroScreen renders buddy card and 4-tier hierarchy', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const OrgChartIntroScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Đội ngũ & Người đồng hành'), findsOneWidget);
      expect(find.text('Người hướng dẫn (Buddy) của bạn'), findsOneWidget);
      expect(find.text('Lê Thu Hà'), findsWidgets);
      expect(find.text('Buddy 60 Ngày'), findsOneWidget);
      expect(find.text('Gọi điện'), findsOneWidget);
      expect(find.text('Nhắn tin'), findsOneWidget);
      expect(find.text('Trần Văn Cường (BGĐ)'), findsOneWidget);
      expect(find.text('Nguyễn Minh Tuấn (Bạn)'), findsOneWidget);
    });

    testWidgets('DocumentUploadScreen uploads missing required documents', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const DocumentUploadScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Nộp hồ sơ nhân sự'), findsOneWidget);
      expect(find.text('Đã nộp 2/4 tài liệu'), findsOneWidget);
      expect(find.text('Tải lên'), findsNWidgets(2));

      // Tap upload on first missing document
      await tester.tap(find.text('Tải lên').first);
      await tester.pumpAndSettle();

      // Upload count increases to 3/4
      expect(find.text('Đã nộp 3/4 tài liệu'), findsOneWidget);
      expect(find.text('Tải lên'), findsOneWidget);
    });

    testWidgets('CapturePhotoScreen provides viewfinder and captures badge photo', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const CapturePhotoScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Chụp ảnh thẻ nhân viên'), findsOneWidget);
      expect(find.text('Căn chỉnh khuôn mặt vào khung bầu dục'), findsOneWidget);

      // Tap capture button
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();

      expect(find.text('Ảnh đạt tiêu chuẩn 3x4'), findsOneWidget);
      expect(find.text('Chụp lại'), findsOneWidget);
      expect(find.text('Xác nhận dùng ảnh này'), findsOneWidget);
    });

    testWidgets('OcrVerificationScreen renders scanned chip and verified data', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const OcrVerificationScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Xác thực danh tính (OCR CCCD)'), findsOneWidget);
      expect(find.text('Đã xác thực trùng khớp 100%'), findsOneWidget);
      expect(find.text('079094001234'), findsOneWidget);
      expect(find.text('NGUYEN MINH TUAN'), findsOneWidget);
      expect(find.text('Tiếp tục: Ký hợp đồng điện tử'), findsOneWidget);
    });

    testWidgets('DigitalContractSignScreen validates OTP and completes signing', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const DigitalContractSignScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Hợp đồng thử việc điện tử'), findsOneWidget);
      expect(find.text('Xác thực mã OTP ký hợp đồng'), findsOneWidget);
      expect(find.text('Xác nhận ký hợp đồng'), findsOneWidget);

      // Tap sign
      await tester.tap(find.text('Xác nhận ký hợp đồng'));
      await tester.pumpAndSettle();

      expect(find.text('Hợp đồng đã ký điện tử thành công'), findsOneWidget);
      expect(find.text('Đã ký điện tử'), findsOneWidget);
      expect(find.text('Tiếp tục: Cẩm nang Ngày đầu tiên'), findsOneWidget);
    });

    testWidgets('DayOneGuideScreen renders time, address, buddy and preparation list', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapWithApp(const DayOneGuideScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Cẩm nang Ngày đầu tiên'), findsOneWidget);
      expect(find.text('08:30 SÁNG · 01/10/2026'), findsOneWidget);
      expect(find.text('Trụ sở chính VSTECH TP.HCM'), findsOneWidget);
      expect(find.text('Những điều cần lưu ý cho Ngày 1'), findsOneWidget);
      expect(find.text('Mang theo CCCD bản gốc'), findsOneWidget);
      expect(find.text('Trang phục chuẩn Smart Casual'), findsOneWidget);
      expect(find.text('Gửi xe tại hầm B2'), findsOneWidget);
      expect(find.text('Tôi đã sẵn sàng cho Ngày 1!'), findsOneWidget);
    });
  });
}
