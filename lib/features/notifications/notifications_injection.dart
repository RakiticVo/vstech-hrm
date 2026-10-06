import 'package:get_it/get_it.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:vstech_hrm/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:vstech_hrm/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/register_fcm_token_usecase.dart';

void initNotificationsDependencies(GetIt sl) {
  // 1. Data Sources
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // 2. Repositories
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remoteDataSource: sl<NotificationsRemoteDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton<MarkAllNotificationsReadUseCase>(
    () => MarkAllNotificationsReadUseCase(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton<RegisterFcmTokenUseCase>(
    () => RegisterFcmTokenUseCase(sl<NotificationsRepository>()),
  );
}
