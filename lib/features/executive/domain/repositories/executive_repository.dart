import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';
import 'package:vstech_hrm/features/executive/domain/entities/final_approval_entity.dart';

abstract class ExecutiveRepository {
  Future<Either<Failure, ExecutiveStatsEntity>> getExecutiveOverview();
  Future<Either<Failure, List<FinalApprovalItemEntity>>> getFinalApprovalQueue();
  Future<Either<Failure, Unit>> approveFinalRequest(String requestId);
  Future<Either<Failure, Unit>> rejectFinalRequest(String requestId, {String? reason});
  Future<Either<Failure, Unit>> approveAllFinalRequests();
}
