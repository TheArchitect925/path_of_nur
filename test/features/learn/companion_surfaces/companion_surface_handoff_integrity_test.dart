import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/companion_surfaces/data/learn_companion_content.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

void main() {
  test('seerah handoffs prefer owned history and quran destinations', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    final periodLinks = buildSeerahPeriodLinks(l10n);
    final hijrah = periodLinks.firstWhere((item) => item.id == 'hijrah');
    expect(hijrah.whyItMatters, isNotNull);
    expect(hijrah.nextExploration, isNotNull);

    final exploreLinks = buildSeerahExploreLinks(l10n);
    final timelineLink = exploreLinks.firstWhere(
      (item) => item.id == 'timeline',
    );
    expect(timelineLink.routeTarget.routeName, 'learnHistoryArchive');
    expect(timelineLink.routeTarget.queryParameters['tab'], 'timeline');
    final hadithLink = exploreLinks.firstWhere(
      (item) => item.id == 'hadith-guidance',
    );
    expect(hadithLink.routeTarget.routeName, 'learnHadithLanding');

    final sourceLinks = buildSeerahCompanionSources(l10n);
    final quranLink = sourceLinks.firstWhere(
      (item) => item.id == 'quran-learning',
    );
    expect(quranLink.routeTarget.routeName, 'quranAyahInsightsDomain');
    expect(
      quranLink.routeTarget.pathParameters['domainId'],
      'prophets-lessons',
    );

    final momentLinks = buildSeerahMomentLinks(l10n);
    final hudaybiyyah = momentLinks.firstWhere(
      (item) => item.id == 'hudaybiyyah',
    );
    expect(hudaybiyyah.whyItMatters, isNotNull);
    expect(hudaybiyyah.nextExploration, isNotNull);
    expect(hudaybiyyah.routeTarget.routeName, 'learnHistoryArchive');
    expect(hudaybiyyah.routeTarget.queryParameters['tab'], 'timeline');

    final conquest = momentLinks.firstWhere(
      (item) => item.id == 'conquest-of-makkah',
    );
    expect(conquest.routeTarget.routeName, 'learnHistoryArchive');
    expect(conquest.routeTarget.queryParameters['tab'], 'timeline');

    final farewellHajj = momentLinks.firstWhere(
      (item) => item.id == 'farewell-hajj',
    );
    expect(farewellHajj.routeTarget.routeName, 'learnJourneyStage');
    expect(
      farewellHajj.routeTarget.pathParameters['journeyId'],
      'seerah-journey',
    );
    expect(
      farewellHajj.routeTarget.pathParameters['stageId'],
      'seerah-final-sermon',
    );
  });

  test(
    'character and daily wisdom handoffs keep specific owned destinations',
    () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      final traitLinks = buildCharacterTraitLinks(l10n);
      final ikhlas = traitLinks.firstWhere((item) => item.id == 'ikhlas');
      expect(ikhlas.description, isNotNull);
      expect(ikhlas.practicalExpression, isNotNull);
      expect(ikhlas.nextStep, isNotNull);

      final scenarioLinks = buildCharacterScenarioLinks(l10n);
      final speech = scenarioLinks.firstWhere((item) => item.id == 'speech');
      expect(speech.routeTarget.routeName, 'quranAyahInsightsDomain');
      expect(speech.routeTarget.pathParameters['domainId'], 'character-adab');
      expect(speech.practicalExpression, isNotNull);
      expect(speech.nextStep, isNotNull);

      final intentions = scenarioLinks.firstWhere(
        (item) => item.id == 'intentions',
      );
      expect(intentions.routeTarget.routeName, 'hadithThemeDetail');
      expect(
        intentions.routeTarget.pathParameters['themeId'],
        'worship-intention',
      );

      final anger = scenarioLinks.firstWhere(
        (item) => item.id == 'anger-self-control',
      );
      expect(anger.routeTarget.routeName, 'hadithThemeDetail');
      expect(anger.routeTarget.pathParameters['themeId'], 'character-manners');

      final neighbors = scenarioLinks.firstWhere(
        (item) => item.id == 'neighbors',
      );
      expect(neighbors.practicalExpression, isNotNull);
      expect(neighbors.nextStep, isNotNull);
      expect(neighbors.routeTarget.routeName, 'learnLifeLanding');
      expect(
        neighbors.routeTarget.queryParameters['themeId'],
        'community-relationships',
      );

      final consistency = scenarioLinks.firstWhere(
        (item) => item.id == 'consistency',
      );
      expect(consistency.practicalExpression, isNotNull);
      expect(consistency.nextStep, isNotNull);
      expect(consistency.routeTarget.routeName, 'quranAyahInsightsDomain');
      expect(
        consistency.routeTarget.pathParameters['domainId'],
        'guidance-daily-life',
      );

      final workStudy = scenarioLinks.firstWhere(
        (item) => item.id == 'work-study-pressure',
      );
      expect(workStudy.description, isNotNull);
      expect(workStudy.practicalExpression, isNotNull);
      expect(workStudy.nextStep, isNotNull);
      expect(workStudy.routeTarget.routeName, 'learnLifeLanding');
      expect(workStudy.routeTarget.queryParameters['themeId'], 'trust_allah');

      final characterSources = buildCharacterCompanionSources(l10n);
      final quranSource = characterSources.firstWhere(
        (item) => item.id == 'quran-insights',
      );
      expect(quranSource.routeTarget.routeName, 'quranAyahInsightsDomain');
      expect(
        quranSource.routeTarget.pathParameters['domainId'],
        'character-adab',
      );

      final wisdomEntries = buildDailyWisdomEntries(l10n);
      expect(
        wisdomEntries.map((entry) => entry.themeLabel).toSet(),
        containsAll(<String>[
          l10n.learnDailyWisdomThemeMercy,
          l10n.learnDailyWisdomThemeGratitude,
          l10n.learnDailyWisdomThemePatience,
          l10n.learnDailyWisdomThemeTrust,
          l10n.learnDailyWisdomThemeSincerity,
          l10n.learnDailyWisdomThemeHumility,
          l10n.learnDailyWisdomThemeService,
          l10n.learnDailyWisdomThemeRemembrance,
          l10n.learnDailyWisdomThemeHope,
          l10n.learnDailyWisdomThemeReflection,
        ]),
      );
      final gratitude = wisdomEntries.firstWhere(
        (item) => item.id == 'gratitude',
      );
      expect(gratitude.sourceRouteTarget.routeName, 'quranAyahInsightsDomain');
      expect(
        gratitude.sourceRouteTarget.pathParameters['domainId'],
        'worship-remembrance',
      );

      final mercy = wisdomEntries.firstWhere((item) => item.id == 'mercy');
      expect(mercy.sourceRouteTarget.routeName, 'learnSeerahCompanion');
      expect(mercy.ownerLabel, l10n.learnCompanionSourceLabelSeerah);

      final mercyRestraint = wisdomEntries.firstWhere(
        (item) => item.id == 'mercy-restraint',
      );
      expect(mercyRestraint.sourceRouteTarget.routeName, 'learnHadithLanding');
      expect(mercyRestraint.ownerLabel, l10n.learnCompanionSourceLabelHadith);

      final service = wisdomEntries.firstWhere((item) => item.id == 'service');
      expect(service.sourceRouteTarget.routeName, 'learnLifeLanding');
      expect(
        service.sourceRouteTarget.queryParameters['themeId'],
        'community-relationships',
      );

      final servicePresence = wisdomEntries.firstWhere(
        (item) => item.id == 'service-presence',
      );
      expect(servicePresence.sourceRouteTarget.routeName, 'learnLifeLanding');
      expect(
        servicePresence.sourceRouteTarget.queryParameters['themeId'],
        'community-relationships',
      );

      final hopeOpening = wisdomEntries.firstWhere(
        (item) => item.id == 'hope-opening',
      );
      expect(hopeOpening.sourceRouteTarget.routeName, 'learnSeerahCompanion');
      expect(
        hopeOpening.sourceRouteTarget.queryParameters['focus'],
        'turning-points',
      );

      final reflection = wisdomEntries.firstWhere(
        (item) => item.id == 'reflection',
      );
      expect(reflection.sourceRouteTarget.routeName, 'quranReflections');
      expect(
        wisdomEntries.map((entry) => entry.ownerLabel).toSet(),
        containsAll(<String>{
          l10n.learnCompanionSourceLabelSeerah,
          l10n.learnCompanionSourceLabelHadith,
          l10n.learnCompanionSourceLabelQuran,
          l10n.learnCompanionSourceLabelCharacter,
          l10n.learnCompanionSourceLabelDivineLife,
        }),
      );
      expect(wisdomEntries.length, greaterThanOrEqualTo(17));
    },
  );

  test(
    'daily wisdom ordering stays deterministic and fully covers entries',
    () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final entries = buildDailyWisdomEntries(l10n);

      final first = orderDailyWisdomEntries(entries, DateTime(2026, 3, 23));
      final second = orderDailyWisdomEntries(entries, DateTime(2026, 3, 23));
      final nextDay = orderDailyWisdomEntries(entries, DateTime(2026, 3, 24));

      expect(first.map((entry) => entry.id), second.map((entry) => entry.id));
      expect(first.length, entries.length);
      expect(first.map((entry) => entry.id).toSet().length, entries.length);
      expect(first.first.id, isNot(nextDay.first.id));

      final focused = orderDailyWisdomEntries(
        entries,
        DateTime(2026, 3, 23),
        focusedEntryId: 'gratitude',
      );
      expect(focused.first.id, 'gratitude');
    },
  );
}
