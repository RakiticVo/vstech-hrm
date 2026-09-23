import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';

enum QueueFilter { all, pending, synced, failed }

class OfflineQueueState extends Equatable {
  const new({
    this.records = const [],
    this.filter = QueueFilter.all,
    this.isSyncing = false,
    this.remindersConfig = const FactoryRemindersConfig(),
    this.message,
  });

  final List<OfflineAttendanceRecord> records;
  final QueueFilter filter;
  final bool isSyncing;
  final FactoryRemindersConfig remindersConfig;
  final String? message;

  int get pendingCount =>
      records.where((r) => r.syncStatus != SyncStatus.synced).length;

  List<OfflineAttendanceRecord> get filteredRecords {
    return switch (filter) {
      QueueFilter.all => records,
      QueueFilter.pending =>
        records.where((r) => r.syncStatus == SyncStatus.pending || r.syncStatus == SyncStatus.recorded).toList(),
      QueueFilter.synced =>
        records.where((r) => r.syncStatus == SyncStatus.synced).toList(),
      QueueFilter.failed =>
        records.where((r) => r.syncStatus == SyncStatus.failed).toList(),
    };
  }

  OfflineQueueState copyWith({
    List<OfflineAttendanceRecord>? records,
    QueueFilter? filter,
    bool? isSyncing,
    FactoryRemindersConfig? remindersConfig,
    String? message,
  }) {
    return OfflineQueueState(
      records: records ?? this.records,
      filter: filter ?? this.filter,
      isSyncing: isSyncing ?? this.isSyncing,
      remindersConfig: remindersConfig ?? this.remindersConfig,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        records,
        filter,
        isSyncing,
        remindersConfig,
        message,
      ];
}
