import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/repositories/schedule_repository.dart';

/// UseCase to fetch personal shift schedules of current authenticated user
/// (GET /api/ShiftSchedules/me).
class GetMyShiftScheduleUseCase {
  const new(this._repository);

  final ScheduleRepository _repository;

  Future<Either<Failure, List<MyShiftDayEntity>>> call({
    required String from,
    required String to,
  }) {
    return _repository.getMyShiftSchedule(from: from, to: to);
  }
}
