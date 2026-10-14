import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_managed_employees_usecase.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/schedule_remote_datasource.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/schedule_remote_datasource_impl.dart';
import 'package:vstech_hrm/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:vstech_hrm/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_department_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_my_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_cubit.dart';

/// Registers all Shift Schedule feature dependencies into GetIt.
void initScheduleDependencies(GetIt sl) {
  // 1. Data Source
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // 2. Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl<ScheduleRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetMyShiftScheduleUseCase>(
    () => GetMyShiftScheduleUseCase(sl<ScheduleRepository>()),
  );
  sl.registerLazySingleton<GetDepartmentShiftScheduleUseCase>(
    () => GetDepartmentShiftScheduleUseCase(sl<ScheduleRepository>()),
  );

  // 4. Cubit
  sl.registerFactory<ShiftScheduleCubit>(
    () => ShiftScheduleCubit(
      getMyShiftScheduleUseCase: sl<GetMyShiftScheduleUseCase>(),
      getDepartmentShiftScheduleUseCase: sl<GetDepartmentShiftScheduleUseCase>(),
      getManagedEmployeesUseCase: sl<GetManagedEmployeesUseCase>(),
    ),
  );
}
