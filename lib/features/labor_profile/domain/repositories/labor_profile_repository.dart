import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';

/// Contract for fetching employee labor and contract profile.
abstract class LaborProfileRepository {
  Future<Either<Failure, LaborProfileEntity>> getLaborProfile();
}
