import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/core/extensions/date_formatter_extension.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/timesheet_mobile_item_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/admin_confirm_timesheet_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_leave_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_overtime_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/approve_timesheet_correction_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_leave_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_overtime_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_timesheets_mobile_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_leave_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_overtime_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_timesheet_correction_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/reject_timesheet_usecase.dart';
import 'package:vstech_hrm/features/approvals/presentation/widgets/approval_card.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

/// Helper coordinating 3 approval domains: Timesheet Corrections, Leave, and Overtime.
abstract final class ApprovalsActionHandler {
  static final ValueNotifier<int> pendingCountNotifier = ValueNotifier<int>(0);
  static Future<List<ApprovalItem>>? _inFlightFetch;
  static List<ApprovalItem>? _cachedItems;
  static DateTime? _lastFetchTime;
  static const Duration _cacheTtl = Duration(seconds: 4);

  /// Clears in-memory approvals cache (e.g. after approval/rejection or pull to refresh).
  static void invalidateCache() {
    _cachedItems = null;
    _lastFetchTime = null;
  }

  /// Fetches pending approvals concurrently across all 3 domains with in-flight deduplication.
  static Future<List<ApprovalItem>> loadAllPendingApprovals({
    String? month,
    bool forceRefresh = false,
  }) async {
    final now = DateTime.now();
    if (!forceRefresh && _cachedItems != null && _lastFetchTime != null && now.difference(_lastFetchTime!) < _cacheTtl) {
      return _cachedItems!;
    }

    if (_inFlightFetch != null && !forceRefresh) {
      return await _inFlightFetch!;
    }

    final future = _executeFetch(month: month);
    _inFlightFetch = future;
    try {
      final items = await future;
      _cachedItems = items;
      _lastFetchTime = DateTime.now();
      pendingCountNotifier.value = items.where((i) => i.isPending).length;
      return items;
    } finally {
      _inFlightFetch = null;
    }
  }

