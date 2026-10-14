import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_managed_employees_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_leave_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_overtime_approvals_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_department_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_my_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_cubit.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_state.dart';

class MockGetMyShiftScheduleUseCase extends Mock implements GetMyShiftScheduleUseCase;
class MockGetDepartmentShiftScheduleUseCase extends Mock implements GetDepartmentShiftScheduleUseCase;
class MockGetManagedEmployeesUseCase extends Mock implements GetManagedEmployeesUseCase;
class MockGetPendingLeaveApprovalsUseCase extends Mock implements GetPendingLeaveApprovalsUseCase;
class MockGetPendingOvertimeApprovalsUseCase extends Mock implements GetPendingOvertimeApprovalsUseCase;
class MockGetPendingApprovalsUseCase extends Mock implements GetPendingApprovalsUseCase;

void main() {
  group('Roster Tickets Integration Tests', () {
    late MockGetMyShiftScheduleUseCase mockGetMy;
    late MockGetDepartmentShiftScheduleUseCase mockGetDept;
    late MockGetManagedEmployeesUseCase mockGetManaged;
    late MockGetPendingLeaveApprovalsUseCase mockGetLeave;
    late MockGetPendingOvertimeApprovalsUseCase mockGetOt;
    late MockGetPendingApprovalsUseCase mockGetCorr;
    late ShiftScheduleCubit cubit;

    final targetDate = DateTime(2026, 10, 14);

    setUp(() {
      mockGetMy = MockGetMyShiftScheduleUseCase();
      mockGetDept = MockGetDepartmentShiftScheduleUseCase();
      mockGetManaged = MockGetManagedEmployeesUseCase();
      mockGetLeave = MockGetPendingLeaveApprovalsUseCase();
      mockGetOt = MockGetPendingOvertimeApprovalsUseCase();
      mockGetCorr = MockGetPendingApprovalsUseCase();

      cubit = ShiftScheduleCubit(
        getMyShiftScheduleUseCase: mockGetMy,
        getDepartmentShiftScheduleUseCase: mockGetDept,
        getManagedEmployeesUseCase: mockGetManaged,
        getPendingLeaveApprovalsUseCase: mockGetLeave,
        getPendingOvertimeApprovalsUseCase: mockGetOt,
        getPendingApprovalsUseCase: mockGetCorr,
        initialDate: targetDate,
      );
    });

    tearDown(() async {
      await cubit.close();
    });

    test('loadDepartmentRoster fetches tickets and maps correctly to matching employees', () async {
      final subordinates = [
        const ManagedEmployeeEntity(
          code: 'NV01',
          name: 'Nguyễn Văn A',
          departmentCode: 'DEPT_IT',
          department: 'Công nghệ thông tin',
          shiftCode: 'HC',
          shiftName: 'Hành chính (08:00 - 17:00)',
        ),
        const ManagedEmployeeEntity(
          code: 'NV02',
          name: 'Trần Thị B',
          departmentCode: 'DEPT_IT',
          department: 'Công nghệ thông tin',
        ),
      ];

      final assignedShifts = [
        DepartmentShiftDayEntity(
          employeeCode: 'NV01',
          employeeName: 'Nguyễn Văn A',
          date: targetDate,
          shiftCode: 'HC',
          shiftName: 'Hành chính',
          createdBy: 'Quản lý',
        ),
      ];

      final sampleLeaves = <LeaveItemEntity>[
        const LeaveItemEntity(
          code: 'LEAVE_101',
          leavePlan: 'Nghỉ phép năm',
          statusText: 'Đã duyệt',
          status: 2,
          employeeCode: 'NV01',
          employeeName: 'Nguyễn Văn A',
          from: '2026-10-14',
          to: '2026-10-14',
        ),
      ];

      final sampleOvertimes = <OvertimeItemEntity>[
        const OvertimeItemEntity(
          code: 'OT_201',
          statusText: 'Đã duyệt',
          status: 2,
          isLock: false,
          employeeCode: 'NV01',
          employeeName: 'Nguyễn Văn A',
          date: '2026-10-14',
          length: 2.5,
          overtimeTypeName: 'Tăng ca sau giờ',
        ),
      ];

      final sampleCorrections = <CorrectionItemEntity>[
        const CorrectionItemEntity(
          id: 301,
          employeeCode: 'NV01',
          employeeName: 'Nguyễn Văn A',
          workDate: '2026-10-14',
          worktime: 8.0,
          reasonTypeName: 'Quên chấm công ra',
          confirmLevel: 1,
        ),
      ];

      when(() => mockGetManaged(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async => Right(subordinates));
      when(() => mockGetDept(
            from: any(named: 'from'),
            to: any(named: 'to'),
            departmentCode: any(named: 'departmentCode'),
          )).thenAnswer((_) async => Right(assignedShifts));
      when(() => mockGetLeave(month: any(named: 'month')))
          .thenAnswer((_) async => Right(sampleLeaves));
      when(() => mockGetOt(month: any(named: 'month')))
          .thenAnswer((_) async => Right(sampleOvertimes));
      when(() => mockGetCorr(month: any(named: 'month')))
          .thenAnswer((_) async => Right(sampleCorrections));

      await cubit.loadDepartmentRoster(date: targetDate);

      expect(cubit.state.rosterStatus, ScheduleLoadingStatus.success);
      expect(cubit.state.rosterItems.length, 2);

      final nv01 = cubit.state.rosterItems.firstWhere((e) => e.employeeCode == 'NV01');
      expect(nv01.hasTickets, isTrue);
      expect(nv01.leaveRequests.length, 1);
      expect(nv01.leaveRequests.first.leavePlan, 'Nghỉ phép năm');
      expect(nv01.overtimeRequests.length, 1);
      expect(nv01.overtimeRequests.first.length, 2.5);
      expect(nv01.correctionRequests.length, 1);
      expect(nv01.correctionRequests.first.reasonTypeName, 'Quên chấm công ra');

      final nv02 = cubit.state.rosterItems.firstWhere((e) => e.employeeCode == 'NV02');
      expect(nv02.hasTickets, isFalse);
      expect(nv02.leaveRequests, isEmpty);
      expect(nv02.overtimeRequests, isEmpty);
      expect(nv02.correctionRequests, isEmpty);
    });
  });
}
