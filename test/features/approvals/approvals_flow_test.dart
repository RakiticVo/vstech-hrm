import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/approvals/data/datasources/approvals_remote_datasource.dart';
import 'package:vstech_hrm/features/approvals/data/repositories/approvals_repository_impl.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_leave_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_overtime_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_timesheet_correction_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_leave_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_overtime_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_leave_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_overtime_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_timesheet_correction_usecase.dart';

class MockDioClient extends Mock implements DioClient;

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  group('Flow 4: Manager Approvals OpenAPI Integration Tests', () {
    late MockDioClient mockDioClient;
    late ApprovalsRemoteDataSource remoteDataSource;
    late ApprovalsRepository repository;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = ApprovalsRemoteDataSourceImpl(dioClient: mockDioClient);
      repository = ApprovalsRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('TC-APPV-01: Manager approves and rejects leave request via ConfirmRequests/leave API', () async {
      const requestId = 'LR-001';
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.leaveAccept(requestId))).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Đơn xin nghỉ phép đã được duyệt'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.leaveAccept(requestId)),
        ),
      );
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.leaveDeny(requestId))).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Đơn xin nghỉ phép đã bị từ chối'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.leaveDeny(requestId)),
        ),
      );

      final approveUseCase = ApproveLeaveUseCase(repository);
      final rejectUseCase = RejectLeaveUseCase(repository);

      final approveResult = await approveUseCase(requestId);
      expect(approveResult.isRight(), isTrue);
      approveResult.fold(
        (failure) => fail('Should succeed'),
        (entity) {
          expect(entity.success, isTrue);
          expect(entity.message, equals('Đơn xin nghỉ phép đã được duyệt'));
        },
      );

      final rejectResult = await rejectUseCase(requestId);
      expect(rejectResult.isRight(), isTrue);
      rejectResult.fold(
        (failure) => fail('Should succeed'),
        (entity) {
          expect(entity.success, isTrue);
          expect(entity.message, equals('Đơn xin nghỉ phép đã bị từ chối'));
        },
      );
    });

    test('TC-APPV-02: Overtime approval calls /overtime/accept and /overtime/Deny exact non-standard paths', () async {
      const overtimeId = 'OT-099';
      expect(ApiEndpoints.overtimeAccept(overtimeId), equals('/overtime/accept/OT-099'));
      expect(ApiEndpoints.overtimeDeny(overtimeId), equals('/overtime/Deny/OT-099'));

      when(() => mockDioClient.get<dynamic>(ApiEndpoints.overtimeAccept(overtimeId))).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Đơn tăng ca đã duyệt'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.overtimeAccept(overtimeId)),
        ),
      );
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.overtimeDeny(overtimeId))).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Đơn tăng ca bị từ chối'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.overtimeDeny(overtimeId)),
        ),
      );

      final approveUseCase = ApproveOvertimeUseCase(repository);
      final rejectUseCase = RejectOvertimeUseCase(repository);

      final approveResult = await approveUseCase(overtimeId);
      expect(approveResult.isRight(), isTrue);

      final rejectResult = await rejectUseCase(overtimeId);
      expect(rejectResult.isRight(), isTrue);
    });

    test('TC-APPV-03: Timesheet regularization approval & rejection posts with confirmed hours and reason', () async {
      const correctionId = 42;
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.timesheetConfirmAccept(correctionId),
            data: any<dynamic>(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Xác nhận giải trình công thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetConfirmAccept(correctionId)),
        ),
      );
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.timesheetConfirmReject(correctionId),
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'message': 'Từ chối giải trình công thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetConfirmReject(correctionId)),
        ),
      );

      final approveUseCase = ApproveTimesheetCorrectionUseCase(repository);
      final rejectUseCase = RejectTimesheetCorrectionUseCase(repository);

      final approveResult = await approveUseCase(
        correctionId,
        confirmedWorktime: 8,
        note: 'Đã xác nhận với bảo vệ ca sáng',
      );
      expect(approveResult.isRight(), isTrue);

      final rejectResult = await rejectUseCase(
        correctionId,
        note: 'Không có minh chứng hợp lệ',
      );
      expect(rejectResult.isRight(), isTrue);
    });

    test('TC-APPV-03b: Manager fetches subordinate timesheet confirm requests via admin-mobile endpoint', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.timesheetConfirmRequestsAdminMobile,
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'data': <dynamic>[
              <String, dynamic>{
                'id': 101,
                'employeeCode': 'NV0091',
                'workDate': '2026-10-01',
                'worktime': 8.0,
                'reasonTypeName': 'Quên chấm công',
                'confirmLevel': 0,
                'isReject': false,
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.timesheetConfirmRequestsAdminMobile),
        ),
      );

      final useCase = GetPendingApprovalsUseCase(repository);
      final result = await useCase(month: '2026-10');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (items) {
          expect(items.length, equals(1));
          expect(items.first.id, equals(101));
          expect(items.first.employeeCode, equals('NV0091'));
          expect(items.first.isPending, isTrue);
        },
      );
    });

    test('TC-APPV-04: Manager fetches subordinate leave requests via admin-mobile endpoint', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.leaveRequestsAdminMobile,
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'data': <dynamic>[
              <String, dynamic>{
                'code': 'LR-002',
                'leavePlan': 'Nghỉ phép năm',
                'employeeCode': 'NV0089',
                'employeeName': 'Trần Thị Mai',
                'departmentName': 'Kinh doanh',
                'from': '2026-10-10',
                'to': '2026-10-10',
                'status': 0,
                'statusText': 'Chờ duyệt',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.leaveRequestsAdminMobile),
        ),
      );

      final useCase = GetPendingLeaveApprovalsUseCase(repository);
      final result = await useCase(month: '2026-10');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (items) {
          expect(items.length, equals(1));
          expect(items.first.code, equals('LR-002'));
          expect(items.first.employeeName, equals('Trần Thị Mai'));
          expect(items.first.employeeCode, equals('NV0089'));
        },
      );
    });

    test('TC-APPV-05: Manager fetches subordinate overtime requests via admin-mobile endpoint', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.overtimeRequestsAdminMobile,
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'items': <dynamic>[
              <String, dynamic>{
                'code': 'OT-002',
                'employee': 'Lê Văn Cường',
                'employeeCode': 'NV0102',
                'dateStr': '2026-10-09',
                'overtimeTimeStr': '18:00 - 20:30',
                'overtimeType': 'Tăng ca ngày thường',
                'status': 0,
                'statusText': 'Chờ duyệt',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.overtimeRequestsAdminMobile),
        ),
      );

      final useCase = GetPendingOvertimeApprovalsUseCase(repository);
      final result = await useCase(month: '2026-10');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (items) {
          expect(items.length, equals(1));
          expect(items.first.code, equals('OT-002'));
          expect(items.first.employeeName, equals('Lê Văn Cường'));
          expect(items.first.employeeCode, equals('NV0102'));
        },
      );
    });
  });
}
