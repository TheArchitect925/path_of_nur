import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/theme/app_backgrounds.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/accounts_sync/application/accounts_sync_services.dart';
import '../../../features/accounts_sync/domain/accounts_sync_models.dart';
import '../../../features/learn/quran/application/quran_providers.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/global_background.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../../profile/domain/profile_age_preferences.dart';
import '../../learn/journey/application/learning_path_provider.dart';
import '../application/onboarding_preferences_provider.dart';
import '../application/onboarding_state_provider.dart';
import '../domain/onboarding_preferences.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const _lastIndex = 12;
  static const _growthInterestUnderstandingQuran = 'understanding_quran';
  static const _growthInterestLearningHadith = 'learning_hadith';
  static const _growthInterestStoriesProphets = 'stories_prophets';
  static const _growthInterestStrengtheningSalah = 'strengthening_salah';
  static const _growthInterestDhikrRemembrance = 'dhikr_remembrance';
  static const _growthInterestBetterHabits = 'better_habits';
  static const _growthInterestWorldThroughQuran = 'world_through_quran';
  static const _growthInterestIslamicKnowledge = 'islamic_knowledge';
  static const _growthInterestPersonalGrowth = 'personal_growth';
  static const _growthInterestDailyInspiration = 'daily_inspiration';

  static const _trackingSalah = 'salah_tracking';
  static const _trackingDhikr = 'dhikr_tracking';
  static const _trackingQuranReading = 'quran_reading_progress';
  static const _trackingLearning = 'learning_progress';
  static const _trackingHabitBuilding = 'habit_building';
  static const _trackingReflection = 'reflection_journaling';

  late final PageController _controller;
  late final TextEditingController _nameController;

  int _index = 0;

  _LanguageChoice _languageChoice = const _LanguageChoice(
    id: 'system',
    label: '',
  );
  OnboardingAgeRange _ageRange = OnboardingAgeRange.age35_44;
  OnboardingLearningAgeGroup _learningAgeGroup =
      OnboardingLearningAgeGroup.adults;
  OnboardingIslamExperience _islamExperience =
      OnboardingIslamExperience.bornStillLearning;
  OnboardingSalahConsistency _salahConsistency =
      OnboardingSalahConsistency.sometimes;
  OnboardingPrayerMethodChoice _methodChoice =
      OnboardingPrayerMethodChoice.muslimWorldLeague;
  PrayerMadhab _madhab = PrayerMadhab.shafii;

  final Set<String> _growthInterests = <String>{};

  OnboardingArabicReadMode _arabicReadMode =
      OnboardingArabicReadMode.arabicTransliterationTranslation;
  OnboardingHarakatChoice _harakatChoice = OnboardingHarakatChoice.full;
  double _arabicTextScale = 1.0;

  final Map<String, OnboardingReminderChoice> _prayerReminders = {
    'fajr': OnboardingReminderChoice.adhanNotification,
    'dhuhr': OnboardingReminderChoice.notificationOnly,
    'asr': OnboardingReminderChoice.notificationOnly,
    'maghrib': OnboardingReminderChoice.adhanNotification,
    'isha': OnboardingReminderChoice.adhanNotification,
    'tahajjud': OnboardingReminderChoice.none,
  };

  bool _dailyQuranReminder = true;
  bool _dailyLessonReminder = true;

  final Set<String> _trackingModules = <String>{_trackingSalah};

  OnboardingDhikrHapticLevel _dhikrHaptic = OnboardingDhikrHapticLevel.light;
  OnboardingDhikrSound _dhikrSound = OnboardingDhikrSound.softClick;
  OnboardingDhikrPulse _dhikrPulse = OnboardingDhikrPulse.subtleGlow;

  UserSex _sex = UserSex.brother;
  bool _authBusy = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _nameController = TextEditingController();

    final existing = ref.read(onboardingPreferencesProvider);
    if (existing != null) {
      _ageRange = _normalizeAgeRange(existing.ageRange);
      _learningAgeGroup = _learningAgeGroupForAgeRange(
        _normalizeAgeRange(existing.ageRange),
      );
      _islamExperience = existing.islamExperience;
      _salahConsistency = existing.salahConsistency;
      _methodChoice = _normalizePrayerMethodChoice(existing.prayerMethodChoice);
      _madhab = existing.madhab;
      _growthInterests
        ..clear()
        ..addAll(existing.growthInterests.map(_normalizeGrowthInterestId));
      _arabicReadMode = existing.arabicReadMode;
      _harakatChoice = existing.harakatChoice == OnboardingHarakatChoice.minimal
          ? OnboardingHarakatChoice.full
          : existing.harakatChoice;
      _arabicTextScale = existing.arabicTextScale;
      _prayerReminders
        ..clear()
        ..addAll(
          existing.prayerReminderChoices.map(
            (key, value) => MapEntry(
              key,
              value == OnboardingReminderChoice.forceAdhan
                  ? OnboardingReminderChoice.adhanNotification
                  : value,
            ),
          ),
        );
      _dailyQuranReminder = existing.dailyQuranReminder;
      _dailyLessonReminder = existing.dailyLessonReminder;
      _trackingModules
        ..clear()
        ..addAll(existing.trackingModules.map(_normalizeTrackingModuleId));
      _dhikrHaptic = existing.dhikrHaptic;
      _dhikrSound = existing.dhikrSound;
      _dhikrPulse = existing.dhikrPulse;
      _sex = existing.addressPreference;
      if (existing.userName.trim().isNotEmpty) {
        _nameController.text = existing.userName;
      }
      _languageChoice = _languageChoiceForId(existing.languageChoiceId);
    } else {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final country = (systemLocale.countryCode ?? '').toUpperCase();
      if (country == 'US' || country == 'CA') {
        _methodChoice = OnboardingPrayerMethodChoice.isna;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final showSettingsHint = _index > 1 && _index < _lastIndex;

    return Scaffold(
      body: Stack(
        children: [
          const GlobalBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _index == 0 ? null : _previous,
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      const Spacer(),
                      Text(
                        l10n.onboardingProgressValue(
                          '${_index + 1}',
                          '${_lastIndex + 1}',
                        ),
                      ),
                      const Spacer(),
                      if (_index < _lastIndex)
                        TextButton(
                          onPressed: _next,
                          child: Text(l10n.onboardingSkipAction),
                        )
                      else
                        const SizedBox(width: 62),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_index + 1) / (_lastIndex + 1),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _lastIndex + 1,
                      onPageChanged: (value) => setState(() => _index = value),
                      itemBuilder: (context, pageIndex) {
                        final page = _buildPage(pageIndex);
                        if (reduceMotion) return page;
                        return TweenAnimationBuilder<double>(
                          key: ValueKey('onboarding-step-$pageIndex'),
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 10),
                                child: child,
                              ),
                            );
                          },
                          child: page,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (showSettingsHint)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF3EBDD).withValues(alpha: 0.92),
                        border: Border.all(
                          color: const Color(
                            0xFFD8C49A,
                          ).withValues(alpha: 0.55),
                        ),
                      ),
                      child: Text(
                        l10n.onboardingSettingsHintBody,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF5A4635),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (showSettingsHint) const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _index == _lastIndex ? _finish : _next,
                      child: Text(
                        _index == _lastIndex
                            ? l10n.onboardingBeginJourneyAction
                            : l10n.onboardingContinueAction,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return _openingPage();
      case 1:
        return _disclaimerPage();
      case 2:
        return _languagePage();
      case 3:
        return _themePage();
      case 4:
        return _experiencePage();
      case 5:
        return _agePage();
      case 6:
        return _salahConsistencyPage();
      case 7:
        return _arabicReadingPage();
      case 8:
        return _prayerMethodPage();
      case 9:
        return _madhabPage();
      case 10:
        return _remindersPage();
      case 11:
        return _identityPage();
      case 12:
        return _finalWelcomePage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _openingPage() {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFF4ECDD).withValues(alpha: 0.84),
                border: Border.all(
                  color: const Color(0xFFD8C49A).withValues(alpha: 0.45),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.6,
                      fontFamily: 'AmiriQuran',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingBismillahTransliteration,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.onboardingBismillahMeaningBody,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.onboardingOpeningTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.onboardingOpeningHadithLead,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFF7F1E7).withValues(alpha: 0.72),
                border: Border.all(
                  color: const Color(0xFFD8C49A).withValues(alpha: 0.34),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.onboardingOpeningHadithQuote,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingOpeningHadithSource,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingOpeningMissionBodyOne,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingOpeningMissionBodyTwo,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingOpeningMissionBodyThree,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingOpeningSupportLine,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(l10n.onboardingOpeningBlessingBody),
            const SizedBox(height: 14),
            Text(
              l10n.onboardingOpeningPlatformFooter,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withValues(alpha: 0.78),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disclaimerPage() {
    final l10n = AppLocalizations.of(context);
    return _stepCard(
      title: l10n.onboardingDisclaimerTitle,
      subtitle: '',
      child: ListView(
        children: [
          Text(l10n.onboardingDisclaimerIntroBody),
          const SizedBox(height: 12),
          Text(l10n.onboardingDisclaimerSourcesBody),
          const SizedBox(height: 12),
          Text(l10n.onboardingDisclaimerNeutralBody),
          const SizedBox(height: 12),
          Text(l10n.onboardingDisclaimerNotRulingBody),
          const SizedBox(height: 12),
          Text(l10n.onboardingDisclaimerSeekScholarBody),
          const SizedBox(height: 12),
          Text(l10n.onboardingDisclaimerFeedbackBody),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingDisclaimerFooter,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _languagePage() {
    final l10n = AppLocalizations.of(context);
    final languageChoices = _localizedLanguageChoices(l10n);
    return _stepCard(
      title: l10n.onboardingLanguageTitle,
      subtitle: l10n.onboardingLanguageSubtitle,
      child: ListView(
        children: languageChoices
            .map(
              (choice) => ListTile(
                dense: true,
                leading: Icon(
                  _languageChoice.id == choice.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 20,
                ),
                title: Text(choice.label),
                onTap: () {
                  setState(() => _languageChoice = choice);
                  final localeNotifier = ref.read(appLocaleProvider.notifier);
                  if (choice.locale == null) {
                    localeNotifier.clearLocale();
                  } else {
                    localeNotifier.setLocale(choice.locale!);
                  }
                },
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _themePage() {
    final l10n = AppLocalizations.of(context);
    final profileSettings = ref.watch(profileSettingsProvider);
    final profileSettingsNotifier = ref.read(profileSettingsProvider.notifier);
    const visibleThemeModes = [
      AppThemeMode.noorGlass,
      AppThemeMode.noorGlassDark,
      AppThemeMode.noGlass,
      AppThemeMode.noGlassDark,
    ];

    return _stepCard(
      title: l10n.onboardingThemeTitle,
      subtitle: l10n.onboardingThemeSubtitle,
      child: ListView(
        children: [
          ...visibleThemeModes.map(
            (mode) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: _OnboardingThemePreviewTile(
                  label: _themeModeLabel(mode, l10n),
                  data: _themePreviewData(mode),
                  selected: profileSettings.appThemeMode == mode,
                  onSelected: () {
                    profileSettingsNotifier.setAppThemeMode(mode);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.onboardingThemePreviewTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.onboardingThemeSampleTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(l10n.onboardingThemeSampleChipPrayer)),
                    Chip(label: Text(l10n.onboardingThemeSampleChipReading)),
                    Chip(label: Text(l10n.onboardingThemeSampleChipReflection)),
                  ],
                ),
                const SizedBox(height: 12),
                PremiumCard(
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.onboardingThemeSampleCardTitle,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _agePage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<OnboardingAgeRange>(
      title: l10n.onboardingAgeRangeTitle,
      subtitle: l10n.onboardingAgeRangeSubtitle,
      value: _ageRange,
      options: {
        OnboardingAgeRange.under18: l10n.onboardingAgeRangeUnder18,
        OnboardingAgeRange.age18_24: l10n.onboardingAgeRange18To24,
        OnboardingAgeRange.age25_34: l10n.onboardingAgeRange25To34,
        OnboardingAgeRange.age35_44: l10n.onboardingAgeRange35To44,
      },
      onChanged: (value) => setState(() {
        _ageRange = value;
        _learningAgeGroup = _learningAgeGroupForAgeRange(value);
      }),
    );
  }

  Widget _experiencePage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<OnboardingIslamExperience>(
      title: l10n.onboardingExperienceTitle,
      subtitle: l10n.onboardingExperienceSubtitle,
      value: _islamExperience,
      options: {
        OnboardingIslamExperience.exploring: l10n.onboardingExperienceExploring,
        OnboardingIslamExperience.newToIslam:
            l10n.onboardingExperienceNewToIslam,
        OnboardingIslamExperience.bornStillLearning:
            l10n.onboardingExperienceBornStillLearning,
        OnboardingIslamExperience.practicingRegularly:
            l10n.onboardingExperiencePracticingRegularly,
        OnboardingIslamExperience.advanced: l10n.onboardingExperienceAdvanced,
      },
      onChanged: (value) => setState(() => _islamExperience = value),
    );
  }

  Widget _salahConsistencyPage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<OnboardingSalahConsistency>(
      title: l10n.onboardingSalahConsistencyTitle,
      subtitle: l10n.onboardingSalahConsistencySubtitle,
      value: _salahConsistency,
      options: {
        OnboardingSalahConsistency.all: l10n.onboardingSalahConsistencyAll,
        OnboardingSalahConsistency.most: l10n.onboardingSalahConsistencyMost,
        OnboardingSalahConsistency.sometimes:
            l10n.onboardingSalahConsistencySometimes,
        OnboardingSalahConsistency.rarely:
            l10n.onboardingSalahConsistencyRarely,
        OnboardingSalahConsistency.justStarted:
            l10n.onboardingSalahConsistencyJustStarted,
      },
      onChanged: (value) => setState(() => _salahConsistency = value),
    );
  }

  Widget _prayerMethodPage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<OnboardingPrayerMethodChoice>(
      title: l10n.onboardingPrayerMethodTitle,
      subtitle: l10n.onboardingPrayerMethodSubtitle,
      value: _methodChoice,
      options: {
        OnboardingPrayerMethodChoice.muslimWorldLeague:
            l10n.onboardingPrayerMethodMuslimWorldLeague,
        OnboardingPrayerMethodChoice.isna: l10n.onboardingPrayerMethodIsna,
        OnboardingPrayerMethodChoice.ummAlQura:
            l10n.onboardingPrayerMethodUmmAlQura,
        OnboardingPrayerMethodChoice.egyptian:
            l10n.onboardingPrayerMethodEgyptian,
        OnboardingPrayerMethodChoice.karachi:
            l10n.onboardingPrayerMethodKarachi,
      },
      onChanged: (value) => setState(() => _methodChoice = value),
    );
  }

  Widget _madhabPage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<PrayerMadhab>(
      title: l10n.onboardingMadhabTitle,
      subtitle: l10n.onboardingMadhabSubtitle,
      value: _madhab,
      options: {
        PrayerMadhab.hanafi: l10n.onboardingMadhabHanafi,
        PrayerMadhab.shafii: l10n.onboardingMadhabShafii,
        PrayerMadhab.maliki: l10n.onboardingMadhabMaliki,
        PrayerMadhab.hanbali: l10n.onboardingMadhabHanbali,
      },
      onChanged: (value) => setState(() => _madhab = value),
    );
  }

  Widget _arabicReadingPage() {
    final l10n = AppLocalizations.of(context);
    return _stepCard(
      title: l10n.onboardingArabicReadModeTitle,
      subtitle: l10n.onboardingArabicReadModeSubtitle,
      child: ListView(
        children: [
          PremiumCard(
            child: Column(
              children: [
                Text(
                  _previewArabicForHarakat(_harakatChoice),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 30 * _arabicTextScale,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                if (_arabicReadMode == OnboardingArabicReadMode.noArabicYet ||
                    _arabicReadMode ==
                        OnboardingArabicReadMode.arabicTransliteration ||
                    _arabicReadMode ==
                        OnboardingArabicReadMode
                            .arabicTransliterationTranslation)
                  Text(l10n.onboardingBismillahTransliteration),
                if (_arabicReadMode ==
                        OnboardingArabicReadMode.arabicTranslation ||
                    _arabicReadMode ==
                        OnboardingArabicReadMode
                            .arabicTransliterationTranslation)
                  Text(
                    l10n.onboardingBismillahMeaningBody,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingTextSizeTitle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Slider(
            value: _arabicTextScale,
            min: 0.85,
            max: 1.4,
            divisions: 11,
            label: _sizeLabel(l10n, _arabicTextScale),
            onChanged: (value) => setState(() => _arabicTextScale = value),
          ),
          const SizedBox(height: 12),
          _choiceRow<OnboardingArabicReadMode>(
            value: _arabicReadMode,
            options: {
              OnboardingArabicReadMode.noArabicYet:
                  l10n.onboardingArabicReadModeNoArabicYet,
              OnboardingArabicReadMode.arabicOnly:
                  l10n.onboardingArabicReadModeArabicOnly,
              OnboardingArabicReadMode.arabicTransliteration:
                  l10n.onboardingArabicReadModeArabicTransliteration,
              OnboardingArabicReadMode.arabicTranslation:
                  l10n.onboardingArabicReadModeArabicTranslation,
              OnboardingArabicReadMode.arabicTransliterationTranslation:
                  l10n.onboardingArabicReadModeArabicTransliterationTranslation,
            },
            onChanged: (value) => setState(() => _arabicReadMode = value),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingHarakatTitle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          _choiceRow<OnboardingHarakatChoice>(
            value: _harakatChoice,
            options: {
              OnboardingHarakatChoice.full: l10n.onboardingHarakatFull,
              OnboardingHarakatChoice.none: l10n.onboardingHarakatNone,
            },
            onChanged: (value) => setState(() => _harakatChoice = value),
          ),
        ],
      ),
    );
  }

  Widget _remindersPage() {
    final l10n = AppLocalizations.of(context);
    return _stepCard(
      title: l10n.onboardingRemindersTitle,
      subtitle: l10n.onboardingRemindersSubtitle,
      child: ListView(
        children: [
          SwitchListTile(
            value: _dailyQuranReminder,
            title: Text(l10n.onboardingDailyQuranReminderTitle),
            onChanged: (value) => setState(() => _dailyQuranReminder = value),
          ),
          SwitchListTile(
            value: _dailyLessonReminder,
            title: Text(l10n.onboardingDailyLessonReminderTitle),
            onChanged: (value) => setState(() => _dailyLessonReminder = value),
          ),
          SwitchListTile(
            value: _allNotificationsDisabled,
            title: Text(l10n.onboardingRemindersDisableAllAction),
            onChanged: (value) => value
                ? _turnOffAllNotifications()
                : _restoreDefaultNotifications(),
          ),
          const SizedBox(height: 4),
          ..._prayerReminders.keys.map(
            (prayer) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _prayerLabel(l10n, prayer),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    _choiceRow<OnboardingReminderChoice>(
                      value: _prayerReminders[prayer]!,
                      options: {
                        OnboardingReminderChoice.none:
                            l10n.onboardingReminderNone,
                        OnboardingReminderChoice.notificationOnly:
                            l10n.onboardingReminderNotificationOnly,
                        OnboardingReminderChoice.adhanNotification:
                            l10n.onboardingReminderAdhanNotification,
                      },
                      onChanged: (choice) =>
                          setState(() => _prayerReminders[prayer] = choice),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _identityPage() {
    final l10n = AppLocalizations.of(context);
    return _stepCard(
      title: l10n.onboardingIdentityTitle,
      subtitle: l10n.onboardingIdentitySubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingGreetingTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          _choiceRow<UserSex>(
            value: _sex,
            options: {
              UserSex.brother: l10n.profileBrother,
              UserSex.sister: l10n.profileSister,
            },
            onChanged: (value) => setState(() => _sex = value),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingNameTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: l10n.onboardingOptionalHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Opacity(
            opacity: 0.7,
            child: Text(
              l10n.onboardingNameHelperBody,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _finalWelcomePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = _nameController.text.trim().isEmpty
        ? l10n.onboardingDefaultNameFallback
        : _nameController.text.trim();
    final focus = <String>[];
    focus.addAll(
      _growthInterests.take(2).map((item) => _growthInterestLabel(l10n, item)),
    );
    if (_salahConsistency.index >= OnboardingSalahConsistency.sometimes.index) {
      focus.add(l10n.onboardingFocusSalahConsistency);
    }
    if (_hasAnyPrayerReminderEnabled) {
      focus.add(l10n.onboardingFocusSalahReminders);
    }

    return PremiumCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.onboardingFinalWelcomeTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingWelcomeGreeting(name),
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingFinalWelcomeBody,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingFocusListTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ...focus
                .take(3)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $item',
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                    ),
                  ),
                ),
            const SizedBox(height: 12),
            const Text(
              'رَبِّ زِدْنِي عِلْمًا',
              style: TextStyle(fontSize: 30, fontFamily: 'AmiriQuran'),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.onboardingKnowledgeDuaMeaning,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingFinalWelcomeClosingBody,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 18),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.onboardingAccountOptionsTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingAccountOptionsBody,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingAccountOptionsManualBackupBody,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _authBusy
                        ? null
                        : () => _handleOnboardingAuthAction(
                            () => ref
                                .read(accountsAuthRepositoryProvider)
                                .signInWithApple(),
                          ),
                    icon: const Icon(Icons.apple_rounded),
                    label: Text(l10n.accountsSyncContinueWithAppleAction),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _authBusy
                        ? null
                        : () => _handleOnboardingAuthAction(
                            () => ref
                                .read(accountsAuthRepositoryProvider)
                                .signInWithGoogle(),
                          ),
                    icon: const Icon(Icons.account_circle_outlined),
                    label: Text(l10n.accountsSyncContinueWithGoogleAction),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _authBusy
                        ? null
                        : () => _handleOnboardingAuthAction(
                            () => ref
                                .read(accountsAuthRepositoryProvider)
                                .signInWithEmail(),
                          ),
                    icon: const Icon(Icons.email_outlined),
                    label: Text(l10n.accountsSyncContinueWithEmailAction),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.accountsSyncEmailComingNextBody,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.accountsSyncLocalOnlyBody,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleOnboardingAuthAction(
    Future<AuthActionResult> Function() action,
  ) async {
    setState(() => _authBusy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await action();
    if (!mounted) return;
    setState(() => _authBusy = false);
    final message = switch (result.status) {
      AuthActionStatus.success => l10n.accountsSyncAccountConnectedResult(
        result.identity?.displayName ??
            l10n.accountsSyncDefaultAccountDisplayName,
      ),
      AuthActionStatus.cancelled => l10n.accountsSyncAuthCancelledResult,
      AuthActionStatus.unavailable => l10n.accountsSyncAuthUnavailableResult,
      AuthActionStatus.notConfigured =>
        l10n.accountsSyncAuthNotConfiguredResult,
      AuthActionStatus.error => l10n.accountsSyncAuthFailedResult,
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _stepCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final bodyStyle =
        theme.textTheme.bodyLarge?.copyWith(height: 1.45) ??
        const TextStyle(fontSize: 16, height: 1.45);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(subtitle, style: bodyStyle),
          ],
          const SizedBox(height: 14),
          Expanded(
            child: DefaultTextStyle.merge(style: bodyStyle, child: child),
          ),
        ],
      ),
    );
  }

  Widget _choicePage<T>({
    required String title,
    required String subtitle,
    required T value,
    required Map<T, String> options,
    required ValueChanged<T> onChanged,
  }) {
    return _stepCard(
      title: title,
      subtitle: subtitle,
      child: _choiceRow<T>(
        value: value,
        options: options,
        onChanged: onChanged,
      ),
    );
  }

  Widget _choiceRow<T>({
    required T value,
    required Map<T, String> options,
    required ValueChanged<T> onChanged,
  }) {
    return Column(
      children: options.entries
          .map(
            (entry) => ListTile(
              dense: true,
              leading: Icon(
                entry.key == value
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 20,
              ),
              title: Text(entry.value),
              onTap: () => onChanged(entry.key),
            ),
          )
          .toList(growable: false),
    );
  }

  String _prayerLabel(AppLocalizations l10n, String prayer) {
    switch (prayer) {
      case 'fajr':
        return l10n.settingsPrayerNameFajr;
      case 'dhuhr':
        return l10n.settingsPrayerNameDhuhr;
      case 'asr':
        return l10n.settingsPrayerNameAsr;
      case 'maghrib':
        return l10n.settingsPrayerNameMaghrib;
      case 'isha':
        return l10n.settingsPrayerNameIsha;
      case 'tahajjud':
        return l10n.notificationsPrayerNameTahajjud;
      default:
        return prayer;
    }
  }

  String _sizeLabel(AppLocalizations l10n, double value) {
    if (value < 0.93) return l10n.onboardingSizeSmall;
    if (value < 1.03) return l10n.onboardingOptionMedium;
    if (value < 1.17) return l10n.onboardingSizeLarge;
    return l10n.onboardingSizeExtraLarge;
  }

  OnboardingAgeRange _normalizeAgeRange(OnboardingAgeRange value) {
    switch (value) {
      case OnboardingAgeRange.age45_54:
      case OnboardingAgeRange.age55Plus:
        return OnboardingAgeRange.age35_44;
      case OnboardingAgeRange.under18:
      case OnboardingAgeRange.age18_24:
      case OnboardingAgeRange.age25_34:
      case OnboardingAgeRange.age35_44:
        return value;
    }
  }

  OnboardingLearningAgeGroup _learningAgeGroupForAgeRange(
    OnboardingAgeRange value,
  ) {
    switch (value) {
      case OnboardingAgeRange.under18:
      case OnboardingAgeRange.age18_24:
        return OnboardingLearningAgeGroup.kids;
      case OnboardingAgeRange.age25_34:
        return OnboardingLearningAgeGroup.teens;
      case OnboardingAgeRange.age35_44:
      case OnboardingAgeRange.age45_54:
      case OnboardingAgeRange.age55Plus:
        return OnboardingLearningAgeGroup.adults;
    }
  }

  ProfileAgeRange _profileAgeRangeForOnboardingAgeRange(
    OnboardingAgeRange value,
  ) {
    switch (value) {
      case OnboardingAgeRange.under18:
      case OnboardingAgeRange.age18_24:
        return ProfileAgeRange.child;
      case OnboardingAgeRange.age25_34:
        return ProfileAgeRange.teen;
      case OnboardingAgeRange.age35_44:
      case OnboardingAgeRange.age45_54:
      case OnboardingAgeRange.age55Plus:
        return ProfileAgeRange.adult;
    }
  }

  void _previous() {
    if (_index == 0) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_index >= _lastIndex) return;
    _controller.nextPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    final localeNotifier = ref.read(appLocaleProvider.notifier);
    final profileNotifier = ref.read(userProfileProvider.notifier);
    final prayerNotifier = ref.read(prayerSettingsProvider.notifier);
    final profileSettings = ref.read(profileSettingsProvider.notifier);
    final quranReaderSettings = ref.read(quranReaderSettingsProvider.notifier);
    final onboardingPreferencesNotifier = ref.read(
      onboardingPreferencesProvider.notifier,
    );

    if (_languageChoice.locale == null) {
      localeNotifier.clearLocale();
    } else {
      localeNotifier.setLocale(_languageChoice.locale!);
    }

    final trimmedName = _nameController.text.trim();
    if (trimmedName.isNotEmpty) profileNotifier.updateName(trimmedName);
    profileNotifier.updateSex(_sex);

    prayerNotifier.updateMadhab(_madhab);
    prayerNotifier.updateMethod(_mapPrayerMethod(_methodChoice));

    for (final entry in _prayerReminders.entries) {
      prayerNotifier.updateNotificationMode(
        entry.key,
        _mapReminderChoice(entry.value),
      );
    }

    final hasPrayerReminder = _hasAnyPrayerReminderEnabled;
    profileSettings.setAgeRange(
      _profileAgeRangeForOnboardingAgeRange(_ageRange),
    );
    profileSettings.setPrayerReminders(hasPrayerReminder);
    profileSettings.setQuranReminders(_dailyQuranReminder);
    profileSettings.setReflectionReminders(_dailyLessonReminder);

    quranReaderSettings.setShowTransliteration(
      _arabicReadMode == OnboardingArabicReadMode.noArabicYet ||
          _arabicReadMode == OnboardingArabicReadMode.arabicTransliteration ||
          _arabicReadMode ==
              OnboardingArabicReadMode.arabicTransliterationTranslation,
    );
    quranReaderSettings.setShowTranslation(
      _arabicReadMode == OnboardingArabicReadMode.noArabicYet ||
          _arabicReadMode == OnboardingArabicReadMode.arabicTranslation ||
          _arabicReadMode ==
              OnboardingArabicReadMode.arabicTransliterationTranslation,
    );
    final textScalePercent = (_arabicTextScale * 100).round();
    quranReaderSettings.setArabicScalePercent(textScalePercent);
    quranReaderSettings.setTranslationScalePercent(textScalePercent);
    quranReaderSettings.setTransliterationScalePercent(textScalePercent);
    quranReaderSettings.setRedDiacriticsEnabled(
      _harakatChoice != OnboardingHarakatChoice.none,
    );
    quranReaderSettings.setTranslationCode(
      _translationCodeForLanguage(_languageChoice.id),
    );

    profileSettings.setDhikrReminders(
      _trackingModules.contains(_trackingDhikr) ||
          _growthInterests.contains(_growthInterestDhikrRemembrance),
    );

    final prefs = OnboardingPreferences(
      onboardingCompleted: true,
      languageChoiceId: _languageChoice.id,
      localeTag: _languageChoice.locale?.toLanguageTag(),
      ageRange: _ageRange,
      learningAgeGroup: _learningAgeGroup,
      islamExperience: _islamExperience,
      salahConsistency: _salahConsistency,
      prayerMethodChoice: _methodChoice,
      madhab: _madhab,
      growthInterests: _growthInterests.toList(growable: false),
      arabicReadMode: _arabicReadMode,
      harakatChoice: _harakatChoice,
      arabicTextScale: _arabicTextScale,
      prayerReminderChoices: Map<String, OnboardingReminderChoice>.from(
        _prayerReminders,
      ),
      dailyQuranReminder: _dailyQuranReminder,
      dailyLessonReminder: _dailyLessonReminder,
      trackingModules: _trackingModules.toList(growable: false),
      dhikrHaptic: _dhikrHaptic,
      dhikrSound: _dhikrSound,
      dhikrPulse: _dhikrPulse,
      addressPreference: _sex,
      userName: trimmedName,
      completedAtIso: DateTime.now().toIso8601String(),
    );
    onboardingPreferencesNotifier.save(prefs);
    ref
        .read(learningPathSelectionProvider.notifier)
        .syncFromOnboardingProfile(_islamExperience, _learningAgeGroup);

    ref.read(onboardingCompletedProvider.notifier).complete();
    if (!mounted) return;
    context.go('/home');
  }

  PrayerCalculationMethod _mapPrayerMethod(
    OnboardingPrayerMethodChoice choice,
  ) {
    switch (choice) {
      case OnboardingPrayerMethodChoice.muslimWorldLeague:
        return PrayerCalculationMethod.muslimWorldLeague;
      case OnboardingPrayerMethodChoice.isna:
        return PrayerCalculationMethod.isna;
      case OnboardingPrayerMethodChoice.ummAlQura:
        return PrayerCalculationMethod.ummAlQura;
      case OnboardingPrayerMethodChoice.egyptian:
        return PrayerCalculationMethod.egyptian;
      case OnboardingPrayerMethodChoice.karachi:
        return PrayerCalculationMethod.karachi;
      case OnboardingPrayerMethodChoice.moonsighting:
        return PrayerCalculationMethod.isna;
    }
  }

  OnboardingPrayerMethodChoice _normalizePrayerMethodChoice(
    OnboardingPrayerMethodChoice choice,
  ) {
    switch (choice) {
      case OnboardingPrayerMethodChoice.moonsighting:
        return OnboardingPrayerMethodChoice.isna;
      case OnboardingPrayerMethodChoice.muslimWorldLeague:
      case OnboardingPrayerMethodChoice.isna:
      case OnboardingPrayerMethodChoice.ummAlQura:
      case OnboardingPrayerMethodChoice.egyptian:
      case OnboardingPrayerMethodChoice.karachi:
        return choice;
    }
  }

  PrayerNotificationMode _mapReminderChoice(OnboardingReminderChoice choice) {
    switch (choice) {
      case OnboardingReminderChoice.none:
        return PrayerNotificationMode.none;
      case OnboardingReminderChoice.notificationOnly:
        return PrayerNotificationMode.notificationOnly;
      case OnboardingReminderChoice.adhanNotification:
        return PrayerNotificationMode.adhanWithSound;
      case OnboardingReminderChoice.forceAdhan:
        // Stored explicitly in onboarding preferences for future platform-specific behavior.
        return PrayerNotificationMode.adhanWithSound;
    }
  }

  bool get _hasAnyPrayerReminderEnabled => _prayerReminders.values.any(
    (choice) => choice != OnboardingReminderChoice.none,
  );

  bool get _allNotificationsDisabled =>
      !_dailyQuranReminder &&
      !_dailyLessonReminder &&
      !_hasAnyPrayerReminderEnabled;

  void _turnOffAllNotifications() {
    setState(() {
      _dailyQuranReminder = false;
      _dailyLessonReminder = false;
      for (final prayer in _prayerReminders.keys) {
        _prayerReminders[prayer] = OnboardingReminderChoice.none;
      }
    });
  }

  void _restoreDefaultNotifications() {
    setState(() {
      _dailyQuranReminder = true;
      _dailyLessonReminder = true;
      _prayerReminders
        ..['fajr'] = OnboardingReminderChoice.adhanNotification
        ..['dhuhr'] = OnboardingReminderChoice.notificationOnly
        ..['asr'] = OnboardingReminderChoice.notificationOnly
        ..['maghrib'] = OnboardingReminderChoice.adhanNotification
        ..['isha'] = OnboardingReminderChoice.adhanNotification
        ..['tahajjud'] = OnboardingReminderChoice.none;
    });
  }

  String _previewArabicForHarakat(OnboardingHarakatChoice choice) {
    switch (choice) {
      case OnboardingHarakatChoice.full:
        return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
      case OnboardingHarakatChoice.minimal:
        return 'بسمِ اللهِ الرحمنِ الرحيم';
      case OnboardingHarakatChoice.none:
        return 'بسم الله الرحمن الرحيم';
    }
  }

  String _translationCodeForLanguage(String languageChoiceId) {
    switch (languageChoiceId) {
      case 'ur':
        return 'ur.urdu';
      case 'bn':
        return 'bn.bengali';
      case 'id':
        return 'id.indonesian';
      case 'tr':
        return 'tr.saheeh';
      case 'fa':
        return 'fa.dari';
      default:
        return 'en.sahih';
    }
  }

  String _normalizeGrowthInterestId(String raw) {
    switch (raw) {
      case 'Understanding the Qur’an':
      case _growthInterestUnderstandingQuran:
        return _growthInterestUnderstandingQuran;
      case 'Learning Hadith':
      case _growthInterestLearningHadith:
        return _growthInterestLearningHadith;
      case 'Stories of the Prophets':
      case _growthInterestStoriesProphets:
        return _growthInterestStoriesProphets;
      case 'Strengthening my Salah':
      case _growthInterestStrengtheningSalah:
        return _growthInterestStrengtheningSalah;
      case 'Dhikr and remembrance':
      case _growthInterestDhikrRemembrance:
        return _growthInterestDhikrRemembrance;
      case 'Building better habits':
      case _growthInterestBetterHabits:
        return _growthInterestBetterHabits;
      case 'Learning about the world through the Qur’an':
      case _growthInterestWorldThroughQuran:
        return _growthInterestWorldThroughQuran;
      case 'Islamic knowledge':
      case _growthInterestIslamicKnowledge:
        return _growthInterestIslamicKnowledge;
      case 'Personal growth and discipline':
      case _growthInterestPersonalGrowth:
        return _growthInterestPersonalGrowth;
      case 'Daily inspiration':
      case _growthInterestDailyInspiration:
        return _growthInterestDailyInspiration;
      default:
        return raw;
    }
  }

  String _normalizeTrackingModuleId(String raw) {
    switch (raw) {
      case 'Salah tracking':
      case _trackingSalah:
        return _trackingSalah;
      case 'Dhikr tracking':
      case _trackingDhikr:
        return _trackingDhikr;
      case 'Qur’an reading progress':
      case _trackingQuranReading:
        return _trackingQuranReading;
      case 'Learning progress':
      case _trackingLearning:
        return _trackingLearning;
      case 'Habit building':
      case _trackingHabitBuilding:
        return _trackingHabitBuilding;
      case 'Reflection / journaling':
      case _trackingReflection:
        return _trackingReflection;
      default:
        return raw;
    }
  }

  List<_LanguageChoice> _localizedLanguageChoices(AppLocalizations l10n) {
    return <_LanguageChoice>[
      _LanguageChoice(
        id: 'en',
        label: l10n.onboardingLanguageEnglish,
        locale: const Locale('en'),
      ),
      _LanguageChoice(
        id: 'de',
        label: l10n.onboardingLanguageGerman,
        locale: const Locale('de'),
      ),
      _LanguageChoice(
        id: 'ar',
        label: l10n.onboardingLanguageArabic,
        locale: const Locale('ar'),
      ),
      _LanguageChoice(
        id: 'ur',
        label: l10n.onboardingLanguageUrdu,
        locale: const Locale('ur'),
      ),
      _LanguageChoice(
        id: 'fr',
        label: l10n.onboardingLanguageFrench,
        locale: const Locale('fr'),
      ),
    ];
  }

  _LanguageChoice _languageChoiceForId(String id) {
    switch (id) {
      case 'en':
        return const _LanguageChoice(id: 'en', label: '', locale: Locale('en'));
      case 'de':
        return const _LanguageChoice(id: 'de', label: '', locale: Locale('de'));
      case 'ar':
        return const _LanguageChoice(id: 'ar', label: '', locale: Locale('ar'));
      case 'ur':
        return const _LanguageChoice(id: 'ur', label: '', locale: Locale('ur'));
      case 'fr':
        return const _LanguageChoice(id: 'fr', label: '', locale: Locale('fr'));
      default:
        return const _LanguageChoice(id: 'en', label: '', locale: Locale('en'));
    }
  }

  List<_OnboardingOption> _interestOptions(AppLocalizations l10n) {
    return <_OnboardingOption>[
      _OnboardingOption(
        id: _growthInterestUnderstandingQuran,
        title: l10n.onboardingInterestUnderstandingQuran,
        icon: Icons.menu_book_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestLearningHadith,
        title: l10n.onboardingInterestLearningHadith,
        icon: Icons.auto_stories_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestStoriesProphets,
        title: l10n.onboardingInterestStoriesProphets,
        icon: Icons.history_edu_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestStrengtheningSalah,
        title: l10n.onboardingInterestStrengtheningSalah,
        icon: Icons.mosque_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestDhikrRemembrance,
        title: l10n.onboardingInterestDhikrRemembrance,
        icon: Icons.favorite_outline_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestBetterHabits,
        title: l10n.onboardingInterestBetterHabits,
        icon: Icons.timeline_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestWorldThroughQuran,
        title: l10n.onboardingInterestWorldThroughQuran,
        icon: Icons.public_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestIslamicKnowledge,
        title: l10n.onboardingInterestIslamicKnowledge,
        icon: Icons.school_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestPersonalGrowth,
        title: l10n.onboardingInterestPersonalGrowth,
        icon: Icons.self_improvement_rounded,
      ),
      _OnboardingOption(
        id: _growthInterestDailyInspiration,
        title: l10n.onboardingInterestDailyInspiration,
        icon: Icons.wb_sunny_outlined,
      ),
    ];
  }

  String _growthInterestLabel(AppLocalizations l10n, String id) {
    for (final item in _interestOptions(l10n)) {
      if (item.id == id) return item.title;
    }
    return id;
  }
}

String _themeModeLabel(AppThemeMode mode, AppLocalizations l10n) {
  switch (mode) {
    case AppThemeMode.defaultMode:
      return l10n.settingsThemeChoiceDefault;
    case AppThemeMode.calmBeautiful:
      return l10n.settingsThemeChoiceCalmBeautiful;
    case AppThemeMode.easyRead:
      return l10n.settingsThemeChoiceEasyRead;
    case AppThemeMode.dark:
      return l10n.profileThemeDark;
    case AppThemeMode.noorGlass:
      return l10n.settingsThemeChoiceNoorGlass;
    case AppThemeMode.noorGlassDark:
      return l10n.settingsThemeChoiceNoorGlassDark;
    case AppThemeMode.noGlass:
      return l10n.settingsThemeChoiceNoGlass;
    case AppThemeMode.noGlassDark:
      return l10n.settingsThemeChoiceNoGlassDark;
    case AppThemeMode.midnightManuscript:
      return l10n.settingsThemeChoiceMidnightManuscript;
    case AppThemeMode.noorMidnightManuscript:
      return l10n.settingsThemeChoiceNoorMidnightManuscript;
    case AppThemeMode.noorKids:
      return l10n.settingsThemeChoiceNoorKids;
    case AppThemeMode.midnight:
      return l10n.quranReaderAtmosphereMidnight;
    case AppThemeMode.candlelight:
      return l10n.quranReaderAtmosphereCandlelight;
    case AppThemeMode.jummah:
      return l10n.settingsThemeChoiceJummah;
    case AppThemeMode.ramadan:
      return l10n.settingsThemeChoiceRamadan;
    case AppThemeMode.laylatAlQadr:
      return l10n.settingsThemeChoiceLaylatAlQadr;
    case AppThemeMode.eid:
      return l10n.settingsThemeChoiceEid;
  }
}

_OnboardingThemePreviewData _themePreviewData(AppThemeMode mode) {
  final appearance = AppAppearanceTheme.defaults(
    mode: mode,
    disableGlassTransparency: false,
    disableColoredGlass: false,
    disableBackground: false,
    glassSurfaceAlpha: 0.88,
  );
  final background = AppBackgroundTheme.resolve(
    appearance: appearance,
    disableGlassTransparency: false,
    atmosphere: appearance.isMidnightFamily
        ? AppBackgroundAtmosphere.quran
        : AppBackgroundAtmosphere.standard,
  );
  final isNoorGlass = appearance.isNoorGlassFamily;
  final isMidnight = appearance.isMidnightFamily;
  final isNoGlass =
      appearance.isNoGlassFamily || appearance.isNoorGlassPrimaryFamily;

  return _OnboardingThemePreviewData(
    backgroundGradient: background.previewGradient ?? background.baseGradient,
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appearance.surfaceSoft.withValues(
          alpha: isNoGlass
              ? 0.94
              : isNoorGlass
              ? 0.58
              : 0.86,
        ),
        appearance.surface.withValues(
          alpha: isNoGlass
              ? 0.96
              : isNoorGlass
              ? 0.36
              : 0.74,
        ),
      ],
    ),
    cardBorder: appearance.border.withValues(
      alpha: isMidnight
          ? 0.85
          : isNoorGlass
          ? 0.68
          : 0.58,
    ),
    primaryText: appearance.quranArabicEmphasis,
    secondaryText: appearance.onSurfaceSubtle,
    accent: appearance.accent,
    accentSoft: appearance.isMidnightFamily
        ? appearance.success
        : isNoorGlass
        ? Colors.white.withValues(alpha: 0.92)
        : appearance.accentSoft,
  );
}

class _OnboardingThemePreviewData {
  const _OnboardingThemePreviewData({
    required this.backgroundGradient,
    required this.cardGradient,
    required this.cardBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
    required this.accentSoft,
  });

  final Gradient backgroundGradient;
  final Gradient cardGradient;
  final Color cardBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
  final Color accentSoft;
}

class _OnboardingThemePreviewTile extends StatelessWidget {
  const _OnboardingThemePreviewTile({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.data,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final _OnboardingThemePreviewData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBorder = selected
        ? data.accent.withValues(alpha: 0.92)
        : theme.dividerColor.withValues(alpha: 0.30);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selectedBorder,
              width: selected ? 1.4 : 1,
            ),
            color: theme.colorScheme.surface.withValues(alpha: 0.28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: data.backgroundGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            opacity: selected ? 1 : 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: data.accent.withValues(alpha: 0.24),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: data.accent.withValues(alpha: 0.8),
                                ),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 9,
                                color: data.primaryText,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 34,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: data.primaryText.withValues(
                                    alpha: 0.82,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 18,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: data.accent.withValues(alpha: 0.72),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: data.cardGradient,
                              border: Border.all(color: data.cardBorder),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 54,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: data.accent.withValues(alpha: 0.75),
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  width: double.infinity,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: data.primaryText.withValues(
                                      alpha: 0.84,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          color: data.secondaryText.withValues(
                                            alpha: 0.72,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 26,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        color: data.accentSoft.withValues(
                                          alpha: 0.28,
                                        ),
                                        border: Border.all(
                                          color: data.accentSoft.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageChoice {
  const _LanguageChoice({required this.id, required this.label, this.locale});

  final String id;
  final String label;
  final Locale? locale;
}

class _OnboardingOption {
  const _OnboardingOption({
    required this.id,
    required this.title,
    required this.icon,
  });

  final String id;
  final String title;
  final IconData icon;
}
