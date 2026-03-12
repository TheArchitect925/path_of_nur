class WuduStep {
  const WuduStep({
    required this.number,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.illustrationAssetKey,
    this.repeatCount,
    this.trainerNote,
    this.whyItMatters,
    this.instructionAudioKey,
    this.pronunciationAudioKey,
  });

  final int number;
  final String title;
  final String description;
  final String iconKey;
  final String illustrationAssetKey;
  final int? repeatCount;
  final String? trainerNote;
  final String? whyItMatters;
  final String? instructionAudioKey;
  final String? pronunciationAudioKey;
}

class WuduDua {
  const WuduDua({
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  final String arabic;
  final String transliteration;
  final String translation;
}

class WuduContent {
  const WuduContent({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.whyWuduMatters,
    required this.quranVerse,
    required this.quranReference,
    required this.steps,
    required this.requiredEssentials,
    required this.sunnahEnhancements,
    required this.reminders,
    required this.afterWuduDua,
    required this.learningNote,
  });

  final String heroTitle;
  final String heroSubtitle;
  final String whyWuduMatters;
  final String quranVerse;
  final String quranReference;
  final List<WuduStep> steps;
  final List<String> requiredEssentials;
  final List<String> sunnahEnhancements;
  final List<String> reminders;
  final WuduDua afterWuduDua;
  final String learningNote;
}
