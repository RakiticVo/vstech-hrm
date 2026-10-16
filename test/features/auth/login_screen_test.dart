import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/login_screen.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/login_submit_button.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/remember_me_row.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockAuthCubit extends Mock implements AuthCubit {}

Widget _wrapWithApp(Widget child, {AuthCubit? authCubit}) {
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
    home: Scaffold(
      body: authCubit != null
          ? BlocProvider<AuthCubit>.value(value: authCubit, child: child)
          : child,
    ),
  );
}

void main() {
  final sl = GetIt.instance;
  late MockFlutterSecureStorage mockStorage;
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockAuthCubit = MockAuthCubit();

    if (sl.isRegistered<FlutterSecureStorage>()) {
      sl.unregister<FlutterSecureStorage>();
    }
    sl.registerLazySingleton<FlutterSecureStorage>(() => mockStorage);

    when(() => mockAuthCubit.state).thenReturn(const Unauthenticated());
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    if (sl.isRegistered<FlutterSecureStorage>()) {
      sl.unregister<FlutterSecureStorage>();
    }
  });

  group('RememberMeRow & LoginSubmitButton Widget Tests', () {
    testWidgets('RememberMeRow toggles callback when pressed', (tester) async {
      bool? changedValue;
      bool forgotPressed = false;

      await tester.pumpWidget(
        _wrapWithApp(
          RememberMeRow(
            rememberMe: false,
            onChanged: (val) => changedValue = val,
            onForgotPassword: () => forgotPressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ghi nhớ'), findsOneWidget);
      expect(find.text('Quên mật khẩu?'), findsOneWidget);

      await tester.tap(find.text('Ghi nhớ'));
      expect(changedValue, isTrue);

      await tester.tap(find.text('Quên mật khẩu?'));
      expect(forgotPressed, isTrue);
    });

    testWidgets('LoginSubmitButton shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          LoginSubmitButton(
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('ĐĂNG NHẬP HỆ THỐNG'), findsNothing);
    });
  });

  group('LoginScreen Remember Me & Preservation Tests', () {
    testWidgets('Pre-fills saved username and password if keyRememberMe is true', (tester) async {
      when(() => mockStorage.read(key: AppConstants.keyRememberMe))
          .thenAnswer((_) async => 'true');
      when(() => mockStorage.read(key: AppConstants.keySavedUsername))
          .thenAnswer((_) async => 'NV0142');
      when(() => mockStorage.read(key: AppConstants.keySavedPassword))
          .thenAnswer((_) async => 'SecretPass123');

      await tester.pumpWidget(
        _wrapWithApp(
          const LoginScreen(),
          authCubit: mockAuthCubit,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('NV0142'), findsOneWidget);
      expect(find.text('SecretPass123'), findsOneWidget);
    });

    testWidgets('Keeps credentials intact when login fails with Unauthenticated', (tester) async {
      when(() => mockStorage.read(key: AppConstants.keyRememberMe))
          .thenAnswer((_) async => 'false');

      await tester.pumpWidget(
        _wrapWithApp(
          const LoginScreen(),
          authCubit: mockAuthCubit,
        ),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'NV0999');
      await tester.enterText(textFields.at(1), 'wrong_password');
      await tester.pump();

      expect(find.text('NV0999'), findsOneWidget);
      expect(find.text('wrong_password'), findsOneWidget);

      // Verify that after rebuilding or when auth state stays Unauthenticated, inputs remain untouched
      await tester.pump();
      expect(find.text('NV0999'), findsOneWidget);
      expect(find.text('wrong_password'), findsOneWidget);
    });
  });
}
