import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/widgets/month_picker_dialog.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';

/// Helper loading leave, overtime, and attendance correction requests for a given month.
abstract final class RequestsLoader {
  static Future<List<RequestData>> loadRequests({
    required String selectedMonth,
  }) async {
    final range = AppMonthPickerDialog.getMonthDateRange(selectedMonth);
    final leaveResult = await sl<GetLeaveRequestsUseCase>()(
      from: range?.from,
      to: range?.to,
    );
    final otResult = await sl<GetOvertimeRequestsUseCase>()(month: range?.from);
    final corrResult = await sl<GetCorrectionRequestsUseCase>()(
      month: range?.from,
    );

    final items = <RequestData>[];

    void addReq(
      String mark,
      String type,
      String dates,
      String key, {
      required bool isApproved,
      required bool isRejected,
      String? code,
      String? requesterName,
      String? reason,
      double? worktime,
      String? confirmerName,
    }) {
      final codeInt = isApproved ? 2 : (isRejected ? 3 : 1);
      final text = isApproved ? 'Đã duyệt' : (isRejected ? 'Từ chối' : 'Chờ duyệt');
      items.add(
        RequestData(
          mark: mark,
          type: type,
          dates: dates,
          status: text,
          statusCode: codeInt,
          stage: text,
          completedSteps: codeInt,
          requestTypeKey: key,
          code: code,
          requesterName: requesterName,
          reason: reason,
          worktime: worktime,
          confirmerName: confirmerName,
        ),
      );
    }

    leaveResult.fold((_) {}, (list) {
      for (final l in list) {
        final start = l.from ?? l.validFrom ?? '';
        final end = l.to ?? l.validTo ?? '';
        final dateStr = (start == end || end.isEmpty) ? start : '$start - $end';
        addReq(
          'P',
          l.leavePlan,
          dateStr,
          'leave',
          isApproved: l.isApproved,
          isRejected: l.isRejected,
          code: l.code,
          requesterName: l.employeeName,
          reason: l.note,
          confirmerName: l.confirmBy,
        );
      }
    });

    otResult.fold((_) {}, (list) {
      for (final o in list) {
        final hoursStr = o.length != null ? ' · ${o.length} giờ' : '';
        final rawReason = o.overtimeReason?.trim();
        final fallback =
            (rawReason != null && rawReason.isNotEmpty && rawReason != '.')
                ? rawReason
                : 'Tăng ca';
        final title = '${o.overtimeTypeName ?? fallback}$hoursStr';
        addReq(
          'T',
          title,
          '${o.date ?? ''} ${o.timeRange ?? ''}'.trim(),
          'ot',
          isApproved: o.isApproved,
          isRejected: o.isRejected,
          code: o.code,
          requesterName: o.employeeName,
          reason: o.note ?? o.overtimeReason,
          worktime: o.length,
          confirmerName: o.confirmedBy,
        );
      }
    });

    corrResult.fold((_) {}, (list) {
      for (final c in list) {
        addReq(
          'S',
          'Sửa công · ${c.reasonTypeName ?? 'Giải trình'}',
          '${c.workDate ?? ''} (${c.worktime ?? 0}h)',
          'correction',
          isApproved: c.isApproved,
          isRejected: c.isReject,
          code: 'TC-${c.id}',
          requesterName: c.employeeName ?? c.employeeCode,
          reason: c.note ?? c.reasonTypeName,
          worktime: c.worktime,
          confirmerName: c.confirmerName,
        );
      }
    });

    return items;
  }
}
