import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_in_usecase.dart';

class MockAttendanceRepository extends Mock implements AttendanceRepository;

void main() {
  late MockAttendanceRepository mockRepository;
  late CheckInUseCase checkInUseCase;

  setUp(() {
    mockRepository = MockAttendanceRepository();
    checkInUseCase = CheckInUseCase(mockRepository);
  });

  final testParams = CheckInParams(
    imagePath: 'mock_image.jpg',
    lat: 10.7769,
    lng: 106.7009,
    bssid: 'vstech-office-5g',
    capturedAt: DateTime(2026, 9, 20, 8, 24),
  );

  final testRecord = AttendanceRecordEntity(
    id: 'att_001',
    timestamp: DateTime(2026, 9, 20, 8, 24),
    type: AttendanceType.checkIn,
    classification: AttendanceClassification.onTime,
    locationName: 'Trụ sở chính VSTech',
  );

  test('CheckInUseCase executes repository.checkIn successfully', () async {
    when(() => mockRepository.checkIn(testParams)).thenAnswer(
      (_) async => Right<Failure, AttendanceRecordEntity>(testRecord),
    );

    final result = await checkInUseCase(testParams);

    expect(result, equals(Right<Failure, AttendanceRecordEntity>(testRecord)));
    verify(() => mockRepository.checkIn(testParams)).called(1);
  });
}
