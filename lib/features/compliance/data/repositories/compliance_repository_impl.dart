import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/compliance/data/datasources/compliance_mock_datasource.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/repositories/compliance_repository.dart';

class ComplianceRepositoryImpl implements ComplianceRepository {
  const new(this._datasource);

  final ComplianceMockDatasource _datasource;

  @override
  Future<Either<Failure, List<RiskAlertEntity>>> getRiskAlerts() async {
    try {
      final models = await _datasource.getRiskAlerts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> assignRiskToHr(String alertId) async {
    try {
      await _datasource.assignRiskToHr(alertId);
      return const Right(unit);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DelegatePersonEntity>>>
      getEligibleDelegates() async {
    try {
      final models = await _datasource.getEligibleDelegates();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DelegationEntity>>> getActiveDelegations() async {
    try {
      final models = await _datasource.getActiveDelegations();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DelegationEntity>> createDelegation({
    required DelegatePersonEntity delegatePerson,
    required DateTime fromDate,
    required DateTime toDate,
    required String scopeDescription,
    required String financialLimitText,
  }) async {
    try {
      final model = await _datasource.createDelegation(
        delegatePerson: delegatePerson,
        fromDate: fromDate,
        toDate: toDate,
        scopeDescription: scopeDescription,
        financialLimitText: financialLimitText,
      );
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> revokeDelegation(String delegationId) async {
    try {
      await _datasource.revokeDelegation(delegationId);
      return const Right(unit);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
