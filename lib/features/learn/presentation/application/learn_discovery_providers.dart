import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../guided_paths/application/guided_learning_paths_provider.dart';
import '../../guided_paths/domain/guided_learning_path_models.dart';
import '../data/learn_discovery_flags.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_discovery_models.dart';
import '../models/learn_hub_models.dart';
import 'learn_hub_providers.dart';

final learnDiscoveryIndexProvider = Provider<List<LearnDiscoveryIndexEntry>>((
  ref,
) {
  final locale = ref.watch(appLocaleProvider) ?? const Locale('en');
  final l10n = lookupAppLocalizations(locale);
  final knowledgeItems = ref.watch(learnHubKnowledgeIndexProvider);
  final localizedPaths = ref.watch(localizedGuidedLearningPathsProvider);

  final entries = <LearnDiscoveryIndexEntry>[
    for (final path in localizedPaths) _mapLocalizedGuidedPath(path),
    for (final item in knowledgeItems)
      if (item.contentType != LearnHubContentType.category)
        _mapKnowledgeItem(l10n, item),
  ];

  final deduped = <String, LearnDiscoveryIndexEntry>{};
  for (final entry in entries) {
    deduped.putIfAbsent(entry.id, () => entry);
  }
  return deduped.values.toList(growable: false);
});

final learnDiscoveryFeaturedStartHereProvider =
    Provider<List<LearnDiscoveryIndexEntry>>((ref) {
      final entries = ref.watch(learnDiscoveryIndexProvider);
      final results = entries
          .where((entry) => entry.startHere)
          .toList(growable: false);
      results.sort((a, b) {
        final audienceCompare = a.audience.index.compareTo(b.audience.index);
        if (audienceCompare != 0) {
          return audienceCompare;
        }
        return a.title.compareTo(b.title);
      });
      return results;
    });

List<LearnDiscoverySearchResult> searchLearnDiscoveryEntries({
  required List<LearnDiscoveryIndexEntry> entries,
  required String query,
  LearnHubCategoryId? categoryId,
  LearnDiscoveryContentType? contentType,
  LearnDiscoveryAudience? audience,
  LearnDiscoveryDifficulty? difficulty,
  bool alphabetical = false,
}) {
  final normalized = _normalizeSearchText(query);
  if (normalized.isEmpty && query.trim().isNotEmpty) {
    // Something was typed, but nothing searchable (punctuation, emoji):
    // that is not a request to browse everything.
    return <LearnDiscoverySearchResult>[];
  }
  final queryTokens = _tokenize(normalized);
  final expandedTokens = _expandedTokens(queryTokens);
  final typedForms = _typedFormsByToken(query);

  final filtered = <LearnDiscoverySearchResult>[];
  for (final entry in entries) {
    if (categoryId != null && entry.categoryId != categoryId) {
      continue;
    }
    if (contentType != null && entry.contentType != contentType) {
      continue;
    }
    if (audience != null && entry.audience != audience) {
      continue;
    }
    if (difficulty != null && entry.difficulty != difficulty) {
      continue;
    }
    final match = _scoreEntry(
      entry,
      normalizedQuery: normalized,
      queryTokens: queryTokens,
      expandedTokens: expandedTokens,
      typedForms: typedForms,
    );
    if (normalized.isNotEmpty && match.score <= 0) {
      continue;
    }
    filtered.add(match);
  }

  filtered.sort((a, b) {
    if (alphabetical) {
      return a.entry.title.compareTo(b.entry.title);
    }
    final scoreCompare = b.score.compareTo(a.score);
    if (scoreCompare != 0) {
      return scoreCompare;
    }
    final typeCompare = _contentTypePriority(
      a.entry.contentType,
    ).compareTo(_contentTypePriority(b.entry.contentType));
    if (typeCompare != 0) {
      return typeCompare;
    }
    return a.entry.title.compareTo(b.entry.title);
  });
  return filtered;
}

