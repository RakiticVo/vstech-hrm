import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_managed_employees_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_leave_approvals_usecase.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_pending_overtime_approvals_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_department_shift_schedule_usecase.dart';

/// Roster loading result containing mapped roster items and discovered department list.
class DepartmentRosterResult {
  const new({
    required this.roster,
    required this.departmentMap,
  });

  final List<ShiftRosterItemEntity> roster;
  final Map<String, String> departmentMap;
}

/// Helper loading manager daily roster items and attaching employee tickets (OT, Leave, Correction).
abstract final class DepartmentRosterLoader {
  static String _formatDate(DateTime d) {
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final clean = raw.split('T')[0].trim();
    if (clean.contains('-')) {
      final parts = clean.split('-');
      if (parts.length == 3) {
        if (parts[0].length == 4) {
          final y = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          final d = int.tryParse(parts[2]);
          if (y != null && m != null && d != null) return DateTime(y, m, d);
        } else {
          final d = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          final y = int.tryParse(parts[2]);
          if (y != null && m != null && d != null) return DateTime(y, m, d);
        }
      }
    } else if (clean.contains('/')) {
      final parts = clean.split('/');
      if (parts.length == 3) {
        if (parts[2].length == 4) {
          final d = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          final y = int.tryParse(parts[2]);
          if (y != null && m != null && d != null) return DateTime(y, m, d);
        } else if (parts[0].length == 4) {
          final y = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          final d = int.tryParse(parts[2]);
          if (y != null && m != null && d != null) return DateTime(y, m, d);
        }
      }
    }
    return DateTime.tryParse(raw);
  }

  static bool _isSameDay(String? raw, DateTime target) {
    final parsed = _parseDate(raw);
    if (parsed == null) return false;
    return parsed.year == target.year && parsed.month == target.month && parsed.day == target.day;
  }

