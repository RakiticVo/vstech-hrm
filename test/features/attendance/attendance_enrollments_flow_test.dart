import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_today_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/enroll_action_response_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/enroll_form_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/enrollment_attend_response_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/enrollment_info_model.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  group('Flow 2: Attendance & Enrollments OpenAPI Integration Tests', () {
    late MockDioClient mockDioClient;
    late AttendanceRemoteDataSource remoteDataSource;

    setUp(() {
      mockDioClient = MockDioClient();
      remoteDataSource = AttendanceRemoteDataSourceImpl(dioClient: mockDioClient);
    });

    test('TC-ENROLL-01: Checkin with EnrollForm sends GPS and Wi-Fi, returns EnrollActionResponse', () async {
      when(() => mockDioClient.post<dynamic>(
            ApiEndpoints.attendanceCheckIn,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'message': 'Ghi nhận chấm công vào ca thành công lúc 08:04',
            'checkin': true,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.attendanceCheckIn),
        ),
      );

      final checkInParams = CheckInParams(
        imagePath: '/tmp/face.jpg',
        lat: 10.7769,
        lng: 106.7009,
        bssid: 'vstech-5g',
        capturedAt: DateTime(2026, 10, 2, 8, 4),
      );

      final result = await remoteDataSource.checkIn(checkInParams);

      expect(result.type, equals('checkIn'));
      expect(result.classification, equals('onTime'));
      expect(result.note, contains('Ghi nhận chấm công vào ca thành công'));
    });

    test('TC-ENROLL-02: getTodayAttendance parses OpenAPI EnrollmentInfoResponse properly', () async {
      final mockOpenApiResponse = <String, dynamic>{
        'enroll': 'OUT',
        'startShift': '08:00',
        'endShift': '17:00',
        'serverTime': '2026-10-02T08:05:00',
        'isValidCheckIn': true,
        'facialDisabled': false,
        'timesheet': <String, dynamic>{
          'code': 'TS-20261002',
          'employeeCode': 'NV0142',
          'workDate': '2026-10-02',
          'late': 0.0,
          'early': 0.0,
          'actualTime': 4.0,
        },
        'enrolls': <dynamic>[
          <String, dynamic>{
            'date': '02-10-2026',
            'checkin': '01:00:00',
            'checkout': '00:00:00',
            'early': 0.0,
            'late': 0.0,
            'total': 0.0,
          }
        ],
      };

      when(() => mockDioClient.get<dynamic>(ApiEndpoints.attendanceToday)).thenAnswer(
        (_) async => Response<dynamic>(
          data: mockOpenApiResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.attendanceToday),
        ),
      );

      final model = await remoteDataSource.getTodayAttendance();
      final entity = model.toEntity();

      expect(entity.shiftStart, equals('08:00'));
      expect(entity.shiftEnd, equals('17:00'));
      expect(entity.checkInTime, equals('08:00'));
      expect(entity.checkOutTime, isNull);
      expect(entity.hasCheckedIn, isTrue);
      expect(entity.hasCheckedOut, isFalse);
    });

    test('TC-ENROLL-03: getAttendMode calls attend endpoint and returns IN or OUT', () async {
      when(() => mockDioClient.get<dynamic>(ApiEndpoints.enrollmentAttend)).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'mode': 'OUT'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.enrollmentAttend),
        ),
      );

      final mode = await remoteDataSource.getAttendMode();
      expect(mode, equals('OUT'));
    });

    test('EnrollFormModel serialization generates correct OpenAPI schema payload', () {
      const form = EnrollFormModel(
        coordinate: '10.7769,106.7009',
        local: 'VSTech-HQ-WiFi',
        fingerprint: 'device_fp_pixel7',
        ip4: '192.168.1.10',
      );

      final json = form.toJson();

      expect(json['coordinate'], equals('10.7769,106.7009'));
      expect(json['local'], equals('VSTech-HQ-WiFi'));
      expect(json['fingerprint'], equals('device_fp_pixel7'));
      expect(json['ip4'], equals('192.168.1.10'));
    });
  });
}
