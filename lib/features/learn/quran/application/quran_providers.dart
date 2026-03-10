import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/quran_repository.dart';
import '../domain/quran_ayah.dart';
import '../domain/quran_bookmark.dart';
import '../domain/quran_daily_verse.dart';
import '../domain/quran_note.dart';
import '../domain/quran_reading_progress.dart';
import '../domain/quran_surah.dart';

const _progressKey = 'learn.quran.readingProgress';
const _bookmarksKey = 'learn.quran.bookmarks';
const _notesKey = 'learn.quran.notes';
const _recentSearchesKey = 'learn.quran.recentSearches';
const _recentReadingsKey = 'learn.quran.recentReadings';
const _translationCodeKey = 'learn.quran.translationCode';
const _showTransliterationKey = 'learn.quran.showTransliteration';
const _showTranslationKey = 'learn.quran.showTranslation';
const _arabicScalePercentKey = 'learn.quran.arabicScalePercent';
const _translationScalePercentKey = 'learn.quran.translationScalePercent';
const _cleanReadingModeKey = 'learn.quran.cleanReadingMode';
const _showWordByWordKey = 'learn.quran.showWordByWord';
const _wordFavoritesKey = 'learn.quran.wordFavorites';
const _wordReviewProgressKey = 'learn.quran.wordReviewProgress';
const _audioSettingsKey = 'learn.quran.audioSettings';
const _hifzSettingsKey = 'learn.quran.hifzSettings';
const _notesFilterFolderKey = 'learn.quran.notesFilterFolder';
const _notesFilterTagKey = 'learn.quran.notesFilterTag';

const quranTranslationCodes = <String>[
  'en.sahih',
  'en.clear',
  'ur.urdu',
  'bn.bengali',
  'id.indonesian',
  'tr.saheeh',
  'fa.dari',
];

class QuranReaderSettings {
  const QuranReaderSettings({
    required this.translationCode,
    required this.showTransliteration,
    required this.showTranslation,
    required this.arabicScalePercent,
    required this.translationScalePercent,
    required this.cleanReadingMode,
    required this.showWordByWord,
  });

  final String translationCode;
  final bool showTransliteration;
  final bool showTranslation;
  final int arabicScalePercent;
  final int translationScalePercent;
  final bool cleanReadingMode;
  final bool showWordByWord;

  QuranReaderSettings copyWith({
    String? translationCode,
    bool? showTransliteration,
    bool? showTranslation,
    int? arabicScalePercent,
    int? translationScalePercent,
    bool? cleanReadingMode,
    bool? showWordByWord,
  }) {
    return QuranReaderSettings(
      translationCode: translationCode ?? this.translationCode,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      arabicScalePercent: arabicScalePercent ?? this.arabicScalePercent,
      translationScalePercent:
          translationScalePercent ?? this.translationScalePercent,
      cleanReadingMode: cleanReadingMode ?? this.cleanReadingMode,
      showWordByWord: showWordByWord ?? this.showWordByWord,
    );
  }
}

class QuranWordFavorite {
  const QuranWordFavorite({
    required this.arabic,
    required this.gloss,
    required this.transliteration,
    required this.pinnedAtIso,
    required this.reviewCount,
    required this.lastReviewedAtIso,
  });

  final String arabic;
  final String gloss;
  final String transliteration;
  final String pinnedAtIso;
  final int reviewCount;
  final String? lastReviewedAtIso;

  QuranWordFavorite copyWith({
    String? arabic,
    String? gloss,
    String? transliteration,
    String? pinnedAtIso,
    int? reviewCount,
    String? lastReviewedAtIso,
  }) {
    return QuranWordFavorite(
      arabic: arabic ?? this.arabic,
      gloss: gloss ?? this.gloss,
      transliteration: transliteration ?? this.transliteration,
      pinnedAtIso: pinnedAtIso ?? this.pinnedAtIso,
      reviewCount: reviewCount ?? this.reviewCount,
      lastReviewedAtIso: lastReviewedAtIso ?? this.lastReviewedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'arabic': arabic,
    'gloss': gloss,
    'transliteration': transliteration,
    'pinnedAtIso': pinnedAtIso,
    'reviewCount': reviewCount,
    'lastReviewedAtIso': lastReviewedAtIso,
  };

  static QuranWordFavorite? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final arabic = json['arabic']?.toString();
    final gloss = json['gloss']?.toString();
    final transliteration = json['transliteration']?.toString();
    final pinnedAtIso = json['pinnedAtIso']?.toString();
    if (arabic == null ||
        gloss == null ||
        transliteration == null ||
        pinnedAtIso == null) {
      return null;
    }
    return QuranWordFavorite(
      arabic: arabic,
      gloss: gloss,
      transliteration: transliteration,
      pinnedAtIso: pinnedAtIso,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      lastReviewedAtIso: json['lastReviewedAtIso']?.toString(),
    );
  }
}

