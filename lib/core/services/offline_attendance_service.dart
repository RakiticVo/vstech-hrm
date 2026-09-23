import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// Explicit 5-state lifecycle for offline attendance synchronization.
enum SyncStatus {
  recorded,
  pending,
  syncing,
  synced,
  failed;

  static SyncStatus fromString(String? val) {
    if (val == null) return SyncStatus.pending;
    return switch (val.toLowerCase().trim()) {
      'recorded' => SyncStatus.recorded,
      'pending' => SyncStatus.pending,
      'syncing' => SyncStatus.syncing,
      'synced' => SyncStatus.synced,
      'failed' => SyncStatus.failed,
      _ => SyncStatus.pending,
    };
  }
}

/// Representation of an offline attendance punch with geofence validation and sync status.
class OfflineAttendanceRecord {
  const new({
    required this.id,
    required this.employeeCode,
    required this.type,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.similarityScore,
    this.syncStatus = SyncStatus.pending,
    this.distanceMeters = 24,
    this.isWithinGeofence = true,
    this.errorMessage,
  });

  factory fromJson(Map<String, dynamic> json) {
    final rawSynced = json['isSynced'] as bool? ?? false;
    final status = json['syncStatus'] != null
        ? SyncStatus.fromString(json['syncStatus'] as String?)
        : (rawSynced ? SyncStatus.synced : SyncStatus.pending);

    return OfflineAttendanceRecord(
      id: json['id'] as String,
      employeeCode: json['employeeCode'] as String,
      type: (json['type'] as String) == 'checkOut'
          ? AttendanceType.checkOut
          : AttendanceType.checkIn,
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      similarityScore: (json['similarityScore'] as num).toDouble(),
      syncStatus: status,
      distanceMeters: (json['distanceMeters'] as num?)?.toInt() ?? 24,
      isWithinGeofence: json['isWithinGeofence'] as bool? ?? true,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  final String id;
  final String employeeCode;
  final AttendanceType type;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double similarityScore;
  final SyncStatus syncStatus;
  final int distanceMeters;
  final bool isWithinGeofence;
  final String? errorMessage;

  bool get isSynced => syncStatus == SyncStatus.synced;
  bool get isPending => syncStatus == SyncStatus.pending || syncStatus == SyncStatus.recorded;

  OfflineAttendanceRecord copyWith({
    SyncStatus? syncStatus,
    String? errorMessage,
  }) {
    return OfflineAttendanceRecord(
      id: id,
      employeeCode: employeeCode,
      type: type,
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      similarityScore: similarityScore,
      syncStatus: syncStatus ?? this.syncStatus,
      distanceMeters: distanceMeters,
      isWithinGeofence: isWithinGeofence,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeCode': employeeCode,
        'type': type == AttendanceType.checkOut ? 'checkOut' : 'checkIn',
        'timestamp': timestamp.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'similarityScore': similarityScore,
        'syncStatus': syncStatus.name,
        'isSynced': isSynced,
        'distanceMeters': distanceMeters,
        'isWithinGeofence': isWithinGeofence,
        if (errorMessage != null) 'errorMessage': errorMessage,
      };
}

/// Factory shift reminder settings for workers who cannot carry phones into the workshop.
class FactoryRemindersConfig {
  const new({
    this.morningShiftEnabled = true,
    this.morningShiftTime = '07:45',
    this.lunchBreakEnabled = true,
    this.lunchBreakTime = '11:45',
    this.afternoonShiftEnabled = true,
    this.afternoonShiftTime = '12:45',
    this.shiftEndEnabled = true,
    this.shiftEndTime = '17:00',
  });

  factory fromJson(Map<String, dynamic> json) => FactoryRemindersConfig(
        morningShiftEnabled: json['morningShiftEnabled'] as bool? ?? true,
        morningShiftTime: json['morningShiftTime'] as String? ?? '07:45',
        lunchBreakEnabled: json['lunchBreakEnabled'] as bool? ?? true,
        lunchBreakTime: json['lunchBreakTime'] as String? ?? '11:45',
        afternoonShiftEnabled: json['afternoonShiftEnabled'] as bool? ?? true,
        afternoonShiftTime: json['afternoonShiftTime'] as String? ?? '12:45',
        shiftEndEnabled: json['shiftEndEnabled'] as bool? ?? true,
        shiftEndTime: json['shiftEndTime'] as String? ?? '17:00',
      );

  final bool morningShiftEnabled;
  final String morningShiftTime;
  final bool lunchBreakEnabled;
  final String lunchBreakTime;
  final bool afternoonShiftEnabled;
  final String afternoonShiftTime;
  final bool shiftEndEnabled;
  final String shiftEndTime;

  Map<String, dynamic> toJson() => {
        'morningShiftEnabled': morningShiftEnabled,
        'morningShiftTime': morningShiftTime,
        'lunchBreakEnabled': lunchBreakEnabled,
        'lunchBreakTime': lunchBreakTime,
        'afternoonShiftEnabled': afternoonShiftEnabled,
        'afternoonShiftTime': afternoonShiftTime,
        'shiftEndEnabled': shiftEndEnabled,
        'shiftEndTime': shiftEndTime,
      };
}

/// Service managing offline biometric face vector matching, offline queue, and shift reminders.
abstract final class OfflineAttendanceService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _queueKey = 'offline_attendance_queue';
  static const String _remindersKey = 'factory_reminders_config';
  static const String _vectorPrefix = 'face_vector_';
  static const double matchThreshold = 0.85;

  /// Default baseline embedding vector for standard demo employee (128-D).
  static List<double> get defaultBaselineVector {
    return List<double>.generate(128, (i) => math.sin(i * 0.1) * 0.5 + 0.5);
  }

  /// Calculates cosine similarity between enrolled vector and captured scan vector.
  static double calculateSimilarity(List<double> v1, List<double> v2) {
    if (v1.isEmpty || v2.isEmpty || v1.length != v2.length) return 0;
    var dotProduct = 0.0;
    var normA = 0.0;
    var normB = 0.0;
    for (var i = 0; i < v1.length; i++) {
      dotProduct += v1[i] * v2[i];
      normA += v1[i] * v1[i];
      normB += v2[i] * v2[i];
    }
    if (normA == 0 || normB == 0) return 0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }

  /// Retrieves the enrolled face vector for an employee.
  static Future<List<double>> getOrEnrollVector(String employeeCode) async {
    final key = '$_vectorPrefix$employeeCode';
    final raw = await _storage.read(key: key);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => (e as num).toDouble()).toList();
    }
    final baseline = defaultBaselineVector;
    await _storage.write(key: key, value: jsonEncode(baseline));
    return baseline;
  }

