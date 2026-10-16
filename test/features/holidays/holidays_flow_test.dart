import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/holidays/data/datasources/holidays_remote_datasource.dart';
import 'package:vstech_hrm/features/holidays/data/repositories/holidays_repository_impl.dart';
import 'package:vstech_hrm/features/holidays/domain/repositories/holidays_repository.dart';
import 'package:vstech_hrm/features/holidays/domain/usecases/get_holidays_usecase.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('Flow 5: Holidays OpenAPI Integration Tests', () {
    late MockDioClient mockDioClient;
    late HolidaysRemoteDataSource remoteDataSource;
    late HolidaysRepository repository;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = HolidaysRemoteDataSourceImpl(dioClient: mockDioClient);
      repository = HolidaysRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('TC-HOLI-01: Fetches holidays list and parses national holidays with scale factors', () async {
      final mockResponse = <String, dynamic>{
        'items': <dynamic>[
          <String, dynamic>{
            'code': 'TET_2026',
            'name': 'Tết Nguyên Đán 2026',
            'date': '2026-02-17T00:00:00',
            'symbol': 'L',
            'isActive': true,
            'scale': 3.0,
          },
          <String, dynamic>{
            'code': 'QG_2026',
            'name': 'Quốc khánh 02/09',
            'date': '2026-09-02T00:00:00',
            'symbol': 'L',
            'isActive': true,
            'scale': 3.0,
          },
        ]
      };

      when(() => mockDioClient.get<dynamic>(ApiEndpoints.holidays)).thenAnswer(
        (_) async => Response<dynamic>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.holidays),
        ),
      );

      final useCase = GetHolidaysUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (holidays) {
          expect(holidays.length, equals(2));
          expect(holidays.first.code, equals('TET_2026'));
          expect(holidays.first.scale, equals(3.0));
          expect(holidays.first.isActive, isTrue);
          expect(holidays.last.name, contains('Quốc khánh'));
        },
      );
    });
  });
}
