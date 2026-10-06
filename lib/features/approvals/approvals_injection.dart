import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/approvals/data/datasources/approvals_remote_datasource.dart';
import 'package:vstech_hrm/features/approvals/data/repositories/approvals_repository_impl.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_leave_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_overtime_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_timesheet_correction_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_leave_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_overtime_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_timesheet_correction_usecase.dart';

/// Registers all Approvals feature dependencies in GetIt.
void initApprovalsDependencies(GetIt sl) {
  // 1. Data Sources
  sl.registerLazySingleton<ApprovalsRemoteDataSource>(
    () => ApprovalsRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // 2. Repositories
  sl.registerLazySingleton<ApprovalsRepository>(
    () => ApprovalsRepositoryImpl(remoteDataSource: sl<ApprovalsRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<ApproveLeaveUseCase>(
    () => ApproveLeaveUseCase(sl<ApprovalsRepository>()),
  );
  sl.registerLazySingleton<RejectLeaveUseCase>(
    () => RejectLeaveUseCase(sl<ApprovalsRepository>()),
  );
  sl.registerLazySingleton<ApproveOvertimeUseCase>(
    () => ApproveOvertimeUseCase(sl<ApprovalsRepository>()),
  );
  sl.registerLazySingleton<RejectOvertimeUseCase>(
    () => RejectOvertimeUseCase(sl<ApprovalsRepository>()),
  );
  sl.registerLazySingleton<ApproveTimesheetCorrectionUseCase>(
    () => ApproveTimesheetCorrectionUseCase(sl<ApprovalsRepository>()),
  );
  sl.registerLazySingleton<RejectTimesheetCorrectionUseCase>(
    () => RejectTimesheetCorrectionUseCase(sl<ApprovalsRepository>()),
  );
  sl.registerLazySingleton<GetPendingApprovalsUseCase>(
    () => GetPendingApprovalsUseCase(sl<ApprovalsRepository>()),
  );
}
