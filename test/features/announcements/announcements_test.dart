import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:vstech_hrm/features/announcements/domain/usecases/get_announcement_detail_usecase.dart';
import 'package:vstech_hrm/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:vstech_hrm/features/announcements/domain/usecases/mark_announcement_read_usecase.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_cubit.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_state.dart';

class MockAnnouncementRepository extends Mock implements AnnouncementRepository;

void main() {
  late MockAnnouncementRepository mockRepository;
  late GetAnnouncementsUseCase getAnnouncementsUseCase;
  late GetAnnouncementDetailUseCase getAnnouncementDetailUseCase;
  late MarkAnnouncementReadUseCase markAnnouncementReadUseCase;
  late AnnouncementsCubit cubit;

  final testAnnouncement = AnnouncementEntity(
    id: 'ann_test_01',
    title: 'Test Announcement',
    content: 'Announcement detailed content here.',
    publishedAt: DateTime(2026, 3, 20),
    authorName: 'HR Team',
    authorRole: 'HR Manager',
    scope: AnnouncementScope.company,
  );

  setUp(() {
    mockRepository = MockAnnouncementRepository();
    getAnnouncementsUseCase = GetAnnouncementsUseCase(mockRepository);
    getAnnouncementDetailUseCase = GetAnnouncementDetailUseCase(mockRepository);
    markAnnouncementReadUseCase = MarkAnnouncementReadUseCase(mockRepository);
    cubit = AnnouncementsCubit(
      getAnnouncementsUseCase: getAnnouncementsUseCase,
      markAnnouncementReadUseCase: markAnnouncementReadUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('Announcement UseCases', () {
    test('GetAnnouncementsUseCase returns list from repository', () async {
      when(() => mockRepository.getAnnouncements(scope: any(named: 'scope')))
          .thenAnswer((_) async => Right([testAnnouncement]));

      final result = await getAnnouncementsUseCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(list.length, 1),
      );
      verify(() => mockRepository.getAnnouncements()).called(1);
    });

    test('GetAnnouncementDetailUseCase returns announcement details', () async {
      when(() => mockRepository.getAnnouncementDetail('ann_test_01'))
          .thenAnswer((_) async => Right(testAnnouncement));

      final result = await getAnnouncementDetailUseCase('ann_test_01');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (item) => expect(item.id, 'ann_test_01'),
      );
    });

    test('MarkAnnouncementReadUseCase triggers read status update', () async {
      when(() => mockRepository.markAsRead('ann_test_01'))
          .thenAnswer((_) async => const Right(null));

      final result = await markAnnouncementReadUseCase('ann_test_01');

      expect(result.isRight(), isTrue);
      verify(() => mockRepository.markAsRead('ann_test_01')).called(1);
    });
  });

  group('AnnouncementsCubit', () {
    test('loadAnnouncements updates state on success', () async {
      when(() => mockRepository.getAnnouncements(scope: any(named: 'scope')))
          .thenAnswer((_) async => Right([testAnnouncement]));

      await cubit.loadAnnouncements();

      expect(cubit.state.status, AnnouncementsStatus.success);
      expect(cubit.state.allAnnouncements.length, 1);
    });

    test('filter by search query filters list', () async {
      when(() => mockRepository.getAnnouncements(scope: any(named: 'scope')))
          .thenAnswer((_) async => Right([testAnnouncement]));

      await cubit.loadAnnouncements();
      cubit.setSearchQuery('NonExistent');

      expect(cubit.state.filteredAnnouncements.isEmpty, isTrue);

      cubit.setSearchQuery('Test');
      expect(cubit.state.filteredAnnouncements.length, 1);
    });

    test('filter by scope filters list', () async {
      when(() => mockRepository.getAnnouncements(scope: any(named: 'scope')))
          .thenAnswer((_) async => Right([testAnnouncement]));

      await cubit.loadAnnouncements();
      cubit.setScopeFilter(AnnouncementScope.factory);

      expect(cubit.state.filteredAnnouncements.isEmpty, isTrue);

      cubit.setScopeFilter(AnnouncementScope.company);
      expect(cubit.state.filteredAnnouncements.length, 1);
    });
  });
}
