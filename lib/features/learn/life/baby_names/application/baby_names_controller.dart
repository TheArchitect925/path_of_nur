import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/persistence/local_store.dart';
import '../data/baby_names_repository.dart';
import '../domain/baby_name_models.dart';

class BabyNamesState {
  const BabyNamesState({
    required this.searchQuery,
    required this.filters,
    required this.sort,
    required this.favorites,
    required this.recentSearches,
    required this.recentlyViewed,
    required this.finderInput,
  });

  final String searchQuery;
  final BabyNameFilters filters;
  final BabyNameSort sort;
  final Set<String> favorites;
  final List<String> recentSearches;
  final List<String> recentlyViewed;
  final BabyNameFinderInput finderInput;

  BabyNamesState copyWith({
    String? searchQuery,
    BabyNameFilters? filters,
    BabyNameSort? sort,
    Set<String>? favorites,
    List<String>? recentSearches,
    List<String>? recentlyViewed,
    BabyNameFinderInput? finderInput,
  }) {
    return BabyNamesState(
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
      favorites: favorites ?? this.favorites,
      recentSearches: recentSearches ?? this.recentSearches,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
      finderInput: finderInput ?? this.finderInput,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery,
      'sort': sort.name,
      'favorites': favorites.toList(),
      'recentSearches': recentSearches,
      'recentlyViewed': recentlyViewed,
      'filters': {
        'gender': filters.gender?.name,
        'category': filters.category?.name,
        'quranicOnly': filters.quranicOnly,
        'prophetAssociationOnly': filters.prophetAssociationOnly,
        'companionAssociationOnly': filters.companionAssociationOnly,
        'origin': filters.origin,
        'meaningTheme': filters.meaningTheme,
        'startingLetter': filters.startingLetter,
        'favoritesOnly': filters.favoritesOnly,
        'featuredOnly': filters.featuredOnly,
      },
      'finderInput': {
        'fatherName': finderInput.fatherName,
        'motherName': finderInput.motherName,
        'preferredGender': finderInput.preferredGender?.name,
        'meaningThemes': finderInput.meaningThemes.toList(),
        'quranicOnly': finderInput.quranicOnly,
        'originPreference': finderInput.originPreference,
      },
    };
  }

  static BabyNamesState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initialBabyNamesState;

    BabyNameSort parseSort(String? raw) {
      for (final item in BabyNameSort.values) {
        if (item.name == raw) return item;
      }
      return BabyNameSort.alphabeticalAz;
    }

    BabyNameGender? parseGender(String? raw) {
      for (final item in BabyNameGender.values) {
        if (item.name == raw) return item;
      }
      return null;
    }

    BabyNameCategory? parseCategory(String? raw) {
      for (final item in BabyNameCategory.values) {
        if (item.name == raw) return item;
      }
      return null;
    }

    final filterRaw = json['filters'];
    final finderRaw = json['finderInput'];

    final favorites = <String>{
      if (json['favorites'] is List)
        ...(json['favorites'] as List).map((e) => e.toString()),
    };

    final recentSearches = <String>[
      if (json['recentSearches'] is List)
        ...(json['recentSearches'] as List)
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty),
    ].take(10).toList();

    final recentlyViewed = <String>[
      if (json['recentlyViewed'] is List)
        ...(json['recentlyViewed'] as List)
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty),
    ].take(20).toList();

    return BabyNamesState(
      searchQuery: json['searchQuery']?.toString() ?? '',
      sort: parseSort(json['sort']?.toString()),
      favorites: favorites,
      recentSearches: recentSearches,
      recentlyViewed: recentlyViewed,
      filters: BabyNameFilters(
        gender: filterRaw is Map
            ? parseGender(filterRaw['gender']?.toString())
            : null,
        category: filterRaw is Map
            ? parseCategory(filterRaw['category']?.toString())
            : null,
        quranicOnly: filterRaw is Map && filterRaw['quranicOnly'] == true,
        prophetAssociationOnly:
            filterRaw is Map && filterRaw['prophetAssociationOnly'] == true,
        companionAssociationOnly:
            filterRaw is Map && filterRaw['companionAssociationOnly'] == true,
        origin: filterRaw is Map ? filterRaw['origin']?.toString() : null,
        meaningTheme: filterRaw is Map
            ? filterRaw['meaningTheme']?.toString()
            : null,
        startingLetter: filterRaw is Map
            ? filterRaw['startingLetter']?.toString()
            : null,
        favoritesOnly: filterRaw is Map && filterRaw['favoritesOnly'] == true,
        featuredOnly: filterRaw is Map && filterRaw['featuredOnly'] == true,
      ),
      finderInput: BabyNameFinderInput(
        fatherName: finderRaw is Map
            ? finderRaw['fatherName']?.toString() ?? ''
            : '',
        motherName: finderRaw is Map
            ? finderRaw['motherName']?.toString() ?? ''
            : '',
        preferredGender: finderRaw is Map
            ? parseGender(finderRaw['preferredGender']?.toString())
            : null,
        meaningThemes: {
          if (finderRaw is Map && finderRaw['meaningThemes'] is List)
            ...(finderRaw['meaningThemes'] as List)
                .map((e) => e.toString())
                .where((e) => e.isNotEmpty),
        },
        quranicOnly: finderRaw is Map && finderRaw['quranicOnly'] == true,
        originPreference: finderRaw is Map
            ? finderRaw['originPreference']?.toString()
            : null,
      ),
    );
  }
}

