import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_managed_employees_usecase.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/schedule_remote_datasource.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/schedule_remote_datasource_impl.dart';
import 'package:vstech_hrm/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_department_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_my_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_cubit.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_state.dart';

class MockDioClient extends Mock implements DioClient;
class MockGetMyShiftScheduleUseCase extends Mock implements GetMyShiftScheduleUseCase;
class MockGetDepartmentShiftScheduleUseCase extends Mock implements GetDepartmentShiftScheduleUseCase;
class MockGetManagedEmployeesUseCase extends Mock implements GetManagedEmployeesUseCase;

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  group('ScheduleRepositoryImpl Tests', () {
    late MockDioClient mockDioClient;
    late ScheduleRemoteDataSource remoteDataSource;
    late ScheduleRepository repository;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = ScheduleRemoteDataSourceImpl(dioClient: mockDioClient);
      repository = ScheduleRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('getMyShiftSchedule returns list of MyShiftDayEntity from GET /api/ShiftSchedules/me', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.myShiftSchedules,
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'from': '2026-10-12',
            'to': '2026-10-18',
            'items': <dynamic>[
              <String, dynamic>{
                'date': '2026-10-12',
                'shiftCode': 'HC',
                'shiftName': 'Hành chính (08:00 - 17:00)',
                'startHour': '08:00',
                'endHour': '17:00',
                'isOvernight': false,
                'source': 'SCHEDULE',
              },
              <String, dynamic>{
                'date': '2026-10-13',
                'shiftCode': 'CA1',
                'shiftName': 'Ca sáng (06:00 - 14:00)',
                'startHour': '06:00',
                'endHour': '14:00',
                'isOvernight': false,
                'source': 'DEFAULT',
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.myShiftSchedules),
        ),
      );

      final result = await repository.getMyShiftSchedule(from: '2026-10-12', to: '2026-10-18');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (days) {
          expect(days.length, 2);
          expect(days[0].shiftCode, 'HC');
          expect(days[0].source, 'SCHEDULE');
          expect(days[1].shiftCode, 'CA1');
          expect(days[1].source, 'DEFAULT');
        },
      );
    });

    test('getDepartmentShiftSchedule returns assigned shifts for department', () async {
      when(() => mockDioClient.get<dynamic>(
            ApiEndpoints.shiftSchedules,
            queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'from': '2026-10-12',
            'to': '2026-10-12',
            'items': <dynamic>[
              <String, dynamic>{
                'employeeCode': 'NV001',
                'employeeName': 'Nguyễn Văn A',
                'date': '2026-10-12',
                'shiftCode': 'CA_DEM',
                'shiftName': 'Ca đêm (22:00 - 06:00)',
                'createdBy': 'Trần Quản Lý',
                'createdAt': '2026-10-10T10:00:00Z',
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.shiftSchedules),
        ),
      );

      final result = await repository.getDepartmentShiftSchedule(
        from: '2026-10-12',
        to: '2026-10-12',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (items) {
          expect(items.length, 1);
          expect(items.first.employeeCode, 'NV001');
          expect(items.first.shiftCode, 'CA_DEM');
          expect(items.first.createdBy, 'Trần Quản Lý');
        },
      );
    });
  });

  group('ShiftScheduleCubit State Tests', () {
    late MockGetMyShiftScheduleUseCase mockGetMy;
    late MockGetDepartmentShiftScheduleUseCase mockGetDept;
    late MockGetManagedEmployeesUseCase mockGetManaged;
    late ShiftScheduleCubit cubit;

    setUp(() {
      mockGetMy = MockGetMyShiftScheduleUseCase();
      mockGetDept = MockGetDepartmentShiftScheduleUseCase();
      mockGetManaged = MockGetManagedEmployeesUseCase();
      cubit = ShiftScheduleCubit(
        getMyShiftScheduleUseCase: mockGetMy,
        getDepartmentShiftScheduleUseCase: mockGetDept,
        getManagedEmployeesUseCase: mockGetManaged,
        initialDate: DateTime(2026, 10, 12),
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('loadMyShifts successfully populates weekShifts and selectedShift', () async {
      final sampleDays = [
        MyShiftDayEntity(
          date: DateTime(2026, 10, 12),
          shiftCode: 'HC',
          shiftName: 'Hành chính (08:00 - 17:00)',
          startHour: '08:00',
          endHour: '17:00',
          source: 'SCHEDULE',
        ),
      ];

      when(() => mockGetMy(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async => Right(sampleDays));

      await cubit.loadMyShifts();

      expect(cubit.state.personalStatus, ScheduleLoadingStatus.success);
      expect(cubit.state.myShifts.length, 1);
      expect(cubit.state.weekShifts.length, 7);
      expect(cubit.state.selectedShift?.shiftCode, 'HC');
      expect(cubit.state.selectedShift?.source, 'SCHEDULE');
    });

    test('selectDate updates selectedDate and selectedShift', () async {
      final monday = DateTime(2026, 10, 12);
      final tuesday = DateTime(2026, 10, 13);
      final sampleDays = [
        MyShiftDayEntity(
          date: monday,
          shiftCode: 'HC',
          shiftName: 'Hành chính',
        ),
        MyShiftDayEntity(
          date: tuesday,
          shiftCode: 'CA2',
          shiftName: 'Ca chiều',
        ),
      ];

      when(() => mockGetMy(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async => Right(sampleDays));

      await cubit.loadMyShifts(anchorDate: monday);
      cubit.selectDate(tuesday);

      expect(cubit.state.selectedDate, tuesday);
      expect(cubit.state.selectedShift?.shiftCode, 'CA2');
    });

    test('loadDepartmentRoster calculates counts and filters correctly', () async {
      final testDate = DateTime(2026, 10, 12);
      final subordinates = [
        const ManagedEmployeeEntity(
          code: 'NV01',
          name: 'Nguyễn A',
          departmentCode: 'PB_KD',
          department: 'Phòng Kinh Doanh',
          shiftCode: 'HC',
          shiftName: 'Hành chính',
          shiftStart: '08:00',
          shiftEnd: '17:00',
        ),
        const ManagedEmployeeEntity(
          code: 'NV02',
          name: 'Lê B',
          departmentCode: 'PB_KD',
          department: 'Phòng Kinh Doanh',
          // No default shift => Day Off
        ),
      ];

      final deptAssignments = [
        DepartmentShiftDayEntity(
          employeeCode: 'NV01',
          employeeName: 'Nguyễn A',
          date: testDate,
          shiftCode: 'CA_DEM',
          shiftName: 'Ca đêm (22:00 - 06:00)',
          createdBy: 'Quản lý',
        ),
      ];

      when(() => mockGetManaged(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async => Right(subordinates));
      when(() => mockGetDept(
            from: any(named: 'from'),
            to: any(named: 'to'),
            departmentCode: any(named: 'departmentCode'),
          )).thenAnswer((_) async => Right(deptAssignments));

      await cubit.loadDepartmentRoster(date: testDate);

      expect(cubit.state.rosterStatus, ScheduleLoadingStatus.success);
      expect(cubit.state.rosterItems.length, 2);
      expect(cubit.state.totalRosterEmployees, 2);
      expect(cubit.state.onDutyCount, 1);
      expect(cubit.state.offDutyCount, 1);

      // Search query filtering
      cubit.setSearchQuery('Lê B');
      expect(cubit.state.filteredRosterItems.length, 1);
      expect(cubit.state.filteredRosterItems.first.employeeCode, 'NV02');

      // Shift filter
      cubit.setSearchQuery('');
      cubit.setShiftFilter('OFF');
      expect(cubit.state.filteredRosterItems.length, 1);
      expect(cubit.state.filteredRosterItems.first.employeeCode, 'NV02');

      cubit.setShiftFilter('CA_DEM');
      expect(cubit.state.filteredRosterItems.length, 1);
      expect(cubit.state.filteredRosterItems.first.employeeCode, 'NV01');
      expect(cubit.state.filteredRosterItems.first.source, 'SCHEDULE');
    });
  });
}
