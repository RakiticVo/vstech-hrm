import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/timesheet_detail_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_timesheet_detail_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/timesheet_detail_cards.dart';

/// Modal bottom sheet displaying detailed timesheet & attendance logs for a selected day.
class DailyAttendanceDetailSheet extends StatefulWidget {
  const new({
    required this.record,
    this.timesheet,
    super.key,
  });

  final AttendanceRecordEntity record;
  final AccountTimesheetEntity? timesheet;

  static Future<void> show(
    BuildContext context, {
    required AttendanceRecordEntity record,
    AccountTimesheetEntity? timesheet,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DailyAttendanceDetailSheet(
        record: record,
        timesheet: timesheet,
      ),
    );
  }

  @override
  State<DailyAttendanceDetailSheet> createState() => _DailyAttendanceDetailSheetState();
}

class _DailyAttendanceDetailSheetState extends State<DailyAttendanceDetailSheet> {
  TimesheetDetailEntity? _detail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadTimesheetDetail());
  }

  Future<void> _loadTimesheetDetail() async {
    // If timesheet is already provided, all timesheet variables (leaveTime, overtime, etc.)
    // are already available from /api/Account/timesheet. No extra API call needed.
    if (widget.timesheet != null) {
      return;
    }

    final id = widget.record.id;
    // Enrollment IDs ('1834448_in', '1834448_out', 'att_...') come from GET /api/Account/enrollment.
    // They are not timesheet line codes, so they do not need GET /api/TimeSheets/{id}.
    final isEnrollmentId = id.contains('_in') || id.contains('_out') || id.startsWith('att_');
    if (isEnrollmentId) {
      return;
    }

    setState(() => _isLoading = true);
    final result = await sl<GetTimesheetDetailUseCase>()(id);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (data) => setState(() {
        _isLoading = false;
        _detail = data;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final rec = widget.record;
    final dateStr = DateFormat('EEEE, dd/MM/yyyy', 'vi').format(rec.timestamp);

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          10.gapH,
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.timesheetDetailTitle,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary),
                      ),
                      3.gapH,
                      Text(dateStr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: colors.textSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimesheetOverviewCard(record: rec, detail: _detail, timesheet: widget.timesheet),
                    14.gapH,
                    TimesheetTimeCard(record: rec, detail: _detail, timesheet: widget.timesheet),
                    if (_hasSlips) ...[
                      14.gapH,
                      TimesheetSlipsCard(detail: _detail!),
                    ],
                    24.gapH,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get _hasSlips =>
      _detail?.overtimeSlip != null ||
      _detail?.confirmRequestId != null ||
      _detail?.leaveSlip != null ||
      _detail?.businessSlip != null;
}
