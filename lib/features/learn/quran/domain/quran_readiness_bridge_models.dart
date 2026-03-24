import '../../../arabic/domain/arabic_beginner_content_models.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import 'quran_content_refs.dart';

enum QuranReadinessBridgeLevel {
  firstRecognition,
  familiarPhrases,
  ayahConfidence,
}

enum QuranReadinessPronunciationHintType {
  clear,
  stretch,
  bounce,
  nasal,
}

class QuranReadinessPronunciationHintSeed {
  const QuranReadinessPronunciationHintSeed({
    required this.id,
    required this.type,
    required this.focusArabic,
    this.adultTarget,
    this.kidsTarget,
  });

  final String id;
  final QuranReadinessPronunciationHintType type;
  final String focusArabic;
  final ArabicLearningRouteTarget? adultTarget;
  final ArabicLearningRouteTarget? kidsTarget;
}

class QuranReadinessPronunciationHint {
  const QuranReadinessPronunciationHint({
    required this.id,
    required this.type,
    required this.focusArabic,
    this.adultTarget,
    this.kidsTarget,
  });

  final String id;
  final QuranReadinessPronunciationHintType type;
  final String focusArabic;
  final ArabicLearningRouteTarget? adultTarget;
  final ArabicLearningRouteTarget? kidsTarget;

  ArabicLearningRouteTarget? targetForAudience(ArabicLearningAudience audience) {
    switch (audience) {
      case ArabicLearningAudience.kids:
        return kidsTarget;
      case ArabicLearningAudience.adult:
        return adultTarget;
    }
  }
}

class QuranReadinessBridgeSeed {
  const QuranReadinessBridgeSeed({
    required this.id,
    required this.order,
    required this.level,
    required this.ref,
    required this.snippetArabic,
    required this.transliteration,
    required this.simpleMeaning,
    this.sharedPhraseId,
    this.audioAssetPath,
    this.familiarWordIds = const <String>[],
    this.hints = const <QuranReadinessPronunciationHintSeed>[],
  });

  final String id;
  final int order;
  final QuranReadinessBridgeLevel level;
  final QuranQuoteRef ref;
  final String snippetArabic;
  final String transliteration;
  final String simpleMeaning;
  final String? sharedPhraseId;
  final String? audioAssetPath;
  final List<String> familiarWordIds;
  final List<QuranReadinessPronunciationHintSeed> hints;
}

class QuranReadinessBridgeSnippet {
  const QuranReadinessBridgeSnippet({
    required this.id,
    required this.order,
    required this.level,
    required this.ref,
    required this.snippetArabic,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.transliteration,
    required this.simpleMeaning,
    required this.audioAssetPath,
    required this.familiarWords,
    required this.surahName,
    required this.hints,
    this.sharedPhrase,
  });

  final String id;
  final int order;
  final QuranReadinessBridgeLevel level;
  final QuranQuoteRef ref;
  final String snippetArabic;
  final String ayahArabic;
  final String ayahTranslation;
  final String transliteration;
  final String simpleMeaning;
  final String? audioAssetPath;
  final List<ArabicBeginnerWordEntry> familiarWords;
  final String surahName;
  final List<QuranReadinessPronunciationHint> hints;
  final ArabicBeginnerPhraseEntry? sharedPhrase;
}

class QuranReadinessBridgeLevelSummary {
  const QuranReadinessBridgeLevelSummary({
    required this.level,
    required this.openedCount,
    required this.totalCount,
  });

  final QuranReadinessBridgeLevel level;
  final int openedCount;
  final int totalCount;
}

class QuranReadinessBridgeProgressState {
  const QuranReadinessBridgeProgressState({
    this.lastSnippetId,
    this.openedSnippetIds = const <String>{},
    this.lastOpenedAt,
  });

  final String? lastSnippetId;
  final Set<String> openedSnippetIds;
  final DateTime? lastOpenedAt;

  QuranReadinessBridgeProgressState copyWith({
    String? lastSnippetId,
    Set<String>? openedSnippetIds,
    DateTime? lastOpenedAt,
    bool clearLastSnippetId = false,
    bool clearLastOpenedAt = false,
  }) {
    return QuranReadinessBridgeProgressState(
      lastSnippetId: clearLastSnippetId
          ? null
          : lastSnippetId ?? this.lastSnippetId,
      openedSnippetIds: openedSnippetIds ?? this.openedSnippetIds,
      lastOpenedAt: clearLastOpenedAt ? null : lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lastSnippetId': lastSnippetId,
    'openedSnippetIds': openedSnippetIds.toList(growable: false),
    'lastOpenedAt': lastOpenedAt?.toIso8601String(),
  };

  factory QuranReadinessBridgeProgressState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranReadinessBridgeProgressState();
    }
    final rawOpened = json['openedSnippetIds'];
    return QuranReadinessBridgeProgressState(
      lastSnippetId: json['lastSnippetId']?.toString(),
      openedSnippetIds: rawOpened is List
          ? rawOpened.map((item) => item.toString()).toSet()
          : const <String>{},
      lastOpenedAt: DateTime.tryParse(json['lastOpenedAt']?.toString() ?? ''),
    );
  }
}

class QuranReadinessBridgeSummary {
  const QuranReadinessBridgeSummary({
    required this.audience,
    required this.intent,
    required this.snippet,
    required this.levelSummaries,
    required this.currentLevel,
    required this.routeName,
    required this.hasArabicFoundationStarted,
    required this.openedCount,
    required this.totalCount,
  });

  final ArabicLearningAudience audience;
  final ArabicLearningContinuationIntent intent;
  final QuranReadinessBridgeSnippet snippet;
  final List<QuranReadinessBridgeLevelSummary> levelSummaries;
  final QuranReadinessBridgeLevel currentLevel;
  final String routeName;
  final bool hasArabicFoundationStarted;
  final int openedCount;
  final int totalCount;
}
