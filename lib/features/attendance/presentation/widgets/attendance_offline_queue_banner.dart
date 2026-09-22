import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Banner notifying employee of pending offline attendance records needing synchronization.
class AttendanceOfflineQueueBanner extends StatefulWidget {
  const new({super.key});

  @override
  State<AttendanceOfflineQueueBanner> createState() =>
      _AttendanceOfflineQueueBannerState();
}

class _AttendanceOfflineQueueBannerState
    extends State<AttendanceOfflineQueueBanner> {
  int _pendingCount = 0;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkPendingRecords());
  }

  Future<void> _checkPendingRecords() async {
    final pending = await OfflineAttendanceService.getPendingRecords();
    if (mounted) {
      setState(() => _pendingCount = pending.length);
    }
  }

  Future<void> _syncNow() async {
    setState(() => _isSyncing = true);
    final count = await OfflineAttendanceService.syncPendingRecords();
    if (mounted) {
      setState(() {
        _isSyncing = false;
        _pendingCount = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Symbols.cloud_done, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Đã đồng bộ thành công $count lượt chấm công lên hệ thống!',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: context.colors.pineGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingCount == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Symbols.cloud_off,
              color: Color(0xFFD97706),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_pendingCount lượt chấm công ngoại tuyến',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
                const Text(
                  'Đã lưu cục bộ an toàn, sẵn sàng đồng bộ.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFFB45309)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            onPressed: _isSyncing ? null : _syncNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: _isSyncing
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Symbols.sync, size: 14),
                      SizedBox(width: 4),
                      Text('Đồng bộ', style: TextStyle(fontSize: 12)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