List<LearnDiscoveryBucketSection> bucketLearnDiscoveryResults({
  required List<LearnDiscoverySearchResult> results,
  required List<LearnDiscoveryIndexEntry> allEntries,
}) {
  if (results.isEmpty) {
    return const <LearnDiscoveryBucketSection>[];
  }

  final sections = <LearnDiscoveryBucketSection>[];
  final bestMatch = results.first;
  sections.add(
    LearnDiscoveryBucketSection(
      bucket: LearnDiscoveryBucket.bestMatch,
      results: <LearnDiscoverySearchResult>[bestMatch],
    ),
  );

  final remaining = results.skip(1).toList(growable: false);
  final usedIds = <String>{bestMatch.entry.id};
  final guidedPaths = remaining
      .where(
        (result) =>
            result.entry.contentType == LearnDiscoveryContentType.path &&
            !usedIds.contains(result.entry.id),
      )
      .take(6)
      .toList(growable: false);
  if (guidedPaths.isNotEmpty) {
    usedIds.addAll(guidedPaths.map((result) => result.entry.id));
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.guidedPaths,
        results: guidedPaths,
      ),
    );
  }

  final kidsResults = remaining
      .where(
        (result) =>
            result.entry.audience == LearnDiscoveryAudience.kids &&
            !usedIds.contains(result.entry.id),
      )
      .take(6)
      .toList(growable: false);
  if (kidsResults.isNotEmpty) {
    usedIds.addAll(kidsResults.map((result) => result.entry.id));
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.kids,
        results: kidsResults,
      ),
    );
  }

  final lessonsAndPages = remaining
      .where(
        (result) =>
            result.entry.audience != LearnDiscoveryAudience.kids &&
            !usedIds.contains(result.entry.id),
      )
      .where(
        (result) => result.entry.contentType != LearnDiscoveryContentType.path,
      )
      .take(10)
      .toList(growable: false);
  if (lessonsAndPages.isNotEmpty) {
    usedIds.addAll(lessonsAndPages.map((result) => result.entry.id));
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.lessonsAndPages,
        results: lessonsAndPages,
      ),
    );
  }

  final related = _relatedResultsFor(
    bestMatch.entry,
    allEntries: allEntries,
    existingIds: results.map((result) => result.entry.id).toSet(),
  );
  if (related.isNotEmpty) {
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.related,
        results: related,
      ),
    );
  }

  return sections;
}

List<LearnDiscoveryBucketSection> curatedLearnDiscoverySections({
  required List<LearnDiscoveryIndexEntry> entries,
}) {
  final sections = <LearnDiscoveryBucketSection>[];
  final usedIds = <String>{};

  final startHere = entries
      .where((entry) => entry.startHere && !usedIds.contains(entry.id))
      .take(6)
      .map(
        (entry) => LearnDiscoverySearchResult(
          entry: entry,
          score: 1,
          matchedTerms: const <String>{},
        ),
      )
      .toList(growable: false);
  if (startHere.isNotEmpty) {
    usedIds.addAll(startHere.map((result) => result.entry.id));
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.startHere,
        results: startHere,
      ),
    );
  }

  final guidedPaths = entries
      .where(
        (entry) =>
            entry.contentType == LearnDiscoveryContentType.path &&
            !usedIds.contains(entry.id),
      )
      .take(7)
      .map(
        (entry) => LearnDiscoverySearchResult(
          entry: entry,
          score: 1,
          matchedTerms: const <String>{},
        ),
      )
      .toList(growable: false);
  if (guidedPaths.isNotEmpty) {
    usedIds.addAll(guidedPaths.map((result) => result.entry.id));
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.guidedPaths,
        results: guidedPaths,
      ),
    );
  }

  final kids = entries
      .where(
        (entry) =>
            entry.audience == LearnDiscoveryAudience.kids &&
            !usedIds.contains(entry.id),
      )
      .take(6)
      .map(
        (entry) => LearnDiscoverySearchResult(
          entry: entry,
          score: 1,
          matchedTerms: const <String>{},
        ),
      )
      .toList(growable: false);
  if (kids.isNotEmpty) {
    usedIds.addAll(kids.map((result) => result.entry.id));
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.kids,
        results: kids,
      ),
    );
  }

  final practice = entries
      .where(
        (entry) =>
            !usedIds.contains(entry.id) &&
            (entry.contentType == LearnDiscoveryContentType.practice ||
                entry.contentType == LearnDiscoveryContentType.tool ||
                entry.categoryId == LearnHubCategoryId.worshipPractice ||
                entry.categoryId == LearnHubCategoryId.quizzesChallenges),
      )
      .take(8)
      .map(
        (entry) => LearnDiscoverySearchResult(
          entry: entry,
          score: 1,
          matchedTerms: const <String>{},
        ),
      )
      .toList(growable: false);
  if (practice.isNotEmpty) {
    sections.add(
      LearnDiscoveryBucketSection(
        bucket: LearnDiscoveryBucket.practiceAndTools,
        results: practice,
      ),
    );
  }

  return sections;
}

