import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// UseCase executing Check-in action with face photo and location metadata.
class CheckInUseCase {
  const new(this._repository);

  final AttendanceRepository _repository;

  Future<Either<Failure, AttendanceRecordEntity>> call(CheckInParams params) {
    return _repository.checkIn(params);
  }
}