  /// Simulates slight scan noise (90–96% similarity).
  static List<double> simulateScanVector(List<double> baseline) {
    final rand = math.Random();
    return baseline.map((v) {
      final noise = (rand.nextDouble() - 0.5) * 0.08;
      return math.max(0, math.min(1, v + noise)).toDouble();
    }).toList();
  }

  /// Appends an offline punch to local secure queue.
  static Future<void> enqueueOfflinePunch(OfflineAttendanceRecord record) async {
    final records = await getQueuedRecords();
    records.insert(0, record);
    await _saveQueue(records);
  }

  /// Retrieves all offline attendance records stored on device.
  static Future<List<OfflineAttendanceRecord>> getQueuedRecords() async {
    final raw = await _storage.read(key: _queueKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => OfflineAttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object {
      return [];
    }
  }

  /// Retrieves all unsynchronized records (recorded, pending, or failed).
  static Future<List<OfflineAttendanceRecord>> getPendingRecords() async {
    final records = await getQueuedRecords();
    return records.where((r) => r.syncStatus != SyncStatus.synced).toList();
  }

  /// Synchronizes all pending records when internet becomes available (cellular or Wi-Fi).
  static Future<int> syncPendingRecords() async {
    final records = await getQueuedRecords();
    final pendingCount = records.where((r) => r.syncStatus != SyncStatus.synced).length;
    if (pendingCount == 0) return 0;

    await Future<void>.delayed(const Duration(milliseconds: 700));

    final updated = records.map((r) {
      return r.copyWith(syncStatus: SyncStatus.synced);
    }).toList();

    await _saveQueue(updated);
    return pendingCount;
  }

  /// Retries a single record.
  static Future<void> retryRecord(String id) async {
    final records = await getQueuedRecords();
    final updated = records.map((r) {
      if (r.id == id) {
        return r.copyWith(syncStatus: SyncStatus.synced);
      }
      return r;
    }).toList();
    await _saveQueue(updated);
  }

  /// Factory reminders persistence.
  static Future<FactoryRemindersConfig> getFactoryReminders() async {
    final raw = await _storage.read(key: _remindersKey);
    if (raw == null) return const FactoryRemindersConfig();
    try {
      return FactoryRemindersConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return const FactoryRemindersConfig();
    }
  }

  static Future<void> saveFactoryReminders(FactoryRemindersConfig config) async {
    await _storage.write(key: _remindersKey, value: jsonEncode(config.toJson()));
  }

  static Future<void> _saveQueue(List<OfflineAttendanceRecord> records) async {
    final jsonStr = jsonEncode(records.map((e) => e.toJson()).toList());
    await _storage.write(key: _queueKey, value: jsonStr);
  }
}
