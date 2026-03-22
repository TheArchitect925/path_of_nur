import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/activity/application/kids_activity_log_service.dart';
import 'package:path_of_nur/features/kids/activity/domain/kids_activity_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const learnerA = BedtimeLearnerIdentity(
    learnerId: 'child_a',
    displayName: 'Maryam',
    avatarReference: '🌙',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: 'guardian_1',
    isFallbackLearner: false,
    preferences: BedtimeLearnerPreferences(),
  );
  const learnerB = BedtimeLearnerIdentity(
    learnerId: 'child_b',
    displayName: 'Yusuf',
    avatarReference: '⭐',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: 'guardian_1',
    isFallbackLearner: false,
    preferences: BedtimeLearnerPreferences(),
  );

  Future<ProviderContainer> makeContainer(
    BedtimeLearnerIdentity learner,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        bedtimeAvailableLearnersProvider.overrideWith(
          (ref) => const [learnerA, learnerB],
        ),
        bedtimeActiveLearnerProvider.overrideWith((ref) => learner),
      ],
    );
  }

  group('KidsActivityLogController', () {
    test('stores learner-scoped activity separately', () async {
      final first = await makeContainer(learnerA);
      addTearDown(first.dispose);
      first
          .read(kidsActivityLogProvider.notifier)
          .log(
            type: KidsActivityType.storyCompleted,
            domain: KidsActivityDomain.stories,
            sourceRef: 'story:adam:complete',
            contentId: 'story_adam',
            titleSnapshot: 'Prophet Adam',
          );

      final second = await makeContainer(learnerB);
      addTearDown(second.dispose);

      expect(first.read(kidsActivityLogProvider).entries, hasLength(1));
      expect(second.read(kidsActivityLogProvider).entries, isEmpty);
    });

    test('returns most recent activity and filters by domain', () async {
      final container = await makeContainer(learnerA);
      addTearDown(container.dispose);
      final controller = container.read(kidsActivityLogProvider.notifier);
      final base = DateTime(2026, 3, 21, 20);

      controller.log(
        type: KidsActivityType.duaLessonCompleted,
        domain: KidsActivityDomain.duas,
        sourceRef: 'dua:sleep:complete',
        contentId: 'before-sleep',
        occurredAt: base,
      );
      controller.log(
        type: KidsActivityType.storyCompleted,
        domain: KidsActivityDomain.stories,
        sourceRef: 'story:adam:complete',
        contentId: 'story_adam',
        occurredAt: base.add(const Duration(minutes: 5)),
      );

      expect(
        controller.mostRecentActivity()?.domain,
        KidsActivityDomain.stories,
      );
      expect(
        controller
            .mostRecentActivity(domains: const {KidsActivityDomain.duas})
            ?.contentId,
        'before-sleep',
      );
      expect(
        controller.recentActivities(
          domains: const {KidsActivityDomain.stories},
        ),
        hasLength(1),
      );
    });

    test('dedupes rapid repeated open events', () async {
      final container = await makeContainer(learnerA);
      addTearDown(container.dispose);
      final controller = container.read(kidsActivityLogProvider.notifier);
      final now = DateTime(2026, 3, 21, 20, 15);

      controller.log(
        type: KidsActivityType.storyOpened,
        domain: KidsActivityDomain.stories,
        sourceRef: 'story_open:adam',
        contentId: 'story_adam',
        occurredAt: now,
        dedupeWindow: const Duration(minutes: 2),
      );
      controller.log(
        type: KidsActivityType.storyOpened,
        domain: KidsActivityDomain.stories,
        sourceRef: 'story_open:adam',
        contentId: 'story_adam',
        occurredAt: now.add(const Duration(seconds: 45)),
        dedupeWindow: const Duration(minutes: 2),
      );

      expect(container.read(kidsActivityLogProvider).entries, hasLength(1));
    });

    test(
      'tracks content history and allows later events outside dedupe window',
      () async {
        final container = await makeContainer(learnerA);
        addTearDown(container.dispose);
        final controller = container.read(kidsActivityLogProvider.notifier);
        final start = DateTime(2026, 3, 21, 21);

        controller.log(
          type: KidsActivityType.storyOpened,
          domain: KidsActivityDomain.stories,
          sourceRef: 'story_open:nuh',
          contentId: 'story_nuh',
          titleSnapshot: 'Prophet Nuh',
          occurredAt: start,
          dedupeWindow: const Duration(minutes: 2),
        );
        controller.log(
          type: KidsActivityType.storyOpened,
          domain: KidsActivityDomain.stories,
          sourceRef: 'story_open:nuh',
          contentId: 'story_nuh',
          titleSnapshot: 'Prophet Nuh',
          occurredAt: start.add(const Duration(minutes: 3)),
          dedupeWindow: const Duration(minutes: 2),
        );

        expect(container.read(kidsActivityLogProvider).entries, hasLength(2));
        expect(
          controller
              .lastActivityForContent(
                domain: KidsActivityDomain.stories,
                contentId: 'story_nuh',
              )
              ?.occurredAtIso,
          start.add(const Duration(minutes: 3)).toIso8601String(),
        );
      },
    );
  });
}
