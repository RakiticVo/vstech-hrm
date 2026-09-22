import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';

class MockAttendanceRepository extends Mock implements AttendanceRepository;

void main() {
  late MockAttendanceRepository mockRepository;
  late GetTodayAttendanceUseCase useCase;

  setUp(() {
    mockRepository = MockAttendanceRepository();
    useCase = GetTodayAttendanceUseCase(mockRepository);
  });

  const testToday = AttendanceTodayEntity(
    hasCheckedIn: true,
    hasCheckedOut: false,
    shiftName: 'Ca Hành chính',
    shiftStart: '08:30',
    shiftEnd: '17:30',
    classification: AttendanceClassification.onTime,
    todayDate: 'Thứ Ba, 20/09/2026',
    checkInTime: '08:24',
  );

  test('GetTodayAttendanceUseCase executes repository.getTodayAttendance successfully', () async {
    when(() => mockRepository.getTodayAttendance()).thenAnswer(
      (_) async => const Right<Failure, AttendanceTodayEntity>(testToday),
    );

    final result = await useCase();

    expect(result, equals(const Right<Failure, AttendanceTodayEntity>(testToday)));
    verify(() => mockRepository.getTodayAttendance()).called(1);
  });
}
