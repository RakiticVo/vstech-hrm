import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:vstech_hrm/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:vstech_hrm/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/register_fcm_token_usecase.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('Flow 5: Notifications & FCM OpenAPI Integration Tests', () {
    late MockDioClient mockDioClient;
    late NotificationsRemoteDataSource remoteDataSource;
    late NotificationsRepository repository;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = NotificationsRemoteDataSourceImpl(dioClient: mockDioClient);
      repository = NotificationsRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('TC-NOTIF-01: Fetches notifications, parses read/unread status, marks single and all as read', () async {
      final mockListResponse = <String, dynamic>{
        'data': <dynamic>[
          <String, dynamic>{
            'id': 101,
            'title': 'Đơn xin nghỉ phép đã được duyệt',
            'body': 'Quản lý đã duyệt đơn nghỉ phép ngày 10/10/2026',
            'status': 2,
            'dateSent': '2026-10-02T09:00:00',
          },
          <String, dynamic>{
            'id': 102,
            'title': 'Nhắc nhở chấm công',
            'body': 'Vui lòng hoàn thành chấm công ra ca',
            'status': 1,
            'dateSent': '2026-10-01T17:30:00',
          },
        ]
      };

      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.notifications,
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: mockListResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.notifications),
        ),
      );

      final getUseCase = GetNotificationsUseCase(repository);
      final listResult = await getUseCase();

      expect(listResult.isRight(), isTrue);
      listResult.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (notifs) {
          expect(notifs.length, equals(2));
          expect(notifs.first.isRead, isFalse);
          expect(notifs.last.isRead, isTrue);
        },
      );

      // Mark single as read
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.notificationRead(101))).thenAnswer(
        (_) async => Response<dynamic>(
          data: '',
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.notificationRead(101)),
        ),
      );

      final markSingleUseCase = MarkNotificationReadUseCase(repository);
      final singleResult = await markSingleUseCase(101);
      expect(singleResult.isRight(), isTrue);

      // Mark all as read
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.notificationsReadAll)).thenAnswer(
        (_) async => Response<dynamic>(
          data: '',
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.notificationsReadAll),
        ),
      );

      final markAllUseCase = MarkAllNotificationsReadUseCase(repository);
      final allResult = await markAllUseCase();
      expect(allResult.isRight(), isTrue);
    });

    test('TC-FCM-01: Registers FCM device push token and handles plain text response', () async {
      const sampleToken = 'fcm_mock_token_abc_123_xyz';
      const user = 'NV0142';

      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.fcmSetToken,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: 'token saved',
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.fcmSetToken),
        ),
      );

      final useCase = RegisterFcmTokenUseCase(repository);
      final result = await useCase(token: sampleToken, userName: user);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (msg) => expect(msg, equals('token saved')),
      );

      verify(() => mockDioClient.get<dynamic>(
            ApiEndpoints.fcmSetToken,
            queryParameters: <String, dynamic>{
              'token': sampleToken,
              'userName': user,
            },
          )).called(1);
    });
  });
}
