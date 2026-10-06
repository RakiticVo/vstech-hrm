import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/session/locale_cubit.dart';
import 'package:vstech_hrm/core/session/theme_cubit.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/language_selection_sheet.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/theme_selection_sheet.dart';
import 'package:vstech_hrm/features/settings/presentation/screens/settings_screen.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockAuthCubit extends Mock implements AuthCubit {}

class MockThemeCubit extends Mock implements ThemeCubit {}

class MockLocaleCubit extends Mock implements LocaleCubit {}

Widget _wrapWithApp({
  required Widget child,
  required AuthCubit authCubit,
  required ThemeCubit themeCubit,
  required LocaleCubit localeCubit,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>.value(value: authCubit),
      BlocProvider<ThemeCubit>.value(value: themeCubit),
      BlocProvider<LocaleCubit>.value(value: localeCubit),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi'), Locale('en')],
      locale: const Locale('vi'),
      home: child,
    ),
  );
}

void main() {
  final sl = GetIt.instance;
  late MockFlutterSecureStorage mockStorage;
  late MockAuthCubit mockAuthCubit;
  late MockThemeCubit mockThemeCubit;
  late MockLocaleCubit mockLocaleCubit;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockAuthCubit = MockAuthCubit();
    mockThemeCubit = MockThemeCubit();
    mockLocaleCubit = MockLocaleCubit();

    if (sl.isRegistered<FlutterSecureStorage>()) {
      sl.unregister<FlutterSecureStorage>();
    }
    sl.registerLazySingleton<FlutterSecureStorage>(() => mockStorage);

    const user = UserSession(
      id: '1',
      name: 'Nguyen Van An',
      email: 'an@vstech.vn',
      employeeCode: 'NV0142',
      department: 'Tech',
      role: UserRole.employee,
    );
    when(() => mockAuthCubit.state).thenReturn(
      const Authenticated(user: user, token: 'token123', role: UserRole.employee),
    );
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthCubit.logout()).thenAnswer((_) async {});

    when(() => mockThemeCubit.state).thenReturn(ThemeMode.system);
    when(() => mockThemeCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockLocaleCubit.state).thenReturn(const Locale('vi'));
    when(() => mockLocaleCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    if (sl.isRegistered<FlutterSecureStorage>()) {
      sl.unregister<FlutterSecureStorage>();
    }
  });

  group('SettingsScreen Theme, Language & Logout Tests', () {
    testWidgets('Renders ThemeMode and Language items in Display section', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          child: const SettingsScreen(),
          authCubit: mockAuthCubit,
          themeCubit: mockThemeCubit,
          localeCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hiển thị'), findsOneWidget);
      expect(find.text('Chế độ giao diện'), findsOneWidget);
      expect(find.text('Theo hệ thống'), findsOneWidget);
      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
      expect(find.text('VI'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Đăng xuất'), 100);
      expect(find.text('Đăng xuất'), findsOneWidget);
    });

    testWidgets('Tapping ThemeMode opens ThemeSelectionSheet', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          child: const SettingsScreen(),
          authCubit: mockAuthCubit,
          themeCubit: mockThemeCubit,
          localeCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chế độ giao diện'));
      await tester.pumpAndSettle();

      expect(find.byType(ThemeSelectionSheet), findsOneWidget);
      expect(find.text('Chọn chế độ hiển thị'), findsOneWidget);
      expect(find.text('Giao diện sáng'), findsOneWidget);
      expect(find.text('Giao diện tối'), findsOneWidget);
    });

    testWidgets('Tapping Language opens LanguageSelectionSheet', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          child: const SettingsScreen(),
          authCubit: mockAuthCubit,
          themeCubit: mockThemeCubit,
          localeCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ngôn ngữ'));
      await tester.pumpAndSettle();

      expect(find.byType(LanguageSelectionSheet), findsOneWidget);
      expect(find.text('Chọn ngôn ngữ hiển thị'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('Tapping Logout displays confirmation dialog and triggers logout on confirm', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          child: const SettingsScreen(),
          authCubit: mockAuthCubit,
          themeCubit: mockThemeCubit,
          localeCubit: mockLocaleCubit,
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Đăng xuất'), 100);
      await tester.tap(find.text('Đăng xuất'));
      await tester.pumpAndSettle();

      expect(find.text('Xác nhận đăng xuất'), findsOneWidget);
      expect(find.text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng VSTech HRM không?'), findsOneWidget);

      final confirmBtn = find.widgetWithText(ElevatedButton, 'Đăng xuất');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pump();

      verify(() => mockAuthCubit.logout()).called(1);
    });
  });
}
