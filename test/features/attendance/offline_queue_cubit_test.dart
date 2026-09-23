import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_cubit.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('OfflineQueueCubit Tests', () {
    test('initial state has empty records and default filter all', () async {
      final cubit = OfflineQueueCubit();
      expect(cubit.state.records, isEmpty);
      expect(cubit.state.filter, QueueFilter.all);
      expect(cubit.state.isSyncing, isFalse);
      await cubit.close();
    });

    test('loadQueue seeds demo records and sets state', () async {
      final cubit = OfflineQueueCubit();
      await cubit.loadQueue();

      expect(cubit.state.records.isNotEmpty, isTrue);
      expect(cubit.state.pendingCount, greaterThan(0));
      await cubit.close();
    });

    test('setFilter updates filter criteria', () async {
      final cubit = OfflineQueueCubit()..setFilter(QueueFilter.pending);
      expect(cubit.state.filter, QueueFilter.pending);
      await cubit.close();
    });
  });
}
