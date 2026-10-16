import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/executive/data/datasources/executive_mock_datasource.dart';
import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';
import 'package:vstech_hrm/features/executive/domain/entities/final_approval_entity.dart';
import 'package:vstech_hrm/features/executive/domain/repositories/executive_repository.dart';

class ExecutiveRepositoryImpl implements ExecutiveRepository {
  const new(this._dataSource);

  final ExecutiveMockDataSource _dataSource;

  @override
  Future<Either<Failure, ExecutiveStatsEntity>> getExecutiveOverview() async {
    try {
      final model = await _dataSource.getOverviewStats();
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FinalApprovalItemEntity>>> getFinalApprovalQueue() async {
    try {
      final list = await _dataSource.getFinalQueue();
      return Right(list.map((m) => m.toEntity()).toList());
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> approveFinalRequest(String requestId) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return const Right(unit);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rejectFinalRequest(String requestId, {String? reason}) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return const Right(unit);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> approveAllFinalRequests() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return const Right(unit);
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
