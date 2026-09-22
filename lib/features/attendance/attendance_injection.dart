import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_in_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_out_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';

/// Registers all Attendance feature dependencies in GetIt.
void initAttendanceDependencies(GetIt sl) {
  // 1. Data Sources
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // 2. Repositories
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: sl<AttendanceRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetTodayAttendanceUseCase>(
    () => GetTodayAttendanceUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<CheckInUseCase>(
    () => CheckInUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<CheckOutUseCase>(
    () => CheckOutUseCase(sl<AttendanceRepository>()),
  );

  // 4. BLoC (Factory so each scan session gets fresh state)
  sl.registerFactory<AttendanceBloc>(
    () => AttendanceBloc(
      getTodayAttendanceUseCase: sl<GetTodayAttendanceUseCase>(),
      checkInUseCase: sl<CheckInUseCase>(),
      checkOutUseCase: sl<CheckOutUseCase>(),
    ),
  );
}