const initialBabyNamesState = BabyNamesState(
  searchQuery: '',
  filters: BabyNameFilters(),
  sort: BabyNameSort.alphabeticalAz,
  favorites: <String>{},
  recentSearches: <String>[],
  recentlyViewed: <String>[],
  finderInput: BabyNameFinderInput(
    fatherName: '',
    motherName: '',
    preferredGender: null,
    meaningThemes: <String>{},
    quranicOnly: false,
    originPreference: null,
  ),
);

class BabyNamesController extends StateNotifier<BabyNamesState> {
  BabyNamesController(this._store)
    : super(BabyNamesState.fromJson(_store.getJsonMap(_key)));

  final LocalStore _store;
  static const _key = 'learn.life.baby_names.state.v2';

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
    _save();
  }

  void submitSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    final recent = [
      query,
      ...state.recentSearches.where((q) => q != query),
    ].take(10).toList();
    state = state.copyWith(searchQuery: query, recentSearches: recent);
    _save();
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    _save();
  }

  void setSort(BabyNameSort sort) {
    state = state.copyWith(sort: sort);
    _save();
  }

  void setFilters(BabyNameFilters filters) {
    state = state.copyWith(filters: filters);
    _save();
  }

  void clearFilters() {
    state = state.copyWith(filters: const BabyNameFilters());
    _save();
  }

  void toggleFavorite(String id) {
    final updated = Set<String>.from(state.favorites);
    if (!updated.remove(id)) {
      updated.add(id);
    }
    state = state.copyWith(favorites: updated);
    _save();
  }

  void markViewed(String id) {
    final updated = [
      id,
      ...state.recentlyViewed.where((item) => item != id),
    ].take(20).toList();
    state = state.copyWith(recentlyViewed: updated);
    _save();
  }

  void clearRecents() {
    state = state.copyWith(
      recentSearches: const <String>[],
      recentlyViewed: const <String>[],
    );
    _save();
  }

  void updateFinderInput(BabyNameFinderInput input) {
    state = state.copyWith(finderInput: input);
    _save();
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }
}

final babyNamesControllerProvider =
    StateNotifierProvider<BabyNamesController, BabyNamesState>((ref) {
      return BabyNamesController(ref.watch(localStoreProvider));
    });

final babyNamesFilterOptionsProvider = Provider<BabyNamesFilterOptions>((ref) {
  final index = ref.watch(babyNamesIndexProvider).value;
  if (index == null) {
    return const BabyNamesFilterOptions(
      origins: <String>[],
      meaningThemes: <String>[],
      startingLetters: <String>[],
    );
  }
  return BabyNamesFilterOptions(
    origins: index.byOrigin.keys.toList()..sort(),
    meaningThemes: index.byMeaningTheme.keys.toList()..sort(),
    startingLetters: index.byStartingLetter.keys.toList()..sort(),
  );
});

class BabyNamesFilterOptions {
  const BabyNamesFilterOptions({
    required this.origins,
    required this.meaningThemes,
    required this.startingLetters,
  });

  final List<String> origins;
  final List<String> meaningThemes;
  final List<String> startingLetters;
}

