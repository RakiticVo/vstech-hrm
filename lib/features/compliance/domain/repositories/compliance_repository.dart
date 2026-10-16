import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';

abstract class ComplianceRepository {
  Future<Either<Failure, List<RiskAlertEntity>>> getRiskAlerts();
  Future<Either<Failure, Unit>> assignRiskToHr(String alertId);
  Future<Either<Failure, List<DelegatePersonEntity>>> getEligibleDelegates();
  Future<Either<Failure, List<DelegationEntity>>> getActiveDelegations();
  Future<Either<Failure, DelegationEntity>> createDelegation({
    required DelegatePersonEntity delegatePerson,
    required DateTime fromDate,
    required DateTime toDate,
    required String scopeDescription,
    required String financialLimitText,
  });
  Future<Either<Failure, Unit>> revokeDelegation(String delegationId);
}