LearnDiscoverySearchResult _scoreEntry(
  LearnDiscoveryIndexEntry entry, {
  required String normalizedQuery,
  required Set<String> queryTokens,
  required Set<String> expandedTokens,
  required Map<String, String> typedForms,
}) {
  if (normalizedQuery.isEmpty) {
    var baseScore = 1;
    if (entry.startHere) {
      baseScore += 12;
    }
    if (entry.contentType == LearnDiscoveryContentType.path) {
      baseScore += 8;
    }
    if (entry.beginnerSafe) {
      baseScore += 4;
    }
    return LearnDiscoverySearchResult(
      entry: entry,
      score: baseScore,
      matchedTerms: const <String>{},
    );
  }

  var score = 0;
  final matchedTerms = <String>{};
  final text = _entrySearchText[entry] ??= _EntrySearchText(entry);
  final title = text.title;
  final subtitle = text.subtitle;
  final summary = text.summary;
  final keywordText = text.keywords;

  if (title == normalizedQuery) {
    score += 120;
    matchedTerms.add(normalizedQuery);
  } else if (title.contains(normalizedQuery)) {
    score += 70;
    matchedTerms.add(normalizedQuery);
  }

  for (final token in expandedTokens) {
    if (token.isEmpty) continue;
    if (title.contains(token)) {
      score += queryTokens.contains(token) ? 24 : 12;
      matchedTerms.add(token);
    }
    if (subtitle.contains(token)) {
      score += queryTokens.contains(token) ? 12 : 7;
      matchedTerms.add(token);
    }
    if (summary.contains(token)) {
      score += queryTokens.contains(token) ? 10 : 6;
      matchedTerms.add(token);
    }
    if (keywordText.contains(token)) {
      score += queryTokens.contains(token) ? 16 : 9;
      matchedTerms.add(token);
    }
  }

  final beginnerIntent = queryTokens.intersection(_beginnerIntentTokens);
  if (beginnerIntent.isNotEmpty) {
    if (entry.difficulty == LearnDiscoveryDifficulty.startHere) {
      score += 18;
    }
    if (entry.beginnerSafe) {
      score += 10;
    }
    if (entry.contentType == LearnDiscoveryContentType.path) {
      score += 10;
    }
    if (entry.contentType == LearnDiscoveryContentType.hub ||
        entry.contentType == LearnDiscoveryContentType.tool) {
      score -= 4;
    }
  }

  if (queryTokens.intersection(_kidsIntentTokens).isNotEmpty &&
      entry.audience == LearnDiscoveryAudience.kids) {
    score += 20;
    if (entry.contentType == LearnDiscoveryContentType.path) {
      score += 18;
    }
  }

  // The Start-here and path boosts rank matches; on their own they are not
  // a match, or every query (even nonsense) would list them.
  if (score <= 0) {
    return LearnDiscoverySearchResult(
      entry: entry,
      score: 0,
      matchedTerms: const <String>{},
    );
  }
  if (entry.startHere) {
    score += 8;
  }
  if (entry.contentType == LearnDiscoveryContentType.path) {
    score += 6;
  }

  // Highlights are drawn on the original copy, where the folded token
  // ("schopfung", "صلاه") never appears; add what the reader typed.
  for (final term in matchedTerms.toList(growable: false)) {
    final typed = typedForms[term];
    if (typed != null) {
      matchedTerms.add(typed);
    }
  }

  return LearnDiscoverySearchResult(
    entry: entry,
    score: score,
    matchedTerms: matchedTerms,
  );
}

List<LearnDiscoverySearchResult> _relatedResultsFor(
  LearnDiscoveryIndexEntry entry, {
  required List<LearnDiscoveryIndexEntry> allEntries,
  required Set<String> existingIds,
}) {
  final byId = <String, LearnDiscoveryIndexEntry>{
    for (final candidate in allEntries) candidate.id: candidate,
  };
  final related = <LearnDiscoverySearchResult>[];
  for (final pathId in entry.relatedPathIds) {
    final candidate = byId['path:$pathId'];
    if (candidate == null || existingIds.contains(candidate.id)) {
      continue;
    }
    related.add(
      LearnDiscoverySearchResult(
        entry: candidate,
        score: 1,
        matchedTerms: const <String>{},
      ),
    );
  }
  for (final entryId in entry.relatedEntryIds) {
    final candidate = byId[entryId];
    if (candidate == null || existingIds.contains(candidate.id)) {
      continue;
    }
    related.add(
      LearnDiscoverySearchResult(
        entry: candidate,
        score: 1,
        matchedTerms: const <String>{},
      ),
    );
  }
  return related.take(4).toList(growable: false);
}

