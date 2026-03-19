import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../features/faq/data/faq_seed_data.dart';
import '../../../../l10n/app_localizations.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../../shared/domain/learn_system_models.dart';
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
    ..._mapUnifiedItems(l10n, unifiedItems),
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