final babyNamesFilteredProvider = Provider<List<BabyNameEntry>>((ref) {
  final index = ref.watch(babyNamesIndexProvider).value;
  if (index == null) return const <BabyNameEntry>[];
  final state = ref.watch(babyNamesControllerProvider);
  final query = state.searchQuery.trim().toLowerCase();
  final f = state.filters;

  final candidateIds = <String>{...index.byId.keys};

  void intersect(Set<String> ids) {
    candidateIds.retainAll(ids);
  }

  if (f.gender != null) {
    intersect(index.byGender[f.gender!] ?? const <String>{});
  }
  if (f.quranicOnly) {
    intersect(index.quranicIds);
  }
  if (f.prophetAssociationOnly) {
    intersect(index.prophetIds);
  }
  if (f.companionAssociationOnly) {
    intersect(index.companionIds);
  }
  if (f.origin != null) {
    intersect(index.byOrigin[f.origin!] ?? const <String>{});
  }
  if (f.meaningTheme != null) {
    intersect(index.byMeaningTheme[f.meaningTheme!] ?? const <String>{});
  }
  if (f.startingLetter != null) {
    intersect(index.byStartingLetter[f.startingLetter!] ?? const <String>{});
  }
  if (f.favoritesOnly) {
    intersect(state.favorites);
  }
  if (f.featuredOnly) {
    intersect({...index.popularIds, ...index.quranicIds});
  }

  if (f.category != null) {
    switch (f.category!) {
      case BabyNameCategory.quranic:
        intersect(index.quranicIds);
        break;
      case BabyNameCategory.prophet:
        intersect(index.prophetIds);
        break;
      case BabyNameCategory.companions:
        intersect(index.companionIds);
        break;
      case BabyNameCategory.popular:
        intersect(index.popularIds);
        break;
      case BabyNameCategory.classic:
        intersect(index.byCategory['classic'] ?? const <String>{});
        break;
      case BabyNameCategory.modern:
        intersect(index.byCategory['modern'] ?? const <String>{});
        break;
    }
  }

  if (query.isNotEmpty) {
    candidateIds.retainWhere(
      (id) => (index.searchableById[id] ?? '').contains(query),
    );
  }

  final filtered = candidateIds
      .map((id) => index.byId[id])
      .whereType<BabyNameEntry>()
      .toList();

  final repository = ref.watch(babyNamesRepositoryProvider);
  int compareAlpha(BabyNameEntry a, BabyNameEntry b) =>
      a.name.compareTo(b.name);

  filtered.sort((a, b) {
    if (query.isNotEmpty) {
      final scoreA = repository.searchScore(a, query);
      final scoreB = repository.searchScore(b, query);
      final byScore = scoreB.compareTo(scoreA);
      if (byScore != 0) return byScore;
    }

    switch (state.sort) {
      case BabyNameSort.alphabeticalAz:
        return compareAlpha(a, b);
      case BabyNameSort.alphabeticalZa:
        return compareAlpha(b, a);
      case BabyNameSort.mostPopular:
        final p = b.popularityScore.compareTo(a.popularityScore);
        return p == 0 ? compareAlpha(a, b) : p;
      case BabyNameSort.classicFirst:
        final aClassic =
            a.associatedCategories.contains('classic') || a.isQuranic;
        final bClassic =
            b.associatedCategories.contains('classic') || b.isQuranic;
        if (aClassic != bClassic) return aClassic ? -1 : 1;
        return compareAlpha(a, b);
      case BabyNameSort.modernFirst:
        final aModern = a.associatedCategories.contains('modern');
        final bModern = b.associatedCategories.contains('modern');
        if (aModern != bModern) return aModern ? -1 : 1;
        return compareAlpha(a, b);
      case BabyNameSort.shortestFirst:
        final len = a.name.length.compareTo(b.name.length);
        return len == 0 ? compareAlpha(a, b) : len;
    }
  });

  return filtered;
});

final babyNamesFavoritesProvider = Provider<List<BabyNameEntry>>((ref) {
  final index = ref.watch(babyNamesIndexProvider).value;
  if (index == null) return const <BabyNameEntry>[];
  final favorites = ref.watch(babyNamesControllerProvider).favorites;
  return favorites
      .map((id) => index.byId[id])
      .whereType<BabyNameEntry>()
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});

final babyNamesRecentlyViewedProvider = Provider<List<BabyNameEntry>>((ref) {
  final index = ref.watch(babyNamesIndexProvider).value;
  if (index == null) return const <BabyNameEntry>[];
  final ids = ref.watch(babyNamesControllerProvider).recentlyViewed;
  return ids.map((id) => index.byId[id]).whereType<BabyNameEntry>().toList();
});

final babyNamesNameOfDayProvider = Provider<BabyNameEntry?>((ref) {
  final namesIndex = ref.watch(babyNamesIndexProvider).value;
  if (namesIndex == null) return null;
  final all = namesIndex.all;
  if (all.isEmpty) return null;
  final now = DateTime.now().toUtc();
  final dayIndex = (now.year * 1000 + now.month * 50 + now.day) % all.length;
  return all[dayIndex];
});

