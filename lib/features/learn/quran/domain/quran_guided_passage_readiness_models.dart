import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import 'quran_content_refs.dart';
import 'quran_readiness_bridge_models.dart';

enum QuranGuidedPassageReadinessStage {
  familiarOpening,
  completingFatihah,
  fullSurahConfidence,
}

class QuranGuidedPassageReadinessSeed {
  const QuranGuidedPassageReadinessSeed({
    required this.id,
    required this.order,
    required this.stage,
    required this.ref,
  });

  final String id;
  final int order;
  final QuranGuidedPassageReadinessStage stage;
  final QuranQuoteRef ref;
}

class QuranGuidedPassageReadinessAyah {
  const QuranGuidedPassageReadinessAyah({
    required this.ref,
    required this.arabic,
    required this.translation,
  });

  final QuranQuoteRef ref;
  final String arabic;
  final String translation;
}

class QuranGuidedPassageReadinessPassage {
  const QuranGuidedPassageReadinessPassage({
    required this.id,
    required this.order,
    required this.stage,
    required this.ref,
    required this.surahArabicName,
    required this.surahTransliteratedName,
    required this.ayahs,
    required this.familiarSnippets,
    required this.hints,
  });

  final String id;
  final int order;
  final QuranGuidedPassageReadinessStage stage;
  final QuranQuoteRef ref;
  final String surahArabicName;
  final String surahTransliteratedName;
  final List<QuranGuidedPassageReadinessAyah> ayahs;
  final List<QuranReadinessBridgeSnippet> familiarSnippets;
  final List<QuranReadinessPronunciationHint> hints;

  int get ayahCount => ayahs.length;
}

class QuranGuidedPassageReadinessStageSummary {
  const QuranGuidedPassageReadinessStageSummary({
    required this.stage,
    required this.openedCount,
    required this.totalCount,
  });

  final QuranGuidedPassageReadinessStage stage;
  final int openedCount;
  final int totalCount;
}

class QuranGuidedPassageReadinessProgressState {
  const QuranGuidedPassageReadinessProgressState({
    this.lastPassageId,
    this.openedPassageIds = const <String>{},
    this.lastOpenedAt,
  });

  final String? lastPassageId;
  final Set<String> openedPassageIds;
  final DateTime? lastOpenedAt;

  QuranGuidedPassageReadinessProgressState copyWith({
    String? lastPassageId,
    Set<String>? openedPassageIds,
    DateTime? lastOpenedAt,
    bool clearLastPassageId = false,
    bool clearLastOpenedAt = false,
  }) {
    return QuranGuidedPassageReadinessProgressState(
      lastPassageId: clearLastPassageId
          ? null
          : lastPassageId ?? this.lastPassageId,
      openedPassageIds: openedPassageIds ?? this.openedPassageIds,
      lastOpenedAt: clearLastOpenedAt
          ? null
          : lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lastPassageId': lastPassageId,
    'openedPassageIds': openedPassageIds.toList(growable: false),
    'lastOpenedAt': lastOpenedAt?.toIso8601String(),
  };

  factory QuranGuidedPassageReadinessProgressState.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const QuranGuidedPassageReadinessProgressState();
    }
    final rawOpened = json['openedPassageIds'];
    return QuranGuidedPassageReadinessProgressState(
      lastPassageId: json['lastPassageId']?.toString(),
      openedPassageIds: rawOpened is List
          ? rawOpened.map((item) => item.toString()).toSet()
          : const <String>{},
      lastOpenedAt: DateTime.tryParse(json['lastOpenedAt']?.toString() ?? ''),
    );
  }
}

class QuranGuidedPassageReadinessSummary {
  const QuranGuidedPassageReadinessSummary({
    required this.audience,
    required this.intent,
    required this.passage,
    required this.stageSummaries,
    required this.currentStage,
    required this.routeName,
    required this.hasShortSurahStageStarted,
    required this.openedCount,
    required this.totalCount,
  });

  final ArabicLearningAudience audience;
  final ArabicLearningContinuationIntent intent;
  final QuranGuidedPassageReadinessPassage passage;
  final List<QuranGuidedPassageReadinessStageSummary> stageSummaries;
  final QuranGuidedPassageReadinessStage currentStage;
  final String routeName;
  final bool hasShortSurahStageStarted;
  final int openedCount;
  final int totalCount;
}
