import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payroll_summary_entity.dart';
import 'package:vstech_hrm/features/payroll/domain/repositories/payroll_repository.dart';

class GetPayrollSummaryUseCase {
  const new(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, List<PayrollSummaryEntity>>> call(int id) {
    return _repository.getPayrollSummary(id);
  }
}
