import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../features/faq/data/faq_seed_data.dart';
import '../../../../features/kids_arabic/data/kids_arabic_letters_data.dart';
import '../../../../features/kids_dua_learning/application/kids_dua_repository.dart';
import '../../../../features/kids_dua_learning/application/kids_dua_story_repository.dart';
import '../../../../features/kids_dua_learning/application/kids_dua_my_day_service.dart';
import '../../../../features/kids_dua_learning/domain/kids_dua_models.dart';
import '../../../../features/kids_dua_learning/presentation/kids_dua_localized_content.dart';
import '../../../../l10n/app_localizations.dart';
import '../../dua/data/dua_seed_data.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../../shared/domain/learn_system_models.dart';
import '../../trivia/data/trivia_knowledge_paths.dart';
import '../../world/data/world_creation_data.dart';
import '../../world/data/world_curriculum_data.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_hub_models.dart';

final learnHubCategoriesProvider = Provider<List<LearnHubCategoryDescriptor>>((
  ref,
) {
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  return LearnHubTaxonomy.orderedCategories
      .map(
        (category) => LearnHubCategoryDescriptor(
          id: category,
          title: LearnHubTaxonomy.categoryTitle(l10n, category),
          subtitle: LearnHubTaxonomy.categorySubtitle(l10n, category),
          routeTarget: LearnHubRouteTarget(
            routeName: 'learnHubCategory',
            pathParameters: {
              'categoryId': LearnHubTaxonomy.categorySlug(category),
            },
          ),
        ),
      )
      .toList(growable: false);
});

final learnHubSubcategoriesProvider =
    Provider<List<LearnHubSubcategoryDescriptor>>((ref) {
      final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
      final l10n = lookupAppLocalizations(locale);
      return LearnHubTaxonomy.subcategories(l10n);
    });

final learnHubKnowledgeIndexProvider = Provider<List<LearnHubKnowledgeItem>>((
  ref,
) {
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  final categories = ref.watch(learnHubCategoriesProvider);
  final subcategories = ref.watch(learnHubSubcategoriesProvider);
  final unifiedItems = ref.watch(learnUnifiedItemsProvider);
  final kidsDuaCategories = ref.watch(kidsDuaCategoriesProvider);
  final kidsDuaLessons = ref.watch(kidsDuaLessonsProvider);
  final kidsDuaStories = ref.watch(kidsDuaStoriesProvider);

  final results = <LearnHubKnowledgeItem>[
    for (final category in categories)
      LearnHubKnowledgeItem(
        id: 'category:${LearnHubTaxonomy.categorySlug(category.id)}',
        title: category.title,
        subtitle: category.subtitle,
        summary: category.subtitle,
        categoryId: category.id,
        contentType: LearnHubContentType.category,
        routeTarget: category.routeTarget,
        searchKeywords: [
          category.title,
          category.subtitle,
          LearnHubTaxonomy.categorySlug(category.id),
        ],
      ),
    for (final subcategory in subcategories)
      LearnHubKnowledgeItem(
        id: 'subcategory:${subcategory.id}',
        title: subcategory.title,
        subtitle: LearnHubTaxonomy.categoryTitle(l10n, subcategory.categoryId),
        summary: subcategory.subtitle,
        categoryId: subcategory.categoryId,
        subcategoryId: subcategory.id,
        subcategoryTitle: subcategory.title,
        contentType: LearnHubContentType.subcategory,
        routeTarget: subcategory.routeTarget,
        searchKeywords: [
          subcategory.title,
          subcategory.subtitle,
          ...subcategory.searchKeywords,
        ],
      ),
    ..._staticKnowledgeEntries(l10n),
    ..._babyNamesHubEntries(l10n),
    ..._mapUnifiedItems(l10n, unifiedItems),
    ..._duaKnowledgeEntries(l10n),
    ..._worldCreationCategoryEntries(l10n),
    ..._worldKnowledgeEntries(l10n),
    ..._kidsDuaCategoryEntries(l10n, kidsDuaCategories),
    ..._kidsArabicKnowledgeEntries(l10n),
    ..._kidsArabicHubEntries(l10n),
    ..._kidsStoryHubEntries(l10n),
    ..._kidsStoriesKnowledgeEntries(l10n, kidsDuaLessons, kidsDuaStories),
    ..._kidsSalahKnowledgeEntries(l10n, kidsDuaLessons),
    ..._triviaKnowledgePathHubEntries(l10n),
    ..._triviaChallengeKnowledgeEntries(l10n),
    ..._faqKnowledgeEntries(l10n),
  ];

  results.sort((a, b) {
    final categoryCompare = LearnHubTaxonomy.categoryTitle(
      l10n,
      a.categoryId,
    ).compareTo(LearnHubTaxonomy.categoryTitle(l10n, b.categoryId));
    if (categoryCompare != 0) {
      return categoryCompare;
    }
    return a.title.compareTo(b.title);
  });
  return results;
});