class QuranAudioSettings {
  const QuranAudioSettings({
    required this.playbackSpeed,
    required this.repeatStartAyah,
    required this.repeatEndAyah,
    required this.ayahLoopCount,
  });

  final double playbackSpeed;
  final int? repeatStartAyah;
  final int? repeatEndAyah;
  final int ayahLoopCount;

  QuranAudioSettings copyWith({
    double? playbackSpeed,
    int? repeatStartAyah,
    int? repeatEndAyah,
    int? ayahLoopCount,
    bool clearRange = false,
  }) {
    return QuranAudioSettings(
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      repeatStartAyah: clearRange
          ? null
          : repeatStartAyah ?? this.repeatStartAyah,
      repeatEndAyah: clearRange ? null : repeatEndAyah ?? this.repeatEndAyah,
      ayahLoopCount: ayahLoopCount ?? this.ayahLoopCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'playbackSpeed': playbackSpeed,
    'repeatStartAyah': repeatStartAyah,
    'repeatEndAyah': repeatEndAyah,
    'ayahLoopCount': ayahLoopCount,
  };

  static QuranAudioSettings fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranAudioSettings(
        playbackSpeed: 1.0,
        repeatStartAyah: null,
        repeatEndAyah: null,
        ayahLoopCount: 1,
      );
    }
    return QuranAudioSettings(
      playbackSpeed: ((json['playbackSpeed'] as num?)?.toDouble() ?? 1.0).clamp(
        0.6,
        1.2,
      ),
      repeatStartAyah: (json['repeatStartAyah'] as num?)?.toInt(),
      repeatEndAyah: (json['repeatEndAyah'] as num?)?.toInt(),
      ayahLoopCount: ((json['ayahLoopCount'] as num?)?.toInt() ?? 1).clamp(
        1,
        12,
      ),
    );
  }
}

enum HifzRevealMode { full, firstWordOnly, hidden }

class QuranHifzSettings {
  const QuranHifzSettings({
    required this.enabled,
    required this.revealMode,
    required this.checkpointMistakes,
    required this.dailyRevisionTarget,
  });

  final bool enabled;
  final HifzRevealMode revealMode;
  final Map<String, int> checkpointMistakes;
  final int dailyRevisionTarget;

  QuranHifzSettings copyWith({
    bool? enabled,
    HifzRevealMode? revealMode,
    Map<String, int>? checkpointMistakes,
    int? dailyRevisionTarget,
  }) {
    return QuranHifzSettings(
      enabled: enabled ?? this.enabled,
      revealMode: revealMode ?? this.revealMode,
      checkpointMistakes: checkpointMistakes ?? this.checkpointMistakes,
      dailyRevisionTarget: dailyRevisionTarget ?? this.dailyRevisionTarget,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'revealMode': revealMode.name,
    'checkpointMistakes': checkpointMistakes,
    'dailyRevisionTarget': dailyRevisionTarget,
  };

  static QuranHifzSettings fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranHifzSettings(
        enabled: false,
        revealMode: HifzRevealMode.full,
        checkpointMistakes: {},
        dailyRevisionTarget: 5,
      );
    }
    final rawReveal = json['revealMode']?.toString();
    var reveal = HifzRevealMode.full;
    for (final item in HifzRevealMode.values) {
      if (item.name == rawReveal) {
        reveal = item;
        break;
      }
    }
    final rawMap = json['checkpointMistakes'];
    final map = <String, int>{};
    if (rawMap is Map) {
      for (final entry in rawMap.entries) {
        final key = entry.key.toString();
        final value = (entry.value as num?)?.toInt() ?? 0;
        if (key.isNotEmpty && value > 0) {
          map[key] = value;
        }
      }
    }
    return QuranHifzSettings(
      enabled: json['enabled'] == true,
      revealMode: reveal,
      checkpointMistakes: map,
      dailyRevisionTarget: ((json['dailyRevisionTarget'] as num?)?.toInt() ?? 5)
          .clamp(1, 25),
    );
  }
}

