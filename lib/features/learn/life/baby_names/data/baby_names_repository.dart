import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/baby_name_models.dart';

class BabyNamesRepository {
  static const _seedAssetPath = 'assets/data/baby_names_seed.json';
  static const _fallbackAssetPath = 'assets/data/baby_names.json';

  List<BabyNameEntry>? _cached;
  BabyNamesIndex? _indexCached;
  BabyNamesValidationReport? _validationReport;

  Future<List<BabyNameEntry>> loadAll() async {
    if (_cached != null) return _cached!;
    String raw;
    try {
      raw = await rootBundle.loadString(_seedAssetPath);
    } catch (_) {
      raw = await rootBundle.loadString(_fallbackAssetPath);
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      _cached = const <BabyNameEntry>[];
      _validationReport = const BabyNamesValidationReport(
        totalRawEntries: 0,
        validEntries: 0,
        maleCount: 0,
        femaleCount: 0,
        unisexCount: 0,
        quranicCount: 0,
        popularCount: 0,
        entriesMissingOptionalMetadata: 0,
        invalidRequiredEntries: 0,
        duplicateIds: <String>[],
        probableDuplicateNames: <String>[],
      );
      return _cached!;
    }

    _cached = _loadNormalizedEntries(decoded.whereType<Map>().toList());
    _indexCached = BabyNamesIndex.fromEntries(_cached!);

    if (kDebugMode && _validationReport != null) {
      debugPrint(_validationReport!.toDebugSummary());
    }

    return _cached!;
  }

  Future<Map<String, BabyNameEntry>> loadById() async {
    final all = await loadAll();
    return {for (final item in all) item.id: item};
  }

  Future<BabyNamesIndex> loadIndex() async {
    if (_indexCached != null) return _indexCached!;
    final all = await loadAll();
    _indexCached = BabyNamesIndex.fromEntries(all);
    return _indexCached!;
  }

  Future<BabyNamesValidationReport> loadValidationReport() async {
    await loadAll();
    return _validationReport ?? const BabyNamesValidationReport.empty();
  }

  List<BabyNameEntry> _loadNormalizedEntries(List<Map> rawMaps) {
    final entries = <BabyNameEntry>[];
    final duplicateIds = <String>{};
    final probableDuplicateNames = <String>{};
    final seenIds = <String>{};
    final seenNameKeys = <String>{};

    var invalidRequiredEntries = 0;
    var missingOptionalMetadata = 0;

    for (final rawMap in rawMaps) {
      final normalizedJson = _normalizeRawRecord(
        rawMap.map((k, v) => MapEntry(k.toString(), v)),
      );
      if (normalizedJson == null) {
        invalidRequiredEntries += 1;
        continue;
      }

      final id = normalizedJson['id']?.toString() ?? '';
      if (!seenIds.add(id)) {
        duplicateIds.add(id);
        continue;
      }

      final genderRaw =
          normalizedJson['gender']?.toString().toLowerCase() ?? '';
      final nameKey =
          '${_normalizeNameKey(normalizedJson['name'].toString())}|$genderRaw';
      if (!seenNameKeys.add(nameKey)) {
        probableDuplicateNames.add(nameKey);
        continue;
      }

      final entry = BabyNameEntry.fromJson(normalizedJson);
      if (!_isMinimumValid(entry)) {
        invalidRequiredEntries += 1;
        continue;
      }

      if (_missingOptional(entry)) {
        missingOptionalMetadata += 1;
      }

      entries.add(entry);
    }

    final male = entries.where((e) => e.gender == BabyNameGender.male).length;
    final female = entries
        .where((e) => e.gender == BabyNameGender.female)
        .length;
    final unisex = entries
        .where((e) => e.gender == BabyNameGender.unisex)
        .length;

    _validationReport = BabyNamesValidationReport(
      totalRawEntries: rawMaps.length,
      validEntries: entries.length,
      maleCount: male,
      femaleCount: female,
      unisexCount: unisex,
      quranicCount: entries.where((e) => e.isQuranic).length,
      popularCount: entries.where((e) => e.isPopular).length,
      entriesMissingOptionalMetadata: missingOptionalMetadata,
      invalidRequiredEntries: invalidRequiredEntries,
      duplicateIds: duplicateIds.toList()..sort(),
      probableDuplicateNames: probableDuplicateNames.toList()..sort(),
    );

    return entries;
  }