final learnHubFeaturedItemsProvider = Provider<List<LearnHubKnowledgeItem>>((
  ref,
) {
  final items = ref.watch(learnHubKnowledgeIndexProvider);
  final allowed = {
    LearnHubContentType.lesson,
    LearnHubContentType.story,
    LearnHubContentType.quiz,
    LearnHubContentType.tool,
    LearnHubContentType.note,
    LearnHubContentType.faq,
  };
  final filtered = items
      .where((item) => allowed.contains(item.contentType))
      .take(12)
      .toList(growable: false);
  return filtered;
});

List<LearnHubKnowledgeItem> filterLearnHubKnowledgeItems({
  required List<LearnHubKnowledgeItem> items,
  required String query,
  LearnHubCategoryId? categoryId,
}) {
  final normalized = query.trim().toLowerCase();
  return items.where((item) {
    if (categoryId != null && item.categoryId != categoryId) {
      return false;
    }
    if (normalized.isEmpty) {
      return true;
    }
    final haystack = <String>[
      item.title,
      item.subtitle,
      item.summary,
      if (item.subcategoryTitle != null) item.subcategoryTitle!,
      ...item.searchKeywords,
    ].join(' ').toLowerCase();
    return haystack.contains(normalized);
  }).toList(growable: false);
}

List<LearnHubKnowledgeItem> sortLearnHubKnowledgeItems(
  List<LearnHubKnowledgeItem> items, {
  bool alphabetical = false,
}) {
  final sorted = [...items];
  if (alphabetical) {
    sorted.sort((a, b) => a.title.compareTo(b.title));
    return sorted;
  }
  sorted.sort((a, b) {
    final typePriority = _contentTypePriority(a.contentType).compareTo(
      _contentTypePriority(b.contentType),
    );
    if (typePriority != 0) {
      return typePriority;
    }
    final badgePriority = (b.badgeLabel?.isNotEmpty ?? false ? 1 : 0).compareTo(
      a.badgeLabel?.isNotEmpty ?? false ? 1 : 0,
    );
    if (badgePriority != 0) {
      return badgePriority;
    }
    return a.title.compareTo(b.title);
  });
  return sorted;
}

int _contentTypePriority(LearnHubContentType type) {
  switch (type) {
    case LearnHubContentType.category:
      return 0;
    case LearnHubContentType.subcategory:
      return 1;
    case LearnHubContentType.journey:
      return 2;
    case LearnHubContentType.tool:
      return 3;
    case LearnHubContentType.lesson:
    case LearnHubContentType.story:
    case LearnHubContentType.note:
    case LearnHubContentType.quiz:
    case LearnHubContentType.challenge:
    case LearnHubContentType.faq:
      return 4;
  }
}

