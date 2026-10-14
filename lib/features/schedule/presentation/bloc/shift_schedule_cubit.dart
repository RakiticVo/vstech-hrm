import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_managed_employees_usecase.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_department_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/domain/usecases/get_my_shift_schedule_usecase.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_schedule_state.dart';
import 'package:vstech_hrm/features/schedule/presentation/bloc/shift_week_mapper.dart';

/// Cubit managing personal shift schedule and manager daily roster state.
class ShiftScheduleCubit extends Cubit<ShiftScheduleState> {
  ShiftScheduleCubit({
    required this.getMyShiftScheduleUseCase,
    required this.getDepartmentShiftScheduleUseCase,
    required this.getManagedEmployeesUseCase,
    DateTime? initialDate,
  }) : super(
          ShiftScheduleState(
            selectedDate: initialDate ?? DateTime.now(),
          ),
        );

  final GetMyShiftScheduleUseCase getMyShiftScheduleUseCase;
  final GetDepartmentShiftScheduleUseCase getDepartmentShiftScheduleUseCase;
  final GetManagedEmployeesUseCase getManagedEmployeesUseCase;
  String _monthKey(DateTime d) => '${d.year}-${d.month}';

  String _formatDate(DateTime d) {
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// Loads personal shifts for the whole month surrounding [anchorDate].
  Future<void> loadMyShifts({DateTime? anchorDate}) async {
    final target = anchorDate ?? state.selectedDate;
    final mKey = _monthKey(target);
    final firstDayOfMonth = DateTime(target.year, target.month);
    final lastDayOfMonth = DateTime(target.year, target.month + 1, 0);

    if (state.monthlyShiftsCache.containsKey(mKey)) {
      final cached = state.monthlyShiftsCache[mKey]!;
      final monday = target.subtract(Duration(days: target.weekday - 1));
      final week = ShiftWeekMapper.mapToWeekShifts(monday, cached);
      emit(
        state.copyWith(
          personalStatus: ScheduleLoadingStatus.success,
          myShifts: cached,
          weekShifts: week,
          selectedDate: target,
        ),
      );
    } else {
      emit(state.copyWith(personalStatus: ScheduleLoadingStatus.loading));
    }

    final result = await getMyShiftScheduleUseCase(
      from: _formatDate(firstDayOfMonth),
      to: _formatDate(lastDayOfMonth),
    );

    result.fold(
      (failure) {
        if (!state.monthlyShiftsCache.containsKey(mKey)) {
          final monday = target.subtract(Duration(days: target.weekday - 1));
          final emptyWeek = ShiftWeekMapper.mapToWeekShifts(monday, const []);
          emit(
            state.copyWith(
              personalStatus: ScheduleLoadingStatus.failure,
              myShifts: const [],
              weekShifts: emptyWeek,
              errorMessage: failure.message,
              selectedDate: target,
            ),
          );
        }
      },
      (items) {
        final newCache = Map<String, List<MyShiftDayEntity>>.from(state.monthlyShiftsCache);
        newCache[mKey] = items;
        final monday = target.subtract(Duration(days: target.weekday - 1));
        final week = ShiftWeekMapper.mapToWeekShifts(monday, items);
        emit(
          state.copyWith(
            personalStatus: ScheduleLoadingStatus.success,
            myShifts: items,
            monthlyShiftsCache: newCache,
            weekShifts: week,
            selectedDate: target,
          ),
        );
      },
    );
  }

  /// Fetches shifts for month [monthDate] to display dots in month dialog.
  Future<void> fetchShiftsForMonth(DateTime monthDate) async {
    final mKey = _monthKey(monthDate);
    if (state.monthlyShiftsCache.containsKey(mKey)) return;

    final firstDay = DateTime(monthDate.year, monthDate.month);
    final lastDay = DateTime(monthDate.year, monthDate.month + 1, 0);

    final result = await getMyShiftScheduleUseCase(
      from: _formatDate(firstDay),
      to: _formatDate(lastDay),
    );

    result.fold(
      (_) {},
      (items) {
        final newCache = Map<String, List<MyShiftDayEntity>>.from(state.monthlyShiftsCache);
        newCache[mKey] = items;
        final isCurrentMonth = state.selectedDate.year == monthDate.year &&
            state.selectedDate.month == monthDate.month;
        if (isCurrentMonth) {
          final monday = state.selectedDate.subtract(Duration(days: state.selectedDate.weekday - 1));
          final week = ShiftWeekMapper.mapToWeekShifts(monday, items);
          emit(state.copyWith(
            monthlyShiftsCache: newCache,
            myShifts: items,
            weekShifts: week,
          ));
        } else {
          emit(state.copyWith(monthlyShiftsCache: newCache));
        }
      },
    );
  }

  /// Loads manager's daily roster for [date] across subordinates.
  Future<void> loadDepartmentRoster({
    DateTime? date,
    String? departmentCode,
  }) async {
    final target = date ?? state.selectedDate;
    final dateStr = _formatDate(target);

    emit(state.copyWith(rosterStatus: ScheduleLoadingStatus.loading));

    final subordinatesRes = await getManagedEmployeesUseCase(
      from: dateStr,
      to: dateStr,
    );

    await subordinatesRes.fold(
      (failure) async {
        emit(
          state.copyWith(
            rosterStatus: ScheduleLoadingStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (subordinates) async {
        final deptMap = <String, String>{};
        for (final emp in subordinates) {
          if (emp.departmentCode != null && emp.departmentCode!.isNotEmpty) {
            deptMap[emp.departmentCode!] = emp.department ?? emp.departmentCode!;
          }
        }

        final activeDeptCode = departmentCode ?? state.selectedDepartmentCode;

        var assignedShifts = <DepartmentShiftDayEntity>[];
        if (activeDeptCode != null && activeDeptCode != 'ALL' && activeDeptCode.isNotEmpty) {
          final assignedRes = await getDepartmentShiftScheduleUseCase(
            from: dateStr,
            to: dateStr,
            departmentCode: activeDeptCode,
          );
          assignedShifts = assignedRes.getOrElse((_) => []);
        } else if (deptMap.isNotEmpty) {
          final results = await Future.wait(
            deptMap.keys.map(
              (code) => getDepartmentShiftScheduleUseCase(
                from: dateStr,
                to: dateStr,
                departmentCode: code,
              ),
            ),
          );
          for (final res in results) {
            assignedShifts.addAll(res.getOrElse((_) => []));
          }
        }

        final roster = subordinates.map((emp) {
          final assigned = assignedShifts.where((s) => s.employeeCode == emp.code);
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
          );
        }).toList();

        emit(
          state.copyWith(
            rosterStatus: ScheduleLoadingStatus.success,
            rosterItems: roster,
            selectedDepartmentCode: activeDeptCode,
            availableDepartments: deptMap,
          ),
        );
      },
    );
  }

  /// Changes active department for manager view and reloads roster.
  void selectDepartment(String departmentCode) {
    emit(state.copyWith(selectedDepartmentCode: departmentCode));
    unawaited(loadDepartmentRoster(departmentCode: departmentCode));
  }

  /// Handles date selection changes.
  void selectDate(DateTime newDate, {bool isManager = false, String? departmentCode}) {
    final mKey = _monthKey(newDate);
    final hasCache = state.monthlyShiftsCache.containsKey(mKey);
    final shiftsForMonth = hasCache
        ? state.monthlyShiftsCache[mKey]!
        : (newDate.month == state.selectedDate.month && newDate.year == state.selectedDate.year
            ? state.myShifts
            : const <MyShiftDayEntity>[]);

    final monday = newDate.subtract(Duration(days: newDate.weekday - 1));
    final week = ShiftWeekMapper.mapToWeekShifts(monday, shiftsForMonth);

    emit(state.copyWith(
      selectedDate: newDate,
      myShifts: shiftsForMonth,
      weekShifts: week,
    ));

    if (!hasCache) {
      unawaited(loadMyShifts(anchorDate: newDate));
    }

    if (isManager) {
      unawaited(loadDepartmentRoster(date: newDate, departmentCode: departmentCode));
    }
  }

  void setShiftFilter(String filter) {
    emit(state.copyWith(selectedShiftFilter: filter));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
