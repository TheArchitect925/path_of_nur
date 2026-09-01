import '../../journey/domain/learning_path_models.dart';
import 'quran_reference_models.dart';

/// The three reading-level presets from the calm-navigation plan: one reader
/// that fits every level of Arabic. A preset is a bundle of existing
/// settings, not a mode — applying one writes through to the individual
/// settings, which stay adjustable afterwards.
enum QuranReaderLevel {
  newReader,
  learning,
  fluent;

  String get storageValue => name;

  static QuranReaderLevel? tryParse(String? raw) {
    if (raw == null) return null;
    for (final level in QuranReaderLevel.values) {
      if (level.name == raw) return level;
    }
    return null;
  }
}

/// What one level sets. Playback speed rides along even though it lives in
/// the audio settings — a new reader following the highlight needs the
/// recitation slowed down to stay with it.
class QuranReaderLevelPreset {
  const QuranReaderLevelPreset({
    required this.arabicScalePercent,
    required this.showTransliteration,
    required this.showTranslation,
    required this.showWordByWord,
    required this.followPlayback,
    required this.wordSyncHighlightBeta,
    required this.cleanReadingMode,
    required this.explanationDetailLevel,
    required this.playbackSpeed,
  });

  final int arabicScalePercent;
  final bool showTransliteration;
  final bool showTranslation;
  final bool showWordByWord;
  final bool followPlayback;
  final bool wordSyncHighlightBeta;
  final bool cleanReadingMode;
  final QuranExplanationDetailLevel explanationDetailLevel;
  final double playbackSpeed;
}

QuranReaderLevelPreset presetForQuranReaderLevel(QuranReaderLevel level) {
  return switch (level) {
    // Cannot read the script yet: big Arabic, every helper on, and slow
    // audio with the word highlight so the ear teaches the eye.
    QuranReaderLevel.newReader => const QuranReaderLevelPreset(
      arabicScalePercent: 130,
      showTransliteration: true,
      showTranslation: true,
      showWordByWord: false,
      followPlayback: true,
      wordSyncHighlightBeta: true,
      cleanReadingMode: false,
      explanationDetailLevel: QuranExplanationDetailLevel.simple,
      playbackSpeed: 0.7,
    ),
    // Reads slowly and is building vocabulary: word glosses under the ayah
    // do the teaching, transliteration stays as a crutch.
    QuranReaderLevel.learning => const QuranReaderLevelPreset(
      arabicScalePercent: 115,
      showTransliteration: true,
      showTranslation: true,
      showWordByWord: true,
      followPlayback: true,
      wordSyncHighlightBeta: true,
      cleanReadingMode: false,
      explanationDetailLevel: QuranExplanationDetailLevel.standard,
      playbackSpeed: 0.9,
    ),
    // Reads comfortably: a calm, mushaf-like page — just the Arabic at
    // full pace, study tools a tap away in the ayah sheet.
    QuranReaderLevel.fluent => const QuranReaderLevelPreset(
      arabicScalePercent: 100,
      showTransliteration: false,
      showTranslation: false,
      showWordByWord: false,
      followPlayback: false,
      wordSyncHighlightBeta: false,
      cleanReadingMode: true,
      explanationDetailLevel: QuranExplanationDetailLevel.off,
      playbackSpeed: 1.0,
    ),
  };
}

/// Seed mapping from the Learn path level, per the plan: "New to Islam" opens
/// the reader as a new reader. Refinement students read fluently; the middle
/// levels land on the learning preset.
QuranReaderLevel quranReaderLevelForLearningPath(LearningPathLevel level) {
  return switch (level) {
    LearningPathLevel.beginner => QuranReaderLevel.newReader,
    LearningPathLevel.practicing ||
    LearningPathLevel.seeker => QuranReaderLevel.learning,
    LearningPathLevel.advanced => QuranReaderLevel.fluent,
  };
}