int _contentTypePriority(LearnDiscoveryContentType type) {
  switch (type) {
    case LearnDiscoveryContentType.path:
      return 0;
    case LearnDiscoveryContentType.lesson:
    case LearnDiscoveryContentType.story:
    case LearnDiscoveryContentType.practice:
    case LearnDiscoveryContentType.reflection:
      return 1;
    case LearnDiscoveryContentType.quiz:
      return 2;
    case LearnDiscoveryContentType.tool:
      return 3;
    case LearnDiscoveryContentType.note:
    case LearnDiscoveryContentType.faq:
      return 4;
    case LearnDiscoveryContentType.journey:
      return 5;
    case LearnDiscoveryContentType.hub:
      return 6;
  }
}

LearnDiscoveryIndexEntry _mapLocalizedGuidedPath(
  LocalizedGuidedLearningPath path,
) {
  final categoryId = switch (path.path.id) {
    'quran-beginner-starter' => LearnHubCategoryId.quranHadith,
    'salah-starter' ||
    'daily-dhikr-starter' => LearnHubCategoryId.worshipPractice,
    'character-starter' => LearnHubCategoryId.characterAdab,
    'stories-starter' => LearnHubCategoryId.prophetsStories,
    'kids-starter' => LearnHubCategoryId.kidsLearning,
    _ => LearnHubCategoryId.foundations,
  };

  final searchTerms = <String>[
    path.title,
    path.subtitle,
    path.description,
    ...path.path.tags,
    ..._pathKeywords(path.path.id),
    for (final step in path.steps) step.title,
    for (final step in path.steps) step.subtitle,
  ];

  return LearnDiscoveryIndexEntry(
    id: 'path:${path.path.id}',
    title: path.title,
    subtitle: path.subtitle,
    summary: path.description,
    categoryId: categoryId,
    contentType: LearnDiscoveryContentType.path,
    routeTarget: LearnHubRouteTarget(
      routeName: 'learnGuidedPathDetail',
      pathParameters: <String, String>{'pathId': path.path.id},
    ),
    audience: path.path.audience == GuidedLearningPathAudience.kids
        ? LearnDiscoveryAudience.kids
        : LearnDiscoveryAudience.beginner,
    difficulty: LearnDiscoveryDifficulty.startHere,
    searchTerms: searchTerms,
    relatedPathIds: _relatedPathsForPath(path.path.id),
    startHere: true,
    beginnerSafe: true,
  );
}

LearnDiscoveryIndexEntry _mapKnowledgeItem(
  AppLocalizations l10n,
  LearnHubKnowledgeItem item,
) {
  final contentType = switch (item.contentType) {
    LearnHubContentType.lesson => LearnDiscoveryContentType.lesson,
    LearnHubContentType.story => LearnDiscoveryContentType.story,
    LearnHubContentType.quiz => LearnDiscoveryContentType.quiz,
    LearnHubContentType.challenge => LearnDiscoveryContentType.quiz,
    LearnHubContentType.tool =>
      learnDiscoveryToolContentTypes[item.id] ?? LearnDiscoveryContentType.tool,
    LearnHubContentType.note => LearnDiscoveryContentType.note,
    LearnHubContentType.faq => LearnDiscoveryContentType.faq,
    LearnHubContentType.journey => LearnDiscoveryContentType.journey,
    LearnHubContentType.subcategory => LearnDiscoveryContentType.hub,
    LearnHubContentType.category => LearnDiscoveryContentType.hub,
  };

  final startHere = learnDiscoveryStartHereIds.contains(item.id);
  final beginnerSafe =
      item.categoryId == LearnHubCategoryId.foundations ||
      item.categoryId == LearnHubCategoryId.kidsLearning ||
      learnDiscoveryBeginnerIds.contains(item.id);

  final audience = item.categoryId == LearnHubCategoryId.kidsLearning
      ? LearnDiscoveryAudience.kids
      : beginnerSafe
      ? LearnDiscoveryAudience.beginner
      : LearnDiscoveryAudience.general;

  final difficulty = startHere
      ? LearnDiscoveryDifficulty.startHere
      : learnDiscoveryDeeperIds.contains(item.id)
      ? LearnDiscoveryDifficulty.deeper
      : LearnDiscoveryDifficulty.growing;

  return LearnDiscoveryIndexEntry(
    id: item.id,
    title: item.title,
    subtitle: item.subtitle,
    summary: item.summary.isEmpty ? item.subtitle : item.summary,
    categoryId: item.categoryId,
    contentType: contentType,
    routeTarget: _canonicalRouteTargetForKnowledgeItem(item),
    audience: audience,
    difficulty: difficulty,
    searchTerms: <String>[
      item.title,
      item.subtitle,
      item.summary,
      if (item.subcategoryTitle != null) item.subcategoryTitle!,
      LearnHubTaxonomy.categoryTitle(l10n, item.categoryId),
      ...item.searchKeywords,
      ..._categoryKeywords(item.categoryId),
    ],
    relatedPathIds: _relatedPathsForCategory(item.categoryId),
    startHere: startHere,
    beginnerSafe: beginnerSafe,
    badgeLabel: item.badgeLabel,
  );
}

