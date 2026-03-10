import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/persistence/local_store.dart';
import '../data/baby_names_seed.dart';
import '../domain/baby_name_models.dart';

class BabyNamesState {
  const BabyNamesState({
    required this.searchQuery,
    required this.filters,
    required this.sort,
    required this.favorites,
    required this.shortlist,
    required this.notesById,
    required this.compareIds,
    required this.finderInput,
  });

  final String searchQuery;
  final BabyNameFilters filters;
  final BabyNameSort sort;
  final Set<String> favorites;
  final Set<String> shortlist;
  final Map<String, String> notesById;
  final List<String> compareIds;
  final BabyNameFinderInput finderInput;

  BabyNamesState copyWith({
    String? searchQuery,
    BabyNameFilters? filters,
    BabyNameSort? sort,
    Set<String>? favorites,
    Set<String>? shortlist,
    Map<String, String>? notesById,
    List<String>? compareIds,
    BabyNameFinderInput? finderInput,
  }) {
    return BabyNamesState(
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
      favorites: favorites ?? this.favorites,
      shortlist: shortlist ?? this.shortlist,
      notesById: notesById ?? this.notesById,
      compareIds: compareIds ?? this.compareIds,
      finderInput: finderInput ?? this.finderInput,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery,
      'sort': sort.name,
      'favorites': favorites.toList(),
      'shortlist': shortlist.toList(),
      'notesById': notesById,
      'compareIds': compareIds,
      'filters': {
        'gender': filters.gender?.name,
        'region': filters.region,
        'origin': filters.origin,
        'onlyQuranic': filters.onlyQuranic,
        'onlyCompanion': filters.onlyCompanion,
        'rarity': filters.rarity?.name,
        'meaningTags': filters.meaningTags.toList(),
      },
      'finder': {
        'fatherName': finderInput.fatherName,
        'motherName': finderInput.motherName,
        'gender': finderInput.gender?.name,
        'meaningTags': finderInput.meaningTags.toList(),
        'regionPreference': finderInput.regionPreference,
        'firstLetter': finderInput.firstLetter,
        'classicVsRare': finderInput.classicVsRare,
        'easyInEnglish': finderInput.easyInEnglish,
      },
    };
  }

  static BabyNamesState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initialBabyNamesState;

    BabyNameSort sort = BabyNameSort.alphabetical;
    final sortRaw = json['sort']?.toString();
    for (final value in BabyNameSort.values) {
      if (value.name == sortRaw) {
        sort = value;
        break;
      }
    }

    BabyNameGender? gender;
    final filterRaw = json['filters'];
    if (filterRaw is Map) {
      final genderRaw = filterRaw['gender']?.toString();
      for (final item in BabyNameGender.values) {
        if (item.name == genderRaw) {
          gender = item;
          break;
        }
      }
    }

    BabyNameRarity? rarity;
    if (filterRaw is Map) {
      final rarityRaw = filterRaw['rarity']?.toString();
      for (final item in BabyNameRarity.values) {
        if (item.name == rarityRaw) {
          rarity = item;
          break;
        }
      }
    }

    final favorites = <String>{};
    final shortlist = <String>{};
    final compareIds = <String>[];
    final notesById = <String, String>{};

    final favRaw = json['favorites'];
    if (favRaw is List) {
      for (final item in favRaw) {
        final value = item.toString();
        if (value.isNotEmpty) favorites.add(value);
      }
    }

    final shortlistRaw = json['shortlist'];
    if (shortlistRaw is List) {
      for (final item in shortlistRaw) {
        final value = item.toString();
        if (value.isNotEmpty) shortlist.add(value);
      }
    }

    final compareRaw = json['compareIds'];
    if (compareRaw is List) {
      for (final item in compareRaw) {
        final value = item.toString();
        if (value.isNotEmpty) compareIds.add(value);
      }
    }

    final notesRaw = json['notesById'];
    if (notesRaw is Map) {
      for (final entry in notesRaw.entries) {
        final key = entry.key.toString();
        final value = entry.value?.toString() ?? '';
        if (key.isNotEmpty && value.isNotEmpty) {
          notesById[key] = value;
        }
      }
    }

    final finderRaw = json['finder'];
    BabyNameGender? finderGender;
    if (finderRaw is Map) {
      final finderGenderRaw = finderRaw['gender']?.toString();
      for (final item in BabyNameGender.values) {
        if (item.name == finderGenderRaw) {
          finderGender = item;
          break;
        }
      }
    }