List<LearnHubKnowledgeItem> _staticKnowledgeEntries(AppLocalizations l10n) {
  return [
    LearnHubKnowledgeItem(
      id: 'journey:home',
      title: l10n.learningJourneyHomeTitle,
      subtitle: l10n.learnHubJourneysBrowseAction,
      summary: l10n.learnHubJourneysBrowseSubtitle,
      categoryId: LearnHubCategoryId.toolsExplore,
      contentType: LearnHubContentType.journey,
      routeTarget: const LearnHubRouteTarget(routeName: 'learnJourneyHome'),
      searchKeywords: const ['journeys', 'learning journey', 'browse journeys'],
    ),
    LearnHubKnowledgeItem(
      id: 'kids:practice',
      title: l10n.learnHubKidsPracticeTitle,
      subtitle: l10n.learnHubCategoryKidsLearningTitle,
      summary: l10n.learnHubKidsPracticeSubtitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-learning',
      subcategoryTitle: l10n.learnHubSubcategoryKidsLearningTitle,
      contentType: LearnHubContentType.challenge,
      routeTarget: const LearnHubRouteTarget(routeName: 'kidsDuaPractice'),
      searchKeywords: const ['kids practice', 'kids duas', 'practice'],
    ),
    LearnHubKnowledgeItem(
      id: 'kids:rewards',
      title: l10n.learnHubKidsRewardsTitle,
      subtitle: l10n.learnHubCategoryKidsLearningTitle,
      summary: l10n.learnHubKidsRewardsSubtitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-learning',
      subcategoryTitle: l10n.learnHubSubcategoryKidsLearningTitle,
      contentType: LearnHubContentType.tool,
      routeTarget: const LearnHubRouteTarget(routeName: 'kidsDuaRewards'),
      searchKeywords: const ['kids rewards', 'kids stars', 'motivation'],
    ),
    LearnHubKnowledgeItem(
      id: 'kids:coloring',
      title: l10n.learnHubKidsColoringTitle,
      subtitle: l10n.learnHubCategoryKidsLearningTitle,
      summary: l10n.learnHubKidsColoringSubtitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-arabic',
      subcategoryTitle: l10n.learnHubSubcategoryKidsArabicTitle,
      contentType: LearnHubContentType.tool,
      routeTarget: const LearnHubRouteTarget(
        routeName: 'kidsArabicColoringPages',
      ),
      searchKeywords: const ['coloring', 'kids arabic', 'letters'],
    ),
    LearnHubKnowledgeItem(
      id: 'tools:explore',
      title: l10n.learnHubExploreAllAction,
      subtitle: l10n.learnHubCategoryToolsExploreTitle,
      summary: l10n.learnHubExploreAllSubtitle,
      categoryId: LearnHubCategoryId.toolsExplore,
      subcategoryId: 'explore-all',
      subcategoryTitle: l10n.learnHubExploreAllAction,
      contentType: LearnHubContentType.tool,
      routeTarget: const LearnHubRouteTarget(
        routeName: 'learnExploreAllKnowledge',
      ),
      badgeLabel: l10n.learnHubBadgeExplore,
      searchKeywords: const ['explore all knowledge', 'search all', 'browse all'],
    ),
  ];
}

List<LearnHubKnowledgeItem> _duaKnowledgeEntries(AppLocalizations l10n) {
  return duaSeedDataset.verifiedItems.map((dua) {
    final subtitleParts = <String>[
      duaSeedDataset.categoryLabel(dua.category),
      if (dua.whenToSay.trim().isNotEmpty) dua.whenToSay.trim(),
    ];
    return LearnHubKnowledgeItem(
      id: 'dua:${dua.id}',
      title: dua.title,
      subtitle: subtitleParts.join(' • '),
      summary: dua.translation,
      categoryId: LearnHubCategoryId.worshipPractice,
      subcategoryId: 'duas',
      subcategoryTitle: l10n.learnCategoryDuasTitle,
      contentType: LearnHubContentType.lesson,
      routeTarget: LearnHubRouteTarget(
        routeName: 'learnDuaDetail',
        pathParameters: {'duaId': dua.id},
      ),
      searchKeywords: [
        dua.category,
        dua.subcategory,
        dua.sourceType,
        dua.sourceRef,
        ...dua.tags,
      ],
    );
  }).toList(growable: false);
}

List<LearnHubKnowledgeItem> _babyNamesHubEntries(AppLocalizations l10n) {
  return [
    LearnHubKnowledgeItem(
      id: 'baby-names:home',
      title: l10n.babyNamesTitle,
      subtitle: l10n.learnHubSubcategoryJourneyToolsTitle,
      summary: l10n.babyNamesSubtitle,
      categoryId: LearnHubCategoryId.toolsExplore,
      subcategoryId: 'journey-tools',
      subcategoryTitle: l10n.learnHubSubcategoryJourneyToolsTitle,
      contentType: LearnHubContentType.tool,
      routeTarget: const LearnHubRouteTarget(routeName: 'babyNamesHome'),
      searchKeywords: const [
        'baby names',
        'muslim names',
        'name finder',
        'family tools',
      ],
    ),
  ];
}