  Map<String, dynamic>? _normalizeRawRecord(Map<String, dynamic> raw) {
    String clean(dynamic value) =>
        value?.toString().trim().replaceAll(RegExp(r'\s+'), ' ') ?? '';

    List<String> cleanList(dynamic value) {
      if (value is! List) return <String>[];
      final out = <String>{};
      for (final item in value) {
        final cleaned = clean(item);
        if (cleaned.isNotEmpty) out.add(cleaned);
      }
      return out.toList();
    }

    final id = clean(raw['id']);
    final name = clean(raw['name']);
    final arabic = clean(raw['arabic']);
    var transliteration = clean(raw['transliteration']);
    final gender = clean(raw['gender']).toLowerCase();
    final meaning = clean(raw['meaning']);
    final origin = cleanList(raw['origin']);
    final meaningThemes = cleanList(raw['meaningThemes']);
    final startsWithRaw = clean(raw['startsWith']);

    if (id.isEmpty ||
        name.isEmpty ||
        arabic.isEmpty ||
        transliteration.isEmpty ||
        meaning.isEmpty ||
        origin.isEmpty ||
        meaningThemes.isEmpty) {
      return null;
    }

    if (gender != 'male' && gender != 'female' && gender != 'unisex') {
      return null;
    }

    transliteration = _normalizeTransliteration(transliteration);

    final startsWith = startsWithRaw.isNotEmpty
        ? startsWithRaw.substring(0, 1).toUpperCase()
        : _deriveStartsWith(name);

    final categories = cleanList(raw['associatedCategories']);
    final normalizedCategories = categories.isEmpty
        ? <String>['classic']
        : categories;

    return {
      'id': id,
      'name': name,
      'arabic': arabic,
      'transliteration': transliteration,
      'pronunciation': clean(raw['pronunciation']).isEmpty
          ? null
          : clean(raw['pronunciation']),
      'gender': gender,
      'meaning': meaning,
      'description': clean(raw['description']).isEmpty
          ? null
          : clean(raw['description']),
      'meaningThemes': meaningThemes,
      'origin': origin,
      'isQuranic': raw['isQuranic'] == true,
      'quranReferences': cleanList(raw['quranReferences']),
      'associatedFigures': cleanList(raw['associatedFigures']),
      'associatedCategories': normalizedCategories,
      'popularityRegions': cleanList(raw['popularityRegions']),
      'variants': cleanList(raw['variants']),
      'similarNames': cleanList(raw['similarNames']),
      'startsWith': startsWith,
      'syllables': raw['syllables'] is num
          ? (raw['syllables'] as num).toInt()
          : null,
      'isPopular': raw['isPopular'] == true,
      'styleTags': cleanList(raw['styleTags']),
      'audioPronunciation': clean(raw['audioPronunciation']).isEmpty
          ? null
          : clean(raw['audioPronunciation']),
    };
  }

  bool _isMinimumValid(BabyNameEntry entry) {
    return entry.id.isNotEmpty &&
        entry.name.isNotEmpty &&
        entry.arabic.isNotEmpty &&
        entry.transliteration.isNotEmpty &&
        entry.meaning.isNotEmpty &&
        entry.origin.isNotEmpty &&
        entry.meaningThemes.isNotEmpty &&
        entry.startsWith.isNotEmpty;
  }

  bool _missingOptional(BabyNameEntry entry) {
    return (entry.pronunciation == null || entry.pronunciation!.isEmpty) ||
        (entry.description == null || entry.description!.isEmpty) ||
        entry.quranReferences.isEmpty ||
        entry.associatedFigures.isEmpty ||
        entry.popularityRegions.isEmpty ||
        entry.variants.isEmpty ||
        entry.similarNames.isEmpty ||
        entry.syllables == null ||
        entry.styleTags.isEmpty;
  }

  String _deriveStartsWith(String name) {
    for (final rune in name.runes) {
      final char = String.fromCharCode(rune);
      if (RegExp(r'[A-Za-z]').hasMatch(char)) {
        return char.toUpperCase();
      }
    }
    return name.substring(0, 1).toUpperCase();
  }

