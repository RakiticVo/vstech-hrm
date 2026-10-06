import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/requests/data/datasources/requests_remote_datasource.dart';
import 'package:vstech_hrm/features/requests/data/repositories/requests_repository_impl.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/cancel_leave_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/cancel_overtime_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_correction_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_leave_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_overtime_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_reasons_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_plans_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_types_usecase.dart';

/// Registers all Requests feature dependencies in GetIt.
void initRequestsDependencies(GetIt sl) {
  // 1. Data Sources
  sl.registerLazySingleton<RequestsRemoteDataSource>(
    () => RequestsRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // 2. Repositories
  sl.registerLazySingleton<RequestsRepository>(
    () => RequestsRepositoryImpl(remoteDataSource: sl<RequestsRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetLeaveRequestsUseCase>(
    () => GetLeaveRequestsUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<GetLeavePlansUseCase>(
    () => GetLeavePlansUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<CreateLeaveRequestUseCase>(
    () => CreateLeaveRequestUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<CancelLeaveRequestUseCase>(
    () => CancelLeaveRequestUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<GetOvertimeRequestsUseCase>(
    () => GetOvertimeRequestsUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<GetOvertimeTypesUseCase>(
    () => GetOvertimeTypesUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<CreateOvertimeRequestUseCase>(
    () => CreateOvertimeRequestUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<CancelOvertimeRequestUseCase>(
    () => CancelOvertimeRequestUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<GetCorrectionRequestsUseCase>(
    () => GetCorrectionRequestsUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<GetCorrectionReasonsUseCase>(
    () => GetCorrectionReasonsUseCase(sl<RequestsRepository>()),
  );
  sl.registerLazySingleton<CreateCorrectionRequestUseCase>(
    () => CreateCorrectionRequestUseCase(sl<RequestsRepository>()),
  );
}
