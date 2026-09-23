import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_state.dart';

class OfflineQueueCubit extends Cubit<OfflineQueueState> {
  new() : super(const OfflineQueueState());

  Future<void> loadQueue() async {
    var records = await OfflineAttendanceService.getQueuedRecords();
    if (records.isEmpty) {
      // Seed initial demonstration records to show the 5 states
      final now = DateTime.now();
      final demoRecords = [
        OfflineAttendanceRecord(
          id: 'punch_rec_01',
          employeeCode: 'NV-04821',
          type: AttendanceType.checkIn,
          timestamp: now.subtract(const Duration(minutes: 42)),
          latitude: 10.7769,
          longitude: 106.7009,
          similarityScore: 0.94,
          distanceMeters: 18,
        ),
        OfflineAttendanceRecord(
          id: 'punch_rec_02',
          employeeCode: 'NV-04821',
          type: AttendanceType.checkOut,
          timestamp: now.subtract(const Duration(hours: 3)),
          latitude: 10.7771,
          longitude: 106.7012,
          similarityScore: 0.91,
          syncStatus: SyncStatus.recorded,
          distanceMeters: 22,
        ),
        OfflineAttendanceRecord(
          id: 'punch_rec_03',
          employeeCode: 'NV-04821',
          type: AttendanceType.checkIn,
          timestamp: now.subtract(const Duration(days: 1, hours: 8)),
          latitude: 10.7768,
          longitude: 106.7010,
          similarityScore: 0.96,
          syncStatus: SyncStatus.synced,
          distanceMeters: 15,
        ),
        OfflineAttendanceRecord(
          id: 'punch_rec_04',
          employeeCode: 'NV-04821',
          type: AttendanceType.checkOut,
          timestamp: now.subtract(const Duration(days: 1, hours: 1)),
          latitude: 10.7810,
          longitude: 106.7050,
          similarityScore: 0.88,
          syncStatus: SyncStatus.failed,
          distanceMeters: 580,
          isWithinGeofence: false,
          errorMessage: 'Vượt quá bán kính 50m của nhà máy',
        ),
      ];
      for (final r in demoRecords) {
        await OfflineAttendanceService.enqueueOfflinePunch(r);
      }
      records = demoRecords;
    }

    final reminders = await OfflineAttendanceService.getFactoryReminders();
    emit(state.copyWith(records: records, remindersConfig: reminders));
  }

  void setFilter(QueueFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  Future<void> syncAll() async {
    emit(state.copyWith(isSyncing: true));
    await OfflineAttendanceService.syncPendingRecords();
    final refreshed = await OfflineAttendanceService.getQueuedRecords();
    emit(
      state.copyWith(
        records: refreshed,
        isSyncing: false,
        message: 'Đã đồng bộ toàn bộ hàng đợi thành công!',
      ),
    );
  }

  Future<void> retryRecord(String id) async {
    await OfflineAttendanceService.retryRecord(id);
    final refreshed = await OfflineAttendanceService.getQueuedRecords();
    emit(
      state.copyWith(
        records: refreshed,
        message: 'Đã thử lại và đồng bộ thành công!',
      ),
    );
  }

  Future<void> updateReminders(FactoryRemindersConfig config) async {
    await OfflineAttendanceService.saveFactoryReminders(config);
    emit(state.copyWith(remindersConfig: config));
  }
}
