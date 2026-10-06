import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payroll_summary_entity.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payslip_entity.dart';

abstract class PayrollRepository {
  Future<Either<Failure, PayslipEntity>> getPayslipDetail(int id);
  Future<Either<Failure, List<PayrollSummaryEntity>>> getPayrollSummary(int id);
}