class QuranNotesFilterState {
  const QuranNotesFilterState({required this.folder, required this.tag});

  final String folder;
  final String tag;

  QuranNotesFilterState copyWith({String? folder, String? tag}) {
    return QuranNotesFilterState(
      folder: folder ?? this.folder,
      tag: tag ?? this.tag,
    );
  }
}

class QuranReaderSettingsNotifier extends StateNotifier<QuranReaderSettings> {
  QuranReaderSettingsNotifier(this._store)
    : super(
        const QuranReaderSettings(
          translationCode: 'en.sahih',
          showTransliteration: false,
          showTranslation: true,
          arabicScalePercent: 100,
          translationScalePercent: 100,
          cleanReadingMode: false,
          showWordByWord: true,
        ),
      ) {
    _load();
  }

  final LocalStore _store;

  void setTranslationCode(String code) {
    if (!quranTranslationCodes.contains(code)) return;
    state = state.copyWith(translationCode: code);
    _store.setString(_translationCodeKey, code);
  }

  void setShowTransliteration(bool value) {
    state = state.copyWith(showTransliteration: value);
    _store.setBool(_showTransliterationKey, value);
  }

  void setShowTranslation(bool value) {
    state = state.copyWith(showTranslation: value);
    _store.setBool(_showTranslationKey, value);
  }

  void setArabicScalePercent(int value) {
    final clamped = value.clamp(85, 140);
    state = state.copyWith(arabicScalePercent: clamped);
    _store.setInt(_arabicScalePercentKey, clamped);
  }

  void setTranslationScalePercent(int value) {
    final clamped = value.clamp(85, 140);
    state = state.copyWith(translationScalePercent: clamped);
    _store.setInt(_translationScalePercentKey, clamped);
  }

  void setCleanReadingMode(bool value) {
    state = state.copyWith(cleanReadingMode: value);
    _store.setBool(_cleanReadingModeKey, value);
  }

  void setShowWordByWord(bool value) {
    state = state.copyWith(showWordByWord: value);
    _store.setBool(_showWordByWordKey, value);
  }

  void _load() {
    final code = _store.getString(_translationCodeKey);
    final showTransliteration = _store.getBool(_showTransliterationKey);
    final showTranslation = _store.getBool(_showTranslationKey);
    final arabicScalePercent = _store.getInt(_arabicScalePercentKey);
    final translationScalePercent = _store.getInt(_translationScalePercentKey);
    final cleanReadingMode = _store.getBool(_cleanReadingModeKey);
    final showWordByWord = _store.getBool(_showWordByWordKey);

    state = state.copyWith(
      translationCode: (code != null && quranTranslationCodes.contains(code))
          ? code
          : state.translationCode,
      showTransliteration: showTransliteration ?? state.showTransliteration,
      showTranslation: showTranslation ?? state.showTranslation,
      arabicScalePercent: arabicScalePercent ?? state.arabicScalePercent,
      translationScalePercent:
          translationScalePercent ?? state.translationScalePercent,
      cleanReadingMode: cleanReadingMode ?? state.cleanReadingMode,
      showWordByWord: showWordByWord ?? state.showWordByWord,
    );
  }
}

class QuranReadingProgressNotifier extends StateNotifier<QuranReadingProgress> {
  QuranReadingProgressNotifier(this._store)
    : super(
        QuranReadingProgress(
          surahNumber: 2,
          ayahNumber: 45,
          updatedAtIso: DateTime.now().toIso8601String(),
        ),
      ) {
    _load();
  }

  final LocalStore _store;