List<LearnHubKnowledgeItem> _worldCreationCategoryEntries(
  AppLocalizations l10n,
) {
  return worldCreationCategories.map((category) {
    return LearnHubKnowledgeItem(
      id: 'world-category:${category.id.name}',
      title: category.title,
      subtitle: l10n.learnCategoryWorldCreationTitle,
      summary: category.description,
      categoryId: LearnHubCategoryId.quranHadith,
      subcategoryId: 'world-creation',
      subcategoryTitle: l10n.learnCategoryWorldCreationTitle,
      contentType: LearnHubContentType.tool,
      routeTarget: LearnHubRouteTarget(
        routeName: 'worldCreationCategory',
        pathParameters: {'categoryName': category.id.name},
      ),
      searchKeywords: [
        category.id.name,
        category.featuredVerse.surahName,
        category.featuredVerse.referenceLabel,
        ...category.lessonIds,
      ],
    );
  }).toList(growable: false);
}

List<LearnHubKnowledgeItem> _worldKnowledgeEntries(AppLocalizations l10n) {
  final themeById = {
    for (final theme in worldCurriculum.themes) theme.id: theme,
  };
  final subcategoryById = {
    for (final subcategory in worldCurriculum.subcategories)
      subcategory.id: subcategory,
  };

  return worldCurriculum.lessons.map((lesson) {
    final theme = themeById[lesson.themeId];
    final subcategory = subcategoryById[lesson.subcategoryId];
    return LearnHubKnowledgeItem(
      id: 'world:${lesson.id}',
      title: lesson.title,
      subtitle: subcategory?.title ?? theme?.title ?? lesson.subtitle,
      summary: lesson.overview,
      categoryId: LearnHubCategoryId.quranHadith,
      subcategoryId: 'world-creation',
      subcategoryTitle: l10n.learnCategoryWorldCreationTitle,
      contentType: LearnHubContentType.lesson,
      routeTarget: LearnHubRouteTarget(
        routeName: 'worldLessonDetail',
        pathParameters: {'lessonId': lesson.id},
      ),
      searchKeywords: [
        lesson.subtitle,
        lesson.quranicPerspective,
        lesson.reflectiveTakeaway,
        if (theme != null) theme.title,
        if (subcategory != null) subcategory.title,
        ...lesson.keyConcepts,
      ],
    );
  }).toList(growable: false);
}

List<LearnHubKnowledgeItem> _kidsDuaCategoryEntries(
  AppLocalizations l10n,
  List<KidsDuaCategory> categories,
) {
  return categories.map((category) {
    return LearnHubKnowledgeItem(
      id: 'kids-dua-category:${category.id}',
      title: category.title,
      subtitle: l10n.learnHubSubcategoryKidsLearningTitle,
      summary: category.subtitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-learning',
      subcategoryTitle: l10n.learnHubSubcategoryKidsLearningTitle,
      contentType: LearnHubContentType.lesson,
      routeTarget: LearnHubRouteTarget(
        routeName: 'kidsDuaCategory',
        pathParameters: {'categoryId': category.id},
      ),
      searchKeywords: [category.id, category.title, category.subtitle],
    );
  }).toList(growable: false);
}

List<LearnHubKnowledgeItem> _kidsArabicKnowledgeEntries(AppLocalizations l10n) {
  return kidsArabicLetters.map((letter) {
    return LearnHubKnowledgeItem(
      id: 'kids-arabic:${letter.id}',
      title: letter.nameEn,
      subtitle: '${letter.glyph} • ${letter.exampleWordEn}',
      summary: letter.childFriendlyLine,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-arabic',
      subcategoryTitle: l10n.learnHubSubcategoryKidsArabicTitle,
      contentType: LearnHubContentType.lesson,
      routeTarget: LearnHubRouteTarget(
        routeName: 'kidsArabicLesson',
        pathParameters: {'letterId': letter.id},
      ),
      searchKeywords: [
        letter.glyph,
        letter.nameAr,
        letter.transliteration,
        letter.soundHint,
        letter.exampleWord,
        letter.exampleWordAr,
        letter.exampleWordEn,
      ],
    );
  }).toList(growable: false);
}

