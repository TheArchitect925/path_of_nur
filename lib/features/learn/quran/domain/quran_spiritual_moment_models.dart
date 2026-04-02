import 'quran_ayah_action_models.dart';
import 'quran_ayah_explanation_models.dart';
import 'quran_content_refs.dart';
import 'quran_reference_models.dart';
import 'quran_personalization_models.dart';
import '../../../worship/domain/prayer_name.dart';

enum QuranSpiritualMomentType {
  fajr,
  sunriseReflection,
  dhuhrPause,
  asrReset,
  maghribGratitude,
  ishaWindDown,
  sleepReflection,
  postPrayer,
  friday,
  ramadan,
  tahajjudOrNight,
  kidsDailyMoment,
}

enum QuranSpiritualMomentSurface { home, quranHub, prayer, reader, kidsReader }

enum QuranSpiritualMomentReasonCode {
  morningCalm,
  afterPrayer,
  middayPause,
  afternoonReset,
  sunsetGratitude,
  eveningCalm,
  quietNight,
  fridayReflection,
  ramadanReflection,
  kidsMoment,
}

class QuranSpiritualMomentDebugSignal {
  const QuranSpiritualMomentDebugSignal({
    required this.label,
    required this.score,
    this.detail,
  });

  final String label;
  final int score;
  final String? detail;
}

class QuranSpiritualMomentContext {
  const QuranSpiritualMomentContext({
    required this.now,
    required this.dateKey,
    required this.surface,
    required this.preferKids,
    required this.momentType,
    required this.reasonCode,
    required this.timeSegment,
    required this.isFriday,
    required this.isRamadan,
    required this.currentPrayer,
    required this.nextPrayer,
    required this.recentCompletedPrayer,
    required this.cooldownAyahKeys,
    required this.dismissedAyahKeysToday,
  });

  final DateTime now;
  final String dateKey;
  final QuranSpiritualMomentSurface surface;
  final bool preferKids;
  final QuranSpiritualMomentType momentType;
  final QuranSpiritualMomentReasonCode reasonCode;
  final QuranPersonalizationTimeSegment timeSegment;
  final bool isFriday;
  final bool isRamadan;
  final PrayerName? currentPrayer;
  final PrayerName? nextPrayer;
  final PrayerName? recentCompletedPrayer;
  final List<String> cooldownAyahKeys;
  final Set<String> dismissedAyahKeysToday;
}

class QuranSpiritualMomentRecommendation {
  const QuranSpiritualMomentRecommendation({
    required this.ref,
    required this.explanation,
    required this.actionRecommendation,
    required this.recommendedDetailLevel,
    required this.priority,
    required this.matchedTags,
    required this.reasonCode,
    required this.debugSignals,
    required this.validFrom,
    required this.validUntil,
    required this.kidsSafe,
    required this.usedCooldownException,
    required this.reminderHookId,
  });

  final QuranQuoteRef ref;
  final QuranAyahResolvedExplanation explanation;
  final QuranAyahActionRecommendation actionRecommendation;
  final QuranExplanationDetailLevel recommendedDetailLevel;
  final int priority;
  final List<String> matchedTags;
  final QuranSpiritualMomentReasonCode reasonCode;
  final List<QuranSpiritualMomentDebugSignal> debugSignals;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool kidsSafe;
  final bool usedCooldownException;
  final String reminderHookId;

  String get ayahKey => '${ref.surah}:${ref.ayah}';
}

class QuranSpiritualMomentBundle {
  const QuranSpiritualMomentBundle({
    required this.surface,
    required this.preferKids,
    required this.generatedDateKey,
    required this.context,
    required this.primary,
  });

  final QuranSpiritualMomentSurface surface;
  final bool preferKids;
  final String generatedDateKey;
  final QuranSpiritualMomentContext context;
  final QuranSpiritualMomentRecommendation primary;
}