  void setProgress({required int surahNumber, required int ayahNumber}) {
    state = QuranReadingProgress(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_progressKey, state.toJson());
    _pushRecentReading(surahNumber: surahNumber, ayahNumber: ayahNumber);
  }

  void touchLocation({required int surahNumber, required int ayahNumber}) {
    state = state.copyWith(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_progressKey, state.toJson());
    _pushRecentReading(surahNumber: surahNumber, ayahNumber: ayahNumber);
  }

  void _load() {
    state =
        QuranReadingProgress.fromJson(_store.getJsonMap(_progressKey)) ?? state;
  }

  void _pushRecentReading({required int surahNumber, required int ayahNumber}) {
    final raw = _store.getJsonList(_recentReadingsKey) ?? const [];
    final nowIso = DateTime.now().toIso8601String();
    final nextEntry = QuranRecentReading(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      openedAtIso: nowIso,
    );

    final merged = <QuranRecentReading>[nextEntry];
    for (final row in raw) {
      final existing = QuranRecentReading.fromJson(row);
      if (existing == null) continue;
      final isSame =
          existing.surahNumber == surahNumber &&
          existing.ayahNumber == ayahNumber;
      if (isSame) continue;
      merged.add(existing);
      if (merged.length >= 12) break;
    }
    _store.setJsonList(
      _recentReadingsKey,
      merged.map((item) => item.toJson()).toList(),
    );
  }
}

class QuranBookmarksNotifier extends StateNotifier<List<QuranBookmark>> {
  QuranBookmarksNotifier(this._store) : super(const []) {
    _load();
  }

  final LocalStore _store;

  bool isBookmarked(int surahNumber, int ayahNumber) {
    for (final bookmark in state) {
      if (bookmark.surahNumber == surahNumber &&
          bookmark.ayahNumber == ayahNumber) {
        return true;
      }
    }
    return false;
  }

  void toggleBookmark({required int surahNumber, required int ayahNumber}) {
    if (isBookmarked(surahNumber, ayahNumber)) {
      state = state
          .where(
            (bookmark) =>
                bookmark.surahNumber != surahNumber ||
                bookmark.ayahNumber != ayahNumber,
          )
          .toList();
    } else {
      state = [
        QuranBookmark(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          createdAtIso: DateTime.now().toIso8601String(),
        ),
        ...state,
      ];
    }
    _save();
  }

  void remove(String createdAtIso) {
    state = state
        .where((bookmark) => bookmark.createdAtIso != createdAtIso)
        .toList();
    _save();
  }

  void _load() {
    final data = _store.getJsonList(_bookmarksKey);
    if (data == null) return;
    final items = <QuranBookmark>[];
    for (final row in data) {
      final bookmark = QuranBookmark.fromJson(row);
      if (bookmark != null) {
        items.add(bookmark);
      }
    }
    state = items;
  }

  void _save() {
    _store.setJsonList(
      _bookmarksKey,
      state.map((bookmark) => bookmark.toJson()).toList(),
    );
  }
}

class QuranNotesNotifier extends StateNotifier<List<QuranNote>> {
  QuranNotesNotifier(this._store) : super(const []) {
    _load();
  }

  final LocalStore _store;

