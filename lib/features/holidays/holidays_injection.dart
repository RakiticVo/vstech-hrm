import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/holidays/data/datasources/holidays_remote_datasource.dart';
import 'package:vstech_hrm/features/holidays/data/repositories/holidays_repository_impl.dart';
import 'package:vstech_hrm/features/holidays/domain/repositories/holidays_repository.dart';
import 'package:vstech_hrm/features/holidays/domain/usecases/get_holidays_usecase.dart';

void initHolidaysDependencies(GetIt sl) {
  // 1. Data Sources
  sl.registerLazySingleton<HolidaysRemoteDataSource>(
    () => HolidaysRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // 2. Repositories
  sl.registerLazySingleton<HolidaysRepository>(
    () => HolidaysRepositoryImpl(remoteDataSource: sl<HolidaysRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetHolidaysUseCase>(
    () => GetHolidaysUseCase(sl<HolidaysRepository>()),
  );
}