    return BabyNamesState(
      searchQuery: json['searchQuery']?.toString() ?? '',
      sort: sort,
      favorites: favorites,
      shortlist: shortlist,
      notesById: notesById,
      compareIds: compareIds.take(4).toList(),
      filters: BabyNameFilters(
        gender: gender,
        region: filterRaw is Map ? filterRaw['region']?.toString() : null,
        origin: filterRaw is Map ? filterRaw['origin']?.toString() : null,
        onlyQuranic: filterRaw is Map && filterRaw['onlyQuranic'] == true,
        onlyCompanion: filterRaw is Map && filterRaw['onlyCompanion'] == true,
        rarity: rarity,
        meaningTags: filterRaw is Map && filterRaw['meaningTags'] is List
            ? (filterRaw['meaningTags'] as List).map((e) => e.toString()).toSet()
            : const <String>{},
      ),
      finderInput: BabyNameFinderInput(
        fatherName: finderRaw is Map ? finderRaw['fatherName']?.toString() ?? '' : '',
        motherName: finderRaw is Map ? finderRaw['motherName']?.toString() ?? '' : '',
        gender: finderGender,
        meaningTags: finderRaw is Map && finderRaw['meaningTags'] is List
            ? (finderRaw['meaningTags'] as List).map((e) => e.toString()).toSet()
            : const <String>{},
        regionPreference:
            finderRaw is Map ? finderRaw['regionPreference']?.toString() : null,
        firstLetter: finderRaw is Map ? finderRaw['firstLetter']?.toString() : null,
        classicVsRare: finderRaw is Map
            ? finderRaw['classicVsRare']?.toString() ?? 'balanced'
            : 'balanced',
        easyInEnglish: finderRaw is Map && finderRaw['easyInEnglish'] == true,
      ),
    );
  }
}

const initialBabyNamesState = BabyNamesState(
  searchQuery: '',
  filters: BabyNameFilters(),
  sort: BabyNameSort.alphabetical,
  favorites: {},
  shortlist: {},
  notesById: {},
  compareIds: [],
  finderInput: BabyNameFinderInput(
    fatherName: '',
    motherName: '',
    gender: null,
    meaningTags: <String>{},
    regionPreference: null,
    firstLetter: null,
    classicVsRare: 'balanced',
    easyInEnglish: false,
  ),
);

class BabyNamesController extends StateNotifier<BabyNamesState> {
  BabyNamesController(this._store)
      : super(BabyNamesState.fromJson(_store.getJsonMap(_key)));

  static const _key = 'learn.life.baby_names.state.v1';
  final LocalStore _store;

