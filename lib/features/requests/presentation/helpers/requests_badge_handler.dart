import 'package:flutter/foundation.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_requests_usecase.dart';

/// Manages pending requests badge count for Employee Bottom Nav tab.
abstract final class RequestsBadgeHandler {
  static final ValueNotifier<int> pendingCountNotifier = ValueNotifier<int>(0);

  /// Loads pending requests count submitted by employee across all domains.
  static Future<int> loadPendingCount() async {
    try {
      final now = DateTime.now();
      final m = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      var count = 0;
      if (sl.isRegistered<GetLeaveRequestsUseCase>()) {
        final res = await sl<GetLeaveRequestsUseCase>()();
        res.fold((_) {}, (list) => count += list.where((i) => i.isPending).length);
      }
      if (sl.isRegistered<GetOvertimeRequestsUseCase>()) {
        final res = await sl<GetOvertimeRequestsUseCase>()(month: m);
        res.fold((_) {}, (list) => count += list.where((i) => i.isPending).length);
      }
      if (sl.isRegistered<GetCorrectionRequestsUseCase>()) {
        final res = await sl<GetCorrectionRequestsUseCase>()(month: m);
        res.fold((_) {}, (list) => count += list.where((i) => !i.isApproved && !i.isReject).length);
      }
      pendingCountNotifier.value = count;
      return count;
    } on Object {
      return pendingCountNotifier.value;
    }
  }

  /// Manually update pending count (e.g. from RequestsScreen).
  static void updateCount(int count) {
    if (pendingCountNotifier.value != count) {
      pendingCountNotifier.value = count;
    }
  }
}
