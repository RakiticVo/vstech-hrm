import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_out_usecase.dart';

class MockAttendanceRepository extends Mock implements AttendanceRepository;

void main() {
  late MockAttendanceRepository mockRepository;
  late CheckOutUseCase checkOutUseCase;

  setUp(() {
    mockRepository = MockAttendanceRepository();
    checkOutUseCase = CheckOutUseCase(mockRepository);
  });

  final testParams = CheckInParams(
    imagePath: 'mock_image_checkout.jpg',
    lat: 10.7769,
    lng: 106.7009,
    bssid: 'vstech-office-5g',
    capturedAt: DateTime(2026, 9, 20, 17, 30),
  );

  final testRecord = AttendanceRecordEntity(
    id: 'att_002',
    timestamp: DateTime(2026, 9, 20, 17, 30),
    type: AttendanceType.checkOut,
    classification: AttendanceClassification.onTime,
    locationName: 'Trụ sở chính VSTech',
  );

  test('CheckOutUseCase executes repository.checkOut successfully', () async {
    when(() => mockRepository.checkOut(testParams)).thenAnswer(
      (_) async => Right<Failure, AttendanceRecordEntity>(testRecord),
    );

    final result = await checkOutUseCase(testParams);

    expect(result, equals(Right<Failure, AttendanceRecordEntity>(testRecord)));
    verify(() => mockRepository.checkOut(testParams)).called(1);
  });
}
