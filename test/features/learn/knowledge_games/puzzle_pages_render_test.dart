import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/learn/ayah_completion/presentation/ayah_completion_puzzle_page.dart';
import 'package:path_of_nur/features/learn/crossword/application/crossword_repository.dart';
import 'package:path_of_nur/features/learn/crossword/presentation/crossword_puzzle_page.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/presentation/hadith_reflection_puzzle_page.dart';
import 'package:path_of_nur/features/learn/journey/application/family_learning_provider.dart';
import 'package:path_of_nur/features/learn/journey/domain/family_learning_models.dart';
import 'package:path_of_nur/features/learn/matching/presentation/matching_puzzle_page.dart';
import 'package:path_of_nur/features/learn/word_search/presentation/word_search_puzzle_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart' show makeTestContainer;

/// The five puzzle families never had a widget test, which is how a grid that
/// overflowed on every phone and a page that wrote to a provider during build
/// both reached the branch. Each case pumps a real seeded puzzle at phone
/// width in a viewport tall enough to lay out the whole page, then asserts
/// that nothing was thrown: a RenderFlex overflow and Riverpod's
/// "modified a provider while building" guard both surface here.
void main() {
  const adultContext = ActiveFamilyLearningContext(
    activeProfileId: 'adult-test',
    activeGuardianProfileId: 'adult-test',
    activeChildProfile: null,
    familyGroup: null,
    switchableProfileIds: <String>['adult-test'],
    visibilityPolicy: FamilyLearningVisibilityPolicy(
      isChildProfile: false,
      isGuardianProfile: true,
      guidedOnly: false,
      showBrowseAll: true,
      showLegacyLearning: true,
      showAdvancedJourneys: true,
      showSecondaryExploration: true,
      showTrivia: true,
      showDiscovery: true,
    ),
  );

  Future<ProviderContainer> makeContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-09-05T12:00:00')),
        ),
        activeFamilyLearningContextProvider.overrideWithValue(adultContext),
      ],
    );
  }

  Widget buildApp(ProviderContainer container, Widget page) {
    final router = GoRouter(
      initialLocation: '/puzzle',
      routes: [
        GoRoute(path: '/puzzle', builder: (context, state) => page),
        // Completion actions push these by name; they are never reached
        // here, but a missing name would throw at the first tap.
        GoRoute(
          path: '/pack/:packId',
          name: 'learnCrosswordPack',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        // TextField cells need a Material ancestor, as they have in the app.
        builder: (context, child) => Scaffold(body: child ?? const SizedBox()),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  /// Phone width, and a viewport tall enough that every card on the page is
  /// laid out rather than left virtualised below the fold.
  void usePhoneViewport(WidgetTester tester, {double width = 402}) {
    tester.view.physicalSize = Size(width * 3, 3200 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpUntilLoaded(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 20; i += 1) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) break;
    }
    // Post-frame progress writes and the AnimatedSwitcher settle here.
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> expectRendersCleanly(
    WidgetTester tester,
    Widget page,
    Type pageType, {
    double width = 402,
    Future<void> Function(ProviderContainer container)? warmUp,
  }) async {
    usePhoneViewport(tester, width: width);
    final container = await makeContainer();
    addTearDown(container.dispose);
    if (warmUp != null) {
      // The crossword catalog reads a bundled asset, which finishes on real
      // time that tester.pump does not advance. Resolving the puzzle here
      // means the page watches a provider that is already data.
      await tester.runAsync(() => warmUp(container));
    }

    await tester.pumpWidget(buildApp(container, page));
    await pumpUntilLoaded(tester);

    expect(find.byType(pageType), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  }

  group('puzzle pages render without overflow or build-time writes', () {
    testWidgets('kids crossword, 5-grid', (tester) async {
      await expectRendersCleanly(
        tester,
        const CrosswordPuzzlePage(puzzleId: 'kids_alif_allah'),
        CrosswordPuzzlePage,
        warmUp: (container) => container.read(
          crosswordPuzzleByIdProvider('kids_alif_allah').future,
        ),
      );
      // ALIF across and ALLAH down share one cell: eight live cells.
      expect(find.byType(TextField), findsNWidgets(8));
    });

    testWidgets('adult crossword, 10-grid, on a narrow phone', (tester) async {
      await expectRendersCleanly(
        tester,
        const CrosswordPuzzlePage(puzzleId: 'adult_hadith_intention_sincerity'),
        CrosswordPuzzlePage,
        width: 375,
        warmUp: (container) => container.read(
          crosswordPuzzleByIdProvider(
            'adult_hadith_intention_sincerity',
          ).future,
        ),
      );
    });

    testWidgets('word search, 10x10', (tester) async {
      await expectRendersCleanly(
        tester,
        const WordSearchPuzzlePage(puzzleId: 'ws_adult_08'),
        WordSearchPuzzlePage,
      );
    });

    testWidgets('matching, adult pairs', (tester) async {
      await expectRendersCleanly(
        tester,
        const MatchingPuzzlePage(puzzleId: 'matching_adult_01'),
        MatchingPuzzlePage,
      );
    });

    testWidgets('ayah completion, two blanks', (tester) async {
      await expectRendersCleanly(
        tester,
        const AyahCompletionPuzzlePage(puzzleId: 'ayah_adult_05'),
        AyahCompletionPuzzlePage,
      );
    });

    testWidgets('hadith reflection scenario', (tester) async {
      await expectRendersCleanly(
        tester,
        const HadithReflectionPuzzlePage(puzzleId: 'adult_intentions_service'),
        HadithReflectionPuzzlePage,
      );
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(l10n.hadithReflectionChoiceSectionTitle),
        findsOneWidget,
      );
    });
  });
}
