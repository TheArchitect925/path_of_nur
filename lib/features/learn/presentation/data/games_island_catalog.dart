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
            title: l10n.dailyKnowledgeHubTitle,
            subtitle: l10n.dailyKnowledgeHubSubtitle,
            icon: Icons.bolt_rounded,
            baseColor: const Color(0xFFE7F3EE),
            accentColor: const Color(0xFF2E7D61),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnDailyKnowledgeHub',
            ),
            badgeLabel: l10n.learnGamesIslandTodayBadge,
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
            title: l10n.crosswordHomeTitle,
            subtitle: l10n.learnQuizzesCrosswordSectionSubtitle,
            icon: Icons.grid_on_rounded,
            baseColor: const Color(0xFFF7E8D8),
            accentColor: const Color(0xFF9E5A1A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnCrosswordHome',
            ),
          ),
          GameDiscoveryCard(
            id: 'word-search',
            title: l10n.wordSearchHomeTitle,
            subtitle: l10n.learnQuizzesWordSearchSectionSubtitle,
            icon: Icons.search_rounded,
            baseColor: const Color(0xFFF2E6D7),
            accentColor: const Color(0xFF8C5A1F),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnWordSearchHome',
            ),
          ),
          GameDiscoveryCard(
            id: 'matching',
            title: l10n.matchingHomeTitle,
            subtitle: l10n.learnQuizzesMatchingSectionSubtitle,
            icon: Icons.flip_to_front_rounded,
            baseColor: const Color(0xFFF6EBDD),
            accentColor: const Color(0xFFAA6B17),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnMatchingHome',
            ),
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
            title: l10n.ayahCompletionHomeTitle,
            subtitle: l10n.learnQuizzesAyahCompletionSectionSubtitle,
            icon: Icons.menu_book_rounded,
            baseColor: const Color(0xFFE5F2E4),
            accentColor: const Color(0xFF2D7A46),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionHome',
            ),
          ),
          GameDiscoveryCard(
            id: 'ayah-short-surahs',
            title: l10n.ayahCompletionPackAdultShortSurahsTitle,
            subtitle: l10n.ayahCompletionPackAdultShortSurahsSubtitle,
            icon: Icons.auto_stories_rounded,
            baseColor: const Color(0xFFE9F4E5),
            accentColor: const Color(0xFF3A7F4B),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionPack',
              pathParameters: {'packId': 'ayah_adult_short_surahs'},
            ),
          ),
          GameDiscoveryCard(
            id: 'ayah-memorization',
            title: l10n.ayahCompletionPackAdultMemorizationTitle,
            subtitle: l10n.ayahCompletionPackAdultMemorizationSubtitle,
            icon: Icons.school_rounded,
            baseColor: const Color(0xFFEAF4E8),
            accentColor: const Color(0xFF437F4A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionPack',
              pathParameters: {'packId': 'ayah_adult_memorization'},
            ),
          ),
          GameDiscoveryCard(
            id: 'daily-ayah',
            title: l10n.ayahCompletionDailyModeTitle,
            subtitle: l10n.ayahCompletionDailyModeSubtitle,
            icon: Icons.today_rounded,
            baseColor: const Color(0xFFE8F3E4),
            accentColor: const Color(0xFF347A48),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnAyahCompletionDaily',
            ),
            badgeLabel: l10n.learnGamesIslandTodayBadge,
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
            title: l10n.hadithReflectionHomeTitle,
            subtitle: l10n.learnQuizzesHadithReflectionSectionSubtitle,
            icon: Icons.record_voice_over_rounded,
            baseColor: const Color(0xFFE7EDF6),
            accentColor: const Color(0xFF506587),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnHadithReflectionHome',
            ),
          ),
          GameDiscoveryCard(
            id: 'hadith-patience',
            title: l10n.hadithReflectionPackPatienceTitle,
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
          ),
          GameDiscoveryCard(
            id: 'hadith-anger',
            title: l10n.hadithReflectionPackAngerTitle,
            subtitle: l10n.hadithReflectionPackAngerSubtitle,
            icon: Icons.favorite_outline_rounded,
            baseColor: const Color(0xFFE9EEF8),
            accentColor: const Color(0xFF5E6F94),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnHadithReflectionPack',
              pathParameters: {'packId': 'hadith_reflection_anger_control'},
            ),
          ),
          GameDiscoveryCard(
            id: 'hadith-family',
            title: l10n.hadithReflectionPackFamilyTitle,
            subtitle: l10n.hadithReflectionPackFamilySubtitle,
            icon: Icons.family_restroom_rounded,
            baseColor: const Color(0xFFE6EDF7),
            accentColor: const Color(0xFF526482),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnHadithReflectionPack',
              pathParameters: {'packId': 'hadith_reflection_family_respect'},
            ),
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
            title: l10n.learnGamesIslandModeDailyRunTitle,
            subtitle: l10n.learnGamesIslandModeDailyRunSubtitle,
            icon: Icons.flag_rounded,
            baseColor: const Color(0xFFF5E8D5),
            accentColor: const Color(0xFFA76719),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnDailyKnowledgeHub',
            ),
          ),
          GameDiscoveryCard(
            id: 'challenge-review',
            title: l10n.learnGamesIslandModeReviewTitle,
            subtitle: l10n.learnGamesIslandModeReviewSubtitle,
            icon: Icons.restart_alt_rounded,
            baseColor: const Color(0xFFF6E9D8),
            accentColor: const Color(0xFFA66A1A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnQuizzesHub',
              queryParameters: {'filter': 'review'},
            ),
          ),
          GameDiscoveryCard(
            id: 'challenge-trivia',
            title: l10n.learnGamesIslandModeTriviaTitle,
            subtitle: l10n.learnGamesIslandModeTriviaSubtitle,
            icon: Icons.bolt_rounded,
            baseColor: const Color(0xFFF7EBDD),
            accentColor: const Color(0xFFAC7322),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnQuizzesHub',
              queryParameters: {'filter': 'trivia'},
            ),
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
            title: l10n.spiritualGrowthTitle,
            subtitle: l10n.spiritualGrowthSubtitle,
            icon: Icons.wb_twilight_rounded,
            baseColor: const Color(0xFFECE1F3),
            accentColor: const Color(0xFF75559A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthPage',
            ),
          ),
          GameDiscoveryCard(
            id: 'spiritual-intentions',
            title: l10n.spiritualGrowthChooseIntentionAction,
            subtitle: l10n.spiritualGrowthChooseIntentionSubtitle,
            icon: Icons.flag_outlined,
            baseColor: const Color(0xFFF0E8F6),
            accentColor: const Color(0xFF7B5A9B),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthIntentions',
            ),
          ),
          GameDiscoveryCard(
            id: 'spiritual-reflection',
            title: l10n.spiritualGrowthReflectionTitle,
            subtitle: l10n.spiritualGrowthReflectionEntrySubtitle,
            icon: Icons.nights_stay_rounded,
            baseColor: const Color(0xFFEFE5F5),
            accentColor: const Color(0xFF7F5A9E),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthReflection',
            ),
          ),
          GameDiscoveryCard(
            id: 'spiritual-themes',
            title: l10n.spiritualGrowthThemeSummaryTitle,
            subtitle: l10n.spiritualGrowthThemeSummarySubtitle,
            icon: Icons.insights_rounded,
            baseColor: const Color(0xFFF0E7F6),
            accentColor: const Color(0xFF785691),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'spiritualGrowthThemes',
            ),
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
            title: l10n.crosswordPackAdultFoundationsTitle,
            subtitle: l10n.crosswordPackAdultFoundationsSubtitle,
            icon: Icons.start_rounded,
            baseColor: const Color(0xFFE1EEF0),
            accentColor: const Color(0xFF2E7581),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnCrosswordPack',
              pathParameters: {'packId': 'adult_foundations'},
            ),
          ),
          GameDiscoveryCard(
            id: 'pack-prophets',
            title: l10n.matchingPackProphetsTitle,
            subtitle: l10n.matchingPackProphetsSubtitle,
            icon: IslamicIcons.lantern,
            baseColor: const Color(0xFFE6F0F1),
            accentColor: const Color(0xFF376F79),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnMatchingPack',
              pathParameters: {'packId': 'matching_prophets'},
            ),
          ),
          GameDiscoveryCard(
            id: 'pack-duas',
            title: l10n.wordSearchPackDuaTitle,
            subtitle: l10n.wordSearchPackDuaSubtitle,
            icon: Icons.volunteer_activism_rounded,
            baseColor: const Color(0xFFE4EFF0),
            accentColor: const Color(0xFF2F6D78),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnWordSearchPack',
              pathParameters: {'packId': 'dua_pack'},
            ),
          ),
          GameDiscoveryCard(
            id: 'pack-seven-day',
            title: l10n.crosswordPackDailyTitle,
            subtitle: l10n.crosswordPackDailySubtitle,
            icon: Icons.calendar_view_week_rounded,
            baseColor: const Color(0xFFE7F0F1),
            accentColor: const Color(0xFF39727A),
            routeTarget: const LearnHubRouteTarget(
              routeName: 'learnCrosswordPack',
              pathParameters: {'packId': 'daily_rotation'},
            ),
          ),
        ],
      ),
    ];
  }
}
