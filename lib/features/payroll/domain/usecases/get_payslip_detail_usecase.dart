import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payslip_entity.dart';
import 'package:vstech_hrm/features/payroll/domain/repositories/payroll_repository.dart';

class GetPayslipDetailUseCase {
  const new(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, PayslipEntity>> call(int id) {
    return _repository.getPayslipDetail(id);
  }
}
