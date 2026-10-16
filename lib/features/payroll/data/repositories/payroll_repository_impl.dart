import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/payroll/data/datasources/payroll_remote_datasource.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payroll_summary_entity.dart';
import 'package:vstech_hrm/features/payroll/domain/entities/payslip_entity.dart';
import 'package:vstech_hrm/features/payroll/domain/repositories/payroll_repository.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  const new({required PayrollRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final PayrollRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PayslipEntity>> getPayslipDetail(int id) async {
    try {
      final model = await _remoteDataSource.getPayslipDetail(id);
      final entity = PayslipEntity(
        id: model.id,
        month: model.month,
        employeeCode: model.employeeCode,
        actualBaseSalary: model.actualBaseSalary,
        actualIncomeTotal: model.actualIncomeTotal,
        actualAllowance: model.actualAllowance,
        actualLunchFee: model.actualLunchFee,
        actualPhoneFee: model.actualPhoneFee,
        actualOvertimeSalary: model.actualOvertimeSalary,
        actualKpiSalary: model.actualKpiSalary,
        taxAddition: model.taxAddition,
        taxReturn: model.taxReturn,
        subtractionFund: model.subtractionFund,
        sumPayAmount: model.sumPayAmount,
        note: model.note,
      );
      return Right(entity);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PayrollSummaryEntity>>> getPayrollSummary(int id) async {
    try {
      final models = await _remoteDataSource.getPayrollSummary(id);
      final entities = models.map((m) => PayrollSummaryEntity(
            departmentCode: m.departmentCode,
            departmentName: m.departmentName,
            sumPayAmount: m.sumPayAmount,
            sumSalaryCost: m.sumSalaryCost,
            staffNum: m.staffNum,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