  void addNote({
    required int surahNumber,
    required int ayahNumber,
    required String text,
    List<String> tags = const [],
    String folder = 'General',
    bool isHighlight = false,
    String? highlightLabel,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final note = QuranNote(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      text: trimmed,
      createdAtIso: DateTime.now().toIso8601String(),
      tags: tags,
      folder: folder.trim().isEmpty ? 'General' : folder.trim(),
      isHighlight: isHighlight,
      highlightLabel: highlightLabel?.trim().isEmpty == true
          ? null
          : highlightLabel?.trim(),
    );

    state = [note, ...state];
    _save();
  }

  void removeById(String id) {
    state = state.where((note) => note.id != id).toList();
    _save();
  }

  void _load() {
    final data = _store.getJsonList(_notesKey);
    if (data == null) return;
    final items = <QuranNote>[];
    for (final row in data) {
      final note = QuranNote.fromJson(row);
      if (note != null) {
        items.add(note);
      }
    }
    state = items;
  }

  void _save() {
    _store.setJsonList(_notesKey, state.map((note) => note.toJson()).toList());
  }
}

class QuranWordFavoritesNotifier
    extends StateNotifier<List<QuranWordFavorite>> {
  QuranWordFavoritesNotifier(this._store) : super(const []) {
    _load();
  }

  final LocalStore _store;

  bool isPinned(String arabic) {
    return state.any((item) => item.arabic == arabic);
  }

  void togglePin({
    required String arabic,
    required String gloss,
    required String transliteration,
  }) {
    if (isPinned(arabic)) {
      state = state.where((item) => item.arabic != arabic).toList();
      _save();
      return;
    }
    state = [
      QuranWordFavorite(
        arabic: arabic,
        gloss: gloss,
        transliteration: transliteration,
        pinnedAtIso: DateTime.now().toIso8601String(),
        reviewCount: 0,
        lastReviewedAtIso: null,
      ),
      ...state,
    ];
    _save();
  }

  void markReviewed(String arabic) {
    state = [
      for (final item in state)
        if (item.arabic == arabic)
          item.copyWith(
            reviewCount: item.reviewCount + 1,
            lastReviewedAtIso: DateTime.now().toIso8601String(),
          )
        else
          item,
    ];
    _save();
  }

  void _load() {
    final data = _store.getJsonList(_wordFavoritesKey);
    if (data == null) return;
    final output = <QuranWordFavorite>[];
    for (final row in data) {
      if (row is! Map<String, dynamic>) continue;
      final item = QuranWordFavorite.fromJson(row);
      if (item != null) output.add(item);
    }
    state = output;
  }

  void _save() {
    _store.setJsonList(
      _wordFavoritesKey,
      state.map((item) => item.toJson()).toList(),
    );
  }
}

class QuranWordReviewProgressNotifier extends StateNotifier<Map<String, int>> {
  QuranWordReviewProgressNotifier(this._store) : super(const {}) {
    _load();
  }

  final LocalStore _store;

  void grade(String arabic, int score) {
    final next = Map<String, int>.from(state);
    next[arabic] = (next[arabic] ?? 0) + score.clamp(1, 3);
    state = next;
    _store.setJsonMap(_wordReviewProgressKey, next);
  }

  void _load() {
    final data = _store.getJsonMap(_wordReviewProgressKey);
    if (data == null) return;
    final output = <String, int>{};
    for (final entry in data.entries) {
      final value = (entry.value as num?)?.toInt() ?? 0;
      if (value > 0) output[entry.key] = value;
    }
    state = output;
  }
}

class QuranAudioSettingsNotifier extends StateNotifier<QuranAudioSettings> {
  QuranAudioSettingsNotifier(this._store)
    : super(QuranAudioSettings.fromJson(_store.getJsonMap(_audioSettingsKey)));

  final LocalStore _store;

  void setPlaybackSpeed(double speed) {
    state = state.copyWith(playbackSpeed: speed.clamp(0.6, 1.2));
    _save();
  }

  void setRepeatRange({required int? startAyah, required int? endAyah}) {
    if (startAyah == null || endAyah == null || endAyah < startAyah) {
      state = state.copyWith(clearRange: true);
      _save();
      return;
    }
    state = state.copyWith(repeatStartAyah: startAyah, repeatEndAyah: endAyah);
    _save();
  }

  void setAyahLoopCount(int count) {
    state = state.copyWith(ayahLoopCount: count.clamp(1, 12));
    _save();
  }

  void _save() {
    _store.setJsonMap(_audioSettingsKey, state.toJson());
  }
}

class QuranHifzSettingsNotifier extends StateNotifier<QuranHifzSettings> {
  QuranHifzSettingsNotifier(this._store)
    : super(QuranHifzSettings.fromJson(_store.getJsonMap(_hifzSettingsKey)));

  final LocalStore _store;

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _save();
  }

  void setRevealMode(HifzRevealMode mode) {
    state = state.copyWith(revealMode: mode);
    _save();
  }

  void markMistakeCheckpoint({
    required int surahNumber,
    required int ayahNumber,
  }) {
    final key = '$surahNumber:$ayahNumber';
    final next = Map<String, int>.from(state.checkpointMistakes);
    next[key] = (next[key] ?? 0) + 1;
    state = state.copyWith(checkpointMistakes: next);
    _save();
  }

