import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/hadith_narrator_profiles.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_narrator_models.dart';
import 'hadith_foundation_repository.dart';

final _narratorProfilesById = {
  for (final profile in seededHadithNarratorProfiles) profile.id: profile,
};

final _narratorAliasToId = {
  for (final profile in seededHadithNarratorProfiles)
    for (final alias in <String>[
      profile.displayName,
      ...profile.aliases,
      ...profile.matchAliases,
    ])
      _normalizeNarratorMatchKey(alias): profile.id,
};

String? resolveHadithNarratorId(String? raw) {
  final displayName = _cleanNarratorDisplay(raw);
  if (displayName == null) return null;
  if (_looksLikeMultipleNarrators(displayName)) return null;
  final matchKey = _normalizeNarratorMatchKey(displayName);
  final curatedId = _narratorAliasToId[matchKey];
  if (curatedId != null) return curatedId;
  return 'generated_${_slugifyNarrator(matchKey)}';
}

String? resolveHadithNarratorDisplayName(String? raw) {
  final cleaned = _cleanNarratorDisplay(raw);
  if (cleaned == null) return null;
  final id = resolveHadithNarratorId(cleaned);
  if (id == null) return cleaned;
  return _narratorProfilesById[id]?.displayName ?? cleaned;
}

HadithNarratorProfile? hadithNarratorProfileForId(String narratorId) =>
    _narratorProfilesById[narratorId];

final hadithNarratorDetailProvider =
    Provider.family<HadithNarratorDetail?, String>((ref, narratorId) {
      final entries = ref.watch(hadithEntriesProvider);
      final themesById = {
        for (final theme in ref.watch(hadithThemesProvider))
          theme.id: theme.title,
      };
      final collectionsById = {
        for (final collection in ref.watch(hadithCollectionsProvider))
          collection.id: collection.title,
      };
      final narratorEntries = entries
          .where(
            (entry) => resolveHadithNarratorId(entry.narrator) == narratorId,
          )
          .toList(growable: false);
      if (narratorEntries.isEmpty) return null;

      final sortedEntries = narratorEntries.toList(growable: false)
        ..sort(_compareNarratorEntries);
      final profile = _narratorProfilesById[narratorId];
      final displayName =
          profile?.displayName ??
          _bestNarratorDisplayName(sortedEntries) ??
          narratorId;

      final aliases = <String>{
        ...?profile?.aliases,
        for (final entry in sortedEntries)
          if ((_cleanNarratorDisplay(entry.narrator) ?? '').isNotEmpty)
            _cleanNarratorDisplay(entry.narrator)!,
      }..remove(displayName);

      final sourceTitles =
          sortedEntries
              .map((entry) => entry.displaySourceCollectionTitle.trim())
              .where((value) => value.isNotEmpty)
              .toSet()
              .toList(growable: false)
            ..sort();

      final themeTitles =
          sortedEntries
              .map((entry) => themesById[entry.themeId])
              .whereType<String>()
              .toSet()
              .toList(growable: false)
            ..sort();

      final collectionTitles = <String>{
        for (final entry in sortedEntries)
          for (final collectionId in entry.collectionIds)
            if ((collectionsById[collectionId] ?? '').trim().isNotEmpty)
              collectionsById[collectionId]!,
      }.toList(growable: false)..sort();

      return HadithNarratorDetail(
        id: narratorId,
        displayName: displayName,
        profile: profile,
        entries: sortedEntries,
        aliases: aliases.toList(growable: false)..sort(),
        sourceTitles: sourceTitles,
        themeTitles: themeTitles,
        collectionTitles: collectionTitles,
      );
    });

String? _bestNarratorDisplayName(List<HadithEntry> entries) {
  String? best;
  var bestLength = 0;
  for (final entry in entries) {
    final candidate = _cleanNarratorDisplay(entry.narrator);
    if (candidate == null) continue;
    if (candidate.length > bestLength) {
      best = candidate;
      bestLength = candidate.length;
    }
  }
  return best;
}

String? _cleanNarratorDisplay(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  var result = value
      .replaceAll(RegExp(r'\s*\([^)]*\)\s*'), ' ')
      .replaceAll('`', "'")
      .replaceAll('ʿ', "'")
      .replaceAll('’', "'");
  result = result.replaceFirst(
    RegExp(r'^(on the authority of|narrated by)\s+', caseSensitive: false),
    '',
  );
  final cutMarkers = <Pattern>[
    RegExp(r'\breported\b', caseSensitive: false),
    RegExp(r'\bsaid\b', caseSensitive: false),
    RegExp(r'\bwho said\b', caseSensitive: false),
    RegExp(r'\bused to say\b', caseSensitive: false),
    RegExp(r'\bpertaining to\b', caseSensitive: false),
    RegExp(r'\babout surat\b', caseSensitive: false),
    RegExp(r'\bin the hadith\b', caseSensitive: false),
    RegExp(r'\bthat the messenger\b', caseSensitive: false),
    RegExp(r'\bthat the prophet\b', caseSensitive: false),
  ];
  var cutIndex = result.length;
  for (final marker in cutMarkers) {
    final match = switch (marker) {
      final RegExp regex => regex.firstMatch(result),
      _ => null,
    };
    if (match != null && match.start < cutIndex) {
      cutIndex = match.start;
    }
  }
  result = result.substring(0, cutIndex);
  result = result
      .replaceAll(RegExp(r'\bbin\b', caseSensitive: false), 'ibn')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceAll(RegExp(r"""^[,.;:\-'"]+"""), '')
      .replaceAll(RegExp(r"""[,.;:\-'"]+$"""), '');
  return result.isEmpty ? null : result;
}

bool _looksLikeMultipleNarrators(String value) {
  final normalized = value.toLowerCase();
  return normalized.contains(' / ') ||
      normalized.contains('/') ||
      normalized.contains(' and ');
}

String _normalizeNarratorMatchKey(String raw) {
  return raw
      .toLowerCase()
      .replaceAll('`', "'")
      .replaceAll('ʿ', "'")
      .replaceAll('’', "'")
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .replaceAll(RegExp(r'\bbin\b'), 'ibn')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _slugifyNarrator(String raw) =>
    raw.replaceAll(RegExp(r'[^a-z0-9]+'), '_');

int _compareNarratorEntries(HadithEntry a, HadithEntry b) {
  final sourceCompare = a.displaySourceCollectionTitle.compareTo(
    b.displaySourceCollectionTitle,
  );
  if (sourceCompare != 0) return sourceCompare;
  final chapterCompare = (a.normalizedSourceChapterNumber ?? 0).compareTo(
    b.normalizedSourceChapterNumber ?? 0,
  );
  if (chapterCompare != 0) return chapterCompare;
  final hadithNumberCompare = (a.primaryHadithNumber ?? '').compareTo(
    b.primaryHadithNumber ?? '',
  );
  if (hadithNumberCompare != 0) return hadithNumberCompare;
  return a.title.compareTo(b.title);
}
