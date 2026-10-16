import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';
import 'package:vstech_hrm/features/executive/domain/entities/final_approval_entity.dart';
import 'package:vstech_hrm/features/executive/domain/repositories/executive_repository.dart';

class GetExecutiveOverviewUseCase {
  const new(this._repository);
  final ExecutiveRepository _repository;

  Future<Either<Failure, ExecutiveStatsEntity>> call() =>
      _repository.getExecutiveOverview();
}

class GetFinalApprovalQueueUseCase {
  const new(this._repository);
  final ExecutiveRepository _repository;

  Future<Either<Failure, List<FinalApprovalItemEntity>>> call() =>
      _repository.getFinalApprovalQueue();
}

class ApproveFinalRequestUseCase {
  const new(this._repository);
  final ExecutiveRepository _repository;

  Future<Either<Failure, Unit>> call(String requestId) =>
      _repository.approveFinalRequest(requestId);
}

class RejectFinalRequestUseCase {
  const new(this._repository);
  final ExecutiveRepository _repository;

  Future<Either<Failure, Unit>> call(String requestId, {String? reason}) =>
      _repository.rejectFinalRequest(requestId, reason: reason);
}

class ApproveAllFinalRequestsUseCase {
  const new(this._repository);
  final ExecutiveRepository _repository;

  Future<Either<Failure, Unit>> call() =>
      _repository.approveAllFinalRequests();
}
