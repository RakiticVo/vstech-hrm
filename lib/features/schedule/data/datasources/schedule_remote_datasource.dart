import 'package:vstech_hrm/features/schedule/data/models/department_shift_day_model.dart';
import 'package:vstech_hrm/features/schedule/data/models/my_shift_day_model.dart';

/// Remote data source contract for shift schedules.
abstract class ScheduleRemoteDataSource {
  /// GET /api/ShiftSchedules/me
  Future<List<MyShiftDayModel>> getMyShiftSchedule({
    required String from,
    required String to,
  });

  /// GET /api/ShiftSchedules
  Future<List<DepartmentShiftDayModel>> getDepartmentShiftSchedule({
    required String from,
    required String to,
    String? departmentCode,
  });
}