  void setDailyRevisionTarget(int target) {
    state = state.copyWith(dailyRevisionTarget: target.clamp(1, 25));
    _save();
  }

  void _save() {
    _store.setJsonMap(_hifzSettingsKey, state.toJson());
  }
}

class QuranNotesFilterNotifier extends StateNotifier<QuranNotesFilterState> {
  QuranNotesFilterNotifier(this._store)
    : super(
        QuranNotesFilterState(
          folder: _store.getString(_notesFilterFolderKey) ?? 'All',
          tag: _store.getString(_notesFilterTagKey) ?? 'All',
        ),
      );

  final LocalStore _store;

  void setFolder(String folder) {
    state = state.copyWith(folder: folder);
    _store.setString(_notesFilterFolderKey, folder);
  }

  void setTag(String tag) {
    state = state.copyWith(tag: tag);
    _store.setString(_notesFilterTagKey, tag);
  }
}

class QuranRecentSearchesNotifier extends StateNotifier<List<String>> {
  QuranRecentSearchesNotifier(this._store) : super(const []) {
    _load();
  }

  final LocalStore _store;

  void addSearch(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final next = [
      normalized,
      ...state.where((item) => item.toLowerCase() != normalized.toLowerCase()),
    ];
    state = next.take(10).toList();
    _store.setJsonList(_recentSearchesKey, state);
  }

  void clear() {
    state = const [];
    _store.remove(_recentSearchesKey);
  }

  void _load() {
    final data = _store.getJsonList(_recentSearchesKey);
    if (data == null) return;
    state = data
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class QuranSearchResult {
  const QuranSearchResult({
    required this.surah,
    this.ayah,
    required this.matchText,
  });

  final QuranSurah surah;
  final QuranAyah? ayah;
  final String matchText;
}

class QuranContinueReadingSummary {
  const QuranContinueReadingSummary({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.locationLabel,
  });

  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String locationLabel;
}

class QuranRecentReading {
  const QuranRecentReading({
    required this.surahNumber,
    required this.ayahNumber,
    required this.openedAtIso,
  });

  final int surahNumber;
  final int ayahNumber;
  final String openedAtIso;

  Map<String, dynamic> toJson() => {
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'openedAtIso': openedAtIso,
  };

  static QuranRecentReading? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final surahNumber = json['surahNumber'];
    final ayahNumber = json['ayahNumber'];
    final openedAtIso = json['openedAtIso']?.toString();
    if (surahNumber is! int || ayahNumber is! int || openedAtIso == null) {
      return null;
    }
    return QuranRecentReading(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      openedAtIso: openedAtIso,
    );
  }
}

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository();
});

final quranReaderSettingsProvider =
    StateNotifierProvider<QuranReaderSettingsNotifier, QuranReaderSettings>(
      (ref) => QuranReaderSettingsNotifier(ref.watch(localStoreProvider)),
    );

final quranReadingProgressProvider =
    StateNotifierProvider<QuranReadingProgressNotifier, QuranReadingProgress>(
      (ref) => QuranReadingProgressNotifier(ref.watch(localStoreProvider)),
    );

final quranBookmarksProvider =
    StateNotifierProvider<QuranBookmarksNotifier, List<QuranBookmark>>(
      (ref) => QuranBookmarksNotifier(ref.watch(localStoreProvider)),
    );

final quranNotesProvider =
    StateNotifierProvider<QuranNotesNotifier, List<QuranNote>>(
      (ref) => QuranNotesNotifier(ref.watch(localStoreProvider)),
    );

final quranWordFavoritesProvider =
    StateNotifierProvider<QuranWordFavoritesNotifier, List<QuranWordFavorite>>(
      (ref) => QuranWordFavoritesNotifier(ref.watch(localStoreProvider)),
    );

final quranWordReviewProgressProvider =
    StateNotifierProvider<QuranWordReviewProgressNotifier, Map<String, int>>(
      (ref) => QuranWordReviewProgressNotifier(ref.watch(localStoreProvider)),
    );

