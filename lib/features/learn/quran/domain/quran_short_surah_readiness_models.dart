import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import 'quran_content_refs.dart';
import 'quran_readiness_bridge_models.dart';

enum QuranShortSurahReadinessStage {
  firstCompleteSurah,
  gentleExpansion,
  protectionPair,
}

class QuranShortSurahReadinessSeed {
  const QuranShortSurahReadinessSeed({
    required this.id,
    required this.order,
    required this.stage,
    required this.surahNumber,
  });

  final String id;
  final int order;
  final QuranShortSurahReadinessStage stage;
  final int surahNumber;
}

class QuranShortSurahReadinessAyah {
  const QuranShortSurahReadinessAyah({
    required this.ref,
    required this.arabic,
    required this.translation,
  });

  final QuranQuoteRef ref;
  final String arabic;
  final String translation;
}

class QuranShortSurahReadinessSurah {
  const QuranShortSurahReadinessSurah({
    required this.id,
    required this.order,
    required this.stage,
    required this.surahNumber,
    required this.surahArabicName,
    required this.surahTransliteratedName,
    required this.ayahs,
    required this.familiarSnippets,
    required this.hints,
  });

  final String id;
  final int order;
  final QuranShortSurahReadinessStage stage;
  final int surahNumber;
  final String surahArabicName;
  final String surahTransliteratedName;
  final List<QuranShortSurahReadinessAyah> ayahs;
  final List<QuranReadinessBridgeSnippet> familiarSnippets;
  final List<QuranReadinessPronunciationHint> hints;

  int get ayahCount => ayahs.length;
}

class QuranShortSurahReadinessStageSummary {
  const QuranShortSurahReadinessStageSummary({
    required this.stage,
    required this.openedCount,
    required this.totalCount,
  });

  final QuranShortSurahReadinessStage stage;
  final int openedCount;
  final int totalCount;
}

class QuranShortSurahReadinessProgressState {
  const QuranShortSurahReadinessProgressState({
    this.lastSurahNumber,
    this.openedSurahNumbers = const <int>{},
    this.lastOpenedAt,
  });

  final int? lastSurahNumber;
  final Set<int> openedSurahNumbers;
  final DateTime? lastOpenedAt;

  QuranShortSurahReadinessProgressState copyWith({
    int? lastSurahNumber,
    Set<int>? openedSurahNumbers,
    DateTime? lastOpenedAt,
    bool clearLastSurahNumber = false,
    bool clearLastOpenedAt = false,
  }) {
    return QuranShortSurahReadinessProgressState(
      lastSurahNumber: clearLastSurahNumber
          ? null
          : lastSurahNumber ?? this.lastSurahNumber,
      openedSurahNumbers: openedSurahNumbers ?? this.openedSurahNumbers,
      lastOpenedAt: clearLastOpenedAt
          ? null
          : lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lastSurahNumber': lastSurahNumber,
    'openedSurahNumbers': openedSurahNumbers.toList(growable: false),
    'lastOpenedAt': lastOpenedAt?.toIso8601String(),
  };

  factory QuranShortSurahReadinessProgressState.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const QuranShortSurahReadinessProgressState();
    }
    final rawOpened = json['openedSurahNumbers'];
    return QuranShortSurahReadinessProgressState(
      lastSurahNumber: (json['lastSurahNumber'] as num?)?.toInt(),
      openedSurahNumbers: rawOpened is List
          ? rawOpened
                .map((item) => (item as num?)?.toInt())
                .whereType<int>()
                .toSet()
          : const <int>{},
      lastOpenedAt: DateTime.tryParse(json['lastOpenedAt']?.toString() ?? ''),
    );
  }
}

class QuranShortSurahReadinessSummary {
  const QuranShortSurahReadinessSummary({
    required this.audience,
    required this.intent,
    required this.surah,
    required this.stageSummaries,
    required this.currentStage,
    required this.routeName,
    required this.hasSnippetBridgeStarted,
    required this.openedCount,
    required this.totalCount,
  });

  final ArabicLearningAudience audience;
  final ArabicLearningContinuationIntent intent;
  final QuranShortSurahReadinessSurah surah;
  final List<QuranShortSurahReadinessStageSummary> stageSummaries;
  final QuranShortSurahReadinessStage currentStage;
  final String routeName;
  final bool hasSnippetBridgeStarted;
  final int openedCount;
  final int totalCount;
}
