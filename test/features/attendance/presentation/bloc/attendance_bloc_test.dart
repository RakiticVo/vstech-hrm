import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_in_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_out_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';

class MockGetTodayAttendanceUseCase extends Mock implements GetTodayAttendanceUseCase;

class MockCheckInUseCase extends Mock implements CheckInUseCase;

class MockCheckOutUseCase extends Mock implements CheckOutUseCase;

void main() {
  late MockGetTodayAttendanceUseCase mockGetTodayAttendance;
  late MockCheckInUseCase mockCheckIn;
  late MockCheckOutUseCase mockCheckOut;
  late AttendanceBloc attendanceBloc;

  setUpAll(() {
    registerFallbackValue(
      CheckInParams(
        imagePath: '',
        lat: 0,
        lng: 0,
        bssid: '',
        capturedAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockGetTodayAttendance = MockGetTodayAttendanceUseCase();
    mockCheckIn = MockCheckInUseCase();
    mockCheckOut = MockCheckOutUseCase();
    attendanceBloc = AttendanceBloc(
      getTodayAttendanceUseCase: mockGetTodayAttendance,
      checkInUseCase: mockCheckIn,
      checkOutUseCase: mockCheckOut,
    );
  });

  tearDown(() async {
    await attendanceBloc.close();
  });

  final testRecord = AttendanceRecordEntity(
    id: 'att_001',
    timestamp: DateTime.now(),
    type: AttendanceType.checkIn,
    classification: AttendanceClassification.onTime,
    locationName: 'Trụ sở chính VSTech',
  );

  test('initial state has AttendanceProcessStatus.initial', () {
    expect(attendanceBloc.state.status, equals(AttendanceProcessStatus.initial));
  });

  blocTest<AttendanceBloc, AttendanceState>(
    'SubmitFaceScanEvent emits [submitting, success] on successful check-in',
    build: () {
      when(() => mockCheckIn(any())).thenAnswer((_) async => Right(testRecord));
      return attendanceBloc;
    },
    act: (bloc) => bloc.add(
      const SubmitFaceScanEvent(
        imagePath: 'test_face.jpg',
        type: AttendanceType.checkIn,
      ),
    ),
    expect: () => [
      predicate<AttendanceState>((s) => s.status == AttendanceProcessStatus.submitting),
      predicate<AttendanceState>(
        (s) => s.status == AttendanceProcessStatus.success && s.lastRecord == testRecord,
      ),
    ],
  );
}
