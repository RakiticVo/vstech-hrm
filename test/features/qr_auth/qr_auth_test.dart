import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';
import 'package:vstech_hrm/features/qr_auth/domain/repositories/qr_auth_repository.dart';
import 'package:vstech_hrm/features/qr_auth/domain/usecases/qr_auth_usecases.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/cubit/qr_scanner_cubit.dart';

class MockQrAuthRepository extends Mock implements QrAuthRepository;

void main() {
  late MockQrAuthRepository mockRepository;
  late ParseQrPayloadUseCase parseQrPayloadUseCase;
  late ApproveQrLoginUseCase approveQrLoginUseCase;
  late RejectQrLoginUseCase rejectQrLoginUseCase;
  late QrScannerCubit cubit;

  final testQrRequest = QrLoginRequestEntity(
    sessionId: 'session_vst_test_01',
    browser: 'Chrome 122 (Windows 11)',
    device: 'Dell Latitude 7420',
    ipAddress: '118.69.182.44',
    location: 'Khu Công Nghệ Cao (SHTP), Quận 9, TP.HCM',
    requestTime: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    status: QrSessionStatus.pending,
  );

  setUp(() {
    mockRepository = MockQrAuthRepository();
    parseQrPayloadUseCase = ParseQrPayloadUseCase(mockRepository);
    approveQrLoginUseCase = ApproveQrLoginUseCase(mockRepository);
    rejectQrLoginUseCase = RejectQrLoginUseCase(mockRepository);
    cubit = QrScannerCubit(
      parseQrPayloadUseCase: parseQrPayloadUseCase,
      approveQrLoginUseCase: approveQrLoginUseCase,
      rejectQrLoginUseCase: rejectQrLoginUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('QR Auth Tests', () {
    test('ParseQrPayloadUseCase returns parsed entity for valid QR', () async {
      when(() => mockRepository.parseQrPayload('vstech://qr-login?sid=123'))
          .thenAnswer((_) async => Right(testQrRequest));

      final result = await parseQrPayloadUseCase('vstech://qr-login?sid=123');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.sessionId, 'session_vst_test_01'),
      );
    });

    test('ApproveQrLoginUseCase delegates to repository with biometrics authMethod', () async {
      when(() => mockRepository.approveLogin('session_vst_test_01', authMethod: 'biometrics'))
          .thenAnswer((_) async => const Right(true));

      final result = await approveQrLoginUseCase('session_vst_test_01', authMethod: 'biometrics');

      expect(result.isRight(), isTrue);
      verify(() => mockRepository.approveLogin('session_vst_test_01', authMethod: 'biometrics')).called(1);
    });

    test('RejectQrLoginUseCase delegates to repository', () async {
      when(() => mockRepository.rejectLogin('session_vst_test_01'))
          .thenAnswer((_) async => const Right(true));

      final result = await rejectQrLoginUseCase('session_vst_test_01');

      expect(result.isRight(), isTrue);
      verify(() => mockRepository.rejectLogin('session_vst_test_01')).called(1);
    });

    test('QrScannerCubit processes valid payload and updates state', () async {
      when(() => mockRepository.parseQrPayload(any()))
          .thenAnswer((_) async => Right(testQrRequest));

      await cubit.onPayloadDetected('vstech://qr-login?sid=123');

      expect(cubit.state.activeRequest, isNotNull);
      expect(cubit.state.isProcessing, isFalse);
    });
  });
}
