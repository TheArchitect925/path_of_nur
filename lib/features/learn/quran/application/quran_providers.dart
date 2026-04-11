import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import 'quran_playback_orchestrator.dart';
import 'quran_playback_policy.dart';
import 'quran_search_normalization.dart';
import 'quran_search_support.dart';
import 'quran_note_enrichment.dart';
import '../data/quran_audio_repository.dart';
import '../data/quran_content_repository.dart';
import '../data/quran_repository.dart';
import '../data/quran_transliteration_repository.dart';
import '../data/quran_word_timing_repository.dart';
import '../domain/bismillah_playback_mode.dart';
import '../domain/quran_ayah.dart';
import '../domain/quran_bookmark.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_daily_verse.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_note.dart';
import '../domain/quran_reading_progress.dart';
import '../domain/quran_surah.dart';

const _progressKey = 'learn.quran.readingProgress';
const _readingStatsKey = 'learn.quran.readingStats';
const _listeningStatsKey = 'learn.quran.listeningStats';
const _bookmarksKey = 'learn.quran.bookmarks';
const _notesKey = 'learn.quran.notes';
const _recentSearchesKey = 'learn.quran.recentSearches';
const _savedSearchesKey = 'learn.quran.savedSearches';
const _recentReadingsKey = 'learn.quran.recentReadings';
const _translationCodeKey = 'learn.quran.translationCode';
const _showArabicKey = 'learn.quran.showArabic';
const _showTransliterationKey = 'learn.quran.showTransliteration';
const _showTranslationKey = 'learn.quran.showTranslation';
const _arabicScalePercentKey = 'learn.quran.arabicScalePercent';
const _translationScalePercentKey = 'learn.quran.translationScalePercent';
const _transliterationScalePercentKey =
    'learn.quran.transliterationScalePercent';
const _cleanReadingModeKey = 'learn.quran.cleanReadingMode';
const _showWordByWordKey = 'learn.quran.showWordByWord';
const _followPlaybackKey = 'learn.quran.followPlayback';
const _wordSyncHighlightBetaKey = 'learn.quran.wordSyncHighlightBeta';
const _redDiacriticsKey = 'learn.quran.redDiacriticsEnabled';
const _showLearnMoreKey = 'learn.quran.showLearnMore';
const _explanationDetailLevelKey = 'learn.quran.explanationDetailLevel';
const _focusRecitationShowTranslationKey =
    'learn.quran.focusRecitationShowTranslation';
const _focusRecitationShowTransliterationKey =
    'learn.quran.focusRecitationShowTransliteration';
const _focusRecitationKeepScreenAwakeKey =
    'learn.quran.focusRecitationKeepScreenAwake';
const _kidsExplanationEnabledKey = 'learn.quran.kidsExplanationEnabled';
const _wordFavoritesKey = 'learn.quran.wordFavorites';
const _wordReviewProgressKey = 'learn.quran.wordReviewProgress';
const _audioSettingsKey = 'learn.quran.audioSettings';
const _hifzSettingsKey = 'learn.quran.hifzSettings';
const _notesFilterFolderKey = 'learn.quran.notesFilterFolder';
const _notesFilterTagKey = 'learn.quran.notesFilterTag';
const _recitationSessionKey = 'learn.quran.recitationSession';

const quranTranslationCodes = <String>[
  'en.sahih',
  'en.clear',
  'ur.urdu',
  'bn.bengali',
  'id.indonesian',
  'tr.saheeh',
  'fa.dari',
];

final quranAudioFunctionEnabledProvider = Provider<bool>((ref) => true);

final quranExpandedPlayerOpenProvider = StateProvider<bool>((ref) => false);
final quranFocusRecitationOpenProvider = StateProvider<bool>((ref) => false);

class QuranReaderSettings {
  const QuranReaderSettings({
    required this.translationCode,
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.arabicScalePercent,
    required this.translationScalePercent,
    required this.transliterationScalePercent,
    required this.cleanReadingMode,
    required this.showWordByWord,
    required this.followPlayback,
    required this.wordSyncHighlightBeta,
    required this.redDiacriticsEnabled,
    required this.showLearnMore,
    required this.explanationDetailLevel,
    required this.focusRecitationShowTranslation,
    required this.focusRecitationShowTransliteration,
    required this.focusRecitationKeepScreenAwake,
  });

  final String translationCode;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final int arabicScalePercent;
  final int translationScalePercent;
  final int transliterationScalePercent;
  final bool cleanReadingMode;
  final bool showWordByWord;
  final bool followPlayback;
  final bool wordSyncHighlightBeta;
  final bool redDiacriticsEnabled;
  final bool showLearnMore;
  final QuranExplanationDetailLevel explanationDetailLevel;
  final bool focusRecitationShowTranslation;
  final bool focusRecitationShowTransliteration;
  final bool focusRecitationKeepScreenAwake;

