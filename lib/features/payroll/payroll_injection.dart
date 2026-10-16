import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/payroll/data/datasources/payroll_remote_datasource.dart';
import 'package:vstech_hrm/features/payroll/data/repositories/payroll_repository_impl.dart';
import 'package:vstech_hrm/features/payroll/domain/repositories/payroll_repository.dart';
import 'package:vstech_hrm/features/payroll/domain/usecases/get_payroll_summary_usecase.dart';
import 'package:vstech_hrm/features/payroll/domain/usecases/get_payslip_detail_usecase.dart';

void initPayrollDependencies(GetIt sl) {
  // 1. Data Sources
  sl.registerLazySingleton<PayrollRemoteDataSource>(
    () => PayrollRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // 2. Repositories
  sl.registerLazySingleton<PayrollRepository>(
    () => PayrollRepositoryImpl(remoteDataSource: sl<PayrollRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetPayslipDetailUseCase>(
    () => GetPayslipDetailUseCase(sl<PayrollRepository>()),
  );
  sl.registerLazySingleton<GetPayrollSummaryUseCase>(
    () => GetPayrollSummaryUseCase(sl<PayrollRepository>()),
  );
}