  static Future<List<ApprovalItem>> _executeFetch({String? month}) async {
    final now = DateTime.now();
    final parts = (month ?? '').split('-');
    final y = parts.length >= 2 ? (int.tryParse(parts[0]) ?? now.year) : now.year;
    final m = parts.length >= 2 ? (int.tryParse(parts[1]) ?? now.month) : now.month;
    final mPad = m.toString().padLeft(2, '0');
    final lastDay = DateTime(y, m + 1, 0).day;
    final fromStr = '$y-$mPad-01T00:00:00';
    final toStr = '$y-$mPad-${lastDay.toString().padLeft(2, '0')}T23:59:59';

    final results = await Future.wait([
      sl<GetTimesheetsMobileUseCase>()(from: fromStr, to: toStr),
      sl<GetPendingLeaveApprovalsUseCase>()(month: month),
      sl<GetPendingOvertimeApprovalsUseCase>()(month: month),
      sl<GetPendingApprovalsUseCase>()(month: month),
    ]);

    final timesheetsRes = results[0] as Either<Failure, List<TimesheetMobileItemEntity>>;
    final leaveRes = results[1] as Either<Failure, List<LeaveItemEntity>>;
    final overtimeRes = results[2] as Either<Failure, List<OvertimeItemEntity>>;
    final correctionsRes = results[3] as Either<Failure, List<CorrectionItemEntity>>;

    final items = <ApprovalItem>[];

    // 1. TimeSheets (Xác nhận giờ công cấp dưới - GET /api/TimeSheets/mobile)
    timesheetsRes.fold((_) {}, (list) {
      for (final e in list) {
        final code = (e.code?.isNotEmpty == true) ? e.code! : (e.employeeCode != null ? 'CC-${e.employeeCode}' : 'CC');
        final workHours = e.validActualTime ?? e.actualWorkTime ?? 8.0;
        final shiftHours = e.shiftHour ?? 8.0;
        final note = (e.note?.trim().isNotEmpty == true) ? e.note!.trim() : null;
        final isRejected = note != null && note.contains('[Từ chối');
        final status = e.isConfirmed ? 1 : (isRejected ? 2 : 0);
        final statusText = isRejected
            ? 'Từ chối'
            : (e.isConfirmText ?? (e.isConfirmed ? 'Đã xác nhận' : 'Chưa xác nhận'));
        items.add(ApprovalItem(
          id: code,
          employeeCode: e.employeeCode,
          department: e.department,
          initials: (e.employeeName?.isNotEmpty == true) ? e.employeeName![0].toUpperCase() : 'CC',
          name: _formatName(e.employeeName, e.employeeCode),
          type: 'Xác nhận công',
          dates: e.workDate.toDisplayDate(),
          reason: note,
          category: 'timesheet',
          attendanceSnippet: 'Công: ${workHours}h (Ca ${shiftHours}h)',
          worktime: workHours,
          status: status,
          statusText: statusText,
        ));
      }
    });

    // 2. Timesheet Corrections (Phiếu giải trình / Sửa công)
    correctionsRes.fold((_) {}, (list) {
      for (final e in list) {
        final code = 'GC-${e.id}';
        final note = (e.note?.trim().isNotEmpty == true) ? e.note!.trim() : null;
        items.add(ApprovalItem(
          id: code,
          employeeCode: e.employeeCode,
          initials: (e.employeeName?.isNotEmpty == true) ? e.employeeName![0].toUpperCase() : 'GC',
          name: _formatName(e.employeeName, e.employeeCode),
          type: e.reasonTypeName ?? 'Giải trình công',
          dates: e.workDate.toDisplayDate(),
          reason: note,
          category: 'correction',
          attendanceSnippet: e.worktime != null ? 'Giờ làm: ${e.worktime}h' : null,
          worktime: e.worktime,
          status: e.isApproved ? 1 : (e.isReject ? 2 : 0),
          statusText: e.isApproved ? 'Đã duyệt' : (e.isReject ? 'Từ chối' : 'Chờ duyệt'),
          isLock: e.isLock,
        ));
      }
    });

    // 3. Leave Requests (Đơn xin nghỉ phép cấp dưới)
    leaveRes.fold((_) {}, (list) {
      for (final e in list) {
        final code = e.code.isNotEmpty ? e.code : 'NP';
        final fromStr = e.from ?? '';
        final toStr = e.to ?? '';
        final dateStr = (fromStr == toStr || toStr.isEmpty) ? fromStr : '$fromStr - $toStr';
        final note = (e.note?.trim().isNotEmpty == true) ? e.note!.trim() : null;
        items.add(ApprovalItem(
          id: code,
          employeeCode: e.employeeCode,
          initials: (e.employeeName?.isNotEmpty == true) ? e.employeeName![0].toUpperCase() : 'NP',
          name: _formatName(e.employeeName, e.employeeCode, 'Đơn nghỉ phép'),
          type: e.leavePlan,
          dates: dateStr.trim(),
          reason: note,
          attendanceSnippet: e.halfShiftType != null ? 'Hình thức: ${e.halfShiftType}' : null,
          status: e.status,
          statusText: e.statusText.isNotEmpty
              ? e.statusText
              : (e.isApproved ? 'Đã duyệt' : (e.isRejected ? 'Từ chối' : 'Chờ duyệt')),
        ));
      }
    });

    // 4. Overtime Requests (Đơn đăng ký tăng ca cấp dưới)
    overtimeRes.fold((_) {}, (list) {
      for (final e in list) {
        final code = e.code.isNotEmpty ? e.code : 'TC';
        final dateStr = '${e.date ?? ''} ${e.timeRange ?? ''}'.trim();
        final otReason = (e.note?.trim().isNotEmpty == true)
            ? e.note!.trim()
            : ((e.overtimeReason?.trim().isNotEmpty == true) ? e.overtimeReason!.trim() : null);
        items.add(ApprovalItem(
          id: code,
          employeeCode: e.employeeCode,
          initials: (e.employeeName?.isNotEmpty == true) ? e.employeeName![0].toUpperCase() : 'TC',
          name: _formatName(e.employeeName, e.employeeCode, 'Đăng ký tăng ca'),
          type: e.overtimeTypeName ?? 'Tăng ca',
          dates: dateStr,
          reason: otReason,
          category: 'ot',
          attendanceSnippet: e.length != null ? 'Thời lượng: ${e.length}h' : null,
          worktime: e.length,
          status: e.status,
          statusText: e.statusText.isNotEmpty
              ? e.statusText
              : (e.isApproved ? 'Đã duyệt' : (e.isRejected ? 'Từ chối' : 'Chờ duyệt')),
        ));
      }
    });

    return items;
  }

