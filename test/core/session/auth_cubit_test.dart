import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage;

void main() {
  late MockFlutterSecureStorage mockStorage;
  late AuthCubit authCubit;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    authCubit = AuthCubit(secureStorage: mockStorage);

    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => mockStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});
  });

  tearDown(() async {
    await authCubit.close();
  });

  test('initial state is AuthInitial', () {
    expect(authCubit.state, equals(const AuthInitial()));
  });

  test('loginAsDemo emits Authenticated with employee role', () async {
    await authCubit.loginAsDemo(UserRole.employee);

    expect(authCubit.state, isA<Authenticated>());
    final state = authCubit.state as Authenticated;
    expect(state.role, equals(UserRole.employee));
    expect(state.user.role.isEmployee, isTrue);
    expect(state.user.employeeCode, equals('NV0142'));

    verify(() => mockStorage.write(key: AppConstants.tokenStorageKey, value: any(named: 'value')))
        .called(1);
  });

  test('loginAsDemo emits Authenticated with manager role', () async {
    await authCubit.loginAsDemo(UserRole.manager);

    expect(authCubit.state, isA<Authenticated>());
    final state = authCubit.state as Authenticated;
    expect(state.role, equals(UserRole.manager));
    expect(state.user.role.isManager, isTrue);
    expect(state.user.employeeCode, equals('NV0089'));
  });

  test('logout deletes tokens and emits Unauthenticated', () async {
    await authCubit.logout();

    expect(authCubit.state, isA<Unauthenticated>());
    verify(() => mockStorage.delete(key: AppConstants.tokenStorageKey)).called(1);
    verify(() => mockStorage.delete(key: AppConstants.refreshTokenStorageKey)).called(1);
  });
}
