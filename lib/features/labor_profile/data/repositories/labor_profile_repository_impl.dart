import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/labor_profile/data/datasources/labor_profile_mock_datasource.dart';
import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';
import 'package:vstech_hrm/features/labor_profile/domain/repositories/labor_profile_repository.dart';

class LaborProfileRepositoryImpl implements LaborProfileRepository {
  const new(this._dataSource);

  final LaborProfileDataSource _dataSource;

  @override
  Future<Either<Failure, LaborProfileEntity>> getLaborProfile() async {
    try {
      final model = await _dataSource.getLaborProfile();
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(ServerFailure(message: 'Failed to load labor profile: $e'));
    }
  }
}
