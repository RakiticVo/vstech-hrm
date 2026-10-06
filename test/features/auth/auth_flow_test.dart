import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:vstech_hrm/features/auth/data/models/login_request_model.dart';
import 'package:vstech_hrm/features/auth/data/models/login_result_model.dart';
import 'package:vstech_hrm/features/auth/data/models/user_json_model.dart';
import 'package:vstech_hrm/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vstech_hrm/features/auth/domain/entities/auth_result_entity.dart';
import 'package:vstech_hrm/features/auth/domain/entities/login_params.dart';
import 'package:vstech_hrm/features/auth/domain/repositories/auth_repository.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/login_usecase.dart';

class MockDioClient extends Mock implements DioClient {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginParams(username: 'test', password: 'pwd'));
  });

  group('Flow 1: Auth & Account OpenAPI Integration Tests', () {
    late MockDioClient mockDioClient;
    late AuthRemoteDataSource remoteDataSource;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = AuthRemoteDataSourceImpl(dioClient: mockDioClient);
    });

    test('TC-AUTH-01: Login success with device metadata returns LoginResultModel', () async {
      final mockData = <String, dynamic>{
        'token': 'jwt_test_token_123',
        'validTo': '2026-10-02 23:59',
        'webAllowed': 'NV0142',
        'user': <String, dynamic>{
          'id': 1,
          'userCode': 'NV0142',
          'userName': 'nguyen.an',
          'employeeName': 'Nguyễn Văn An',
          'employeeCode': 'NV0142',
          'email': 'nguyen.an@vstech.vn',
          'avatar': 'avatar.png',
          'claims': <String>['attendance.checkin', 'leave.create'],
        },
      };

      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.login),
        ),
      );

      const request = LoginRequestModel(
        username: 'NV0142',
        password: 'password123',
        deviceId: 'device_uuid_001',
        platform: 'android',
        model: 'Pixel 7',
        brand: 'Google',
      );

      final result = await remoteDataSource.login(request);

      expect(result.token, equals('jwt_test_token_123'));
      expect(result.validTo, equals('2026-10-02 23:59'));
      expect(result.user?.employeeName, equals('Nguyễn Văn An'));
      expect(result.user?.employeeCode, equals('NV0142'));
    });

    test('TC-AUTH-02: Login returns 400 string when account already bound to another device', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: ApiEndpoints.login),
            statusCode: 400,
            data: 'Bạn NV0142 đã đăng nhập trên thiết bị của bạn!!',
          ),
        ),
      );

      const request = LoginRequestModel(
        username: 'NV0142',
        password: 'password123',
        deviceId: 'device_uuid_002',
      );

      expect(
        () => remoteDataSource.login(request),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            contains('Bạn NV0142 đã đăng nhập trên thiết bị của bạn!!'),
          ),
        ),
      );
    });

    test('TC-AUTH-03: Login returns 400 plain text for expired password without JSON crash', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: ApiEndpoints.login),
            statusCode: 400,
            data: 'Mật khẩu đã hết hạn, vui lòng liên hệ HR để đặt lại.',
          ),
        ),
      );

      const request = LoginRequestModel(username: 'NV0142', password: 'old');

      expect(
        () => remoteDataSource.login(request),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            equals('Mật khẩu đã hết hạn, vui lòng liên hệ HR để đặt lại.'),
          ),
        ),
      );
    });

    test('TC-AUTH-04: checkAuth returns true for 200 and false for 401', () async {
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.checkAuth)).thenAnswer(
        (_) async => Response<dynamic>(
          data: '',
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.checkAuth),
        ),
      );

      final isValid = await remoteDataSource.checkAuth();
      expect(isValid, isTrue);

      when(() => mockDioClient.get<dynamic>(ApiEndpoints.checkAuth)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.checkAuth),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: ApiEndpoints.checkAuth),
            statusCode: 401,
          ),
        ),
      );

      final isInvalid = await remoteDataSource.checkAuth();
      expect(isInvalid, isFalse);
    });

    test('AuthCubit login with usecases emits Authenticated on success and saves token', () async {
      final mockRepo = MockAuthRepository();
      final mockStorage = MockFlutterSecureStorage();
      final loginUseCase = LoginUseCase(mockRepo);
      final checkAuthUseCase = CheckAuthUseCase(mockRepo);

      const authEntity = AuthResultEntity(
        token: 'token_abc',
        validTo: '2026-10-02 23:59',
        employeeName: 'Nguyễn Văn An',
        employeeCode: 'NV0142',
        userName: 'nguyen.an',
        userId: 1,
        claims: <String>['attendance.checkin'],
      );

      when(() => mockRepo.login(any())).thenAnswer((_) async => const Right(authEntity));
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
      when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((_) async => null);

      final cubit = AuthCubit(
        secureStorage: mockStorage,
        loginUseCase: loginUseCase,
        checkAuthUseCase: checkAuthUseCase,
      );

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<Authenticated>().having((s) => s.user.employeeCode, 'code', 'NV0142'),
        ]),
      );

      await cubit.login(username: 'NV0142', password: 'password123');

      verify(() => mockStorage.write(key: AppConstants.tokenStorageKey, value: 'token_abc')).called(1);
    });
  });
}