List<LearnHubKnowledgeItem> _kidsArabicHubEntries(AppLocalizations l10n) {
  return [
    LearnHubKnowledgeItem(
      id: 'kids-arabic:review',
      title: l10n.kidsArabicReviewTitle,
      subtitle: l10n.learnHubSubcategoryKidsArabicTitle,
      summary: l10n.kidsArabicReviewSubtitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-arabic',
      subcategoryTitle: l10n.learnHubSubcategoryKidsArabicTitle,
      contentType: LearnHubContentType.challenge,
      routeTarget: const LearnHubRouteTarget(routeName: 'kidsArabicReview'),
      searchKeywords: const [
        'kids arabic review',
        'letter review',
        'arabic letters',
      ],
    ),
    LearnHubKnowledgeItem(
      id: 'kids-arabic:rewards',
      title: l10n.kidsArabicRewardsTitle,
      subtitle: l10n.learnHubSubcategoryKidsArabicTitle,
      summary: l10n.kidsArabicRewardsSubtitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-arabic',
      subcategoryTitle: l10n.learnHubSubcategoryKidsArabicTitle,
      contentType: LearnHubContentType.tool,
      routeTarget: const LearnHubRouteTarget(routeName: 'kidsArabicRewards'),
      searchKeywords: const [
        'kids arabic rewards',
        'stickers',
        'letter rewards',
      ],
    ),
  ];
}

List<LearnHubKnowledgeItem> _kidsStoryHubEntries(AppLocalizations l10n) {
  return [
    LearnHubKnowledgeItem(
      id: 'kids-stories:hub',
      title: l10n.kidsDuaStoriesTitle,
      subtitle: l10n.learnHubSubcategoryKidsStoriesTitle,
      summary: l10n.kidsDuaStoriesSubtitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-stories',
      subcategoryTitle: l10n.learnHubSubcategoryKidsStoriesTitle,
      contentType: LearnHubContentType.story,
      routeTarget: const LearnHubRouteTarget(routeName: 'kidsDuaStories'),
      searchKeywords: const ['kids stories', 'dua stories', 'story time'],
    ),
    LearnHubKnowledgeItem(
      id: 'kids-stories:browse',
      title: l10n.kidsDuaStoriesBrowseAllTitle,
      subtitle: l10n.learnHubSubcategoryKidsStoriesTitle,
      summary: l10n.kidsDuaStoriesBrowseTitle,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-stories',
      subcategoryTitle: l10n.learnHubSubcategoryKidsStoriesTitle,
      contentType: LearnHubContentType.story,
      routeTarget: const LearnHubRouteTarget(
        routeName: 'kidsDuaStoriesBrowse',
      ),
      searchKeywords: const [
        'browse stories',
        'kids stories',
        'dua story categories',
      ],
    ),
  ];
}

List<LearnHubKnowledgeItem> _kidsStoriesKnowledgeEntries(
  AppLocalizations l10n,
  List<KidsDuaLessonContent> kidsDuaLessons,
  List<KidsDuaStory> kidsDuaStories,
) {
  final lessonById = {
    for (final lesson in kidsDuaLessons) lesson.id: lesson,
  };
  return kidsDuaStories.map((story) {
    final lesson = lessonById[story.duaId];
    return LearnHubKnowledgeItem(
      id: 'kids-story:${story.id}',
      title: story.title,
      subtitle: lesson?.title ?? story.category,
      summary: story.introLine,
      categoryId: LearnHubCategoryId.kidsLearning,
      subcategoryId: 'kids-stories',
      subcategoryTitle: l10n.learnHubSubcategoryKidsStoriesTitle,
      contentType: LearnHubContentType.story,
      routeTarget: LearnHubRouteTarget(
        routeName: 'kidsDuaStoryPlayer',
        pathParameters: {'storyId': story.id},
      ),
      searchKeywords: [
        story.category,
        story.ageGroup,
        story.duaId,
        story.slug,
        if (lesson != null) lesson.title,
      ],
    );
  }).toList(growable: false);
}

