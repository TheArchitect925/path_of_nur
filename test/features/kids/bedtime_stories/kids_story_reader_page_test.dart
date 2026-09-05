import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_progress_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/kids_story_pages.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/kids_story_reader_page.dart';
import 'package:path_of_nur/features/kids/shared/application/kids_read_aloud.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart';

/// K2: the storybook turns page by page, ends on the lesson, and "I read
/// it!" completes the story. A recording engine stands in for the voice so
/// the test can see which line the reader asked for.
void main() {
  const storyId = 'story_telling_the_truth_v1';
  final story = kKidsIslamicStories.firstWhere((item) => item.id == storyId);

  Future<void> pumpFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<(ProviderContainer, _RecordingEngine)> openReader(
    WidgetTester tester,
  ) async {
    final engine = _RecordingEngine();
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
        kidsReadAloudEngineProvider.overrideWithValue(engine),
      ],
    );
    addTearDown(container.dispose);
    await tester.binding.setSurfaceSize(const Size(430, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildRouterTestApp(container));
    container.read(appRouterProvider).go('/learn/kids/stories/$storyId/read');
    await pumpFrames(tester);
    return (container, engine);
  }

  testWidgets('opens on the first page with its lines and a page count', (
    tester,
  ) async {
    await openReader(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final pages = kidsStoryPagesFor(story);

    expect(find.byType(KidsStoryReaderPage), findsOneWidget);
    expect(
      find.text(l10n.kidsStoryReaderPageValue(1, pages.length)),
      findsOneWidget,
    );
    for (final line in pages.first.lines) {
      expect(find.text(line), findsOneWidget);
    }
    // The story, not its scholarship: the lesson is not on the page.
    expect(find.text(story.lesson), findsNothing);
  });

  testWidgets('a tapped line is read aloud and Next turns the page', (
    tester,
  ) async {
    final (_, engine) = await openReader(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final pages = kidsStoryPagesFor(story);

    await tester.tap(find.text(pages.first.lines.first));
    await pumpFrames(tester);
    expect(engine.spoken, [pages.first.lines.first]);

    await tester.tap(find.text(l10n.kidsStoryReaderNextAction));
    await pumpFrames(tester);
    expect(
      find.text(l10n.kidsStoryReaderPageValue(2, pages.length)),
      findsOneWidget,
    );
    for (final line in pages[1].lines) {
      expect(find.text(line), findsOneWidget);
    }
  });

  testWidgets('the last page ends on the lesson and completes the story', (
    tester,
  ) async {
    final (container, _) = await openReader(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final pages = kidsStoryPagesFor(story);

    for (var i = 0; i < pages.length; i++) {
      await tester.tap(find.text(l10n.kidsStoryReaderNextAction));
      await pumpFrames(tester);
    }
    expect(find.text(l10n.kidsStoryReaderTheEndTitle), findsOneWidget);
    expect(find.text(story.lesson), findsOneWidget);
    expect(
      container
          .read(bedtimeStoryProgressProvider)
          .storyProgressById[storyId]
          ?.isCompleted,
      isNot(true),
    );

    await tester.tap(find.text(l10n.kidsStoryReaderFinishAction));
    await pumpFrames(tester);
    expect(
      container
          .read(bedtimeStoryProgressProvider)
          .storyProgressById[storyId]
          ?.isCompleted,
      isTrue,
    );
    expect(find.text(l10n.kidsStoryReaderReadAgainAction), findsOneWidget);
  });
}

class _RecordingEngine implements KidsReadAloudEngine {
  final List<String> spoken = <String>[];

  @override
  Future<bool> prepare() async => true;

  @override
  Future<void> speak(String text, {required String languageCode}) async {
    spoken.add(text);
  }

  @override
  Future<void> stop() async {}
}
