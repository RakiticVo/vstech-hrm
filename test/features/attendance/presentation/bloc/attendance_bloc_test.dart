import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_check_reg_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/face_verify_result_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_face_registration_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_in_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_out_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/verify_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';

class MockGetTodayAttendanceUseCase extends Mock implements GetTodayAttendanceUseCase;
class MockCheckInUseCase extends Mock implements CheckInUseCase;
class MockCheckOutUseCase extends Mock implements CheckOutUseCase;
class MockCheckFaceRegistrationUseCase extends Mock implements CheckFaceRegistrationUseCase;
class MockVerifyFaceUseCase extends Mock implements VerifyFaceUseCase;

void main() {
  late MockGetTodayAttendanceUseCase mockGetTodayAttendance;
  late MockCheckInUseCase mockCheckIn;
  late MockCheckOutUseCase mockCheckOut;
  late MockCheckFaceRegistrationUseCase mockCheckFaceReg;
  late MockVerifyFaceUseCase mockVerifyFace;
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
    mockCheckFaceReg = MockCheckFaceRegistrationUseCase();
    mockVerifyFace = MockVerifyFaceUseCase();

    attendanceBloc = AttendanceBloc(
      getTodayAttendanceUseCase: mockGetTodayAttendance,
      checkInUseCase: mockCheckIn,
      checkOutUseCase: mockCheckOut,
      checkFaceRegistrationUseCase: mockCheckFaceReg,
      verifyFaceUseCase: mockVerifyFace,
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
    'PrepareFaceScanEvent with unregistered face emits [loading, faceNotRegistered]',
    build: () {
      when(() => mockCheckFaceReg(code: any(named: 'code'))).thenAnswer(
        (_) async => const Right(
          FaceCheckRegEntity(
            isSuccess: true,
            isRegistered: false,
            count: 0,
            message: 'Chưa đăng ký nhận diện khuôn mặt',
          ),
        ),
      );
      return attendanceBloc;
    },
    act: (bloc) => bloc.add(
      const PrepareFaceScanEvent(
        type: AttendanceType.checkIn,
        employeeCode: 'NV001',
      ),
    ),
    expect: () => [
      predicate<AttendanceState>((s) => s.status == AttendanceProcessStatus.loading),
      predicate<AttendanceState>(
        (s) => s.status == AttendanceProcessStatus.faceNotRegistered && s.isFaceRegistered == false,
      ),
    ],
  );

  blocTest<AttendanceBloc, AttendanceState>(
    'SubmitFaceScanEvent with mismatched face emits [faceVerifying, faceVerifyFailed] and does NOT punch',
    build: () {
      when(() => mockVerifyFace(
            code: any(named: 'code'),
            imagePath: any(named: 'imagePath'),
          )).thenAnswer(
        (_) async => const Right(
          FaceVerifyResultEntity(
            isSuccess: false,
            isMatch: false,
            message: 'Khuôn mặt không khớp',
          ),
        ),
      );
      return attendanceBloc;
    },
    act: (bloc) => bloc.add(
      const SubmitFaceScanEvent(
        imagePath: 'test_face.jpg',
        type: AttendanceType.checkIn,
        employeeCode: 'NV001',
      ),
    ),
    expect: () => [
      predicate<AttendanceState>((s) => s.status == AttendanceProcessStatus.faceVerifying),
      predicate<AttendanceState>((s) => s.status == AttendanceProcessStatus.faceVerifyFailed),
    ],
    verify: (_) {
      verifyNever(() => mockCheckIn(any()));
    },
  );

  blocTest<AttendanceBloc, AttendanceState>(
    'SubmitFaceScanEvent with verified face emits [faceVerifying, submitting, success]',
    build: () {
      when(() => mockVerifyFace(
            code: any(named: 'code'),
            imagePath: any(named: 'imagePath'),
          )).thenAnswer(
        (_) async => const Right(
          FaceVerifyResultEntity(
            isSuccess: true,
            isMatch: true,
            similarity: 0.95,
            message: 'Xác thực thành công',
          ),
        ),
      );
      when(() => mockCheckIn(any())).thenAnswer((_) async => Right(testRecord));
      when(() => mockGetTodayAttendance()).thenAnswer(
        (_) async => const Right(
          AttendanceTodayEntity(
            hasCheckedIn: true,
            hasCheckedOut: false,
            shiftName: 'Ca Tiêu chuẩn',
            shiftStart: '07:30',
            shiftEnd: '17:30',
            classification: AttendanceClassification.onTime,
            todayDate: '2026-10-05',
            checkInTime: '08:00',
          ),
        ),
      );
      return attendanceBloc;
    },
    act: (bloc) => bloc.add(
      const SubmitFaceScanEvent(
        imagePath: 'test_face.jpg',
        type: AttendanceType.checkIn,
        employeeCode: 'NV001',
      ),
    ),
    expect: () => [
      predicate<AttendanceState>((s) => s.status == AttendanceProcessStatus.faceVerifying),
      predicate<AttendanceState>((s) => s.status == AttendanceProcessStatus.submitting),
      predicate<AttendanceState>(
        (s) => s.status == AttendanceProcessStatus.success && s.lastRecord == testRecord,
      ),
    ],
  );
}
