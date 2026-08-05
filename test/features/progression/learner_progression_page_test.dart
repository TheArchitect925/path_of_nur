import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/progression/application/learner_progression_service.dart';
import 'package:path_of_nur/features/progression/domain/learner_progression_models.dart';
import 'package:path_of_nur/features/progression/presentation/learner_progression_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  Future<ProviderContainer> pumpPage(
    WidgetTester tester, {
    required BedtimeLearnerIdentity activeLearner,
  }) async {
    final container = await makeTestContainer(
      overrides: [
        bedtimeAvailableLearnersProvider.overrideWith(
          (ref) => const [learnerA, learnerB],
        ),
        bedtimeActiveLearnerProvider.overrideWith((ref) => activeLearner),
      ],
    );
    addTearDown(container.dispose);

    container
        .read(learnerProgressionControllerProvider('child_a').notifier)
        .award(
          sourceRef: 'story_a',
          activityType: LearnerProgressionActivityType.bedtimeStoryCompletion,
          sourceModule: 'kids_bedtime_story',
          xp: 5,
          drops: 1,
        );
    container
        .read(learnerProgressionControllerProvider('child_a').notifier)
        .award(
          sourceRef: 'dua_a',
          activityType: LearnerProgressionActivityType.duaLessonCompletion,
          sourceModule: 'kids_dua',
          xp: 8,
          drops: 1,
        );
    container
        .read(learnerProgressionControllerProvider('child_b').notifier)
        .award(
          sourceRef: 'routine_b',
          activityType: LearnerProgressionActivityType.bedtimeRoutineCompletion,
          sourceModule: 'kids_bedtime_routine',
          xp: 2,
          drops: 0,
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LearnerProgressionPage()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    return container;
  }

  testWidgets('renders the active learner progression state', (tester) async {
    final container = await pumpPage(tester, activeLearner: learnerA);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(LearnerProgressionPage)),
    );

    expect(find.text(l10n.progressionPageHeroTitle('Maryam')), findsOneWidget);
    expect(find.text('Yusuf'), findsOneWidget);
    container.dispose();

    await pumpPage(tester, activeLearner: learnerB);
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text(l10n.progressionPageHeroTitle('Yusuf')), findsOneWidget);
  });
}
