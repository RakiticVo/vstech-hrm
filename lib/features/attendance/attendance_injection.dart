import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/core/network/face_dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/face_auth_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:vstech_hrm/features/attendance/data/repositories/face_auth_repository_impl.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/face_auth_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_face_registration_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_in_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_out_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/delete_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_account_timesheet_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_attend_mode_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_attendance_history_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_timesheet_detail_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/live_verify_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/register_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/update_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/verify_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_cubit.dart';

/// Registers all Attendance feature dependencies in GetIt.
void initAttendanceDependencies(GetIt sl) {
  // 1. Data Sources
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<FaceAuthRemoteDataSource>(
    () => FaceAuthRemoteDataSourceImpl(faceDioClient: sl<FaceDioClient>()),
  );

  // 2. Repositories
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: sl<AttendanceRemoteDataSource>()),
  );
  sl.registerLazySingleton<FaceAuthRepository>(
    () => FaceAuthRepositoryImpl(remoteDataSource: sl<FaceAuthRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetTodayAttendanceUseCase>(
    () => GetTodayAttendanceUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<GetAttendanceHistoryUseCase>(
    () => GetAttendanceHistoryUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<GetTimesheetDetailUseCase>(
    () => GetTimesheetDetailUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<CheckInUseCase>(
    () => CheckInUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<CheckOutUseCase>(
    () => CheckOutUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<GetAttendModeUseCase>(
    () => GetAttendModeUseCase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<GetAccountTimesheetUseCase>(
    () => GetAccountTimesheetUseCase(repository: sl<AttendanceRepository>()),
  );

  sl.registerLazySingleton<CheckFaceRegistrationUseCase>(
    () => CheckFaceRegistrationUseCase(repository: sl<FaceAuthRepository>()),
  );
  sl.registerLazySingleton<RegisterFaceUseCase>(
    () => RegisterFaceUseCase(repository: sl<FaceAuthRepository>()),
  );
  sl.registerLazySingleton<UpdateFaceUseCase>(
    () => UpdateFaceUseCase(repository: sl<FaceAuthRepository>()),
  );
  sl.registerLazySingleton<DeleteFaceUseCase>(
    () => DeleteFaceUseCase(repository: sl<FaceAuthRepository>()),
  );
  sl.registerLazySingleton<VerifyFaceUseCase>(
    () => VerifyFaceUseCase(repository: sl<FaceAuthRepository>()),
  );
  sl.registerLazySingleton<LiveVerifyFaceUseCase>(
    () => LiveVerifyFaceUseCase(repository: sl<FaceAuthRepository>()),
  );

  // 4. BLoC (Factory so each scan session gets fresh state)
  sl.registerFactory<AttendanceBloc>(
    () => AttendanceBloc(
      getTodayAttendanceUseCase: sl<GetTodayAttendanceUseCase>(),
      checkInUseCase: sl<CheckInUseCase>(),
      checkOutUseCase: sl<CheckOutUseCase>(),
      checkFaceRegistrationUseCase: sl<CheckFaceRegistrationUseCase>(),
      verifyFaceUseCase: sl<VerifyFaceUseCase>(),
    ),
  );

  sl.registerFactory<OfflineQueueCubit>(OfflineQueueCubit.new);
}