  static String _formatName(String? name, String? code, [String fallback = 'Nhân viên']) {
    if (name != null && name.isNotEmpty) return '$name (${code ?? 'NV'})';
    return code != null ? 'Nhân viên ($code)' : fallback;
  }

  /// Executes approval action based on item category.
  static Future<Either<Failure, String>> approve(
    ApprovalItem item, {
    double? hours,
    String? note,
  }) async {
    final idStr = item.id ?? '';
    final idInt = int.tryParse(idStr.replaceAll(RegExp('[^0-9]'), ''));

    if (item.category == 'leave') {
      final res = await sl<ApproveLeaveUseCase>()(idStr);
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã duyệt đơn nghỉ phép');
    }

    if (item.category == 'ot') {
      final res = await sl<ApproveOvertimeUseCase>()(idStr);
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã duyệt đơn tăng ca');
    }

    if (item.category == 'correction' && idInt != null) {
      final res = await sl<ApproveTimesheetCorrectionUseCase>()(
        idInt,
        confirmedWorktime: hours,
        note: note,
      );
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã duyệt phiếu giải trình');
    }

    if (item.category == 'timesheet' || (item.category == 'correction' && item.employeeCode != null)) {
      final empCode = item.employeeCode ?? '';
      final wDate = item.dates.contains('T') ? item.dates : '${item.dates}T00:00:00';
      final res = await sl<AdminConfirmTimesheetUseCase>()(
        employeeCode: empCode,
        workDate: wDate,
        validActualTime: hours ?? item.worktime ?? 8.0,
      );
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã xác nhận giờ công');
    }

    return const Left(ServerFailure(message: 'Yêu cầu không hợp lệ'));
  }

  /// Executes reject action based on item category.
  static Future<Either<Failure, String>> reject(
    ApprovalItem item, {
    String? reason,
  }) async {
    final idStr = item.id ?? '';
    final idInt = int.tryParse(idStr.replaceAll(RegExp('[^0-9]'), ''));

    if (item.category == 'leave') {
      final res = await sl<RejectLeaveUseCase>()(idStr);
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã từ chối đơn nghỉ phép');
    }

    if (item.category == 'ot') {
      final res = await sl<RejectOvertimeUseCase>()(idStr);
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã từ chối đơn tăng ca');
    }

    if (item.category == 'correction' && idInt != null) {
      final res = await sl<RejectTimesheetCorrectionUseCase>()(
        idInt,
        note: reason,
      );
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã từ chối phiếu giải trình');
    }

    if (item.category == 'timesheet' || (item.category == 'correction' && item.employeeCode != null)) {
      final empCode = item.employeeCode ?? '';
      final wDate = item.dates.contains('T') ? item.dates : '${item.dates}T00:00:00';
      final res = await sl<RejectTimesheetUseCase>()(
        employeeCode: empCode,
        workDate: wDate,
        reason: (reason != null && reason.trim().isNotEmpty) ? reason.trim() : 'Từ chối bởi quản lý',
      );
      res.fold((_) {}, (_) => invalidateCache());
      return res.map((r) => r.message ?? 'Đã từ chối giờ công');
    }

    return const Left(ServerFailure(message: 'Yêu cầu không hợp lệ'));
  }
}
