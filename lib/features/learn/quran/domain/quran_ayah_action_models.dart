import 'quran_content_refs.dart';

enum QuranAyahActionCategory {
  worship,
  gratitude,
  patience,
  kindness,
  prayer,
  remembrance,
  trust,
  protection,
  knowledge,
  truthfulness,
  humility,
  repentance,
  guidance,
}

enum QuranAyahActionDifficulty { easy, medium, deep }

class QuranAyahActionLocalizedContent {
  const QuranAyahActionLocalizedContent({
    this.actionTextsByLanguageCode = const <String, String>{},
    this.reflectionPromptsByLanguageCode = const <String, String>{},
  });

  final Map<String, String> actionTextsByLanguageCode;
  final Map<String, String> reflectionPromptsByLanguageCode;

  String? actionTextForLanguage(String languageCode) =>
      _localizedValue(actionTextsByLanguageCode, languageCode);

  String? reflectionPromptForLanguage(String languageCode) =>
      _localizedValue(reflectionPromptsByLanguageCode, languageCode);
}

class QuranAyahAction {
  const QuranAyahAction({
    required this.surahNumber,
    required this.ayahNumber,
    required this.actionText,
    required this.category,
    required this.difficulty,
    this.suggestedDurationMinutes,
    this.reflectionPrompt,
    this.rewardDrops = 1,
    this.tags = const <String>[],
    this.localizedContent = const QuranAyahActionLocalizedContent(),
  });

  final int surahNumber;
  final int ayahNumber;
  final String actionText;
  final QuranAyahActionCategory category;
  final QuranAyahActionDifficulty difficulty;
  final int? suggestedDurationMinutes;
  final String? reflectionPrompt;
  final int rewardDrops;
  final List<String> tags;
  final QuranAyahActionLocalizedContent localizedContent;

  String get ayahKey => '$surahNumber:$ayahNumber';
  String get actionId => 'ayah_action:$ayahKey';

  QuranQuoteRef get ref => QuranQuoteRef(surah: surahNumber, ayah: ayahNumber);

  String localizedActionText(String languageCode) {
    final localized = localizedContent.actionTextForLanguage(languageCode);
    if (localized != null && localized.trim().isNotEmpty) {
      return localized.trim();
    }
    return actionText.trim();
  }

  String? localizedReflectionPrompt(String languageCode) {
    final localized = localizedContent.reflectionPromptForLanguage(
      languageCode,
    );
    if (localized != null && localized.trim().isNotEmpty) {
      return localized.trim();
    }
    final prompt = reflectionPrompt?.trim();
    return prompt == null || prompt.isEmpty ? null : prompt;
  }
}

class QuranAyahActionRecommendation {
  const QuranAyahActionRecommendation({
    required this.action,
    required this.explanationPreview,
    required this.explanationBody,
    required this.isCompletedToday,
    required this.score,
    required this.isDailyAnchor,
    required this.isRecentReading,
    required this.isFoundational,
  });

  final QuranAyahAction action;
  final String explanationPreview;
  final String explanationBody;
  final bool isCompletedToday;
  final int score;
  final bool isDailyAnchor;
  final bool isRecentReading;
  final bool isFoundational;
}

String? _localizedValue(Map<String, String> values, String languageCode) {
  final normalized = languageCode.trim().toLowerCase();
  if (normalized.isEmpty) return null;
  final exact = values[normalized];
  if (exact != null && exact.trim().isNotEmpty) {
    return exact.trim();
  }
  final base = normalized.split(RegExp(r'[-_]')).first;
  final fallback = values[base];
  if (fallback != null && fallback.trim().isNotEmpty) {
    return fallback.trim();
  }
  final english = values['en'];
  if (english != null && english.trim().isNotEmpty) {
    return english.trim();
  }
  return null;
}
