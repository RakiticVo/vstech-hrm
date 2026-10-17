import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/core/widgets/app_logo.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/splash_screen.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

class MockAuthCubit extends Mock implements AuthCubit;

Widget _wrapWithApp(Widget child, {required AuthCubit authCubit}) {
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
    home: BlocProvider<AuthCubit>.value(
      value: authCubit,
      child: child,
    ),
  );
}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.state).thenReturn(const Unauthenticated());
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthCubit.checkAuthStatus()).thenAnswer((_) async {});
  });

  group('SplashScreen', () {
    testWidgets('renders AppLogo, progress bar and version text, then checks auth after delay', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const SplashScreen(),
          authCubit: mockAuthCubit,
        ),
      );

      // Initial frame
      await tester.pump();

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(AppLogo), findsOneWidget);
      expect(find.text('Phiên bản 2.4.0'), findsOneWidget);

      // Verify auth check has NOT been called at 1 second
      await tester.pump(const Duration(milliseconds: 1000));
      verifyNever(() => mockAuthCubit.checkAuthStatus());

      // Advance past the 2.5s splash duration (1500ms remaining)
      await tester.pump(const Duration(milliseconds: 1500));
      verify(() => mockAuthCubit.checkAuthStatus()).called(1);
    });

    testWidgets('AppLogo legacy badge renders preserved custom VS container',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppLogo.legacyBadge(
              title: 'VSTech HRM',
              subtitle: 'Tuyển dụng – Công – Lương – Thưởng',
            ),
          ),
        ),
      );

      expect(find.text('VS'), findsOneWidget);
      expect(find.text('VSTech HRM'), findsOneWidget);
      expect(find.text('Tuyển dụng – Công – Lương – Thưởng'), findsOneWidget);
    });
  });
}
