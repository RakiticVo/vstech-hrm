import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/core/widgets/session_expired_warning_dialog.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

class MockAuthCubit extends Mock implements AuthCubit;

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() async {
    SessionExpiredWarningDialog.resetShowingForTesting();
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.logout()).thenAnswer((_) async {});
    if (sl.isRegistered<AuthCubit>()) {
      await sl.unregister<AuthCubit>();
    }
    sl.registerSingleton<AuthCubit>(mockAuthCubit);
  });

  tearDown(() async {
    SessionExpiredWarningDialog.resetShowingForTesting();
    if (sl.isRegistered<AuthCubit>()) {
      await sl.unregister<AuthCubit>();
    }
  });

  Widget createTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => SessionExpiredWarningDialog.show(context),
              child: const Text('Trigger Dialog'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('SessionExpiredWarningDialog renders warning badge, title, message and relogin button', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trigger Dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(SessionExpiredWarningDialog), findsOneWidget);
    expect(find.text('Phiên đăng nhập hết hạn'), findsOneWidget);
    expect(
      find.text('Phiên làm việc của bạn đã hết hạn hoặc tài khoản được đăng nhập ở thiết bị khác. Vui lòng đăng nhập lại để tiếp tục sử dụng.'),
      findsOneWidget,
    );
    expect(find.text('Đăng nhập lại'), findsOneWidget);
  });

  testWidgets('Tapping relogin triggers logout and closes the dialog', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trigger Dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(SessionExpiredWarningDialog), findsOneWidget);

    await tester.tap(find.text('Đăng nhập lại'));
    await tester.pumpAndSettle();

    verify(() => mockAuthCubit.logout()).called(1);
    expect(find.byType(SessionExpiredWarningDialog), findsNothing);
  });
}
