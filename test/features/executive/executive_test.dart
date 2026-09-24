import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';
import 'package:vstech_hrm/features/executive/domain/entities/final_approval_entity.dart';
import 'package:vstech_hrm/features/executive/domain/repositories/executive_repository.dart';
import 'package:vstech_hrm/features/executive/domain/usecases/executive_usecases.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/executive_cubit.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/executive_state.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/final_approval_cubit.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/final_approval_state.dart';

class MockExecutiveRepository extends Mock implements ExecutiveRepository {}

void main() {
  late MockExecutiveRepository mockRepo;
  late GetExecutiveOverviewUseCase getOverviewUseCase;
  late GetFinalApprovalQueueUseCase getQueueUseCase;
  late ApproveFinalRequestUseCase approveUseCase;
  late RejectFinalRequestUseCase rejectUseCase;
  late ApproveAllFinalRequestsUseCase approveAllUseCase;
  late ExecutiveCubit execCubit;
  late FinalApprovalCubit approvalCubit;

  const testStats = ExecutiveStatsEntity(
    totalHeadcount: 3142,
    todayAttendanceRate: 98.2,
    monthlyPayrollVnd: 42800000000,
    payrollGrowthPercentage: 3.4,
    monthlyOvertimeHours: 14280,
    avgOvertimePerWorker: 18.2,
    turnoverRate: 0.8,
    pendingFinalApprovalsCount: 4,
    oldestPendingHours: 18,
    flaggedRisks: [],
    departmentRates: [],
  );

  final testApprovalItem = FinalApprovalItemEntity(
    id: 'FA-01',
    employeeName: 'Trần Văn Mạnh',
    employeeRole: 'Trưởng ca Cắt',
    department: 'Xưởng Cắt & Chuẩn bị',
    categoryTag: 'Chi trả làm thêm giờ vượt khung',
    financialImpact: '18.450.000 VNĐ',
    contingencyBudget: 'Khối Sản xuất (Còn 142 Tr)',
    hrNotes: 'Đã xác nhận bảng chấm công quét vân tay.',
    createdAt: DateTime(2026, 9, 23),
    approvalChain: const [
      ApprovalChainStep(
        roleTitle: 'Quản lý trực tiếp',
        actorName: 'Nguyễn Văn A',
        status: ApprovalStepStatus.done,
        timestampText: '22/09 14:30',
      ),
    ],
  );

  setUp(() {
    mockRepo = MockExecutiveRepository();
    getOverviewUseCase = GetExecutiveOverviewUseCase(mockRepo);
    getQueueUseCase = GetFinalApprovalQueueUseCase(mockRepo);
    approveUseCase = ApproveFinalRequestUseCase(mockRepo);
    rejectUseCase = RejectFinalRequestUseCase(mockRepo);
    approveAllUseCase = ApproveAllFinalRequestsUseCase(mockRepo);

    execCubit = ExecutiveCubit(
      getExecutiveOverviewUseCase: getOverviewUseCase,
    );

    approvalCubit = FinalApprovalCubit(
      getFinalApprovalQueueUseCase: getQueueUseCase,
      approveFinalRequestUseCase: approveUseCase,
      rejectFinalRequestUseCase: rejectUseCase,
      approveAllFinalRequestsUseCase: approveAllUseCase,
    );
  });

  tearDown(() async {
    await execCubit.close();
    await approvalCubit.close();
  });

  group('Executive UseCases', () {
    test('GetExecutiveOverviewUseCase returns overview stats', () async {
      when(() => mockRepo.getExecutiveOverview())
          .thenAnswer((_) async => const Right(testStats));

      final result = await getOverviewUseCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (stats) => expect(stats.totalHeadcount, 3142),
      );
      verify(() => mockRepo.getExecutiveOverview()).called(1);
    });

    test('GetFinalApprovalQueueUseCase returns pending approvals', () async {
      when(() => mockRepo.getFinalApprovalQueue())
          .thenAnswer((_) async => Right([testApprovalItem]));

      final result = await getQueueUseCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (items) => expect(items.length, 1),
      );
    });

    test('ApproveFinalRequestUseCase delegates to repository', () async {
      when(() => mockRepo.approveFinalRequest('FA-01'))
          .thenAnswer((_) async => const Right(unit));

      final result = await approveUseCase('FA-01');

      expect(result.isRight(), isTrue);
      verify(() => mockRepo.approveFinalRequest('FA-01')).called(1);
    });
  });

  group('Executive Cubits', () {
    test('ExecutiveCubit loads overview stats successfully', () async {
      when(() => mockRepo.getExecutiveOverview())
          .thenAnswer((_) async => const Right(testStats));

      expectLater(
        execCubit.stream,
        emitsInOrder([
          const ExecutiveState(status: ExecutiveStatus.loading),
          const ExecutiveState(
            status: ExecutiveStatus.success,
            stats: testStats,
          ),
        ]),
      );

      await execCubit.loadOverview();
    });

    test('FinalApprovalCubit approves an item and updates queue', () async {
      when(() => mockRepo.getFinalApprovalQueue())
          .thenAnswer((_) async => Right([testApprovalItem]));
      when(() => mockRepo.approveFinalRequest('FA-01'))
          .thenAnswer((_) async => const Right(unit));

      await approvalCubit.loadQueue();
      expect(approvalCubit.state.queue.length, 1);

      await approvalCubit.approveItem('FA-01');
      expect(approvalCubit.state.queue.isEmpty, isTrue);
      expect(approvalCubit.state.userMessage, contains('phê duyệt'));
    });
  });
}
