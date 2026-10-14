import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/timesheet_mobile_item_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';

/// UseCase fetching subordinate timesheet records (GET /api/TimeSheets/mobile).
class GetTimesheetsMobileUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, List<TimesheetMobileItemEntity>>> call({
    String? from,
    String? to,
  }) {
    return _repository.getTimeSheetsMobile(from: from, to: to);
  }
}