List<LearnHubKnowledgeItem> _kidsSalahKnowledgeEntries(
  AppLocalizations l10n,
  List<KidsDuaLessonContent> kidsDuaLessons,
) {
  final lessonById = {
    for (final lesson in kidsDuaLessons) lesson.id: lesson,
  };
  final sectionTitleByDuaId = <String, String>{};
  for (final section in kidsDuaMyDaySections) {
    final sectionTitle = localizedKidsDuaRewardTitle(l10n, section.titleKey);
    for (final duaId in section.duaIds) {
      sectionTitleByDuaId[duaId] = sectionTitle;
    }
  }

  final items = <LearnHubKnowledgeItem>[];
  for (final duaId in sectionTitleByDuaId.keys) {
    final lesson = lessonById[duaId];
    if (lesson == null) {
      continue;
    }
    items.add(
      LearnHubKnowledgeItem(
        id: 'kids-salah:${lesson.id}',
        title: lesson.title,
        subtitle: sectionTitleByDuaId[lesson.id] ?? l10n.kidsDuaMyDayTitle,
        summary: lesson.whenToSay,
        categoryId: LearnHubCategoryId.kidsLearning,
        subcategoryId: 'kids-salah',
        subcategoryTitle: l10n.learnHubSubcategoryKidsSalahTitle,
        contentType: LearnHubContentType.lesson,
        routeTarget: LearnHubRouteTarget(
          routeName: 'kidsDuaLesson',
          pathParameters: {'lessonId': lesson.id},
        ),
        searchKeywords: [
          lesson.categoryId,
          lesson.slug,
          lesson.meaning,
          lesson.practicePrompt ?? '',
          sectionTitleByDuaId[lesson.id] ?? '',
        ],
      ),
    );
  }
  return items;
}

List<LearnHubKnowledgeItem> _triviaChallengeKnowledgeEntries(
  AppLocalizations l10n,
) {
  final items = <LearnHubKnowledgeItem>[];
  for (final path in triviaKnowledgePaths) {
    items.add(
      LearnHubKnowledgeItem(
        id: 'trivia-path:${path.id}',
        title: path.title,
        subtitle: l10n.learnCategoryIslamicTriviaTitle,
        summary: path.description,
        categoryId: LearnHubCategoryId.quizzesChallenges,
        subcategoryId: 'challenges',
        subcategoryTitle: l10n.learnHubSubcategoryChallengesTitle,
        contentType: LearnHubContentType.challenge,
        routeTarget: LearnHubRouteTarget(
          routeName: 'learnTriviaKnowledgePathDetail',
          pathParameters: {'pathId': path.id},
        ),
        searchKeywords: [path.id, ...path.stages.map((stage) => stage.title)],
      ),
    );
    for (final stage in path.stages) {
      items.add(
        LearnHubKnowledgeItem(
          id: 'trivia-stage:${path.id}:${stage.id}',
          title: stage.title,
          subtitle: path.title,
          summary: stage.learningText,
          categoryId: LearnHubCategoryId.quizzesChallenges,
          subcategoryId: 'challenges',
          subcategoryTitle: l10n.learnHubSubcategoryChallengesTitle,
          contentType: LearnHubContentType.challenge,
          routeTarget: LearnHubRouteTarget(
            routeName: 'learnTriviaKnowledgePathStage',
            pathParameters: {'pathId': path.id, 'stageId': stage.id},
          ),
          searchKeywords: [
            path.id,
            path.title,
            stage.id,
            if (stage.reference != null) stage.reference!,
            ...stage.questionIds,
          ],
        ),
      );
    }
  }
  return items;
}

List<LearnHubKnowledgeItem> _triviaKnowledgePathHubEntries(
  AppLocalizations l10n,
) {
  return [
    LearnHubKnowledgeItem(
      id: 'trivia-paths:hub',
      title: l10n.triviaKnowledgePathsPageTitle,
      subtitle: l10n.learnHubSubcategoryChallengesTitle,
      summary: l10n.triviaKnowledgePathsPageSubtitle,
      categoryId: LearnHubCategoryId.quizzesChallenges,
      subcategoryId: 'challenges',
      subcategoryTitle: l10n.learnHubSubcategoryChallengesTitle,
      contentType: LearnHubContentType.challenge,
      routeTarget: const LearnHubRouteTarget(
        routeName: 'learnTriviaKnowledgePaths',
      ),
      searchKeywords: const [
        'knowledge paths',
        'trivia paths',
        'guided challenge',
      ],
    ),
  ];
}

List<LearnHubKnowledgeItem> _mapUnifiedItems(
  AppLocalizations l10n,
  List<LearnUnifiedContentItem> items,
) {
  return items.map((item) {
    final mapped = _mapUnifiedItemCategory(l10n, item);
    return LearnHubKnowledgeItem(
      id: item.id,
      title: item.title,
      subtitle: item.subtitle,
      summary: item.summary,
      categoryId: mapped.$1,
      subcategoryId: mapped.$2,
      subcategoryTitle: mapped.$3,
      contentType: _mapContentType(item.type),
      routeTarget: LearnHubRouteTarget(
        routeName: item.routeName ?? 'learn',
        pathParameters: item.pathParameters,
        queryParameters: item.queryParameters,
      ),
      searchKeywords: item.tags,
    );
  }).where((item) => item.routeTarget.routeName != 'learn').toList(growable: false);
}