final babyNamesFinderSuggestionsProvider = Provider<List<BabyNameSuggestion>>((
  ref,
) {
  final index = ref.watch(babyNamesIndexProvider).value;
  if (index == null) return const <BabyNameSuggestion>[];
  final all = index.all;
  final state = ref.watch(babyNamesControllerProvider);
  final input = state.finderInput;

  Set<String> inferParentThemes() {
    final joined = '${input.fatherName} ${input.motherName}'.toLowerCase();
    final map = {
      'light': [
        'noor',
        'nur',
        'ziya',
        'diya',
        'light',
        'shahab',
        'najm',
        'star',
      ],
      'mercy': ['rahm', 'mercy'],
      'patience': ['sabr', 'patience'],
      'wisdom': ['hikm', 'wisdom', 'ilm'],
      'faith': ['iman', 'faith'],
      'guidance': ['huda', 'guide'],
      'joy': ['farah', 'joy', 'saad'],
      'peace': ['salam', 'aman', 'peace'],
      'blessing': ['barak', 'bless', 'sadia', 'saad'],
      'protection': ['hafiz', 'protect', 'guard'],
    };

    final themes = <String>{};
    for (final entry in map.entries) {
      if (entry.value.any(joined.contains)) themes.add(entry.key);
    }
    return themes;
  }

  final parentThemes = inferParentThemes();
  final selectedThemes = {...input.meaningThemes, ...parentThemes};
  final father = index.byNameLower[input.fatherName.toLowerCase()];
  final mother = index.byNameLower[input.motherName.toLowerCase()];
  if (father != null) selectedThemes.addAll(father.meaningThemes);
  if (mother != null) selectedThemes.addAll(mother.meaningThemes);
  final preferredSyllables = <int>{
    if (father?.syllables != null) father!.syllables!,
    if (mother?.syllables != null) mother!.syllables!,
  };
  final parentOrigins = <String>{...?father?.origin, ...?mother?.origin};

  final suggestions = <BabyNameSuggestion>[];
  for (final item in all) {
    if (input.preferredGender != null && item.gender != input.preferredGender) {
      continue;
    }
    if (input.quranicOnly && !item.isQuranic) continue;

    var score = 0.0;
    final why = <String>[];

    if (input.preferredGender != null) {
      score += 3;
      why.add('Matches preferred gender');
    }

    final overlap = item.meaningThemes.where(selectedThemes.contains).length;
    if (overlap > 0) {
      score += overlap * 2.2;
      why.add('Matches selected meaning themes');
    }

    if (input.quranicOnly && item.isQuranic) {
      score += 2.0;
      why.add('Quranic name');
    } else if (item.isQuranic) {
      score += 0.9;
      why.add('Traditionally linked to Qur’anic usage');
    }

    if (input.originPreference != null &&
        item.origin.contains(input.originPreference)) {
      score += 1.8;
      why.add('Origin preference match');
    } else if (parentOrigins.isNotEmpty &&
        item.origin.any(parentOrigins.contains)) {
      score += 1.2;
      why.add('Matches parent origin style');
    }

    if (item.isProphetAssociated) {
      score += 1.5;
      why.add('Prophetic association');
    }

    if (item.isCompanionAssociated) {
      score += 1.0;
      why.add('Companion association');
    }

    if (preferredSyllables.isNotEmpty &&
        item.syllables != null &&
        preferredSyllables.contains(item.syllables)) {
      score += 0.8;
      why.add('Similar name rhythm');
    }

    if (selectedThemes.contains('light') &&
        (item.meaningThemes.contains('light') ||
            item.meaning.toLowerCase().contains('star'))) {
      score += 1.1;
      why.add('Matches celestial theme');
    }
    if (selectedThemes.contains('blessing') &&
        (item.meaningThemes.contains('blessing') ||
            item.meaningThemes.contains('joy'))) {
      score += 0.9;
      why.add('Matches blessing theme');
    }

    score += item.popularityScore * 0.5;

    if (score > 0) {
      suggestions.add(
        BabyNameSuggestion(
          entry: item,
          score: score,
          explanations: why.take(3).toList(),
        ),
      );
    }
  }

  suggestions.sort((a, b) => b.score.compareTo(a.score));
  return suggestions.take(20).toList();
});

final babyNamesFeaturedProphetsProvider = Provider<List<BabyNameEntry>>((ref) {
  final index = ref.watch(babyNamesIndexProvider).value;
  if (index == null) return const <BabyNameEntry>[];
  return index.prophetIds
      .map((id) => index.byId[id])
      .whereType<BabyNameEntry>()
      .take(12)
      .toList();
});