List<String> _categoryKeywords(LearnHubCategoryId categoryId) {
  return switch (categoryId) {
    LearnHubCategoryId.foundations => const <String>[
      'start islam',
      'basics',
      'belief',
      'who is allah',
      'pillars',
    ],
    LearnHubCategoryId.quranHadith => const <String>[
      'quran',
      'qur an',
      'surah',
      'ayah',
      'hadith',
      'reflection',
      'recitation',
    ],
    LearnHubCategoryId.prophetsStories => const <String>[
      'stories',
      'prophets',
      'seerah',
      'history',
      'story based learning',
    ],
    LearnHubCategoryId.worshipPractice => const <String>[
      'prayer',
      'salah',
      'wudu',
      'dhikr',
      'dua',
      'worship',
    ],
    LearnHubCategoryId.characterAdab => const <String>[
      'character',
      'adab',
      'manners',
      'patience',
      'self improvement',
    ],
    LearnHubCategoryId.arabicLanguage => const <String>[
      'arabic',
      'letters',
      'reading',
      'language',
    ],
    LearnHubCategoryId.kidsLearning => const <String>[
      'kids',
      'children',
      'letters',
      'kids arabic',
      'kids stories',
      'kids dua',
    ],
    LearnHubCategoryId.quizzesChallenges => const <String>[
      'games',
      'quiz',
      'quizzes',
      'trivia',
      'challenge',
      'review',
    ],
    LearnHubCategoryId.faq => const <String>['faq', 'questions', 'answers'],
    LearnHubCategoryId.notes => const <String>['notes', 'saved'],
    LearnHubCategoryId.toolsExplore => const <String>[
      'tools',
      'explore',
      'search',
      'browse',
    ],
  };
}

List<String> _pathKeywords(String pathId) {
  return switch (pathId) {
    'foundations-starter' => const <String>[
      'start islam',
      'basics',
      'beginner islam',
      'new muslim',
      'where to start',
    ],
    'salah-starter' => const <String>[
      'how to pray',
      'prayer',
      'salah',
      'wudu',
      'learn prayer',
    ],
    'quran-beginner-starter' => const <String>[
      'start quran',
      'begin quran',
      'quran beginner',
      'read quran',
      'listen quran',
    ],
    'daily-dhikr-starter' => const <String>[
      'daily dhikr',
      'dhikr habit',
      'remembrance',
      'adhkar',
      'dua and dhikr',
    ],
    'character-starter' => const <String>[
      'character',
      'adab',
      'manners',
      'patience',
      'self improvement',
    ],
    'stories-starter' => const <String>[
      'stories',
      'prophets',
      'seerah',
      'history',
      'story path',
    ],
    'kids-starter' => const <String>[
      'kids islam',
      'kids arabic',
      'kids stories',
      'kids path',
      'children learning',
    ],
    _ => const <String>[],
  };
}

