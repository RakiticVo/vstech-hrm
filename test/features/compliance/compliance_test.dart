import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/repositories/compliance_repository.dart';
import 'package:vstech_hrm/features/compliance/domain/usecases/compliance_usecases.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/delegation_cubit.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/delegation_state.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/risk_alerts_cubit.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/risk_alerts_state.dart';

class MockComplianceRepository extends Mock implements ComplianceRepository {}

void main() {
  late MockComplianceRepository mockRepo;
  late GetRiskAlertsUseCase getRiskAlertsUseCase;
  late AssignRiskToHrUseCase assignRiskToHrUseCase;
  late GetEligibleDelegatesUseCase getEligibleDelegatesUseCase;
  late GetActiveDelegationsUseCase getActiveDelegationsUseCase;
  late CreateDelegationUseCase createDelegationUseCase;
  late RevokeDelegationUseCase revokeDelegationUseCase;
  late RiskAlertsCubit riskCubit;
  late DelegationCubit delCubit;

  const testAlert = RiskAlertEntity(
    id: 'RA-01',
    title: '14 công nhân tăng ca vượt trần 40h/tháng',
    description: 'Quy định Điều 107 Bộ luật Lao động',
    metricValue: '44.5h / 40h',
    tier: RiskTier.critical,
    branch: 'Xưởng May 2 · Chuyền 4',
    detectedTimeText: '08:15 Hôm nay',
  );

  const testPerson = DelegatePersonEntity(
    id: 'DEL-01',
    name: 'Trần Văn Nam',
    role: 'Phó Tổng Giám Đốc',
    department: 'Ban Điều Hành',
    initials: 'TN',
  );

  final testDelegation = DelegationEntity(
    id: 'DLG-01',
    delegatePerson: testPerson,
    fromDate: DateTime(2026, 9, 20),
    toDate: DateTime(2026, 9, 27),
    scopeDescription: 'Tất cả các loại đơn',
    financialLimitText: '≤ 50.000.000 VNĐ',
    isActive: true,
    createdAt: DateTime(2026, 9, 19),
  );

  setUp(() {
    mockRepo = MockComplianceRepository();
    getRiskAlertsUseCase = GetRiskAlertsUseCase(mockRepo);
    assignRiskToHrUseCase = AssignRiskToHrUseCase(mockRepo);
    getEligibleDelegatesUseCase = GetEligibleDelegatesUseCase(mockRepo);
    getActiveDelegationsUseCase = GetActiveDelegationsUseCase(mockRepo);
    createDelegationUseCase = CreateDelegationUseCase(mockRepo);
    revokeDelegationUseCase = RevokeDelegationUseCase(mockRepo);

    riskCubit = RiskAlertsCubit(
      getRiskAlertsUseCase: getRiskAlertsUseCase,
      assignRiskToHrUseCase: assignRiskToHrUseCase,
    );

    delCubit = DelegationCubit(
      getEligibleDelegatesUseCase: getEligibleDelegatesUseCase,
      getActiveDelegationsUseCase: getActiveDelegationsUseCase,
      createDelegationUseCase: createDelegationUseCase,
      revokeDelegationUseCase: revokeDelegationUseCase,
    );
  });

  tearDown(() async {
    await riskCubit.close();
    await delCubit.close();
  });

  group('Compliance UseCases', () {
    test('GetRiskAlertsUseCase returns list of alerts', () async {
      when(() => mockRepo.getRiskAlerts())
          .thenAnswer((_) async => const Right([testAlert]));

      final result = await getRiskAlertsUseCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (alerts) => expect(alerts.length, 1),
      );
      verify(() => mockRepo.getRiskAlerts()).called(1);
    });

    test('AssignRiskToHrUseCase delegates to repository', () async {
      when(() => mockRepo.assignRiskToHr('RA-01'))
          .thenAnswer((_) async => const Right(unit));

      final result = await assignRiskToHrUseCase('RA-01');

      expect(result.isRight(), isTrue);
      verify(() => mockRepo.assignRiskToHr('RA-01')).called(1);
    });

    test('GetEligibleDelegatesUseCase returns delegate candidates', () async {
      when(() => mockRepo.getEligibleDelegates())
          .thenAnswer((_) async => const Right([testPerson]));

      final result = await getEligibleDelegatesUseCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (delegates) => expect(delegates.first.name, 'Trần Văn Nam'),
      );
    });
  });

  group('Compliance Cubits', () {
    test('RiskAlertsCubit fetches alerts and assigns to HR', () async {
      when(() => mockRepo.getRiskAlerts())
          .thenAnswer((_) async => const Right([testAlert]));
      when(() => mockRepo.assignRiskToHr('RA-01'))
          .thenAnswer((_) async => const Right(unit));

      await riskCubit.fetchRiskAlerts();
      expect(riskCubit.state, isA<RiskAlertsLoaded>());

      final loaded = riskCubit.state as RiskAlertsLoaded;
      expect(loaded.criticalCount, 1);
      expect(loaded.alerts.first.isAssignedToHr, isFalse);

      await riskCubit.assignToHr('RA-01');
      final updated = riskCubit.state as RiskAlertsLoaded;
      expect(updated.alerts.first.isAssignedToHr, isTrue);
    });

    test('DelegationCubit loads initial data and toggles scope', () async {
      when(() => mockRepo.getEligibleDelegates())
          .thenAnswer((_) async => const Right([testPerson]));
      when(() => mockRepo.getActiveDelegations())
          .thenAnswer((_) async => Right([testDelegation]));

      await delCubit.loadInitialData();
      expect(delCubit.state, isA<DelegationLoaded>());

      var state = delCubit.state as DelegationLoaded;
      expect(state.eligibleDelegates.length, 1);
      expect(state.activeDelegations.length, 1);
      expect(state.isAllScope, isTrue);

      delCubit.setScope(isAllScope: false);
      state = delCubit.state as DelegationLoaded;
      expect(state.isAllScope, isFalse);
    });
  });
}
