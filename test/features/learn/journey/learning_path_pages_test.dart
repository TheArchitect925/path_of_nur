import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_path_provider.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/learn/journey/presentation/learning_path_picker_page.dart';
import 'package:path_of_nur/features/learn/trivia/presentation/trivia_knowledge_path_detail_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/display/art_header_card.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<ProviderContainer> makeContainer(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  testWidgets('picker shows the friendly level names and selects one', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/learn');
    await pumpRouteFrames(tester);
    router.pushNamed('learnLearningPath');
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.byType(LearningPathPickerPage), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LearningPathPickerPage),
        matching: find.byType(ArtHeaderCard),
      ),
      findsNWidgets(4),
    );
    expect(l10n.learningPathBeginnerTitle, 'New to Islam');
    for (final name in <String>[
      l10n.learningPathBeginnerTitle,
      l10n.learningPathPracticingTitle,
      l10n.learningPathSeekerTitle,
      l10n.learningPathAdvancedTitle,
    ]) {
      expect(find.text(name), findsOneWidget, reason: name);
    }

    await tester.tap(find.text(l10n.learningPathSeekerTitle));
    await pumpRouteFrames(tester);
    // A pre-seeded selection (e.g. from onboarding) raises the honest
    // switch confirmation first.
    final confirm = find.text(l10n.learningPathSwitchConfirm);
    if (confirm.evaluate().isNotEmpty) {
      await tester.tap(confirm);
      await pumpRouteFrames(tester);
    }
    await tester.pump(const Duration(milliseconds: 400));
    await pumpRouteFrames(tester);
    expect(
      container.read(learningPathSelectionProvider)?.selectedLevel,
      LearningPathLevel.seeker,
    );
    expect(find.byType(LearningPathPickerPage), findsNothing);
  });

  testWidgets('path detail shows the spine with guided steps and quiz row', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    container
        .read(learningPathSelectionProvider.notifier)
        .setLevel(LearningPathLevel.beginner);
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/learn/path');
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // All four beginner phases are listed.
    expect(
      find.text(l10n.learningPathPhaseBeginnerFoundationsTitle),
      findsOneWidget,
    );
    expect(
      find.text(l10n.learningPathPhaseBeginnerIdentityTitle),
      findsOneWidget,
    );
    // The current phase is expanded: its guided path and quiz rows render.
    expect(find.text(l10n.guidedPathFoundationsTitle), findsOneWidget);
    expect(find.text(l10n.learnPathTestYourselfTitle), findsOneWidget);

    await tester.ensureVisible(
      find.text(l10n.learnPathTestYourselfTitle).first,
    );
    await pumpRouteFrames(tester);
    await tester.tap(find.text(l10n.learnPathTestYourselfTitle).first);
    await pumpRouteFrames(tester);
    expect(find.byType(IslamicTriviaKnowledgePathDetailPage), findsOneWidget);
  });

  testWidgets('migration card shows once and dismisses for good', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    container
        .read(learningPathSelectionProvider.notifier)
        .setLevel(LearningPathLevel.practicing);
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/learn');
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.learnPathMigrationTitle), findsOneWidget);
    expect(find.textContaining(l10n.learningPathPracticingTitle), findsWidgets);

    await tester.tap(find.text(l10n.learnPathMigrationDismiss));
    await pumpRouteFrames(tester);
    expect(find.text(l10n.learnPathMigrationTitle), findsNothing);
    expect(
      container.read(localStoreProvider).getBool('learn.pathMigrationCard.v1'),
      isTrue,
    );
  });
}