List<String> _relatedPathsForPath(String pathId) {
  return switch (pathId) {
    'foundations-starter' => const <String>[
      'salah-starter',
      'quran-beginner-starter',
      'daily-dhikr-starter',
    ],
    'salah-starter' => const <String>[
      'daily-dhikr-starter',
      'character-starter',
    ],
    'quran-beginner-starter' => const <String>[
      'foundations-starter',
      'stories-starter',
    ],
    'daily-dhikr-starter' => const <String>[
      'character-starter',
      'salah-starter',
    ],
    'character-starter' => const <String>[
      'stories-starter',
      'daily-dhikr-starter',
    ],
    'stories-starter' => const <String>[
      'character-starter',
      'quran-beginner-starter',
    ],
    'kids-starter' => const <String>['stories-starter'],
    _ => const <String>[],
  };
}

List<String> _relatedPathsForCategory(LearnHubCategoryId categoryId) {
  return switch (categoryId) {
    LearnHubCategoryId.foundations => const <String>[
      'foundations-starter',
      'salah-starter',
      'quran-beginner-starter',
    ],
    LearnHubCategoryId.quranHadith => const <String>[
      'quran-beginner-starter',
      'foundations-starter',
    ],
    LearnHubCategoryId.prophetsStories => const <String>[
      'stories-starter',
      'character-starter',
    ],
    LearnHubCategoryId.worshipPractice => const <String>[
      'salah-starter',
      'daily-dhikr-starter',
    ],
    LearnHubCategoryId.characterAdab => const <String>[
      'character-starter',
      'stories-starter',
    ],
    LearnHubCategoryId.kidsLearning => const <String>['kids-starter'],
    LearnHubCategoryId.quizzesChallenges => const <String>['stories-starter'],
    _ => const <String>[],
  };
}

// Search sees letters and digits of every script, so Arabic, Urdu and
// accented Latin queries are searched rather than erased. Folding makes the
// forms a reader may or may not type meet: accents and harakat drop
// (Schöpfung = schopfung, صَلاة = صلاة), alef and hamza seats, yeh, kaf and
// heh variants merge across Arabic, Persian and Urdu keyboards (قرآن = قران),
// and Arabic-Indic digits read as 0-9.
String _normalizeSearchText(String value) {
  return value
      .toLowerCase()
      .replaceAll(_searchIgnorableMarks, '')
      .replaceAllMapped(_searchFoldable, (match) => _searchFolding[match[0]]!)
      .replaceAll(_searchWordBreak, ' ')
      .replaceAll(_searchWhitespace, ' ')
      .trim();
}

// Entries are immutable and searched on every keystroke; normalize each
// one's text once, not once per search.
final Expando<_EntrySearchText> _entrySearchText = Expando<_EntrySearchText>();

class _EntrySearchText {
  _EntrySearchText(LearnDiscoveryIndexEntry entry)
    : title = _normalizeSearchText(entry.title),
      subtitle = _normalizeSearchText(entry.subtitle),
      summary = _normalizeSearchText(entry.summary),
      keywords = entry.searchTerms.map(_normalizeSearchText).join(' ');

  final String title;
  final String subtitle;
  final String summary;
  final String keywords;
}

/// Maps each folded query token back to the words as typed, lower-cased.
Map<String, String> _typedFormsByToken(String query) {
  final typed = query.toLowerCase().trim();
  final forms = <String, String>{_normalizeSearchText(typed): typed};
  for (final word in typed.split(_searchWhitespace)) {
    final bare = word.replaceAll(_searchEdgePunctuation, '');
    final token = _normalizeSearchText(bare);
    if (token.isNotEmpty && !token.contains(' ')) {
      forms[token] = bare;
    }
  }
  return forms;
}

// Latin combining accents, Arabic harakat and Qur'anic annotation signs,
// superscript alef, tatweel, and invisible format characters (ZWNJ, bidi
// marks) that keyboards and pasted text carry.
//
// Both patterns test a Unicode property only once a character is known to
// be non-ASCII: the property test alone is ~10x slower on English copy, and
// every entry is normalized when the index is first searched.
final RegExp _searchIgnorableMarks = RegExp(
  r'(?![\x00-\x7F])'
  r'[̀-ͯؐ-ؚـً-ٰٟۖ-ۭ\p{Cf}]',
  unicode: true,
);
// Anything but a letter, mark or digit (of any script), an apostrophe or a
// space breaks words.
final RegExp _searchWordBreak = RegExp(
  r'[\x00-\x1F\x21-\x26\x28-\x2F\x3A-\x40\x5B-\x60\x7B-\x7F]'
  r'|(?![\x00-\x7F])[^\p{L}\p{M}\p{N}]',
  unicode: true,
);
final RegExp _searchWhitespace = RegExp(r'\s+');
final RegExp _searchEdgePunctuation = RegExp(
  r'^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$',
  unicode: true,
);

