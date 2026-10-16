import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/repositories/compliance_repository.dart';

class GetRiskAlertsUseCase {
  const new(this._repository);
  final ComplianceRepository _repository;

  Future<Either<Failure, List<RiskAlertEntity>>> call() =>
      _repository.getRiskAlerts();
}

class AssignRiskToHrUseCase {
  const new(this._repository);
  final ComplianceRepository _repository;

  Future<Either<Failure, Unit>> call(String alertId) =>
      _repository.assignRiskToHr(alertId);
}

class GetEligibleDelegatesUseCase {
  const new(this._repository);
  final ComplianceRepository _repository;

  Future<Either<Failure, List<DelegatePersonEntity>>> call() =>
      _repository.getEligibleDelegates();
}

class GetActiveDelegationsUseCase {
  const new(this._repository);
  final ComplianceRepository _repository;

  Future<Either<Failure, List<DelegationEntity>>> call() =>
      _repository.getActiveDelegations();
}

class CreateDelegationUseCase {
  const new(this._repository);
  final ComplianceRepository _repository;

  Future<Either<Failure, DelegationEntity>> call({
    required DelegatePersonEntity delegatePerson,
    required DateTime fromDate,
    required DateTime toDate,
    required String scopeDescription,
    required String financialLimitText,
  }) =>
      _repository.createDelegation(
        delegatePerson: delegatePerson,
        fromDate: fromDate,
        toDate: toDate,
        scopeDescription: scopeDescription,
        financialLimitText: financialLimitText,
      );
}

class RevokeDelegationUseCase {
  const new(this._repository);
  final ComplianceRepository _repository;

  Future<Either<Failure, Unit>> call(String delegationId) =>
      _repository.revokeDelegation(delegationId);
}