final quranAudioSettingsProvider =
    StateNotifierProvider<QuranAudioSettingsNotifier, QuranAudioSettings>(
      (ref) => QuranAudioSettingsNotifier(ref.watch(localStoreProvider)),
    );

final quranHifzSettingsProvider =
    StateNotifierProvider<QuranHifzSettingsNotifier, QuranHifzSettings>(
      (ref) => QuranHifzSettingsNotifier(ref.watch(localStoreProvider)),
    );

final quranNotesFilterProvider =
    StateNotifierProvider<QuranNotesFilterNotifier, QuranNotesFilterState>(
      (ref) => QuranNotesFilterNotifier(ref.watch(localStoreProvider)),
    );

final quranRecentSearchesProvider =
    StateNotifierProvider<QuranRecentSearchesNotifier, List<String>>(
      (ref) => QuranRecentSearchesNotifier(ref.watch(localStoreProvider)),
    );

final quranRecentReadingsProvider = Provider<List<QuranRecentReading>>((ref) {
  ref.watch(quranReadingProgressProvider);
  final store = ref.watch(localStoreProvider);
  final data = store.getJsonList(_recentReadingsKey);
  if (data == null) return const [];
  final readings = <QuranRecentReading>[];
  for (final row in data) {
    final reading = QuranRecentReading.fromJson(row);
    if (reading != null) readings.add(reading);
  }
  return readings;
});

final quranSurahListProvider = Provider<List<QuranSurah>>((ref) {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getSurahs();
});

final quranSurahMapProvider = Provider<Map<int, QuranSurah>>((ref) {
  final map = <int, QuranSurah>{};
  for (final surah in ref.watch(quranSurahListProvider)) {
    map[surah.number] = surah;
  }
  return map;
});

final quranDailyVerseProvider = Provider<QuranDailyVerse>((ref) {
  final repository = ref.watch(quranRepositoryProvider);
  final translationCode = ref.watch(
    quranReaderSettingsProvider.select((state) => state.translationCode),
  );
  return repository.getDailyVerse(
    date: DateTime.now(),
    translationCode: translationCode,
  );
});

final quranContinueReadingSummaryProvider =
    Provider<QuranContinueReadingSummary>((ref) {
      final progress = ref.watch(quranReadingProgressProvider);
      final surahMap = ref.watch(quranSurahMapProvider);
      final surahList = ref.watch(quranSurahListProvider);
      final surah = surahMap[progress.surahNumber] ?? surahList.first;
      return QuranContinueReadingSummary(
        surahNumber: surah.number,
        surahName: surah.transliteratedName,
        ayahNumber: progress.ayahNumber,
        locationLabel:
            '${surah.transliteratedName} ${surah.number}:${progress.ayahNumber}',
      );
    });

final quranReadingStreakProvider = Provider<int>((ref) {
  final progress = ref.watch(quranReadingProgressProvider);
  final updated = DateTime.tryParse(progress.updatedAtIso);
  if (updated == null) return 0;
  final days = DateTime.now().difference(updated).inDays;
  if (days <= 1) return 3;
  if (days <= 3) return 2;
  return 1;
});

final quranProgressRatioProvider = Provider<double>((ref) {
  final progress = ref.watch(quranReadingProgressProvider);
  final surah = ref.watch(quranSurahMapProvider)[progress.surahNumber];
  if (surah == null || surah.verseCount == 0) return 0;
  return (progress.ayahNumber / surah.verseCount).clamp(0.0, 1.0).toDouble();
});

final quranSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final quranFilteredSurahListProvider = Provider.autoDispose<List<QuranSurah>>((
  ref,
) {
  final query = ref.watch(quranSearchQueryProvider).trim();
  final normalized = query.toLowerCase();
  final surahs = ref.watch(quranSurahListProvider);
  if (normalized.isEmpty) return surahs;
  return surahs.where((surah) {
    return surah.transliteratedName.toLowerCase().contains(normalized) ||
        surah.englishName.toLowerCase().contains(normalized) ||
        surah.arabicName.contains(query) ||
        surah.number.toString() == normalized;
  }).toList();
});

