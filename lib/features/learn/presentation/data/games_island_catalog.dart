import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../models/game_discovery_models.dart';
import '../models/learn_hub_models.dart';

class GamesIslandCatalog {
  const GamesIslandCatalog._();

  static List<GameDiscoverySection> sections(AppLocalizations l10n) {
    return [
      GameDiscoverySection(
        id: 'daily-challenges',
        title: l10n.learnGamesIslandSectionDailyTitle,
        subtitle: l10n.learnGamesIslandSectionDailySubtitle,
        icon: Icons.calendar_today_rounded,
        baseColor: const Color(0xFFE8F1E8),
        accentColor: const Color(0xFF2D6A4F),
        cards: [
          GameDiscoveryCard(
            id: 'daily-knowledge',
            title: l10n.learnGamesDailyKnowledgeTodayTitleText,
            subtitle: l10n.dailyKnowledgeHubSubtitle,
            icon: Icons.bolt_rounded,
            baseColor: const Color(0xFFE7F3EE),
            accentColor: const Color(0xFF2E7D61),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnDailyKnowledgeHub',
            ),
            badgeLabel: l10n.learnGamesIslandTodayBadge,
            searchKeywords: const ['daily challenge', 'today', 'daily knowledge'],
          ),
        ],
      ),
      GameDiscoverySection(
        id: 'knowledge-games',
        title: l10n.learnGamesIslandSectionKnowledgeTitle,
        subtitle: l10n.learnGamesIslandSectionKnowledgeSubtitle,
        icon: Icons.extension_rounded,
        baseColor: const Color(0xFFF6E4CF),
        accentColor: const Color(0xFFB86A12),
        cards: [
          GameDiscoveryCard(
            id: 'crossword',
            title: l10n.learnGamesKnowledgeCrosswordTitleText,
            subtitle: l10n.learnQuizzesCrosswordSectionSubtitle,
            icon: Icons.grid_on_rounded,
            baseColor: const Color(0xFFF7E8D8),
            accentColor: const Color(0xFF9E5A1A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnCrosswordHome',
            ),
            searchKeywords: const ['crossword', 'puzzles', 'knowledge games'],
          ),
          GameDiscoveryCard(
            id: 'word-search',
            title: l10n.learnGamesKnowledgeWordSearchTitleText,
            subtitle: l10n.learnQuizzesWordSearchSectionSubtitle,
            icon: Icons.search_rounded,
            baseColor: const Color(0xFFF2E6D7),
            accentColor: const Color(0xFF8C5A1F),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnWordSearchHome',
            ),
            searchKeywords: const ['word search', 'knowledge games'],
          ),
          GameDiscoveryCard(
            id: 'matching',
            title: l10n.learnGamesKnowledgeMatchingTitleText,
            subtitle: l10n.learnQuizzesMatchingSectionSubtitle,
            icon: Icons.flip_to_front_rounded,
            baseColor: const Color(0xFFF6EBDD),
            accentColor: const Color(0xFFAA6B17),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnMatchingHome',
            ),
            searchKeywords: const ['matching games', 'matching', 'knowledge games'],
          ),
        ],
      ),
      GameDiscoverySection(
        id: 'quran-games',
        title: l10n.learnGamesIslandSectionQuranTitle,
        subtitle: l10n.learnGamesIslandSectionQuranSubtitle,
        icon: IslamicIcons.quran,
        baseColor: const Color(0xFFE3F0E1),
        accentColor: const Color(0xFF2E7D4B),
        cards: [
          GameDiscoveryCard(
            id: 'ayah-completion',
            title: l10n.learnGamesQuranAyahCompletionTitleText,
            subtitle: l10n.learnQuizzesAyahCompletionSectionSubtitle,
            icon: Icons.menu_book_rounded,
            baseColor: const Color(0xFFE5F2E4),
            accentColor: const Color(0xFF2D7A46),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionHome',
            ),
            searchKeywords: const ['ayah completion', 'quran games'],
          ),
          GameDiscoveryCard(
            id: 'ayah-short-surahs',
            title: l10n.learnGamesQuranAdultShortSurahsTitleText,
            subtitle: l10n.ayahCompletionPackAdultShortSurahsSubtitle,
            icon: Icons.auto_stories_rounded,
            baseColor: const Color(0xFFE9F4E5),
            accentColor: const Color(0xFF3A7F4B),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionPack',
              pathParameters: {'packId': 'ayah_adult_short_surahs'},
            ),
            searchKeywords: const ['adult short surahs', 'short surahs'],
          ),
          GameDiscoveryCard(
            id: 'ayah-memorization',
            title: l10n.learnGamesQuranMemorizationSetTitleText,
            subtitle: l10n.ayahCompletionPackAdultMemorizationSubtitle,
            icon: Icons.school_rounded,
            baseColor: const Color(0xFFEAF4E8),
            accentColor: const Color(0xFF437F4A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionPack',
              pathParameters: {'packId': 'ayah_adult_memorization'},
            ),
            searchKeywords: const ['memorization set', 'memorization'],
          ),
          GameDiscoveryCard(
            id: 'daily-ayah',
            title: l10n.learnGamesQuranDailyAyahTitleText,
            subtitle: l10n.ayahCompletionDailyModeSubtitle,
            icon: Icons.today_rounded,
            baseColor: const Color(0xFFE8F3E4),
            accentColor: const Color(0xFF347A48),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionDaily',
            ),
            badgeLabel: l10n.learnGamesIslandTodayBadge,
            searchKeywords: const ['daily ayah', 'today'],
          ),
        ],
      ),
      GameDiscoverySection(
        id: 'hadith-reflection',
        title: l10n.learnGamesIslandSectionHadithTitle,
        subtitle: l10n.learnGamesIslandSectionHadithSubtitle,
        icon: Icons.menu_book_rounded,
        baseColor: const Color(0xFFE7ECF6),
        accentColor: const Color(0xFF4E628E),
        cards: [
          GameDiscoveryCard(
            id: 'hadith-home',
            title: l10n.learnGamesHadithReflectionHomeTitleText,
            subtitle: l10n.learnQuizzesHadithReflectionSectionSubtitle,
            icon: Icons.record_voice_over_rounded,
            baseColor: const Color(0xFFE7EDF6),
            accentColor: const Color(0xFF506587),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnHadithReflectionHome',
            ),
            searchKeywords: const ['hadith reflection'],
          ),
          GameDiscoveryCard(
            id: 'hadith-patience',
            title: l10n.learnGamesHadithPatienceTitleText,
            subtitle: l10n.hadithReflectionPackPatienceSubtitle,
            icon: Icons.self_improvement_rounded,
            baseColor: const Color(0xFFE8EEF7),
            accentColor: const Color(0xFF556A91),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnHadithReflectionPack',
              pathParameters: {
                'packId': 'hadith_reflection_patience_gratitude',
              },
            ),
            searchKeywords: const ['patience', 'resilience'],
          ),
          GameDiscoveryCard(
            id: 'hadith-anger',
            title: l10n.learnGamesHadithAngerTitleText,
            subtitle: l10n.hadithReflectionPackAngerSubtitle,
            icon: Icons.favorite_outline_rounded,
            baseColor: const Color(0xFFE9EEF8),
            accentColor: const Color(0xFF5E6F94),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnHadithReflectionPack',
              pathParameters: {'packId': 'hadith_reflection_anger_control'},
            ),
            searchKeywords: const ['anger control', 'anger'],
          ),
          GameDiscoveryCard(
            id: 'hadith-family',
            title: l10n.learnGamesHadithFamilyTitleText,
            subtitle: l10n.hadithReflectionPackFamilySubtitle,
            icon: Icons.family_restroom_rounded,
            baseColor: const Color(0xFFE6EDF7),
            accentColor: const Color(0xFF526482),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnHadithReflectionPack',
              pathParameters: {'packId': 'hadith_reflection_family_respect'},
            ),
            searchKeywords: const ['family respect', 'family'],
          ),
        ],
      ),
      GameDiscoverySection(
        id: 'challenge-modes',
        title: l10n.learnGamesIslandSectionModesTitle,
        subtitle: l10n.learnGamesIslandSectionModesSubtitle,
        icon: Icons.emoji_events_rounded,
        baseColor: const Color(0xFFF4E6D3),
        accentColor: const Color(0xFFAA6A17),
        cards: [
          GameDiscoveryCard(
            id: 'challenge-daily-run',
            title: l10n.learnGamesChallengeDailyRunTitleText,
            subtitle: l10n.learnGamesIslandModeDailyRunSubtitle,
            icon: Icons.flag_rounded,
            baseColor: const Color(0xFFF5E8D5),
            accentColor: const Color(0xFFA76719),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnDailyKnowledgeHub',
            ),
            searchKeywords: const ['daily run'],
          ),
          GameDiscoveryCard(
            id: 'challenge-review',
            title: l10n.learnGamesChallengeReviewModeTitleText,
            subtitle: l10n.learnGamesIslandModeReviewSubtitle,
            icon: Icons.restart_alt_rounded,
            baseColor: const Color(0xFFF6E9D8),
            accentColor: const Color(0xFFA66A1A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnQuizzesHub',
              queryParameters: {'filter': 'review'},
            ),
            searchKeywords: const ['review mode', 'review'],
          ),
          GameDiscoveryCard(
            id: 'challenge-trivia',
            title: l10n.learnGamesChallengeTriviaTitleText,
            subtitle: l10n.learnGamesIslandModeTriviaSubtitle,
            icon: Icons.bolt_rounded,
            baseColor: const Color(0xFFF7EBDD),
            accentColor: const Color(0xFFAC7322),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnQuizzesHub',
              queryParameters: {'filter': 'trivia'},
            ),
            searchKeywords: const ['trivia challenge', 'trivia'],
          ),
        ],
      ),
      GameDiscoverySection(
        id: 'growth-spiritual',
        title: l10n.learnGamesIslandSectionGrowthTitle,
        subtitle: l10n.learnGamesIslandSectionGrowthSubtitle,
        icon: Icons.wb_twilight_rounded,
        baseColor: const Color(0xFFEADFF1),
        accentColor: const Color(0xFF735393),
        cards: [
          GameDiscoveryCard(
            id: 'spiritual-growth',
            title: l10n.learnGamesGrowthSpiritualTitleText,
            subtitle: l10n.spiritualGrowthSubtitle,
            icon: Icons.wb_twilight_rounded,
            baseColor: const Color(0xFFECE1F3),
            accentColor: const Color(0xFF75559A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthPage',
            ),
            searchKeywords: const ['spiritual growth'],
          ),
          GameDiscoveryCard(
            id: 'spiritual-intentions',
            title: l10n.learnGamesGrowthChooseIntentionTitleText,
            subtitle: l10n.spiritualGrowthChooseIntentionSubtitle,
            icon: Icons.flag_outlined,
            baseColor: const Color(0xFFF0E8F6),
            accentColor: const Color(0xFF7B5A9B),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthIntentions',
            ),
            searchKeywords: const ['choose intention', 'intentions'],
          ),
          GameDiscoveryCard(
            id: 'spiritual-reflection',
            title: l10n.learnGamesGrowthDailyReflectionTitleText,
            subtitle: l10n.spiritualGrowthReflectionEntrySubtitle,
            icon: Icons.nights_stay_rounded,
            baseColor: const Color(0xFFEFE5F5),
            accentColor: const Color(0xFF7F5A9E),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthReflection',
            ),
            searchKeywords: const ['daily reflection', 'reflection'],
          ),
          GameDiscoveryCard(
            id: 'spiritual-themes',
            title: l10n.learnGamesGrowthThemeFocusTitleText,
            subtitle: l10n.spiritualGrowthThemeSummarySubtitle,
            icon: Icons.insights_rounded,
            baseColor: const Color(0xFFF0E7F6),
            accentColor: const Color(0xFF785691),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthThemes',
            ),
            searchKeywords: const ['theme focus', 'themes'],
          ),
        ],
      ),
      GameDiscoverySection(
        id: 'game-packs',
        title: l10n.learnGamesIslandSectionPacksTitle,
        subtitle: l10n.learnGamesIslandSectionPacksSubtitle,
        icon: Icons.inventory_2_rounded,
        baseColor: const Color(0xFFE2EEF0),
        accentColor: const Color(0xFF2D7380),
        cards: [
          GameDiscoveryCard(
            id: 'pack-beginner',
            title: l10n.learnGamesPackAdultFoundationsTitleText,
            subtitle: l10n.crosswordPackAdultFoundationsSubtitle,
            icon: Icons.start_rounded,
            baseColor: const Color(0xFFE1EEF0),
            accentColor: const Color(0xFF2E7581),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnCrosswordPack',
              pathParameters: {'packId': 'adult_foundations'},
            ),
            searchKeywords: const ['adult foundations'],
          ),
          GameDiscoveryCard(
            id: 'pack-prophets',
            title: l10n.learnGamesPackProphetsTitleText,
            subtitle: l10n.matchingPackProphetsSubtitle,
            icon: IslamicIcons.lantern,
            baseColor: const Color(0xFFE6F0F1),
            accentColor: const Color(0xFF376F79),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnMatchingPack',
              pathParameters: {'packId': 'matching_prophets'},
            ),
            searchKeywords: const ['prophets'],
          ),
          GameDiscoveryCard(
            id: 'pack-duas',
            title: l10n.learnGamesPackDuasTitleText,
            subtitle: l10n.wordSearchPackDuaSubtitle,
            icon: Icons.volunteer_activism_rounded,
            baseColor: const Color(0xFFE4EFF0),
            accentColor: const Color(0xFF2F6D78),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnWordSearchPack',
              pathParameters: {'packId': 'dua_pack'},
            ),
            searchKeywords: const ['duas meanings', 'duas'],
          ),
          GameDiscoveryCard(
            id: 'pack-seven-day',
            title: l10n.learnGamesPackDailyRotationTitleText,
            subtitle: l10n.crosswordPackDailySubtitle,
            icon: Icons.calendar_view_week_rounded,
            baseColor: const Color(0xFFE7F0F1),
            accentColor: const Color(0xFF39727A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnCrosswordPack',
              pathParameters: {'packId': 'daily_rotation'},
            ),
            searchKeywords: const ['daily rotation'],
          ),
        ],
      ),
    ];
  }

  static List<({GameDiscoverySection section, GameDiscoveryCard card})> entries(
    AppLocalizations l10n,
  ) {
    final sections = GamesIslandCatalog.sections(l10n);
    return [
      for (final section in sections)
        for (final card in section.cards) (section: section, card: card),
    ];
  }
}
