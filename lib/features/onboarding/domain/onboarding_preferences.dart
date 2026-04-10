import '../../../core/prayer/prayer_preferences.dart';
import '../../../shared/state/user_profile_state.dart';

enum OnboardingAgeRange {
  under18,
  age18_24,
  age25_34,
  age35_44,
  age45_54,
  age55Plus,
}

enum OnboardingLearningAgeGroup { kids, teens, adults }

enum OnboardingIslamExperience {
  exploring,
  newToIslam,
  bornStillLearning,
  practicingRegularly,
  advanced,
}

enum OnboardingSalahConsistency { all, most, sometimes, rarely, justStarted }

enum OnboardingPrayerMethodChoice {
  muslimWorldLeague,
  isna,
  ummAlQura,
  egyptian,
  karachi,
  moonsighting,
}

enum OnboardingArabicReadMode {
  noArabicYet,
  arabicOnly,
  arabicTransliteration,
  arabicTranslation,
  arabicTransliterationTranslation,
}

enum OnboardingHarakatChoice { full, minimal, none }

enum OnboardingReminderChoice {
  none,
  notificationOnly,
  adhanNotification,
  forceAdhan,
}

enum OnboardingDhikrHapticLevel { off, light, medium, strong }

enum OnboardingDhikrSound { off, softClick, tasbih }

enum OnboardingDhikrPulse { off, subtleGlow, pulse }

class OnboardingPreferences {
  const OnboardingPreferences({
    required this.onboardingCompleted,
    required this.languageChoiceId,
    required this.localeTag,
    required this.ageRange,
    required this.learningAgeGroup,
    required this.islamExperience,
    required this.salahConsistency,
    required this.prayerMethodChoice,
    required this.madhab,
    required this.growthInterests,
    required this.arabicReadMode,
    required this.harakatChoice,
    required this.arabicTextScale,
    required this.prayerReminderChoices,
    required this.dailyQuranReminder,
    required this.dailyLessonReminder,
    required this.trackingModules,
    required this.dhikrHaptic,
    required this.dhikrSound,
    required this.dhikrPulse,
    required this.addressPreference,
    required this.userName,
    required this.completedAtIso,
  });

  final bool onboardingCompleted;
  final String languageChoiceId;
  final String? localeTag;
  final OnboardingAgeRange ageRange;
  final OnboardingLearningAgeGroup learningAgeGroup;
  final OnboardingIslamExperience islamExperience;
  final OnboardingSalahConsistency salahConsistency;
  final OnboardingPrayerMethodChoice prayerMethodChoice;
  final PrayerMadhab madhab;
  final List<String> growthInterests;
  final OnboardingArabicReadMode arabicReadMode;
  final OnboardingHarakatChoice harakatChoice;
  final double arabicTextScale;
  final Map<String, OnboardingReminderChoice> prayerReminderChoices;
  final bool dailyQuranReminder;
  final bool dailyLessonReminder;
  final List<String> trackingModules;
  final OnboardingDhikrHapticLevel dhikrHaptic;
  final OnboardingDhikrSound dhikrSound;
  final OnboardingDhikrPulse dhikrPulse;
  final UserSex addressPreference;
  final String userName;
  final String completedAtIso;

  Map<String, dynamic> toJson() => {
    'onboardingCompleted': onboardingCompleted,
    'languageChoiceId': languageChoiceId,
    'localeTag': localeTag,
    'ageRange': ageRange.name,
    'learningAgeGroup': learningAgeGroup.name,
    'islamExperience': islamExperience.name,
    'salahConsistency': salahConsistency.name,
    'prayerMethodChoice': prayerMethodChoice.name,
    'madhab': madhab.name,
    'growthInterests': growthInterests,
    'arabicReadMode': arabicReadMode.name,
    'harakatChoice': harakatChoice.name,
    'arabicTextScale': arabicTextScale,
    'prayerReminderChoices': prayerReminderChoices.map(
      (key, value) => MapEntry(key, value.name),
    ),
    'dailyQuranReminder': dailyQuranReminder,
    'dailyLessonReminder': dailyLessonReminder,
    'trackingModules': trackingModules,
    'dhikrHaptic': dhikrHaptic.name,
    'dhikrSound': dhikrSound.name,
    'dhikrPulse': dhikrPulse.name,
    'addressPreference': addressPreference.name,
    'userName': userName,
    'completedAtIso': completedAtIso,
  };

  static OnboardingPreferences? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final languageChoiceId = json['languageChoiceId']?.toString();
    final userName = json['userName']?.toString();
    if (languageChoiceId == null || userName == null) return null;

    T enumOrDefault<T extends Enum>(List<T> values, String? raw) {
      for (final value in values) {
        if (value.name == raw) return value;
      }
      return values.first;
    }

    final growthInterests =
        (json['growthInterests'] as List?)
            ?.map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    final trackingModules =
        (json['trackingModules'] as List?)
            ?.map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    final reminderRaw = json['prayerReminderChoices'];
    final reminderMap = <String, OnboardingReminderChoice>{};
    if (reminderRaw is Map) {
      reminderRaw.forEach((key, value) {
        reminderMap[key.toString()] = enumOrDefault(
          OnboardingReminderChoice.values,
          value?.toString(),
        );
      });
    }

    return OnboardingPreferences(
      onboardingCompleted: json['onboardingCompleted'] != false,
      languageChoiceId: languageChoiceId,
      localeTag: json['localeTag']?.toString(),
      ageRange: enumOrDefault(
        OnboardingAgeRange.values,
        json['ageRange']?.toString(),
      ),
      learningAgeGroup: enumOrDefault(
        OnboardingLearningAgeGroup.values,
        json['learningAgeGroup']?.toString(),
      ),
      islamExperience: enumOrDefault(
        OnboardingIslamExperience.values,
        json['islamExperience']?.toString(),
      ),
      salahConsistency: enumOrDefault(
        OnboardingSalahConsistency.values,
        json['salahConsistency']?.toString(),
      ),
      prayerMethodChoice: enumOrDefault(
        OnboardingPrayerMethodChoice.values,
        json['prayerMethodChoice']?.toString(),
      ),
      madhab: enumOrDefault(PrayerMadhab.values, json['madhab']?.toString()),
      growthInterests: growthInterests,
      arabicReadMode: enumOrDefault(
        OnboardingArabicReadMode.values,
        json['arabicReadMode']?.toString(),
      ),
      harakatChoice: enumOrDefault(
        OnboardingHarakatChoice.values,
        json['harakatChoice']?.toString(),
      ),
      arabicTextScale: (json['arabicTextScale'] as num?)?.toDouble() ?? 1.0,
      prayerReminderChoices: reminderMap,
      dailyQuranReminder: json['dailyQuranReminder'] == true,
      dailyLessonReminder: json['dailyLessonReminder'] == true,
      trackingModules: trackingModules,
      dhikrHaptic: enumOrDefault(
        OnboardingDhikrHapticLevel.values,
        json['dhikrHaptic']?.toString(),
      ),
      dhikrSound: enumOrDefault(
        OnboardingDhikrSound.values,
        json['dhikrSound']?.toString(),
      ),
      dhikrPulse: enumOrDefault(
        OnboardingDhikrPulse.values,
        json['dhikrPulse']?.toString(),
      ),
      addressPreference: enumOrDefault(
        UserSex.values,
        json['addressPreference']?.toString(),
      ),
      userName: userName,
      completedAtIso:
          json['completedAtIso']?.toString() ??
          DateTime.now().toIso8601String(),
    );
  }
}