final Map<String, String> _searchFolding = _buildSearchFolding();
final RegExp _searchFoldable = RegExp(
  '[${_searchFolding.keys.map(RegExp.escape).join()}]',
  unicode: true,
);

Map<String, String> _buildSearchFolding() {
  const groups = <String, String>{
    'àáâãäåāăąǎạ': 'a',
    'ɓ': 'b',
    'çćĉċč': 'c',
    'ďđɗḍḏ': 'd',
    'èéêëēĕėęěẹ': 'e',
    'ĝğġģ': 'g',
    'ĥħḥḫẖ': 'h',
    'ìíîïĩīĭįıǐị': 'i',
    'ĵ': 'j',
    'ķƙ': 'k',
    'ĺļľŀł': 'l',
    'ñńņňṇ': 'n',
    'òóôõöøōŏőǒọ': 'o',
    'ŕŗř': 'r',
    'śŝşšșṣ': 's',
    'ţťŧțṭṯ': 't',
    'ùúûüũūŭůűųǔụ': 'u',
    'ŵ': 'w',
    'ýÿŷƴ': 'y',
    'źżžẓẕ': 'z',
    'ß': 'ss',
    'æ': 'ae',
    'œ': 'oe',
    '‘’ʼ': "'",
    'ʾʿ': '',
    'أإآٱ': 'ا',
    'ء': '',
    'ؤ': 'و',
    'ئىی': 'ي',
    'ک': 'ك',
    'ةۃۂہھ': 'ه',
  };
  final folding = <String, String>{};
  groups.forEach((characters, replacement) {
    for (final rune in characters.runes) {
      folding[String.fromCharCode(rune)] = replacement;
    }
  });
  for (var digit = 0; digit <= 9; digit++) {
    folding[String.fromCharCode(0x0660 + digit)] = '$digit'; // Arabic-Indic
    folding[String.fromCharCode(0x06F0 + digit)] = '$digit'; // Persian, Urdu
  }
  return folding;
}

LearnHubRouteTarget _canonicalRouteTargetForKnowledgeItem(
  LearnHubKnowledgeItem item,
) {
  final routeName = item.routeTarget.routeName;
  if (routeName == 'quranLearningHub' ||
      routeName == 'learnHubQuranLearning' ||
      routeName == 'quran') {
    return const LearnHubRouteTarget(routeName: 'quranSummaryPage');
  }
  return item.routeTarget;
}

Set<String> _tokenize(String value) {
  if (value.isEmpty) return const <String>{};
  return value
      .split(' ')
      .map((token) => token.trim())
      .where((token) => token.isNotEmpty)
      .toSet();
}

Set<String> _expandedTokens(Set<String> queryTokens) {
  final expanded = <String>{...queryTokens};
  for (final token in queryTokens) {
    expanded.addAll(_synonymMap[token] ?? const <String>{});
  }
  return expanded;
}

const Set<String> _beginnerIntentTokens = <String>{
  'start',
  'begin',
  'beginner',
  'basics',
  'help',
  'how',
  'learn',
  'first',
};

const Set<String> _kidsIntentTokens = <String>{
  'kids',
  'kid',
  'child',
  'children',
  'family',
  'letters',
};

const Map<String, Set<String>> _synonymMap = <String, Set<String>>{
  'prayer': <String>{'salah', 'wudu', 'pray'},
  'pray': <String>{'salah', 'prayer', 'wudu'},
  'salah': <String>{'prayer', 'pray', 'wudu'},
  'dua': <String>{'dhikr', 'supplication', 'adhkar'},
  'dhikr': <String>{'dua', 'adhkar', 'remembrance'},
  'quran': <String>{'surah', 'ayah', 'recitation', 'reflection'},
  'surah': <String>{'quran', 'ayah'},
  'stories': <String>{'prophets', 'seerah', 'history'},
  'story': <String>{'stories', 'prophets', 'seerah'},
  'manners': <String>{'character', 'adab', 'patience'},
  'patience': <String>{'character', 'adab', 'manners'},
  'game': <String>{'games', 'quiz', 'trivia'},
  'quiz': <String>{'quizzes', 'games', 'trivia'},
  'letters': <String>{'arabic', 'tracing', 'kids'},
};
