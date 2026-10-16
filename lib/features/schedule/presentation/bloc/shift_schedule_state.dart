import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_roster_item_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';

enum ScheduleLoadingStatus { initial, loading, success, failure }

/// State of the shift schedule module covering personal schedule & manager roster.
class ShiftScheduleState extends Equatable {
  const ShiftScheduleState({
    required this.selectedDate,
    this.personalStatus = ScheduleLoadingStatus.initial,
    this.rosterStatus = ScheduleLoadingStatus.initial,
    this.weekShifts = const [],
    this.myShifts = const [],
    this.monthlyShiftsCache = const {},
    this.rosterItems = const [],
    this.selectedShiftFilter = 'ALL',
    this.searchQuery = '',
    this.selectedDepartmentCode,
    this.availableDepartments = const {},
    this.errorMessage,
  });

  /// Status of personal shift loading.
  final ScheduleLoadingStatus personalStatus;

  /// Status of manager roster loading.
  final ScheduleLoadingStatus rosterStatus;

  /// Selected calendar date.
  final DateTime selectedDate;

  /// 7-day capsule entities for current week.
  final List<ShiftScheduleEntity> weekShifts;

  /// All personal shifts returned by GET /api/ShiftSchedules/me.
  final List<MyShiftDayEntity> myShifts;

  /// Map of shifts cached by 'YYYY-MM' key to prevent losing data when switching months.
  final Map<String, List<MyShiftDayEntity>> monthlyShiftsCache;

  /// Subordinates daily roster items for manager view.
  final List<ShiftRosterItemEntity> rosterItems;

  /// Filter code for roster ('ALL', 'OFF', or specific shiftCode).
  final String selectedShiftFilter;

  /// Search keyword for filtering roster items.
  final String searchQuery;

  /// Selected department code for manager scope ('ALL' or specific code).
  final String? selectedDepartmentCode;

  /// Map of {departmentCode: departmentName} available under manager scope.
  final Map<String, String> availableDepartments;

  /// Error message if loading failed.
  final String? errorMessage;

  /// Selected shift entity corresponding to [selectedDate].
  ShiftScheduleEntity? get selectedShift {
    if (weekShifts.isEmpty) return null;
    return weekShifts.firstWhere(
      (s) =>
          s.date.year == selectedDate.year &&
          s.date.month == selectedDate.month &&
          s.date.day == selectedDate.day,
      orElse: () => weekShifts.first,
    );
  }

  /// Filtered list of roster items based on search, shift filter, and department.
  List<ShiftRosterItemEntity> get filteredRosterItems {
    return rosterItems.where((item) {
      // 1. Department filter (only if selected and not ALL)
      if (selectedDepartmentCode != null &&
          selectedDepartmentCode != 'ALL' &&
          selectedDepartmentCode!.isNotEmpty) {
        if (item.departmentCode != selectedDepartmentCode) {
          return false;
        }
      }

      // 2. Shift filter
      if (selectedShiftFilter != 'ALL') {
        if (selectedShiftFilter == 'OFF' && !item.isDayOff) return false;
        if (selectedShiftFilter != 'OFF' && item.shiftCode != selectedShiftFilter) {
          return false;
        }
      }

      // 3. Search query filter
      if (searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchName = item.employeeName.toLowerCase().contains(query);
        final matchCode = item.employeeCode.toLowerCase().contains(query);
        if (!matchName && !matchCode) return false;
      }

      return true;
    }).toList();
  }

  /// Total subordinates in current daily roster.
  int get totalRosterEmployees => rosterItems.length;

  /// Number of subordinates on duty on selected date.
  int get onDutyCount => rosterItems.where((i) => !i.isDayOff).length;

  /// Number of subordinates off duty on selected date.
  int get offDutyCount => rosterItems.where((i) => i.isDayOff).length;

  /// Distinct shift codes present in the roster.
  List<String> get availableShiftCodes {
    final set = <String>{};
    for (final item in rosterItems) {
      if (item.shiftCode != null && item.shiftCode!.isNotEmpty) {
        set.add(item.shiftCode!);
      }
    }
    return set.toList()..sort();
  }

  ShiftScheduleState copyWith({
    DateTime? selectedDate,
    ScheduleLoadingStatus? personalStatus,
    ScheduleLoadingStatus? rosterStatus,
    List<ShiftScheduleEntity>? weekShifts,
    List<MyShiftDayEntity>? myShifts,
    Map<String, List<MyShiftDayEntity>>? monthlyShiftsCache,
    List<ShiftRosterItemEntity>? rosterItems,
    String? selectedShiftFilter,
    String? searchQuery,
    String? selectedDepartmentCode,
    Map<String, String>? availableDepartments,
    String? errorMessage,
  }) {
    return ShiftScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      personalStatus: personalStatus ?? this.personalStatus,
      rosterStatus: rosterStatus ?? this.rosterStatus,
      weekShifts: weekShifts ?? this.weekShifts,
      myShifts: myShifts ?? this.myShifts,
      monthlyShiftsCache: monthlyShiftsCache ?? this.monthlyShiftsCache,
      rosterItems: rosterItems ?? this.rosterItems,
      selectedShiftFilter: selectedShiftFilter ?? this.selectedShiftFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDepartmentCode: selectedDepartmentCode ?? this.selectedDepartmentCode,
      availableDepartments: availableDepartments ?? this.availableDepartments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        personalStatus,
        rosterStatus,
        weekShifts,
        myShifts,
        monthlyShiftsCache,
        rosterItems,
        selectedShiftFilter,
        searchQuery,
        selectedDepartmentCode,
        availableDepartments,
        errorMessage,
      ];
}
