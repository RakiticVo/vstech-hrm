import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/network/face_dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/face_auth_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/data/repositories/face_auth_repository_impl.dart';

class MockFaceDioClient extends Mock implements FaceDioClient;

void main() {
  group('Face Authentication API Integration Tests (face.vitinhkimhung.com)', () {
    late MockFaceDioClient mockClient;
    late FaceAuthRemoteDataSource remoteDataSource;
    late FaceAuthRepositoryImpl repository;

    setUp(() {
      mockClient = MockFaceDioClient();
      remoteDataSource = FaceAuthRemoteDataSourceImpl(faceDioClient: mockClient);
      repository = FaceAuthRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('TC-FACE-01: checkRegistration parses unregistered response properly', () async {
      when(() => mockClient.get<dynamic>(
            FaceApiEndpoints.checkReg,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'status': true,
            'registered': false,
            'count': 0,
            'message': 'Chưa đăng ký nhận diện khuôn mặt',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: FaceApiEndpoints.checkReg),
        ),
      );

      final result = await repository.checkRegistration('NV001');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.isSuccess, isTrue);
          expect(entity.isRegistered, isFalse);
          expect(entity.count, equals(0));
          expect(entity.message, contains('Chưa đăng ký'));
        },
      );
    });

    test('TC-FACE-02: checkRegistration parses registered response properly', () async {
      when(() => mockClient.get<dynamic>(
            FaceApiEndpoints.checkReg,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'status': true,
            'registered': true,
            'count': 1,
            'message': 'Đã đăng ký nhận diện khuôn mặt',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: FaceApiEndpoints.checkReg),
        ),
      );

      final result = await repository.checkRegistration('NV001');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.isSuccess, isTrue);
          expect(entity.isRegistered, isTrue);
          expect(entity.count, equals(1));
        },
      );
    });

    test('TC-FACE-03: deleteFace sends delete request and returns success message', () async {
      when(() => mockClient.delete<dynamic>(
            FaceApiEndpoints.delete,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'status': true,
            'message': 'Xóa khuôn mặt thành công',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: FaceApiEndpoints.delete),
        ),
      );

      final result = await repository.deleteFace('NV001');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (msg) => expect(msg, contains('Xóa khuôn mặt thành công')),
      );
    });

    test('TC-FACE-04: verifyFace parses match and similarity correctly', () async {
      when(() => mockClient.post<dynamic>(
            FaceApiEndpoints.verify,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'status': true,
            'match': true,
            'similarity': 0.94,
            'message': 'Khuôn mặt hợp lệ',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: FaceApiEndpoints.verify),
        ),
      );

      final file = File('${Directory.systemTemp.path}/test_verify.jpg')..writeAsBytesSync([1, 2, 3]);
      final result = await repository.verifyFace('NV001', file.path);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.isSuccess, isTrue);
          expect(entity.isMatch, isTrue);
          expect(entity.similarity, closeTo(0.94, 0.001));
          expect(entity.message, equals('Khuôn mặt hợp lệ'));
        },
      );
      if (file.existsSync()) file.deleteSync();
    });

    test('TC-FACE-05: liveVerifyFace parses liveness match and score', () async {
      when(() => mockClient.post<dynamic>(
            FaceApiEndpoints.liveVerify,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'status': true,
            'match': true,
            'similarity': 0.96,
            'message': 'Xác thực khuôn mặt thực tế thành công',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: FaceApiEndpoints.liveVerify),
        ),
      );

      final file = File('${Directory.systemTemp.path}/test_live.jpg')..writeAsBytesSync([1, 2, 3]);
      final result = await repository.liveVerifyFace('NV001', file.path);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.isSuccess, isTrue);
          expect(entity.isMatch, isTrue);
          expect(entity.similarity, closeTo(0.96, 0.001));
        },
      );
      if (file.existsSync()) file.deleteSync();
    });

    test('TC-FACE-06: 422 HTTPValidationError details are formatted cleanly into failure message', () async {
      when(() => mockClient.get<dynamic>(
            FaceApiEndpoints.checkReg,
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: FaceApiEndpoints.checkReg),
          response: Response<dynamic>(
            statusCode: 422,
            requestOptions: RequestOptions(path: FaceApiEndpoints.checkReg),
            data: <String, dynamic>{
              'detail': [
                <String, dynamic>{'loc': ['query', 'Code'], 'msg': 'Mã nhân sự bắt buộc', 'type': 'value_error'}
              ]
            },
          ),
        ),
      );

      final result = await repository.checkRegistration('INVALID');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('Mã nhân sự bắt buộc')),
        (_) => fail('Expected Left'),
      );
    });
  });
}