  QuranReaderSettings copyWith({
    String? translationCode,
    bool? showArabic,
    bool? showTransliteration,
    bool? showTranslation,
    int? arabicScalePercent,
    int? translationScalePercent,
    int? transliterationScalePercent,
    bool? cleanReadingMode,
    bool? showWordByWord,
    bool? followPlayback,
    bool? wordSyncHighlightBeta,
    bool? redDiacriticsEnabled,
    bool? showLearnMore,
    QuranExplanationDetailLevel? explanationDetailLevel,
    bool? focusRecitationShowTranslation,
    bool? focusRecitationShowTransliteration,
    bool? focusRecitationKeepScreenAwake,
  }) {
    return QuranReaderSettings(
      translationCode: translationCode ?? this.translationCode,
      showArabic: showArabic ?? this.showArabic,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      arabicScalePercent: arabicScalePercent ?? this.arabicScalePercent,
      translationScalePercent:
          translationScalePercent ?? this.translationScalePercent,
      transliterationScalePercent:
          transliterationScalePercent ?? this.transliterationScalePercent,
      cleanReadingMode: cleanReadingMode ?? this.cleanReadingMode,
      showWordByWord: showWordByWord ?? this.showWordByWord,
      followPlayback: followPlayback ?? this.followPlayback,
      wordSyncHighlightBeta:
          wordSyncHighlightBeta ?? this.wordSyncHighlightBeta,
      redDiacriticsEnabled: redDiacriticsEnabled ?? this.redDiacriticsEnabled,
      showLearnMore: showLearnMore ?? this.showLearnMore,
      explanationDetailLevel:
          explanationDetailLevel ?? this.explanationDetailLevel,
      focusRecitationShowTranslation:
          focusRecitationShowTranslation ?? this.focusRecitationShowTranslation,
      focusRecitationShowTransliteration:
          focusRecitationShowTransliteration ??
          this.focusRecitationShowTransliteration,
      focusRecitationKeepScreenAwake:
          focusRecitationKeepScreenAwake ?? this.focusRecitationKeepScreenAwake,
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
    required this.reciterId,
    required this.backgroundPlaybackEnabled,
  });

  final double playbackSpeed;
  final int? repeatStartAyah;
  final int? repeatEndAyah;
  final int ayahLoopCount;
  final String reciterId;
  final bool backgroundPlaybackEnabled;

  QuranAudioSettings copyWith({
    double? playbackSpeed,
    int? repeatStartAyah,
    int? repeatEndAyah,
    int? ayahLoopCount,
    String? reciterId,
    bool? backgroundPlaybackEnabled,
    bool clearRange = false,
  }) {
    return QuranAudioSettings(
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      repeatStartAyah: clearRange
          ? null
          : repeatStartAyah ?? this.repeatStartAyah,
      repeatEndAyah: clearRange ? null : repeatEndAyah ?? this.repeatEndAyah,
      ayahLoopCount: ayahLoopCount ?? this.ayahLoopCount,
      reciterId: reciterId ?? this.reciterId,
      backgroundPlaybackEnabled:
          backgroundPlaybackEnabled ?? this.backgroundPlaybackEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'playbackSpeed': playbackSpeed,
    'repeatStartAyah': repeatStartAyah,
    'repeatEndAyah': repeatEndAyah,
    'ayahLoopCount': ayahLoopCount,
    'reciterId': reciterId,
    'backgroundPlaybackEnabled': backgroundPlaybackEnabled,
  };

  static QuranAudioSettings fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranAudioSettings(
        playbackSpeed: 1.0,
        repeatStartAyah: null,
        repeatEndAyah: null,
        ayahLoopCount: 1,
        reciterId: QuranAudioRepository.defaultReciterId,
        backgroundPlaybackEnabled: true,
      );
    }
    final rawReciterId = json['reciterId']?.toString();
    const defaultReciterId = QuranAudioRepository.defaultReciterId;
    final reciterId =
        QuranAudioRepository.reciters.any((item) => item.id == rawReciterId)
        ? rawReciterId!
        : defaultReciterId;
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
      reciterId: reciterId,
      backgroundPlaybackEnabled:
          (json['backgroundPlaybackEnabled'] as bool?) ?? true,
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

class KidsQuranExplanationSettings {
  const KidsQuranExplanationSettings({required this.enabled});

  final bool enabled;

