import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/payroll/data/datasources/payroll_remote_datasource.dart';
import 'package:vstech_hrm/features/payroll/data/repositories/payroll_repository_impl.dart';
import 'package:vstech_hrm/features/payroll/domain/repositories/payroll_repository.dart';
import 'package:vstech_hrm/features/payroll/domain/usecases/get_payroll_summary_usecase.dart';
import 'package:vstech_hrm/features/payroll/domain/usecases/get_payslip_detail_usecase.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('Flow 5: Payroll OpenAPI Integration Tests', () {
    late MockDioClient mockDioClient;
    late PayrollRemoteDataSource remoteDataSource;
    late PayrollRepository repository;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = PayrollRemoteDataSourceImpl(dioClient: mockDioClient);
      repository = PayrollRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('TC-PAY-01: Fetches payslip detail and parses breakdown components correctly', () async {
      const payrollId = 15;
      final mockResponse = <String, dynamic>{
        'message': '',
        'data': <String, dynamic>{
          'item': <String, dynamic>{
            'id': 15,
            'month': '2026-09',
            'employeeCode': 'NV0142',
            'actualBaseSalary': 20000000.0,
            'actualAllowance': 1200000.0,
            'actualLunchFee': 730000.0,
            'actualPhoneFee': 300000.0,
            'actualOvertimeSalary': 1800000.0,
            'actualKpiSalary': 2500000.0,
            'actualIncomeTotal': 26530000.0,
            'taxAddition': 0.0,
            'taxReturn': 0.0,
            'subtractionFund': 3000000.0,
            'sumPayAmount': 23530000.0,
          },
          'timesheets': <dynamic>[],
        }
      };

      when(() => mockDioClient.get<dynamic>(ApiEndpoints.payslipDetail(payrollId))).thenAnswer(
        (_) async => Response<dynamic>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.payslipDetail(payrollId)),
        ),
      );

      final useCase = GetPayslipDetailUseCase(repository);
      final result = await useCase(payrollId);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed: ${failure.message}'),
        (payslip) {
          expect(payslip.id, equals(15));
          expect(payslip.month, equals('2026-09'));
          expect(payslip.actualBaseSalary, equals(20000000.0));
          expect(payslip.actualIncomeTotal, equals(26530000.0));
          expect(payslip.sumPayAmount, equals(23530000.0));
          expect(payslip.subtractionFund, equals(3000000.0));
        },
      );
    });

    test('TC-EXEC-01: Fetches payroll summary by department for management overview', () async {
      const summaryId = 15;
      final mockResponse = <String, dynamic>{
        'message': '',
        'data': <dynamic>[
          <String, dynamic>{
            'departmentCode': 'DEV_MOB',
            'departmentName': 'Phòng Mobile',
            'sumPayAmount': 150000000.0,
            'sumSalaryCost': 175000000.0,
            'staffNum': 6,
          },
          <String, dynamic>{
            'departmentCode': 'QA_QC',
            'departmentName': 'Phòng Kiểm thử',
            'sumPayAmount': 95000000.0,
            'sumSalaryCost': 110000000.0,
            'staffNum': 4,
          },
        ]
      };

      when(() => mockDioClient.get<dynamic>(ApiEndpoints.payrollSummary(summaryId))).thenAnswer(
        (_) async => Response<dynamic>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.payrollSummary(summaryId)),
        ),
      );

      final useCase = GetPayrollSummaryUseCase(repository);
      final result = await useCase(summaryId);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (list) {
          expect(list.length, equals(2));
          expect(list.first.departmentCode, equals('DEV_MOB'));
          expect(list.first.staffNum, equals(6));
          expect(list.first.sumPayAmount, equals(150000000.0));
        },
      );
    });
  });
}
