import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/features/announcements/data/datasources/announcement_mock_datasource.dart';
import 'package:vstech_hrm/features/announcements/data/repositories/announcement_repository_impl.dart';
import 'package:vstech_hrm/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:vstech_hrm/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:vstech_hrm/features/announcements/domain/usecases/mark_announcement_read_usecase.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_cubit.dart';

void initAnnouncementsDependencies(GetIt sl) {
  // 1. Data Source
  sl.registerLazySingleton<AnnouncementDataSource>(
    AnnouncementMockDataSource.new,
  );

  // 2. Repository
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(sl<AnnouncementDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetAnnouncementsUseCase>(
    () => GetAnnouncementsUseCase(sl<AnnouncementRepository>()),
  );
  sl.registerLazySingleton<MarkAnnouncementReadUseCase>(
    () => MarkAnnouncementReadUseCase(sl<AnnouncementRepository>()),
  );

  // 4. Cubit
  sl.registerFactory<AnnouncementsCubit>(
    () => AnnouncementsCubit(
      getAnnouncementsUseCase: sl<GetAnnouncementsUseCase>(),
      markAnnouncementReadUseCase: sl<MarkAnnouncementReadUseCase>(),
    ),
  );
}