  KidsQuranExplanationSettings copyWith({bool? enabled}) {
    return KidsQuranExplanationSettings(enabled: enabled ?? this.enabled);
  }
}

class QuranReaderSettingsNotifier extends StateNotifier<QuranReaderSettings> {
  QuranReaderSettingsNotifier(this._store)
    : super(
        const QuranReaderSettings(
          translationCode: 'en.sahih',
          showArabic: true,
          showTransliteration: true,
          showTranslation: true,
          arabicScalePercent: 100,
          translationScalePercent: 100,
          transliterationScalePercent: 100,
          cleanReadingMode: false,
          showWordByWord: false,
          followPlayback: true,
          wordSyncHighlightBeta: false,
          redDiacriticsEnabled: true,
          showLearnMore: true,
          explanationDetailLevel: QuranExplanationDetailLevel.off,
          focusRecitationShowTranslation: true,
          focusRecitationShowTransliteration: true,
          focusRecitationKeepScreenAwake: false,
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

  void setShowArabic(bool value) {
    state = state.copyWith(showArabic: value);
    _store.setBool(_showArabicKey, value);
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

  void setTransliterationScalePercent(int value) {
    final clamped = value.clamp(85, 140);
    state = state.copyWith(transliterationScalePercent: clamped);
    _store.setInt(_transliterationScalePercentKey, clamped);
  }

  void setCleanReadingMode(bool value) {
    state = state.copyWith(cleanReadingMode: value);
    _store.setBool(_cleanReadingModeKey, value);
  }

  void setShowWordByWord(bool value) {
    state = state.copyWith(showWordByWord: value);
    _store.setBool(_showWordByWordKey, value);
  }

  void setFollowPlayback(bool value) {
    state = state.copyWith(followPlayback: value);
    _store.setBool(_followPlaybackKey, value);
  }

  void setWordSyncHighlightBeta(bool value) {
    state = state.copyWith(wordSyncHighlightBeta: value);
    _store.setBool(_wordSyncHighlightBetaKey, value);
  }

  void setRedDiacriticsEnabled(bool value) {
    state = state.copyWith(redDiacriticsEnabled: value);
    _store.setBool(_redDiacriticsKey, value);
  }

  void setShowLearnMore(bool value) {
    state = state.copyWith(showLearnMore: value);
    _store.setBool(_showLearnMoreKey, value);
  }

  void setExplanationDetailLevel(QuranExplanationDetailLevel value) {
    state = state.copyWith(explanationDetailLevel: value);
    _store.setString(_explanationDetailLevelKey, value.wireName);
  }

  void setFocusRecitationShowTranslation(bool value) {
    state = state.copyWith(focusRecitationShowTranslation: value);
    _store.setBool(_focusRecitationShowTranslationKey, value);
  }

  void setFocusRecitationShowTransliteration(bool value) {
    state = state.copyWith(focusRecitationShowTransliteration: value);
    _store.setBool(_focusRecitationShowTransliterationKey, value);
  }

  void setFocusRecitationKeepScreenAwake(bool value) {
    state = state.copyWith(focusRecitationKeepScreenAwake: value);
    _store.setBool(_focusRecitationKeepScreenAwakeKey, value);
  }

  void _load() {
    final code = _store.getString(_translationCodeKey);
    final showArabic = _store.getBool(_showArabicKey);
    final showTransliteration = _store.getBool(_showTransliterationKey);
    final showTranslation = _store.getBool(_showTranslationKey);
    final arabicScalePercent = _store.getInt(_arabicScalePercentKey);
    final translationScalePercent = _store.getInt(_translationScalePercentKey);
    final transliterationScalePercent = _store.getInt(
      _transliterationScalePercentKey,
    );
    final cleanReadingMode = _store.getBool(_cleanReadingModeKey);
    final showWordByWord = _store.getBool(_showWordByWordKey);
    final followPlayback = _store.getBool(_followPlaybackKey);
    final wordSyncHighlightBeta = _store.getBool(_wordSyncHighlightBetaKey);
    final redDiacriticsEnabled = _store.getBool(_redDiacriticsKey);
    final showLearnMore = _store.getBool(_showLearnMoreKey);
    final explanationDetailLevel = QuranExplanationDetailLevel.tryParse(
      _store.getString(_explanationDetailLevelKey),
    );
    final focusRecitationShowTranslation = _store.getBool(
      _focusRecitationShowTranslationKey,
    );
    final focusRecitationShowTransliteration = _store.getBool(
      _focusRecitationShowTransliterationKey,
    );
    final focusRecitationKeepScreenAwake = _store.getBool(
      _focusRecitationKeepScreenAwakeKey,
    );

    state = state.copyWith(
      translationCode: (code != null && quranTranslationCodes.contains(code))
          ? code
          : state.translationCode,
      showArabic: showArabic ?? state.showArabic,
      showTransliteration: showTransliteration ?? state.showTransliteration,
      showTranslation: showTranslation ?? state.showTranslation,
      arabicScalePercent: arabicScalePercent ?? state.arabicScalePercent,
      translationScalePercent:
          translationScalePercent ?? state.translationScalePercent,
      transliterationScalePercent:
          transliterationScalePercent ?? state.transliterationScalePercent,
      cleanReadingMode: cleanReadingMode ?? state.cleanReadingMode,
      showWordByWord: showWordByWord ?? state.showWordByWord,
      followPlayback: followPlayback ?? state.followPlayback,
      wordSyncHighlightBeta:
          wordSyncHighlightBeta ?? state.wordSyncHighlightBeta,
      redDiacriticsEnabled: redDiacriticsEnabled ?? state.redDiacriticsEnabled,
      showLearnMore: showLearnMore ?? state.showLearnMore,
      explanationDetailLevel:
          explanationDetailLevel ?? state.explanationDetailLevel,
      focusRecitationShowTranslation:
          focusRecitationShowTranslation ?? state.showTranslation,
      focusRecitationShowTransliteration:
          focusRecitationShowTransliteration ?? state.showTransliteration,
      focusRecitationKeepScreenAwake:
          focusRecitationKeepScreenAwake ??
          state.focusRecitationKeepScreenAwake,
    );
  }
}

class KidsQuranExplanationSettingsNotifier
    extends StateNotifier<KidsQuranExplanationSettings> {
  KidsQuranExplanationSettingsNotifier(this._store)
    : super(const KidsQuranExplanationSettings(enabled: true)) {
    _load();
  }

  final LocalStore _store;

  void setEnabled(bool value) {
    state = state.copyWith(enabled: value);
    _store.setBool(_kidsExplanationEnabledKey, value);
  }

  void _load() {
    final enabled = _store.getBool(_kidsExplanationEnabledKey);
    state = state.copyWith(enabled: enabled ?? state.enabled);
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

class QuranReadingStatsNotifier extends StateNotifier<QuranReadingStats> {
  QuranReadingStatsNotifier(this._store)
    : super(QuranReadingStats.fromJson(_store.getJsonMap(_readingStatsKey)));

  final LocalStore _store;

  void logReadingSession({required Duration duration, DateTime? completedAt}) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final seconds = safeDuration.inSeconds;
    if (seconds < 15) return;

    final endedAt = completedAt ?? DateTime.now();
    final dayKey = LocalStore.todayKey(endedAt);
    final nextByDay = Map<String, int>.from(state.secondsByDayKey);
    nextByDay.update(
      dayKey,
      (value) => value + seconds,
      ifAbsent: () => seconds,
    );
    state = state.copyWith(
      totalReadingSeconds: state.totalReadingSeconds + seconds,
      totalSessions: state.totalSessions + 1,
      secondsByDayKey: nextByDay,
      lastSessionEndedAtIso: endedAt.toIso8601String(),
    );
    _store.setJsonMap(_readingStatsKey, state.toJson());
  }
}

class QuranListeningStatsNotifier extends StateNotifier<QuranListeningStats> {
  QuranListeningStatsNotifier(this._store)
    : super(
        QuranListeningStats.fromJson(_store.getJsonMap(_listeningStatsKey)),
      );

  final LocalStore _store;
  AudioPlayer? _boundPlayer;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  Duration _lastPosition = Duration.zero;
  Duration _sessionAccumulated = Duration.zero;
  bool _sessionActive = false;

  void bindPlayer(AudioPlayer player) {
    if (identical(_boundPlayer, player)) return;
    _disposeSubscriptions();
    _boundPlayer = player;
    _playerStateSubscription = player.playerStateStream.listen(
      _handlePlayerState,
    );
    _positionSubscription = player.positionStream.listen(_handlePosition);
  }

  void disposeTracker() {
    _finalizeSession();
    _disposeSubscriptions();
  }

  void _disposeSubscriptions() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription = null;
    _positionSubscription = null;
    _boundPlayer = null;
    _sessionActive = false;
    _lastPosition = Duration.zero;
    _sessionAccumulated = Duration.zero;
  }

  void _handlePlayerState(PlayerState playerState) {
    final shouldTrack =
        playerState.playing &&
        playerState.processingState != ProcessingState.idle &&
        playerState.processingState != ProcessingState.completed;
    if (shouldTrack) {
      if (!_sessionActive) {
        _sessionActive = true;
        _sessionAccumulated = Duration.zero;
        _lastPosition = _boundPlayer?.position ?? Duration.zero;
      }
      return;
    }
    _finalizeSession();
  }

  void _handlePosition(Duration position) {
    if (!_sessionActive) return;
    final delta = position - _lastPosition;
    _lastPosition = position;
    if (delta <= Duration.zero || delta > const Duration(seconds: 5)) {
      return;
    }
    _sessionAccumulated += delta;
  }

  void _finalizeSession() {
    if (!_sessionActive) return;
    _sessionActive = false;
    final duration = _sessionAccumulated;
    _sessionAccumulated = Duration.zero;
    _lastPosition = Duration.zero;
    logListeningSession(duration: duration);
  }

  void logListeningSession({
    required Duration duration,
    DateTime? completedAt,
  }) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final seconds = safeDuration.inSeconds;
    if (seconds < 15) return;

    final endedAt = completedAt ?? DateTime.now();
    final dayKey = LocalStore.todayKey(endedAt);
    final nextByDay = Map<String, int>.from(state.secondsByDayKey);
    nextByDay.update(
      dayKey,
      (value) => value + seconds,
      ifAbsent: () => seconds,
    );
    state = state.copyWith(
      totalListeningSeconds: state.totalListeningSeconds + seconds,
      totalSessions: state.totalSessions + 1,
      secondsByDayKey: nextByDay,
      lastSessionEndedAtIso: endedAt.toIso8601String(),
    );
    _store.setJsonMap(_listeningStatsKey, state.toJson());
  }

  @override
  void dispose() {
    disposeTracker();
    super.dispose();
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
    String folder = quranNotesDefaultFolder,
    String? categoryId,
    bool isHighlight = false,
    String? highlightLabel,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final normalizedTags = <String>[];
    final seenTags = <String>{};
    for (final tag in tags) {
      final trimmedTag = tag.trim();
      if (trimmedTag.isEmpty) continue;
      final normalizedKey = trimmedTag.toLowerCase();
      if (!seenTags.add(normalizedKey)) continue;
      normalizedTags.add(trimmedTag);
    }

    final note = QuranNote(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      text: trimmed,
      createdAtIso: DateTime.now().toIso8601String(),
      tags: normalizedTags,
      folder: folder.trim().isEmpty ? quranNotesDefaultFolder : folder.trim(),
      categoryId: (categoryId?.trim().isNotEmpty == true
          ? categoryId!.trim()
          : quranNotesDefaultCategory.name),
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

  void setReciterId(String reciterId) {
    final exists = QuranAudioRepository.reciters.any(
      (item) => item.id == reciterId,
    );
    if (!exists) return;
    state = state.copyWith(reciterId: reciterId);
    _save();
  }

  void setBackgroundPlaybackEnabled(bool value) {
    state = state.copyWith(backgroundPlaybackEnabled: value);
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

class QuranStoredSearch {
  const QuranStoredSearch({
    required this.query,
    required this.updatedAtIso,
    this.fieldFilter = QuranSearchFieldFilter.all,
  });

  final String query;
  final String updatedAtIso;
  final QuranSearchFieldFilter fieldFilter;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'query': query,
    'updatedAtIso': updatedAtIso,
    'fieldFilter': fieldFilter.wireValue,
  };

  static QuranStoredSearch? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final query = json['query']?.toString().trim();
    if (query == null || query.isEmpty) return null;
    return QuranStoredSearch(
      query: query,
      updatedAtIso:
          json['updatedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
      fieldFilter: QuranSearchFieldFilterX.fromWireValue(
        json['fieldFilter']?.toString(),
      ),
    );
  }
}

class QuranRecentSearchesNotifier
    extends StateNotifier<List<QuranStoredSearch>> {
  QuranRecentSearchesNotifier(this._store) : super(const []) {
    _load();
  }

  final LocalStore _store;

  void addSearch(
    String query, {
    QuranSearchFieldFilter fieldFilter = QuranSearchFieldFilter.all,
  }) {
    final normalized = normalizeQuranSearchText(query);
    final trimmed = query.trim();
    if (trimmed.isEmpty || normalized.isEmpty) return;

    final nextEntry = QuranStoredSearch(
      query: trimmed,
      fieldFilter: fieldFilter,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    final next = <QuranStoredSearch>[
      nextEntry,
      ...state.where(
        (item) => normalizeQuranSearchText(item.query) != normalized,
      ),
    ].take(12).toList(growable: false);
    state = next;
    _store.setJsonList(
      _recentSearchesKey,
      next.map((entry) => entry.toJson()).toList(growable: false),
    );
  }

  void replaceAll(List<QuranStoredSearch> searches) {
    state = searches.take(12).toList(growable: false);
    if (state.isEmpty) {
      _store.remove(_recentSearchesKey);
      return;
    }
    _store.setJsonList(
      _recentSearchesKey,
      state.map((entry) => entry.toJson()).toList(growable: false),
    );
  }

  void clear() {
    state = const [];
    _store.remove(_recentSearchesKey);
  }

  void _load() {
    final data = _store.getJsonList(_recentSearchesKey);
    if (data == null) return;
    final loaded = <QuranStoredSearch>[];
    for (final item in data) {
      if (item is String) {
        final query = item.trim();
        if (query.isNotEmpty) {
          loaded.add(
            QuranStoredSearch(
              query: query,
              updatedAtIso: DateTime.now().toIso8601String(),
            ),
          );
        }
        continue;
      }
      final parsed = item is Map<String, dynamic>
          ? QuranStoredSearch.fromJson(item)
          : item is Map
          ? QuranStoredSearch.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            )
          : null;
      if (parsed != null) {
        loaded.add(parsed);
      }
    }
    state = loaded.take(12).toList(growable: false);
  }
}

class QuranSavedSearchesNotifier
    extends StateNotifier<List<QuranStoredSearch>> {
  QuranSavedSearchesNotifier(this._store) : super(const []) {
    _load();
  }

  final LocalStore _store;

  bool isSaved(
    String query, {
    QuranSearchFieldFilter fieldFilter = QuranSearchFieldFilter.all,
  }) {
    final normalized = normalizeQuranSearchText(query);
    return state.any(
      (item) =>
          normalizeQuranSearchText(item.query) == normalized &&
          item.fieldFilter == fieldFilter,
    );
  }

  void save(
    String query, {
    QuranSearchFieldFilter fieldFilter = QuranSearchFieldFilter.all,
  }) {
    final trimmed = query.trim();
    final normalized = normalizeQuranSearchText(trimmed);
    if (trimmed.isEmpty || normalized.isEmpty) return;
    final nextEntry = QuranStoredSearch(
      query: trimmed,
      fieldFilter: fieldFilter,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    final next = <QuranStoredSearch>[
      nextEntry,
      ...state.where(
        (item) =>
            normalizeQuranSearchText(item.query) != normalized ||
            item.fieldFilter != fieldFilter,
      ),
    ].take(12).toList(growable: false);
    state = next;
    _persist();
  }

  void remove(
    String query, {
    QuranSearchFieldFilter fieldFilter = QuranSearchFieldFilter.all,
  }) {
    final normalized = normalizeQuranSearchText(query);
    state = state
        .where(
          (item) =>
              normalizeQuranSearchText(item.query) != normalized ||
              item.fieldFilter != fieldFilter,
        )
        .toList(growable: false);
    _persist();
  }

  void _load() {
    final data = _store.getJsonList(_savedSearchesKey);
    if (data == null) return;
    final loaded = <QuranStoredSearch>[];
    for (final item in data) {
      final parsed = item is Map<String, dynamic>
          ? QuranStoredSearch.fromJson(item)
          : item is Map
          ? QuranStoredSearch.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            )
          : null;
      if (parsed != null) {
        loaded.add(parsed);
      }
    }
    state = loaded.take(12).toList(growable: false);
  }

  void _persist() {
    if (state.isEmpty) {
      _store.remove(_savedSearchesKey);
      return;
    }
    _store.setJsonList(
      _savedSearchesKey,
      state.map((entry) => entry.toJson()).toList(growable: false),
    );
  }
}

class QuranRecitationSessionNotifier
    extends StateNotifier<QuranRecitationSession?> {
  QuranRecitationSessionNotifier(this._store) : super(null) {
    state = QuranRecitationSession.fromJson(
      _store.getJsonMap(_recitationSessionKey),
    );
  }

  final LocalStore _store;

  void save({
    required int surahNumber,
    required int ayahNumber,
    required int positionSeconds,
  }) {
    state = QuranRecitationSession(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      positionSeconds: positionSeconds.clamp(0, 24 * 60 * 60),
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_recitationSessionKey, state!.toJson());
  }

  void clear() {
    state = null;
    _store.remove(_recitationSessionKey);
  }
}

class QuranSearchResult {
  const QuranSearchResult({
    required this.surah,
    this.ayah,
    required this.matchText,
    required this.matchField,
    required this.snippetText,
    required this.highlightTerms,
    this.reference,
    this.knowledgeHint,
    this.connectedKnowledgeCount = 0,
  });

  final QuranSurah surah;
  final QuranAyah? ayah;
  final String matchText;
  final QuranSearchMatchField matchField;
  final String snippetText;
  final List<String> highlightTerms;
  final QuranReference? reference;
  final String? knowledgeHint;
  final int connectedKnowledgeCount;
}

class QuranTextSearchQuery {
  const QuranTextSearchQuery({
    required this.query,
    this.maxResults = 100,
    this.allowTransliterationFallback = true,
    this.fieldFilter = QuranSearchFieldFilter.all,
  });

  final String query;
  final int maxResults;
  final bool allowTransliterationFallback;
  final QuranSearchFieldFilter fieldFilter;

  @override
  bool operator ==(Object other) {
    return other is QuranTextSearchQuery &&
        other.query == query &&
        other.maxResults == maxResults &&
        other.allowTransliterationFallback == allowTransliterationFallback &&
        other.fieldFilter == fieldFilter;
  }

  @override
  int get hashCode =>
      Object.hash(query, maxResults, allowTransliterationFallback, fieldFilter);
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

class QuranRecitationSession {
  const QuranRecitationSession({
    required this.surahNumber,
    required this.ayahNumber,
    required this.positionSeconds,
    required this.updatedAtIso,
  });

  final int surahNumber;
  final int ayahNumber;
  final int positionSeconds;
  final String updatedAtIso;

  Map<String, dynamic> toJson() => {
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'positionSeconds': positionSeconds,
    'updatedAtIso': updatedAtIso,
  };

  static QuranRecitationSession? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final surahNumber = json['surahNumber'];
    final ayahNumber = json['ayahNumber'];
    final updatedAtIso = json['updatedAtIso']?.toString();
    if (surahNumber is! int || ayahNumber is! int || updatedAtIso == null) {
      return null;
    }
    return QuranRecitationSession(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      positionSeconds: ((json['positionSeconds'] as num?)?.toInt() ?? 0).clamp(
        0,
        24 * 60 * 60,
      ),
      updatedAtIso: updatedAtIso,
    );
  }
}

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository();
});

final quranAudioRepositoryProvider = Provider<QuranAudioRepository>((ref) {
  return QuranAudioRepository();
});

final quranPlaybackPolicyProvider = Provider<QuranPlaybackPolicy>((ref) {
  return const QuranPlaybackPolicy();
});

final quranPlaybackOrchestratorProvider = Provider<QuranPlaybackOrchestrator>((
  ref,
) {
  return QuranPlaybackOrchestrator(
    audioRepository: ref.watch(quranAudioRepositoryProvider),
    policy: ref.watch(quranPlaybackPolicyProvider),
  );
});

final quranContentRepositoryProvider = Provider<QuranContentRepository>((ref) {
  return DefaultQuranContentRepository(
    quranRepository: ref.watch(quranRepositoryProvider),
    audioRepository: ref.watch(quranAudioRepositoryProvider),
  );
});

final quranSharedAudioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  final listeningStats = ref.read(quranListeningStatsProvider.notifier);
  listeningStats.bindPlayer(player);
  ref.onDispose(() {
    listeningStats.disposeTracker();
    player.dispose();
  });
  return player;
});

final quranTransliterationRepositoryProvider =
    Provider<QuranTransliterationRepository>((ref) {
      return QuranTransliterationRepository();
    });

final quranWordTimingRepositoryProvider = Provider<QuranWordTimingRepository>((
  ref,
) {
  return QuranWordTimingRepository(store: ref.watch(localStoreProvider));
});

final quranAlwaysPrependBismillahProvider = Provider<bool>((ref) {
  return alwaysPrependBismillahAtSurahStart;
});

final quranDefaultBismillahPlaybackModeProvider =
    Provider<BismillahPlaybackMode>((ref) {
      return ref.watch(quranAlwaysPrependBismillahProvider)
          ? BismillahPlaybackMode.alwaysPrepend
          : BismillahPlaybackMode.disabled;
    });

final quranReaderSettingsProvider =
    StateNotifierProvider<QuranReaderSettingsNotifier, QuranReaderSettings>(
      (ref) => QuranReaderSettingsNotifier(ref.watch(localStoreProvider)),
    );

final kidsQuranExplanationSettingsProvider =
    StateNotifierProvider<
      KidsQuranExplanationSettingsNotifier,
      KidsQuranExplanationSettings
    >((ref) {
      return KidsQuranExplanationSettingsNotifier(
        ref.watch(localStoreProvider),
      );
    });

final quranReadingProgressProvider =
    StateNotifierProvider<QuranReadingProgressNotifier, QuranReadingProgress>(
      (ref) => QuranReadingProgressNotifier(ref.watch(localStoreProvider)),
    );

final quranReadingStatsProvider =
    StateNotifierProvider<QuranReadingStatsNotifier, QuranReadingStats>(
      (ref) => QuranReadingStatsNotifier(ref.watch(localStoreProvider)),
    );

final quranListeningStatsProvider =
    StateNotifierProvider<QuranListeningStatsNotifier, QuranListeningStats>(
      (ref) => QuranListeningStatsNotifier(ref.watch(localStoreProvider)),
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
    StateNotifierProvider<QuranRecentSearchesNotifier, List<QuranStoredSearch>>(
      (ref) => QuranRecentSearchesNotifier(ref.watch(localStoreProvider)),
    );

final quranSavedSearchesProvider =
    StateNotifierProvider<QuranSavedSearchesNotifier, List<QuranStoredSearch>>(
      (ref) => QuranSavedSearchesNotifier(ref.watch(localStoreProvider)),
    );

final quranSuggestedSearchesProvider = Provider<List<QuranStoredSearch>>((ref) {
  return const <QuranStoredSearch>[
    QuranStoredSearch(query: 'mercy', updatedAtIso: ''),
    QuranStoredSearch(query: 'guidance', updatedAtIso: ''),
    QuranStoredSearch(query: 'patience', updatedAtIso: ''),
    QuranStoredSearch(query: 'sabr', updatedAtIso: ''),
    QuranStoredSearch(query: 'rahman', updatedAtIso: ''),
    QuranStoredSearch(query: 'repentance', updatedAtIso: ''),
  ];
});

final quranRecitationSessionProvider =
    StateNotifierProvider<
      QuranRecitationSessionNotifier,
      QuranRecitationSession?
    >((ref) => QuranRecitationSessionNotifier(ref.watch(localStoreProvider)));

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
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return repository.getDailyVerse(date: now, translationCode: translationCode);
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
  final stats = ref.watch(quranReadingStatsProvider);
  if (stats.secondsByDayKey.isNotEmpty) {
    var streak = 0;
    var cursor = DateTime.now();
    while (true) {
      final dayKey = LocalStore.todayKey(cursor);
      if ((stats.secondsByDayKey[dayKey] ?? 0) <= 0) break;
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    if (streak > 0) return streak;
  }
  final progress = ref.watch(quranReadingProgressProvider);
  final updated = DateTime.tryParse(progress.updatedAtIso);
  if (updated == null) return 0;
  final days = DateTime.now().difference(updated).inDays;
  if (days <= 1) return 3;
  if (days <= 3) return 2;
  return 1;
});

final quranReadingTimeTodaySecondsProvider = Provider<int>((ref) {
  final stats = ref.watch(quranReadingStatsProvider);
  return stats.secondsForDay(LocalStore.todayKey());
});

final quranListeningTimeTodaySecondsProvider = Provider<int>((ref) {
  final stats = ref.watch(quranListeningStatsProvider);
  return stats.secondsForDay(LocalStore.todayKey());
});

final quranProgressRatioProvider = Provider<double>((ref) {
  final progress = ref.watch(quranReadingProgressProvider);
  final surah = ref.watch(quranSurahMapProvider)[progress.surahNumber];
  if (surah == null || surah.verseCount == 0) return 0;
  return (progress.ayahNumber / surah.verseCount).clamp(0.0, 1.0).toDouble();
});

final quranSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final quranSearchTypeProvider = StateProvider.autoDispose<QuranSearchType>(
  (ref) => QuranSearchType.all,
);
final quranSearchFieldFilterProvider =
    StateProvider.autoDispose<QuranSearchFieldFilter>(
      (ref) => QuranSearchFieldFilter.all,
    );

final quranFilteredSurahListProvider = Provider.autoDispose
    .family<List<QuranSurah>, String>((ref, query) {
      final trimmedQuery = query.trim();
      final normalized = normalizeQuranSearchText(trimmedQuery);
      final normalizedArabic = normalizeQuranArabicSearchText(trimmedQuery);
      final surahs = ref.watch(quranSurahListProvider);
      if (normalized.isEmpty) return surahs;
      return surahs.where((surah) {
        return normalizeQuranSearchText(
              surah.transliteratedName,
            ).contains(normalized) ||
            normalizeQuranSearchText(surah.englishName).contains(normalized) ||
            normalizeQuranArabicSearchText(
              surah.arabicName,
            ).contains(normalizedArabic) ||
            surah.number.toString() == normalized;
      }).toList();
    });

final quranTextSearchResultsProvider = FutureProvider.autoDispose
    .family<List<QuranSearchResult>, QuranTextSearchQuery>((
      ref,
      searchQuery,
    ) async {
      final query = searchQuery.query.trim();
      if (query.isEmpty) return const [];
      final translationCode = ref.watch(
        quranReaderSettingsProvider.select((state) => state.translationCode),
      );
      final repository = ref.watch(quranRepositoryProvider);
      final rows = repository.search(
        query,
        translationCode: translationCode,
        maxResults: searchQuery.maxResults,
        fieldFilter: searchQuery.fieldFilter,
      );

      final output = <QuranSearchResult>[];
      final seenKeys = <String>{};
      final ayahCache = <int, List<QuranAyah>>{};

      List<QuranAyah> ayahsForSurah(int surahNumber) {
        return ayahCache.putIfAbsent(
          surahNumber,
          () => repository.getAyahsForSurah(
            surahNumber,
            translationCode: translationCode,
          ),
        );
      }

      for (final row in rows) {
        final ayahNumber = row.ayahNumber;
        QuranAyah? ayah;
        if (ayahNumber != null) {
          final ayahs = ayahsForSurah(row.surah.number);
          if (ayahNumber > 0 && ayahNumber <= ayahs.length) {
            final resolved = ayahs[ayahNumber - 1];
            ayah = QuranAyah(
              surahNumber: resolved.surahNumber,
              ayahNumber: resolved.ayahNumber,
              arabic: row.arabicText ?? resolved.arabic,
              translation: row.translationText ?? resolved.translation,
              transliteration:
                  row.transliterationText ?? resolved.transliteration,
            );
          }
        }

        final key = '${row.surah.number}:${ayahNumber ?? 0}:';
        if (!seenKeys.add(key)) continue;
        output.add(
          QuranSearchResult(
            surah: row.surah,
            ayah: ayah,
            matchText: row.matchText,
            matchField: row.matchField,
            snippetText: row.snippetText,
            highlightTerms: row.highlightTerms,
          ),
        );
      }

      return output.take(searchQuery.maxResults).toList(growable: false);
    });

final quranSearchResultsProvider =
    FutureProvider.autoDispose<List<QuranSearchResult>>((ref) async {
      final query = ref.watch(quranSearchQueryProvider);
      final fieldFilter = ref.watch(quranSearchFieldFilterProvider);
      return ref.watch(
        quranTextSearchResultsProvider(
          QuranTextSearchQuery(
            query: query,
            maxResults: 80,
            fieldFilter: fieldFilter,
          ),
        ).future,
      );
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

final quranSurahAyahsProvider = FutureProvider.family<List<QuranAyah>, int>((
  ref,
  surahNumber,
) async {
  final translationCode = ref.watch(
    quranReaderSettingsProvider.select((state) => state.translationCode),
  );
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getAyahsForSurah(
    surahNumber,
    translationCode: translationCode,
  );
});

final quranAyahByReferenceProvider =
    FutureProvider.family<QuranAyah?, (int surahNumber, int ayahNumber)>((
      ref,
      reference,
    ) async {
      final ayahs = await ref.watch(
        quranSurahAyahsProvider(reference.$1).future,
      );
      for (final ayah in ayahs) {
        if (ayah.ayahNumber == reference.$2) return ayah;
      }
      return null;
    });

final quranQuoteContentProvider =
    FutureProvider.family<QuranQuoteContent, QuranQuoteRef>((ref, quoteRef) {
      final translationCode = ref.watch(
        quranReaderSettingsProvider.select((state) => state.translationCode),
      );
      final repository = ref.watch(quranContentRepositoryProvider);
      return repository.loadQuoteContent(
        ref: quoteRef,
        translationCode: translationCode,
      );
    });