(LearnHubCategoryId, String?, String?) _mapUnifiedItemCategory(
  AppLocalizations l10n,
  LearnUnifiedContentItem item,
) {
  switch (item.domain) {
    case LearnUnifiedDomain.quran:
      return (
        LearnHubCategoryId.quranHadith,
        'quran-learning',
        l10n.learnCategoryQuranLearningTitle,
      );
    case LearnUnifiedDomain.hadith:
      return (
        LearnHubCategoryId.quranHadith,
        'hadith',
        l10n.learnCategoryHadithTitle,
      );
    case LearnUnifiedDomain.prophets:
      return (
        LearnHubCategoryId.prophetsStories,
        'prophets',
        l10n.learnCategoryStoriesOfProphetsTitle,
      );
    case LearnUnifiedDomain.lifeLessons:
      return (
        LearnHubCategoryId.quranHadith,
        'divine-life-lessons',
        l10n.learnCategoryDivineLifeLessonsTitle,
      );
    case LearnUnifiedDomain.salah:
      return (
        LearnHubCategoryId.worshipPractice,
        'salah-trainer',
        l10n.learnCategorySalahTrainerTitle,
      );
    case LearnUnifiedDomain.namesOfAllah:
      return (
        LearnHubCategoryId.foundations,
        'who-is-allah',
        l10n.learnHubSubcategoryWhoIsAllahTitle,
      );
    case LearnUnifiedDomain.babyNames:
      return (
        LearnHubCategoryId.toolsExplore,
        'journey-tools',
        l10n.learnHubSubcategoryJourneyToolsTitle,
      );
    case LearnUnifiedDomain.quizzes:
      return (
        LearnHubCategoryId.quizzesChallenges,
        'quizzes',
        l10n.learnCategoryQuizzesTitle,
      );
    case LearnUnifiedDomain.notes:
      return (
        LearnHubCategoryId.notes,
        'notes',
        l10n.learnCategoryNotesTitle,
      );
  }
}

LearnHubContentType _mapContentType(LearnItemType type) {
  switch (type) {
    case LearnItemType.prophet:
      return LearnHubContentType.story;
    case LearnItemType.quiz:
      return LearnHubContentType.quiz;
    case LearnItemType.note:
      return LearnHubContentType.note;
    case LearnItemType.pathStep:
      return LearnHubContentType.challenge;
    case LearnItemType.verse:
    case LearnItemType.hadith:
    case LearnItemType.lifeLesson:
    case LearnItemType.salahPrayer:
    case LearnItemType.surah:
    case LearnItemType.recitation:
    case LearnItemType.name:
    case LearnItemType.babyName:
    case LearnItemType.reflection:
      return LearnHubContentType.lesson;
  }
}

List<LearnHubKnowledgeItem> _faqKnowledgeEntries(AppLocalizations l10n) {
  final items = <LearnHubKnowledgeItem>[];
  for (final entry in faqSeedDataset.items) {
    final categoryTitle =
        faqSeedDataset.categoryLabels[entry.category] ?? entry.category;
    items.add(
      LearnHubKnowledgeItem(
        id: 'faq:${entry.id}',
        title: entry.question,
        subtitle: categoryTitle,
        summary: entry.shortAnswer,
        categoryId: LearnHubCategoryId.faq,
        subcategoryId: entry.category,
        subcategoryTitle: categoryTitle,
        contentType: LearnHubContentType.faq,
        routeTarget: LearnHubRouteTarget(
          routeName: 'faqDetail',
          pathParameters: {'faqId': entry.id},
        ),
        searchKeywords: [
          ...entry.relatedTopics,
          ...entry.quranRefs,
          ...entry.hadithRefs,
          if (entry.misconceptionTag != null) entry.misconceptionTag!,
        ],
        badgeLabel: entry.isFeatured ? l10n.learnCommonNewBadge : null,
      ),
    );
  }
  return items;
}

double journeyProgressRatio({
  required Set<String> completedStageIds,
  required List<String> stageIds,
}) {
  if (stageIds.isEmpty) {
    return 0;
  }
  final completed = stageIds.where(completedStageIds.contains).length;
  return completed / math.max(stageIds.length, 1);
}
