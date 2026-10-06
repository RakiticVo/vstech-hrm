import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/requests/data/datasources/requests_remote_datasource.dart';
import 'package:vstech_hrm/features/requests/data/repositories/requests_repository_impl.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/cancel_leave_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_correction_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_leave_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_overtime_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_reasons_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_plans_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_types_usecase.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('Flow 3: Requests Center OpenAPI Integration Tests', () {
    late MockDioClient mockDioClient;
    late RequestsRemoteDataSource remoteDataSource;
    late RequestsRepository repository;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = RequestsRemoteDataSourceImpl(dioClient: mockDioClient);
      repository = RequestsRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('TC-LEAVE-01: Create leave request submits to /api/LeaveRequests successfully', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.leaveRequests,
            data: any<dynamic>(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Đơn xin nghỉ phép đã được tạo'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.leaveRequests),
        ),
      );

      final useCase = CreateLeaveRequestUseCase(repository);
      const params = CreateLeaveParams(
        from: '2026-10-07',
        to: '2026-10-07',
        validFrom: '2026-10-06',
        validTo: '2027-03-31',
        leavePlanCode: 'PN2026',
        leaveAmountType: 1.0,
        halfShiftType: null,
        note: '',
      );
      expect(params.from, equals('2026-10-07'));
      expect(params.to, equals('2026-10-07'));
      expect(params.validFrom, equals('2026-10-06'));
      expect(params.validTo, equals('2027-03-31'));

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (success) => expect(success, isTrue),
      );
      verify(() => mockDioClient.post<dynamic>(
            ApiEndpoints.leaveRequests,
            data: any<dynamic>(
              named: 'data',
              that: isA<Map<String, dynamic>>()
                  .having((m) => m['from'], 'from', '2026-10-07')
                  .having((m) => m['to'], 'to', '2026-10-07')
                  .having((m) => m['validFrom'], 'validFrom', '2026-10-06')
                  .having((m) => m['validTo'], 'validTo', '2027-03-31')
                  .having((m) => m['isMultiple'], 'isMultiple', false)
                  .having((m) => m['leaveAmountType'], 'leaveAmountType', '1')
                  .having((m) => m['leavePlanCode'], 'leavePlanCode', 'PN2026')
                  .having((m) => m['note'], 'note', '')
                  .having((m) => m['halfShiftType'], 'halfShiftType', isNull),
            ),
          )).called(1);
    });

    test('TC-LEAVE-02: Cancel leave request revokes request with DELETE /api/LeaveRequests/self/{id}', () async {
      const requestId = 'LR-9988';
      when(() => mockDioClient.delete<dynamic>(
            ApiEndpoints.leaveRequestDelete(requestId),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Đã hủy đơn thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.leaveRequestDelete(requestId)),
        ),
      );

      final useCase = CancelLeaveRequestUseCase(repository);
      final result = await useCase(requestId);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (success) => expect(success, isTrue),
      );
      verify(() => mockDioClient.delete<dynamic>(
            ApiEndpoints.leaveRequestDelete(requestId),
          )).called(1);
    });

    test('TC-OT-01: Create overtime request submits to /api/OvertimeRequests successfully', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.overtimeRequests,
            data: any<dynamic>(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Đăng ký tăng ca thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.overtimeRequests),
        ),
      );

      final useCase = CreateOvertimeRequestUseCase(repository);
      const params = CreateOvertimeParams(
        employeeCode: 'NV0142',
        date: '2026-10-02',
        length: 2.5,
        overtimeTypeCode: 'WEEKDAY_OT',
        startOvertime: '18:00',
        endOvertime: '20:30',
        note: 'Fix bug release version 1.2',
      );

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (success) => expect(success, isTrue),
      );
      verify(() => mockDioClient.post<dynamic>(
            ApiEndpoints.overtimeRequests,
            data: any<dynamic>(named: 'data'),
          )).called(1);
    });

    test('TC-CORRECT-01: getCorrectionReasons parses reason options with validation flags', () async {
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.timesheetConfirmReasons)).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'data': <dynamic>[
              <String, dynamic>{
                'code': 'RS_FORGOT',
                'name': 'Quên chấm công',
                'mustHaveNote': true,
                'mustHaveImage': false,
              },
              <String, dynamic>{
                'code': 'RS_CLIENT',
                'name': 'Gặp khách hàng ngoài công ty',
                'mustHaveNote': true,
                'mustHaveImage': true,
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetConfirmReasons),
        ),
      );

      final useCase = GetCorrectionReasonsUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (reasons) {
          expect(reasons.length, equals(2));
          expect(reasons.first.code, equals('RS_FORGOT'));
          expect(reasons.first.mustHaveNote, isTrue);
          expect(reasons.last.mustHaveImage, isTrue);
        },
      );
    });

    test('TC-CORRECT-02: Create correction request posts to /api/TimesheetConfirmRequests successfully', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.timesheetConfirmRequests,
            data: any<dynamic>(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Gửi phiếu giải trình thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetConfirmRequests),
        ),
      );

      final useCase = CreateCorrectionRequestUseCase(repository);
      const params = CreateCorrectionParams(
        employeeCode: 'NV0142',
        workDate: '2026-10-01',
        worktime: 8,
        reasonTypeCode: 'RS_FORGOT',
        note: 'Quên chấm công buổi sáng do họp khẩn',
        latitude: 10.7769,
        longitude: 106.7009,
        address: 'Quận 1, TP. Hồ Chí Minh',
      );

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (success) => expect(success, isTrue),
      );
      verify(() => mockDioClient.post<dynamic>(
            ApiEndpoints.timesheetConfirmRequests,
            data: any<dynamic>(named: 'data'),
          )).called(1);
    });

    test('TC-LEAVE-03: Get leave plans from /api/LeaveRequests/self?init=1&version=1', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.leaveRequestsSelf,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'leavePlans': <dynamic>[
              <String, dynamic>{'code': 'LP_ANNUAL', 'name': 'Nghỉ phép năm', 'amount': 12.0},
              <String, dynamic>{'code': 'LP_SICK', 'name': 'Nghỉ ốm', 'amount': 30.0},
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.leaveRequestsSelf),
        ),
      );

      final useCase = GetLeavePlansUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (plans) {
          expect(plans.length, equals(2));
          expect(plans.first.code, equals('LP_ANNUAL'));
          expect(plans.last.name, equals('Nghỉ ốm'));
        },
      );
    });

    test('TC-OT-03: Get overtime types from /api/OvertimeRequests/self?init=1', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.overtimeRequestsSelf,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'overtimeTypes': <dynamic>[
              <String, dynamic>{'code': 'OT_WEEKDAY', 'name': 'Ngày thường', 'scale': 1.5},
              <String, dynamic>{'code': 'OT_WEEKEND', 'name': 'Cuối tuần', 'scale': 2.0},
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.overtimeRequestsSelf),
        ),
      );

      final useCase = GetOvertimeTypesUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (types) {
          expect(types.length, equals(2));
          expect(types.first.code, equals('OT_WEEKDAY'));
          expect(types.first.scale, equals(1.5));
        },
      );
    });
  });
}
