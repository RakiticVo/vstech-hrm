import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// Representation of an offline attendance punch awaiting synchronization.
class OfflineAttendanceRecord {
  const new({
    required this.id,
    required this.employeeCode,
    required this.type,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.similarityScore,
    this.isSynced = false,
  });

  factory fromJson(Map<String, dynamic> json) {
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
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  final String id;
  final String employeeCode;
  final AttendanceType type;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double similarityScore;
  final bool isSynced;

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeCode': employeeCode,
        'type': type == AttendanceType.checkOut ? 'checkOut' : 'checkIn',
        'timestamp': timestamp.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'similarityScore': similarityScore,
        'isSynced': isSynced,
      };
}

/// Service managing offline biometric face vector matching and offline queue.
abstract final class OfflineAttendanceService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _queueKey = 'offline_attendance_queue';
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

  /// Retrieves the enrolled face vector for an employee. If none exists, initializes it.
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

  /// Generates a realistic scanned vector with slight noise (90–96% similarity).
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

  /// Retrieves all offline attendance records that have not been synced.
  static Future<List<OfflineAttendanceRecord>> getPendingRecords() async {
    final records = await getQueuedRecords();
    return records.where((r) => !r.isSynced).toList();
  }

  /// Synchronizes all pending records when connectivity is available.
  static Future<int> syncPendingRecords() async {
    final records = await getQueuedRecords();
    final pendingCount = records.where((r) => !r.isSynced).length;
    if (pendingCount == 0) return 0;

    // Simulate backend sync delay
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final updated = records.map((r) {
      return OfflineAttendanceRecord(
        id: r.id,
        employeeCode: r.employeeCode,
        type: r.type,
        timestamp: r.timestamp,
        latitude: r.latitude,
        longitude: r.longitude,
        similarityScore: r.similarityScore,
        isSynced: true,
      );
    }).toList();

    await _saveQueue(updated);
    return pendingCount;
  }

  static Future<void> _saveQueue(List<OfflineAttendanceRecord> records) async {
    final jsonStr = jsonEncode(records.map((e) => e.toJson()).toList());
    await _storage.write(key: _queueKey, value: jsonStr);
  }
}
