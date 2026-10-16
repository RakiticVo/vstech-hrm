import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/approvals/data/datasources/approvals_remote_datasource.dart';
import 'package:vstech_hrm/features/approvals/data/repositories/approvals_repository_impl.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/admin_confirm_timesheet_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_timesheets_mobile_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_timesheet_usecase.dart';

class MockDioClient extends Mock implements DioClient;

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  group('TimeSheets Mobile & Admin Confirm Integration Tests', () {
    late MockDioClient mockDioClient;
    late ApprovalsRemoteDataSource remoteDataSource;
    late ApprovalsRepository repository;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = ApprovalsRemoteDataSourceImpl(dioClient: mockDioClient);
      repository = ApprovalsRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('TC-TS-01: Manager fetches subordinate daily timesheet via GET /api/TimeSheets/mobile', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.timesheetsMobile,
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'items': <dynamic>[
              <String, dynamic>{
                'code': 'TS-NV0089-20261007',
                'employeeCode': 'NV0089',
                'employee': 'Trần Thị Mai',
                'department': 'Phòng Kinh doanh',
                'actualWorkTime': 8.0,
                'validActualTime': 8.0,
                'shiftHour': 8.0,
                'isConfirmed': false,
                'isConfirmText': 'Chưa xác nhận',
                'workDate': '2026-10-07',
                'note': 'Ca hành chính',
              }
            ],
            'depts': <dynamic>[],
            'statuses': <dynamic>[],
            'employees': <dynamic>[],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetsMobile),
        ),
      );

      final useCase = GetTimesheetsMobileUseCase(repository);
      final result = await useCase(from: '2026-10-01T00:00:00', to: '2026-10-31T23:59:59');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (items) {
          expect(items.length, equals(1));
          expect(items.first.code, equals('TS-NV0089-20261007'));
          expect(items.first.employeeName, equals('Trần Thị Mai'));
          expect(items.first.employeeCode, equals('NV0089'));
          expect(items.first.actualWorkTime, equals(8.0));
          expect(items.first.isConfirmed, isFalse);
        },
      );
    });

    test('TC-TS-02: Manager confirms employee daily timesheet via POST /api/TimeSheets/admin-confirm-timesheet', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.timesheetAdminConfirm,
            data: any<dynamic>(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Xác nhận giờ công thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetAdminConfirm),
        ),
      );

      final useCase = AdminConfirmTimesheetUseCase(repository);
      final result = await useCase(
        employeeCode: 'NV0089',
        workDate: '2026-10-07T00:00:00',
        validActualTime: 8,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (entity) {
          expect(entity.success, isTrue);
          expect(entity.message, equals('Xác nhận giờ công thành công'));
        },
      );
    });

    test('TC-TS-03: Manager rejects employee daily timesheet via POST /api/TimeSheets/reject-timesheet', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.timesheetReject,
            data: any<dynamic>(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Từ chối giờ công thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetReject),
        ),
      );

      final useCase = RejectTimesheetUseCase(repository);
      final result = await useCase(
        employeeCode: 'NV0089',
        workDate: '2026-10-07T00:00:00',
        reason: 'Sai giờ chấm công ca chiều',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (entity) {
          expect(entity.success, isTrue);
          expect(entity.message, equals('Từ chối giờ công thành công'));
        },
      );
    });

    test('TC-TS-04: RejectTimesheetUseCase returns ValidationFailure when reason is empty', () async {
      final useCase = RejectTimesheetUseCase(repository);
      final result = await useCase(
        employeeCode: 'NV0089',
        workDate: '2026-10-07T00:00:00',
        reason: '   ',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, equals('Vui lòng nhập lý do từ chối')),
        (_) => fail('Should fail validation'),
      );
    });
  });
}
