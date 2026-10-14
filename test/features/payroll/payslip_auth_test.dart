import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';
import 'package:vstech_hrm/features/payroll/presentation/helpers/payslip_auth_helper.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockLocalAuthentication extends Mock implements LocalAuthentication {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late MockLocalAuthentication mockLocalAuth;
  late MockAuthRepository mockAuthRepository;

  setUp(() async {
    mockStorage = MockFlutterSecureStorage();
    mockLocalAuth = MockLocalAuthentication();
    mockAuthRepository = MockAuthRepository();

    if (sl.isRegistered<FlutterSecureStorage>()) {
      await sl.unregister<FlutterSecureStorage>();
    }
    if (sl.isRegistered<AuthRepository>()) {
      await sl.unregister<AuthRepository>();
    }

    sl
      ..registerSingleton<FlutterSecureStorage>(mockStorage)
      ..registerSingleton<AuthRepository>(mockAuthRepository);
  });

  tearDown(() async {
    if (sl.isRegistered<FlutterSecureStorage>()) {
      await sl.unregister<FlutterSecureStorage>();
    }
    if (sl.isRegistered<AuthRepository>()) {
      await sl.unregister<AuthRepository>();
    }
  });

  group('PayslipAuthHelper Tests', () {
    test('isBiometricsAvailable returns false if not enabled in settings', () async {
      when(() => mockStorage.read(key: AppConstants.keyBiometricEnabled))
          .thenAnswer((_) async => 'false');

      final result = await PayslipAuthHelper.isBiometricsAvailable(mockLocalAuth);
      expect(result, isFalse);
      verifyNever(() => mockLocalAuth.isDeviceSupported());
    });

    test('isBiometricsAvailable returns true if enabled in settings and supported', () async {
      when(() => mockStorage.read(key: AppConstants.keyBiometricEnabled))
          .thenAnswer((_) async => 'true');
      when(() => mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
      when(() => mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);

      final result = await PayslipAuthHelper.isBiometricsAvailable(mockLocalAuth);
      expect(result, isTrue);
    });

    test('verifyPassword returns true when password matches saved password', () async {
      when(() => mockStorage.read(key: AppConstants.keySavedPassword))
          .thenAnswer((_) async => 'secret123');

      final result = await PayslipAuthHelper.verifyPassword(
        password: 'secret123',
        isDemo: false,
        employeeCode: 'NV0142',
      );
      expect(result, isTrue);
    });

    test('verifyPassword returns false when demo password is incorrect', () async {
      when(() => mockStorage.read(key: AppConstants.keySavedPassword))
          .thenAnswer((_) async => null);

      final result = await PayslipAuthHelper.verifyPassword(
        password: 'wrong_password',
        isDemo: true,
        employeeCode: 'NV0142',
      );
      expect(result, isFalse);
    });

    test('verifyPassword accepts default demo password and saves to storage', () async {
      when(() => mockStorage.read(key: AppConstants.keySavedPassword))
          .thenAnswer((_) async => null);
      when(() => mockStorage.write(key: AppConstants.keySavedPassword, value: '123456'))
          .thenAnswer((_) async {});

      final result = await PayslipAuthHelper.verifyPassword(
        password: '123456',
        isDemo: true,
        employeeCode: 'NV0142',
      );
      expect(result, isTrue);
      verify(() => mockStorage.write(key: AppConstants.keySavedPassword, value: '123456')).called(1);
    });
  });
}
