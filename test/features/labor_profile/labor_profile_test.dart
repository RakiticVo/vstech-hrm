import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';
import 'package:vstech_hrm/features/labor_profile/domain/repositories/labor_profile_repository.dart';
import 'package:vstech_hrm/features/labor_profile/domain/usecases/get_labor_profile_usecase.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_cubit.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_state.dart';

class MockLaborProfileRepository extends Mock implements LaborProfileRepository;

void main() {
  late MockLaborProfileRepository mockRepository;
  late GetLaborProfileUseCase getLaborProfileUseCase;
  late LaborProfileCubit cubit;

  final testProfile = LaborProfileEntity(
    employeeCode: 'NV-04821',
    fullName: 'Nguyễn Văn An',
    jobTitle: 'Kỹ thuật viên Vận hành Máy SMT',
    department: 'Xưởng Lắp ráp Điện tử 2',
    contractNumber: 'HDLD-2023/VST-04821',
    contractType: 'Hợp đồng lao động xác định thời hạn (36 tháng)',
    signingDate: DateTime(2023, 10),
    effectiveDate: DateTime(2023, 10, 15),
    expirationDate: DateTime(2026, 10, 14),
    contractStatus: 'Hiệu lực',
    agreedBaseSalary: 12500000,
    responsibilityAllowance: 2000000,
    mealAllowance: 1200000,
    socialInsuranceNumber: '7916248910',
    hospitalRegistered: 'Bệnh viện Đa khoa Khu vực Củ Chi',
    insuranceSalaryLevel: 12500000,
    insuranceStatus: 'Đang đóng',
    attachments: [
      LaborContractAttachment(
        id: 'att_01',
        name: 'Hop_Dong_Lao_Dong_NV04821.pdf',
        size: '2.4 MB',
        uploadedAt: DateTime(2023, 10, 15),
        url: 'https://cdn.vstech.internal/contracts/HD_NV04821.pdf',
      ),
    ],
  );

  setUp(() {
    mockRepository = MockLaborProfileRepository();
    getLaborProfileUseCase = GetLaborProfileUseCase(mockRepository);
    cubit = LaborProfileCubit(getLaborProfileUseCase: getLaborProfileUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('LaborProfile Tests', () {
    test('GetLaborProfileUseCase returns LaborProfileEntity', () async {
      when(() => mockRepository.getLaborProfile())
          .thenAnswer((_) async => Right(testProfile));

      final result = await getLaborProfileUseCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (profile) {
          expect(profile.employeeCode, 'NV-04821');
          expect(profile.agreedBaseSalary, 12500000);
          expect(profile.attachments.length, 1);
        },
      );
      verify(() => mockRepository.getLaborProfile()).called(1);
    });

    test('LaborProfileCubit loads profile successfully', () async {
      when(() => mockRepository.getLaborProfile())
          .thenAnswer((_) async => Right(testProfile));

      await cubit.loadProfile();

      expect(cubit.state.status, LaborProfileStatus.success);
      expect(cubit.state.profile, isNotNull);
      expect(cubit.state.profile?.contractNumber, 'HDLD-2023/VST-04821');
    });

    test('LaborProfileCubit handles error failure gracefully', () async {
      when(() => mockRepository.getLaborProfile())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Connection error')));

      await cubit.loadProfile();

      expect(cubit.state.status, LaborProfileStatus.failure);
      expect(cubit.state.errorMessage, 'Connection error');
    });
  });
}
