import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// Single responsibility UseCase for fetching the next attendance mode (IN / OUT).
class GetAttendModeUseCase {
  const new(this._repository);

  final AttendanceRepository _repository;

  Future<Either<Failure, String>> call() {
    return _repository.getAttendMode();
  }
}