  String _normalizeTransliteration(String value) {
    final words = value
        .split(' ')
        .map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .map((word) {
          if (word.length == 1) return word.toUpperCase();
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .toList();
    return words.join(' ');
  }

  String _normalizeNameKey(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
  }

  List<BabyNameEntry> namesForCollection(
    List<BabyNameEntry> all,
    String collectionId,
  ) {
    bool hasTheme(BabyNameEntry e, String theme) =>
        e.meaningThemes.contains(theme);

    switch (collectionId) {
      case 'quranic_names':
        return all.where((e) => e.isQuranic).toList();
      case 'prophet_names':
        return all.where((e) => e.isProphetAssociated).toList();
      case 'companion_names':
        return all.where((e) => e.isCompanionAssociated).toList();
      case 'female_companions':
        return all
            .where(
              (e) =>
                  e.isCompanionAssociated && e.gender == BabyNameGender.female,
            )
            .toList();
      case 'meaning_light':
        return all.where((e) => hasTheme(e, 'light')).toList();
      case 'meaning_mercy':
        return all.where((e) => hasTheme(e, 'mercy')).toList();
      case 'meaning_patience':
        return all.where((e) => hasTheme(e, 'patience')).toList();
      case 'meaning_wisdom':
        return all
            .where((e) => hasTheme(e, 'wisdom') || hasTheme(e, 'knowledge'))
            .toList();
      case 'meaning_peace':
        return all.where((e) => hasTheme(e, 'peace')).toList();
      case 'meaning_strength':
        return all.where((e) => hasTheme(e, 'strength')).toList();
      case 'popular_boys':
        return all
            .where((e) => e.gender == BabyNameGender.male && e.isPopular)
            .toList();
      case 'popular_girls':
        return all
            .where((e) => e.gender == BabyNameGender.female && e.isPopular)
            .toList();
      case 'short_names':
        return all.where((e) => e.name.length <= 5).toList();
      case 'modern_names':
        return all
            .where((e) => e.associatedCategories.contains('modern'))
            .toList();
      case 'classic_names':
        return all
            .where((e) => e.associatedCategories.contains('classic'))
            .toList();
      default:
        return all;
    }
  }

  List<BabyNameCollection> collections(List<BabyNameEntry> all) {
    List<String> ids(String key, {int max = 18}) =>
        namesForCollection(all, key).take(max).map((e) => e.id).toList();

    return [
      BabyNameCollection(
        id: 'quranic_names',
        title: 'Quranic Names',
        subtitle: 'Names referenced or traditionally linked with the Qur’an',
        nameIds: ids('quranic_names'),
      ),
      BabyNameCollection(
        id: 'prophet_names',
        title: 'Names of the Prophets',
        subtitle: 'Classical prophetic names used across generations',
        nameIds: ids('prophet_names'),
      ),
      BabyNameCollection(
        id: 'companion_names',
        title: 'Names of Companions',
        subtitle: 'Meaningful names associated with early Muslim companions',
        nameIds: ids('companion_names'),
      ),
      BabyNameCollection(
        id: 'meaning_light',
        title: 'Names of Light',
        subtitle: 'Guidance, illumination, and clarity themes',
        nameIds: ids('meaning_light'),
      ),
      BabyNameCollection(
        id: 'meaning_mercy',
        title: 'Names of Mercy',
        subtitle: 'Names carrying gentleness and compassion',
        nameIds: ids('meaning_mercy'),
      ),
      BabyNameCollection(
        id: 'meaning_patience',
        title: 'Names of Patience',
        subtitle: 'Steadfastness and resilience themes',
        nameIds: ids('meaning_patience'),
      ),
      BabyNameCollection(
        id: 'meaning_wisdom',
        title: 'Names of Wisdom',
        subtitle: 'Knowledge, insight, and sound judgment themes',
        nameIds: ids('meaning_wisdom'),
      ),
      BabyNameCollection(
        id: 'popular_girls',
        title: 'Popular Girl Names',
        subtitle: 'Widely loved names across Muslim communities',
        nameIds: ids('popular_girls'),
      ),
      BabyNameCollection(
        id: 'popular_boys',
        title: 'Popular Boy Names',
        subtitle: 'Widely loved names across Muslim communities',
        nameIds: ids('popular_boys'),
      ),
      BabyNameCollection(
        id: 'short_names',
        title: 'Short and Elegant Names',
        subtitle: 'Simple names with graceful meaning',
        nameIds: ids('short_names'),
      ),
      BabyNameCollection(
        id: 'strong_names',
        title: 'Strong and Noble Names',
        subtitle: 'Names associated with dignity, courage, and honor',
        nameIds: ids('meaning_strength'),
      ),
      BabyNameCollection(
        id: 'modern_names',
        title: 'Modern Muslim Names',
        subtitle: 'Contemporary names that remain spiritually rooted',
        nameIds: ids('modern_names'),
      ),
    ];
  }

  List<BabyNameEntry> relatedNames(BabyNameEntry entry, BabyNamesIndex index) {
    final scores = <String, double>{};

    void addScore(String id, double value) {
      if (id == entry.id) return;
      scores[id] = (scores[id] ?? 0) + value;
    }

    for (final theme in entry.meaningThemes) {
      final ids = index.byMeaningTheme[theme];
      if (ids == null) continue;
      for (final id in ids) {
        addScore(id, 2.0);
      }
    }

    for (final origin in entry.origin) {
      final ids = index.byOrigin[origin];
      if (ids == null) continue;
      for (final id in ids) {
        addScore(id, 1.1);
      }
    }

    for (final category in entry.associatedCategories) {
      final ids = index.byCategory[category];
      if (ids == null) continue;
      for (final id in ids) {
        addScore(id, 1.2);
      }
    }

    for (final style in entry.styleTags) {
      final ids = index.byStyleTag[style];
      if (ids == null) continue;
      for (final id in ids) {
        addScore(id, 0.9);
      }
    }

    for (final figure in entry.associatedFigures) {
      final ids = index.byAssociatedFigure[figure];
      if (ids == null) continue;
      for (final id in ids) {
        addScore(id, 1.0);
      }
    }

    final soundIds =
        index.bySoundKey[_soundKey(entry.name)] ?? const <String>{};
    for (final id in soundIds) {
      addScore(id, 1.4);
    }

    for (final candidate in entry.similarNames) {
      final id = index.byNameLower[candidate.toLowerCase()]?.id;
      if (id != null) addScore(id, 2.4);
    }

    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final primary = sorted
        .map((e) => index.byId[e.key])
        .whereType<BabyNameEntry>()
        .take(8)
        .toList();
    if (primary.isNotEmpty) return primary;

    final fallback =
        (index.byStartingLetter[entry.startsWith] ?? const <String>{})
            .where((id) => id != entry.id)
            .map((id) => index.byId[id])
            .whereType<BabyNameEntry>()
            .toList()
          ..sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
    return fallback.take(8).toList();
  }

  double searchScore(BabyNameEntry entry, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return 0;

    final name = entry.name.toLowerCase();
    final transliteration = entry.transliteration.toLowerCase();
    final arabic = entry.arabic;

    var score = 0.0;

    if (name == query) score += 120;
    if (transliteration == query) score += 115;
    if (arabic == rawQuery.trim()) score += 115;

    if (name.startsWith(query)) score += 90;
    if (transliteration.startsWith(query)) score += 84;

    if (name.contains(query)) score += 55;
    if (transliteration.contains(query)) score += 50;
    if (entry.meaning.toLowerCase().contains(query)) score += 28;
    if ((entry.description ?? '').toLowerCase().contains(query)) score += 18;

    for (final value in entry.variants) {
      final low = value.toLowerCase();
      if (low == query) {
        score += 90;
      } else if (low.startsWith(query)) {
        score += 70;
      } else if (low.contains(query)) {
        score += 35;
      }
    }

    for (final value in [
      ...entry.meaningThemes,
      ...entry.origin,
      ...entry.associatedCategories,
      ...entry.associatedFigures,
    ]) {
      final low = value.toLowerCase();
      if (low == query) {
        score += 32;
      } else if (low.contains(query)) {
        score += 12;
      }
    }

    // Lightweight fuzzy support for near misspellings.
    final nameDistance = _editDistance(name, query);
    if (nameDistance == 1) score += 22;
    if (nameDistance == 2 && query.length >= 5) score += 12;

    return score;
  }
}

class BabyNamesValidationReport {
  const BabyNamesValidationReport({
    required this.totalRawEntries,
    required this.validEntries,
    required this.maleCount,
    required this.femaleCount,
    required this.unisexCount,
    required this.quranicCount,
    required this.popularCount,
    required this.entriesMissingOptionalMetadata,
    required this.invalidRequiredEntries,
    required this.duplicateIds,
    required this.probableDuplicateNames,
  });

  const BabyNamesValidationReport.empty()
    : totalRawEntries = 0,
      validEntries = 0,
      maleCount = 0,
      femaleCount = 0,
      unisexCount = 0,
      quranicCount = 0,
      popularCount = 0,
      entriesMissingOptionalMetadata = 0,
      invalidRequiredEntries = 0,
      duplicateIds = const <String>[],
      probableDuplicateNames = const <String>[];

  final int totalRawEntries;
  final int validEntries;
  final int maleCount;
  final int femaleCount;
  final int unisexCount;
  final int quranicCount;
  final int popularCount;
  final int entriesMissingOptionalMetadata;
  final int invalidRequiredEntries;
  final List<String> duplicateIds;
  final List<String> probableDuplicateNames;

  String toDebugSummary() {
    return '[BabyNamesValidation] totalRaw=$totalRawEntries, valid=$validEntries, '
        'male=$maleCount, female=$femaleCount, unisex=$unisexCount, '
        'quranic=$quranicCount, popular=$popularCount, '
        'missingOptional=$entriesMissingOptionalMetadata, '
        'invalidRequired=$invalidRequiredEntries, '
        'duplicateIds=${duplicateIds.length}, probableDuplicates=${probableDuplicateNames.length}';
  }
}

final babyNamesRepositoryProvider = Provider<BabyNamesRepository>((ref) {
  return BabyNamesRepository();
});

final babyNamesEntriesProvider = FutureProvider<List<BabyNameEntry>>((
  ref,
) async {
  return ref.watch(babyNamesRepositoryProvider).loadAll();
});

final babyNamesByIdProvider = FutureProvider<Map<String, BabyNameEntry>>((
  ref,
) async {
  return ref.watch(babyNamesRepositoryProvider).loadById();
});

final babyNamesValidationReportProvider =
    FutureProvider<BabyNamesValidationReport>((ref) async {
      return ref.watch(babyNamesRepositoryProvider).loadValidationReport();
    });

final babyNamesCollectionsProvider = FutureProvider<List<BabyNameCollection>>((
  ref,
) async {
  final all = await ref.watch(babyNamesEntriesProvider.future);
  return ref.watch(babyNamesRepositoryProvider).collections(all);
});

class BabyNamesIndex {
  const BabyNamesIndex({
    required this.all,
    required this.byId,
    required this.byGender,
    required this.byStartingLetter,
    required this.byMeaningTheme,
    required this.byOrigin,
    required this.byCategory,
    required this.byStyleTag,
    required this.byAssociatedFigure,
    required this.quranicIds,
    required this.prophetIds,
    required this.companionIds,
    required this.popularIds,
    required this.searchableById,
    required this.byNameLower,
    required this.bySoundKey,
  });

  factory BabyNamesIndex.fromEntries(List<BabyNameEntry> entries) {
    final byId = <String, BabyNameEntry>{};
    final byNameLower = <String, BabyNameEntry>{};
    final byGender = <BabyNameGender, Set<String>>{
      BabyNameGender.male: <String>{},
      BabyNameGender.female: <String>{},
      BabyNameGender.unisex: <String>{},
    };
    final byStartingLetter = <String, Set<String>>{};
    final byMeaningTheme = <String, Set<String>>{};
    final byOrigin = <String, Set<String>>{};
    final byCategory = <String, Set<String>>{};
    final byStyleTag = <String, Set<String>>{};
    final byAssociatedFigure = <String, Set<String>>{};
    final quranicIds = <String>{};
    final prophetIds = <String>{};
    final companionIds = <String>{};
    final popularIds = <String>{};
    final searchableById = <String, String>{};
    final bySoundKey = <String, Set<String>>{};

    for (final item in entries) {
      byId[item.id] = item;
      byNameLower[item.name.toLowerCase()] = item;
      byGender[item.gender]!.add(item.id);

      if (item.startsWith.isNotEmpty) {
        byStartingLetter
            .putIfAbsent(item.startsWith, () => <String>{})
            .add(item.id);
      }

      for (final theme in item.meaningThemes) {
        byMeaningTheme.putIfAbsent(theme, () => <String>{}).add(item.id);
      }
      for (final origin in item.origin) {
        byOrigin.putIfAbsent(origin, () => <String>{}).add(item.id);
      }
      for (final category in item.associatedCategories) {
        byCategory.putIfAbsent(category, () => <String>{}).add(item.id);
      }
      for (final tag in item.styleTags) {
        byStyleTag.putIfAbsent(tag, () => <String>{}).add(item.id);
      }
      for (final figure in item.associatedFigures) {
        byAssociatedFigure.putIfAbsent(figure, () => <String>{}).add(item.id);
      }

      if (item.isQuranic) quranicIds.add(item.id);
      if (item.isProphetAssociated) prophetIds.add(item.id);
      if (item.isCompanionAssociated) companionIds.add(item.id);
      if (item.isPopular) popularIds.add(item.id);

      searchableById[item.id] = [
        item.name,
        item.arabic,
        item.transliteration,
        item.meaning,
        item.description ?? '',
        ...item.origin,
        ...item.meaningThemes,
        ...item.associatedCategories,
        ...item.associatedFigures,
        ...item.variants,
      ].join(' ').toLowerCase();

      final soundKey = _soundKey(item.name);
      bySoundKey.putIfAbsent(soundKey, () => <String>{}).add(item.id);
    }

    return BabyNamesIndex(
      all: entries,
      byId: byId,
      byGender: byGender,
      byStartingLetter: byStartingLetter,
      byMeaningTheme: byMeaningTheme,
      byOrigin: byOrigin,
      byCategory: byCategory,
      byStyleTag: byStyleTag,
      byAssociatedFigure: byAssociatedFigure,
      quranicIds: quranicIds,
      prophetIds: prophetIds,
      companionIds: companionIds,
      popularIds: popularIds,
      searchableById: searchableById,
      byNameLower: byNameLower,
      bySoundKey: bySoundKey,
    );
  }

  final List<BabyNameEntry> all;
  final Map<String, BabyNameEntry> byId;
  final Map<BabyNameGender, Set<String>> byGender;
  final Map<String, Set<String>> byStartingLetter;
  final Map<String, Set<String>> byMeaningTheme;
  final Map<String, Set<String>> byOrigin;
  final Map<String, Set<String>> byCategory;
  final Map<String, Set<String>> byStyleTag;
  final Map<String, Set<String>> byAssociatedFigure;
  final Set<String> quranicIds;
  final Set<String> prophetIds;
  final Set<String> companionIds;
  final Set<String> popularIds;
  final Map<String, String> searchableById;
  final Map<String, BabyNameEntry> byNameLower;
  final Map<String, Set<String>> bySoundKey;
}

String _soundKey(String value) {
  final lower = value.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
  if (lower.isEmpty) return '';
  final consonants = lower.replaceAll(RegExp(r'[aeiou]'), '');
  final short = consonants.isEmpty ? lower : consonants;
  return short.length <= 4 ? short : short.substring(0, 4);
}

int _editDistance(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  final rows = a.length + 1;
  final cols = b.length + 1;
  final dp = List.generate(rows, (_) => List<int>.filled(cols, 0));

  for (var i = 0; i < rows; i++) {
    dp[i][0] = i;
  }
  for (var j = 0; j < cols; j++) {
    dp[0][j] = j;
  }

  for (var i = 1; i < rows; i++) {
    for (var j = 1; j < cols; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      dp[i][j] = [
        dp[i - 1][j] + 1,
        dp[i][j - 1] + 1,
        dp[i - 1][j - 1] + cost,
      ].reduce((x, y) => x < y ? x : y);
    }
  }

  return dp[rows - 1][cols - 1];
}

final babyNamesIndexProvider = FutureProvider<BabyNamesIndex>((ref) async {
  return ref.watch(babyNamesRepositoryProvider).loadIndex();
});