  List<BabyNameRecord> get all => babyNameSeed;

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value.trimLeft());
    _save();
  }

  void setSort(BabyNameSort sort) {
    state = state.copyWith(sort: sort);
    _save();
  }

  void setGender(BabyNameGender? value) {
    state = state.copyWith(filters: state.filters.copyWith(gender: value));
    _save();
  }

  void setRegion(String? value) {
    state = state.copyWith(filters: state.filters.copyWith(region: value));
    _save();
  }

  void setOrigin(String? value) {
    state = state.copyWith(filters: state.filters.copyWith(origin: value));
    _save();
  }

  void setRarity(BabyNameRarity? value) {
    state = state.copyWith(filters: state.filters.copyWith(rarity: value));
    _save();
  }

  void toggleOnlyQuranic(bool value) {
    state = state.copyWith(filters: state.filters.copyWith(onlyQuranic: value));
    _save();
  }

  void toggleOnlyCompanion(bool value) {
    state = state.copyWith(filters: state.filters.copyWith(onlyCompanion: value));
    _save();
  }

  void toggleMeaningTag(String tag) {
    final tags = Set<String>.from(state.filters.meaningTags);
    if (!tags.remove(tag)) tags.add(tag);
    state = state.copyWith(filters: state.filters.copyWith(meaningTags: tags));
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

  void toggleShortlist(String id) {
    final updated = Set<String>.from(state.shortlist);
    if (!updated.remove(id)) {
      updated.add(id);
    }
    state = state.copyWith(shortlist: updated);
    _save();
  }

  void setNote(String id, String note) {
    final updated = Map<String, String>.from(state.notesById);
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      updated.remove(id);
    } else {
      updated[id] = trimmed;
    }
    state = state.copyWith(notesById: updated);
    _save();
  }

  void toggleCompare(String id) {
    final updated = List<String>.from(state.compareIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else if (updated.length < 4) {
      updated.add(id);
    }
    state = state.copyWith(compareIds: updated);
    _save();
  }

  void clearCompare() {
    state = state.copyWith(compareIds: []);
    _save();
  }

  void setFinderInput(BabyNameFinderInput input) {
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

final babyNamesAllProvider = Provider<List<BabyNameRecord>>((ref) {
  return ref.watch(babyNamesControllerProvider.notifier).all;
});

final babyNamesByIdProvider = Provider<Map<String, BabyNameRecord>>((ref) {
  final all = ref.watch(babyNamesAllProvider);
  return {for (final item in all) item.id: item};
});

final babyNamesFilterOptionsProvider = Provider<BabyNamesFilterOptions>((ref) {
  final all = ref.watch(babyNamesAllProvider);
  final regions = <String>{};
  final origins = <String>{};
  final meaningTags = <String>{};
  for (final item in all) {
    regions.addAll(item.regions);
    origins.add(item.origin);
    meaningTags.addAll(item.meaningTags);
  }
  return BabyNamesFilterOptions(
    regions: regions.toList()..sort(),
    origins: origins.toList()..sort(),
    meaningTags: meaningTags.toList()..sort(),
  );
});

class BabyNamesFilterOptions {
  const BabyNamesFilterOptions({
    required this.regions,
    required this.origins,
    required this.meaningTags,
  });

  final List<String> regions;
  final List<String> origins;
  final List<String> meaningTags;
}

final babyNamesCollectionsProvider = Provider<List<BabyNameCollection>>((ref) {
  return babyNameCollections;
});

final babyNamesFilteredProvider = Provider<List<BabyNameRecord>>((ref) {
  final all = ref.watch(babyNamesAllProvider);
  final state = ref.watch(babyNamesControllerProvider);
  final loweredQuery = state.searchQuery.trim().toLowerCase();
  final filtered = all.where((item) {
    final f = state.filters;
    if (f.gender != null && item.gender != f.gender) return false;
    if (f.region != null && !item.regions.contains(f.region)) return false;
    if (f.origin != null && item.origin != f.origin) return false;
    if (f.onlyQuranic && !item.isQuranic) return false;
    if (f.onlyCompanion && !item.isCompanionName) return false;
    if (f.rarity != null && item.rarity != f.rarity) return false;
    if (f.meaningTags.isNotEmpty && !item.meaningTags.any(f.meaningTags.contains)) {
      return false;
    }
    if (loweredQuery.isEmpty) return true;
    final hay = [
      item.english,
      item.arabic,
      item.transliteration,
      item.meaning,
      item.extendedMeaning,
      item.origin,
      ...item.meaningTags,
      ...item.styleTags,
      ...item.historicalTags,
    ].join(' ').toLowerCase();
    return hay.contains(loweredQuery);
  }).toList();

  filtered.sort((a, b) {
    switch (state.sort) {
      case BabyNameSort.alphabetical:
        return a.english.compareTo(b.english);
      case BabyNameSort.popularity:
        return b.popularityScore.compareTo(a.popularityScore);
      case BabyNameSort.quranicPriority:
        if (a.isQuranic != b.isQuranic) return a.isQuranic ? -1 : 1;
        return a.english.compareTo(b.english);
      case BabyNameSort.shortest:
        final len = a.english.length.compareTo(b.english.length);
        return len != 0 ? len : a.english.compareTo(b.english);
      case BabyNameSort.mostSaved:
        final savesA = (state.favorites.contains(a.id) ? 2 : 0) +
            (state.shortlist.contains(a.id) ? 1 : 0);
        final savesB = (state.favorites.contains(b.id) ? 2 : 0) +
            (state.shortlist.contains(b.id) ? 1 : 0);
        final bySave = savesB.compareTo(savesA);
        return bySave != 0 ? bySave : a.english.compareTo(b.english);
    }
  });

  return filtered;
});

final babyNamesFavoritesProvider = Provider<List<BabyNameRecord>>((ref) {
  final byId = ref.watch(babyNamesByIdProvider);
  final state = ref.watch(babyNamesControllerProvider);
  return state.favorites.map((id) => byId[id]).whereType<BabyNameRecord>().toList()
    ..sort((a, b) => a.english.compareTo(b.english));
});

final babyNamesShortlistProvider = Provider<List<BabyNameRecord>>((ref) {
  final byId = ref.watch(babyNamesByIdProvider);
  final state = ref.watch(babyNamesControllerProvider);
  return state.shortlist.map((id) => byId[id]).whereType<BabyNameRecord>().toList()
    ..sort((a, b) => a.english.compareTo(b.english));
});

final babyNamesCompareProvider = Provider<List<BabyNameRecord>>((ref) {
  final byId = ref.watch(babyNamesByIdProvider);
  final state = ref.watch(babyNamesControllerProvider);
  return state.compareIds.map((id) => byId[id]).whereType<BabyNameRecord>().toList();
});

final babyNamesNameOfDayProvider = Provider<BabyNameRecord>((ref) {
  final all = ref.watch(babyNamesAllProvider);
  final now = DateTime.now().toUtc();
  final index = (now.year * 1000 + now.month * 50 + now.day) % all.length;
  return all[index];
});

final babyNamesFinderSuggestionsProvider = Provider<List<BabyNameSuggestion>>((ref) {
  final state = ref.watch(babyNamesControllerProvider);
  final all = ref.watch(babyNamesAllProvider);
  final input = state.finderInput;
  final themeWords = _extractThemeWords(input.fatherName, input.motherName);
  final suggestions = <BabyNameSuggestion>[];

  for (final item in all) {
    var score = item.popularityScore / 20.0;
    final reasons = <String>[];

    if (input.gender != null && item.gender == input.gender) {
      score += 3.0;
      reasons.add('Matches selected gender');
    }
    if (input.regionPreference != null && item.regions.contains(input.regionPreference)) {
      score += 2.0;
      reasons.add('Common in ${input.regionPreference}');
    }
    if (input.firstLetter != null &&
        input.firstLetter!.isNotEmpty &&
        item.english.toLowerCase().startsWith(input.firstLetter!.toLowerCase())) {
      score += 1.5;
      reasons.add('Matches preferred first letter');
    }
    if (input.easyInEnglish && item.easyInEnglish) {
      score += 1.4;
      reasons.add('Easy pronunciation in English');
    }
    if (input.classicVsRare == 'classic' &&
        (item.rarity == BabyNameRarity.classic || item.rarity == BabyNameRarity.common)) {
      score += 1.8;
      reasons.add('Classic style');
    } else if (input.classicVsRare == 'rare' &&
        (item.rarity == BabyNameRarity.uncommon || item.rarity == BabyNameRarity.rare)) {
      score += 1.8;
      reasons.add('Leans toward rare style');
    }
    if (item.isQuranic) {
      score += 1.2;
      reasons.add('Qur’anic association');
    }
    if (input.meaningTags.isNotEmpty) {
      final overlap = item.meaningTags.where(input.meaningTags.contains).length;
      if (overlap > 0) {
        score += overlap * 1.4;
        reasons.add('Aligned with selected meaning themes');
      }
    }

    if (themeWords.contains('light') &&
        (item.meaningTags.contains('light') || item.id == 'noor')) {
      score += 1.3;
      reasons.add('Shares light meaning');
    }
    if (themeWords.contains('guidance') && item.meaningTags.contains('guidance')) {
      score += 1.3;
      reasons.add('Related to guidance');
    }
    if (themeWords.contains('blessing') &&
        (item.meaningTags.contains('blessing') || item.meaningTags.contains('abundance'))) {
      score += 1.2;
      reasons.add('Related to blessing and happiness');
    }
    if (themeWords.contains('trust') && item.meaningTags.contains('trust')) {
      score += 1.1;
      reasons.add('Echoes trust and reliability themes');
    }

    if (reasons.isNotEmpty) {
      suggestions.add(
        BabyNameSuggestion(
          record: item,
          score: score,
          reasons: reasons.take(3).toList(),
        ),
      );
    }
  }

  suggestions.sort((a, b) => b.score.compareTo(a.score));
  return suggestions.take(14).toList();
});

Set<String> _extractThemeWords(String father, String mother) {
  final text = '${father.toLowerCase()} ${mother.toLowerCase()}';
  final words = <String>{};
  if (text.contains('noor') || text.contains('nur') || text.contains('light')) {
    words.add('light');
  }
  if (text.contains('huda') || text.contains('guide') || text.contains('guidance')) {
    words.add('guidance');
  }
  if (text.contains('barak') || text.contains('bless')) {
    words.add('blessing');
  }
  if (text.contains('amin') || text.contains('aman')) {
    words.add('trust');
  }
  return words;
}