final quranSearchResultsProvider =
    Provider.autoDispose<List<QuranSearchResult>>((ref) {
      final query = ref.watch(quranSearchQueryProvider).trim();
      if (query.isEmpty) return const [];
      final translationCode = ref.watch(
        quranReaderSettingsProvider.select((state) => state.translationCode),
      );
      final repository = ref.watch(quranRepositoryProvider);
      final rows = repository.search(
        query,
        translationCode: translationCode,
        maxResults: 80,
      );

      return rows.map((row) {
        return QuranSearchResult(
          surah: row.surah,
          ayah: row.ayahNumber == null
              ? null
              : QuranAyah(
                  surahNumber: row.surah.number,
                  ayahNumber: row.ayahNumber!,
                  arabic: '',
                  translation: row.matchText,
                ),
          matchText: row.matchText,
        );
      }).toList();
    });

final quranWordReviewDeckProvider = Provider<List<QuranWordFavorite>>((ref) {
  final favorites = ref.watch(quranWordFavoritesProvider);
  final progress = ref.watch(quranWordReviewProgressProvider);
  final sorted = [...favorites]
    ..sort((a, b) {
      final scoreA = progress[a.arabic] ?? 0;
      final scoreB = progress[b.arabic] ?? 0;
      if (scoreA != scoreB) return scoreA.compareTo(scoreB);
      return a.reviewCount.compareTo(b.reviewCount);
    });
  return sorted;
});

final quranNotesFoldersProvider = Provider<List<String>>((ref) {
  final notes = ref.watch(quranNotesProvider);
  final folders = <String>{'All'};
  for (final note in notes) {
    folders.add(note.folder);
  }
  final ordered = folders.toList()..sort();
  return ordered;
});

final quranNotesTagsProvider = Provider<List<String>>((ref) {
  final notes = ref.watch(quranNotesProvider);
  final tags = <String>{'All'};
  for (final note in notes) {
    tags.addAll(note.tags);
  }
  final ordered = tags.toList()..sort();
  return ordered;
});

final quranFilteredNotesProvider = Provider<List<QuranNote>>((ref) {
  final notes = ref.watch(quranNotesProvider);
  final filter = ref.watch(quranNotesFilterProvider);
  return notes.where((note) {
    final folderOk = filter.folder == 'All' || note.folder == filter.folder;
    final tagOk = filter.tag == 'All' || note.tags.contains(filter.tag);
    return folderOk && tagOk;
  }).toList();
});

class QuranRevisionItem {
  const QuranRevisionItem({
    required this.surahNumber,
    required this.ayahNumber,
    required this.reason,
  });

  final int surahNumber;
  final int ayahNumber;
  final String reason;
}

final quranDailyRevisionPlanProvider = Provider<List<QuranRevisionItem>>((ref) {
  final hifz = ref.watch(quranHifzSettingsProvider);
  final progress = ref.watch(quranReadingProgressProvider);
  final output = <QuranRevisionItem>[];
  final sortedCheckpoints = [...hifz.checkpointMistakes.entries]
    ..sort((a, b) => b.value.compareTo(a.value));

  for (final entry in sortedCheckpoints.take(hifz.dailyRevisionTarget)) {
    final parts = entry.key.split(':');
    if (parts.length != 2) continue;
    final surah = int.tryParse(parts[0]);
    final ayah = int.tryParse(parts[1]);
    if (surah == null || ayah == null) continue;
    output.add(
      QuranRevisionItem(
        surahNumber: surah,
        ayahNumber: ayah,
        reason: 'Checkpoint mistakes: ${entry.value}',
      ),
    );
  }

  var currentAyah = progress.ayahNumber;
  while (output.length < hifz.dailyRevisionTarget && currentAyah > 1) {
    currentAyah -= 1;
    output.add(
      QuranRevisionItem(
        surahNumber: progress.surahNumber,
        ayahNumber: currentAyah,
        reason: 'Recent continuity',
      ),
    );
  }

  return output;
});

final quranSurahAyahsProvider = Provider.family<List<QuranAyah>, int>((
  ref,
  surahNumber,
) {
  final translationCode = ref.watch(
    quranReaderSettingsProvider.select((state) => state.translationCode),
  );
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getAyahsForSurah(
    surahNumber,
    translationCode: translationCode,
  );
});