  static bool _isInRange(String? startRaw, String? endRaw, DateTime target) {
    final start = _parseDate(startRaw);
    if (start == null) return false;
    final end = _parseDate(endRaw) ?? start;
    final t = DateTime(target.year, target.month, target.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return !t.isBefore(s) && !t.isAfter(e);
  }

  static Future<DepartmentRosterResult> load({
    required DateTime target,
    required String? activeDeptCode,
    required GetManagedEmployeesUseCase getManagedEmployeesUseCase,
    required GetDepartmentShiftScheduleUseCase getDepartmentShiftScheduleUseCase,
    GetPendingLeaveApprovalsUseCase? getPendingLeaveApprovalsUseCase,
    GetPendingOvertimeApprovalsUseCase? getPendingOvertimeApprovalsUseCase,
    GetPendingApprovalsUseCase? getPendingApprovalsUseCase,
  }) async {
    final dateStr = _formatDate(target);
    final monthStr = '${target.year}-${target.month.toString().padLeft(2, '0')}-01';

    // 1. Fetch subordinates & 3 ticket categories in parallel
    final subFuture = getManagedEmployeesUseCase(from: dateStr, to: dateStr);
    final leaveFuture = getPendingLeaveApprovalsUseCase != null
        ? getPendingLeaveApprovalsUseCase(month: monthStr)
        : Future.value(const Right<Failure, List<LeaveItemEntity>>([]));
    final otFuture = getPendingOvertimeApprovalsUseCase != null
        ? getPendingOvertimeApprovalsUseCase(month: monthStr)
        : Future.value(const Right<Failure, List<OvertimeItemEntity>>([]));
    final corrFuture = getPendingApprovalsUseCase != null
        ? getPendingApprovalsUseCase(month: monthStr)
        : Future.value(const Right<Failure, List<CorrectionItemEntity>>([]));

    final results = await Future.wait([
      subFuture,
      leaveFuture,
      otFuture,
      corrFuture,
    ]);

    final subResult = results[0];
    var subordinates = <ManagedEmployeeEntity>[];
    subResult.fold((_) {}, (dynamic list) {
      if (list is List<ManagedEmployeeEntity>) subordinates = list;
    });

    var leaveList = <LeaveItemEntity>[];
    results[1].fold((_) {}, (dynamic list) {
      if (list is List<LeaveItemEntity>) leaveList = list;
    });

    var otList = <OvertimeItemEntity>[];
    results[2].fold((_) {}, (dynamic list) {
      if (list is List<OvertimeItemEntity>) otList = list;
    });

    var corrList = <CorrectionItemEntity>[];
    results[3].fold((_) {}, (dynamic list) {
      if (list is List<CorrectionItemEntity>) corrList = list;
    });

    final deptMap = <String, String>{};
    for (final emp in subordinates) {
      if (emp.departmentCode != null && emp.departmentCode!.isNotEmpty) {
        deptMap[emp.departmentCode!] = emp.department ?? emp.departmentCode!;
      }
    }

    // 2. Fetch assigned shifts for department
    var assignedShifts = <DepartmentShiftDayEntity>[];
    if (activeDeptCode != null && activeDeptCode != 'ALL' && activeDeptCode.isNotEmpty) {
      final assignedRes = await getDepartmentShiftScheduleUseCase(
        from: dateStr,
        to: dateStr,
        departmentCode: activeDeptCode,
      );
      assignedShifts = assignedRes.getOrElse((_) => []);
    } else if (deptMap.isNotEmpty) {
      final shiftResults = await Future.wait(
        deptMap.keys.map(
          (code) => getDepartmentShiftScheduleUseCase(
            from: dateStr,
            to: dateStr,
            departmentCode: code,
          ),
        ),
      );
      for (final res in shiftResults) {
        assignedShifts.addAll(res.getOrElse((_) => []));
      }
    }

    // 3. Match tickets for each subordinate employee
    final roster = subordinates.map((emp) {
      final assigned = assignedShifts.where((s) => s.employeeCode == emp.code);
      final empCode = emp.code.trim().toUpperCase();

      // Match leave tickets for this employee
      final empLeaves = leaveList.where((l) {
        if (l.employeeCode?.trim().toUpperCase() != empCode) return false;
        final start = l.from ?? l.validFrom;
        final end = l.to ?? l.validTo;
        return _isInRange(start, end, target);
      }).toList();

      // Match overtime tickets for this employee
      final empOts = otList.where((o) {
        if (o.employeeCode?.trim().toUpperCase() != empCode) return false;
        return _isSameDay(o.date, target);
      }).toList();

      // Match correction / explanation tickets for this employee
      final empCorrs = corrList.where((c) {
        if (c.employeeCode?.trim().toUpperCase() != empCode) return false;
        return _isSameDay(c.workDate, target);
      }).toList();

      if (assigned.isNotEmpty) {
        final first = assigned.first;
        return ShiftRosterItemEntity(
          employeeCode: emp.code,
          employeeName: emp.name,
          date: target,
          departmentCode: emp.departmentCode,
          departmentName: emp.department,
          shiftCode: first.shiftCode,
          shiftName: first.shiftName ?? 'Ca làm việc',
          startHour: emp.shiftStart,
          endHour: emp.shiftEnd,
          source: 'SCHEDULE',
          assignedBy: first.createdBy,
          assignedAt: first.createdAt,
          leaveRequests: empLeaves,
          overtimeRequests: empOts,
          correctionRequests: empCorrs,
          shiftColor: first.color ?? emp.shiftColor,
          shiftTextColor: first.textColor ?? emp.shiftTextColor,
        );
      }

      if (emp.shiftCode != null && emp.shiftCode!.isNotEmpty) {
        return ShiftRosterItemEntity(
          employeeCode: emp.code,
          employeeName: emp.name,
          date: target,
          departmentCode: emp.departmentCode,
          departmentName: emp.department,
          shiftCode: emp.shiftCode,
          shiftName: emp.shiftName ?? 'Ca cố định',
          startHour: emp.shiftStart,
          endHour: emp.shiftEnd,
          leaveRequests: empLeaves,
          overtimeRequests: empOts,
          correctionRequests: empCorrs,
          shiftColor: emp.shiftColor,
          shiftTextColor: emp.shiftTextColor,
        );
      }

      return ShiftRosterItemEntity(
        employeeCode: emp.code,
        employeeName: emp.name,
        date: target,
        departmentCode: emp.departmentCode,
        departmentName: emp.department,
        shiftName: 'Nghỉ tuần',
        source: 'OFF',
        leaveRequests: empLeaves,
        overtimeRequests: empOts,
        correctionRequests: empCorrs,
      );
    }).toList();

    return DepartmentRosterResult(roster: roster, departmentMap: deptMap);
  }
}
