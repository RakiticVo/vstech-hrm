import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/faq_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/privacy_policy_screen.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('vi'),
    home: child,
  );
}

void main() {
  group('FAQ and Privacy Policy Screens Tests', () {
    testWidgets('FaqScreen renders and expands question dropdown on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildTestApp(const FaqScreen()));
      await tester.pumpAndSettle();

      // Check header and category chips
      expect(find.text('Câu hỏi thường gặp (FAQ)'), findsOneWidget);
      expect(find.text('Tất cả'), findsOneWidget);
      expect(find.text('Chấm công'), findsAtLeastNWidgets(1));

      // First question is initially expanded by default
      expect(find.text('Làm sao để điểm danh khi mất kết nối mạng?'), findsOneWidget);
      expect(
        find.textContaining('Hệ thống hỗ trợ hàng đợi điểm danh ngoại tuyến'),
        findsOneWidget,
      );

      // Tap on second question to expand dropdown
      final secondQuestionFinder = find.text('Tại sao cần xác thực bảo mật khi xem phiếu lương?');
      expect(secondQuestionFinder, findsOneWidget);
      await tester.tap(secondQuestionFinder);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Phiếu lương chứa thông tin tài chính cá nhân nhạy cảm'),
        findsOneWidget,
      );
    });

    testWidgets('PrivacyPolicyScreen renders all policy sections and security banner', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildTestApp(const PrivacyPolicyScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Chính sách bảo mật'), findsAtLeastNWidgets(1));
      expect(find.textContaining('1. Thu thập dữ liệu sinh trắc học'), findsOneWidget);
      expect(find.textContaining('2. Dữ liệu vị trí và chấm công'), findsOneWidget);
      expect(find.textContaining('3. Bảo mật thông tin lương và hồ sơ'), findsOneWidget);
    });
  });
}
