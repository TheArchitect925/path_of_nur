import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../features/learn/quran/application/quran_providers.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/global_background.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../profile/application/profile_settings_provider.dart';
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
  static const _lastIndex = 15;
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

  bool _showShahada = false;
  bool _showAllahuAkbar = false;
  bool _showBismillah = false;

  _LanguageChoice _languageChoice = const _LanguageChoice(id: 'system', label: '');
  OnboardingAgeRange _ageRange = OnboardingAgeRange.age25_34;
  OnboardingLearningAgeGroup _learningAgeGroup =
      OnboardingLearningAgeGroup.adults;
  OnboardingIslamExperience _islamExperience =
      OnboardingIslamExperience.bornStillLearning;
  OnboardingSalahConsistency _salahConsistency =
      OnboardingSalahConsistency.sometimes;
  OnboardingPrayerMethodChoice _methodChoice =
      OnboardingPrayerMethodChoice.muslimWorldLeague;
  PrayerMadhab _madhab = PrayerMadhab.shafii;

  final Set<String> _growthInterests = <String>{
    _growthInterestUnderstandingQuran,
    _growthInterestStrengtheningSalah,
    _growthInterestDailyInspiration,
  };

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
    'tahajjud': OnboardingReminderChoice.notificationOnly,
  };

  bool _dailyQuranReminder = true;
  bool _dailyLessonReminder = true;

  final Set<String> _trackingModules = <String>{};

  OnboardingDhikrHapticLevel _dhikrHaptic = OnboardingDhikrHapticLevel.light;
  OnboardingDhikrSound _dhikrSound = OnboardingDhikrSound.softClick;
  OnboardingDhikrPulse _dhikrPulse = OnboardingDhikrPulse.subtleGlow;
  int _dhikrPreviewCount = 0;

  UserSex _sex = UserSex.brother;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _nameController = TextEditingController();

    final existing = ref.read(onboardingPreferencesProvider);
    if (existing != null) {
      _ageRange = existing.ageRange;
      _learningAgeGroup = existing.learningAgeGroup;
      _islamExperience = existing.islamExperience;
      _salahConsistency = existing.salahConsistency;
      _methodChoice = existing.prayerMethodChoice;
      _madhab = existing.madhab;
      _growthInterests
        ..clear()
        ..addAll(existing.growthInterests.map(_normalizeGrowthInterestId));
      _arabicReadMode = existing.arabicReadMode;
      _harakatChoice = existing.harakatChoice;
      _arabicTextScale = existing.arabicTextScale;
      _prayerReminders
        ..clear()
        ..addAll(existing.prayerReminderChoices);
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

    _triggerOpeningSequence();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _triggerOpeningSequence() {
    setState(() {
      _showShahada = false;
      _showAllahuAkbar = false;
      _showBismillah = false;
    });
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (!mounted || _index != 0) return;
      setState(() => _showShahada = true);
    });
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (!mounted || _index != 0) return;
      setState(() => _showAllahuAkbar = true);
    });
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || _index != 0) return;
      setState(() => _showBismillah = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final showSettingsHint = _index > 0 && _index < _lastIndex && _index != 11;

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
                      Text('${_index + 1} / ${_lastIndex + 1}'),
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
                      onPageChanged: (value) {
                        setState(() => _index = value);
                        if (value == 0) _triggerOpeningSequence();
                      },
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
        return _languagePage();
      case 2:
        return _agePage();
      case 3:
        return _learningAgeGroupPage();
      case 4:
        return _experiencePage();
      case 5:
        return _salahConsistencyPage();
      case 6:
        return _prayerMethodPage();
      case 7:
        return _madhabPage();
      case 8:
        return _growthInterestsPage();
      case 9:
        return _arabicReadingPage();
      case 10:
        return _remindersPage();
      case 11:
        return _trackingPage();
      case 12:
        return _familyIntroPage();
      case 13:
        return _dhikrFeedbackPage();
      case 14:
        return _identityPage();
      case 15:
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
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 450),
              opacity: _showShahada ? 1 : 0,
              child: Column(
                children: [
                  Text(
                    'أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ\nوَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.6,
                      fontFamily: 'AmiriQuran',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ashhadu an la ilaha illa Allah\nwa ashhadu anna Muhammadan rasulullah',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 8),
                  Text(
                    l10n.onboardingShahadaMeaningBody,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _showAllahuAkbar ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD8C49A).withValues(alpha: 0.24),
                      blurRadius: 26,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  'اللَّهُ أَكْبَر',
                  style: TextStyle(fontSize: 34, fontFamily: 'AmiriQuran'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _showBismillah ? 1 : 0,
              child: Column(
                children: [
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.6,
                      fontFamily: 'AmiriQuran',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(l10n.onboardingBismillahTransliteration),
                  SizedBox(height: 6),
                  Text(
                    l10n.onboardingBismillahMeaningBody,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingOpeningBlessingBody,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        OnboardingAgeRange.age45_54: l10n.onboardingAgeRange45To54,
        OnboardingAgeRange.age55Plus: l10n.onboardingAgeRange55Plus,
      },
      onChanged: (value) => setState(() => _ageRange = value),
    );
  }

  Widget _experiencePage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<OnboardingIslamExperience>(
      title: l10n.onboardingExperienceTitle,
      subtitle: l10n.onboardingExperienceSubtitle,
      value: _islamExperience,
      options: {
        OnboardingIslamExperience.exploring:
            l10n.onboardingExperienceExploring,
        OnboardingIslamExperience.newToIslam:
            l10n.onboardingExperienceNewToIslam,
        OnboardingIslamExperience.bornStillLearning:
            l10n.onboardingExperienceBornStillLearning,
        OnboardingIslamExperience.practicingRegularly:
            l10n.onboardingExperiencePracticingRegularly,
        OnboardingIslamExperience.advanced:
            l10n.onboardingExperienceAdvanced,
      },
      onChanged: (value) => setState(() => _islamExperience = value),
    );
  }

  Widget _learningAgeGroupPage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<OnboardingLearningAgeGroup>(
      title: l10n.onboardingLearningAgeGroupTitle,
      subtitle: l10n.onboardingLearningAgeGroupSubtitle,
      value: _learningAgeGroup,
      options: {
        OnboardingLearningAgeGroup.kids: l10n.onboardingLearningAgeGroupKids,
        OnboardingLearningAgeGroup.teens: l10n.onboardingLearningAgeGroupTeens,
        OnboardingLearningAgeGroup.adults:
            l10n.onboardingLearningAgeGroupAdults,
      },
      onChanged: (value) => setState(() => _learningAgeGroup = value),
    );
  }

  Widget _salahConsistencyPage() {
    final l10n = AppLocalizations.of(context);
    return _choicePage<OnboardingSalahConsistency>(
      title: l10n.onboardingSalahConsistencyTitle,
      subtitle: l10n.onboardingSalahConsistencySubtitle,
      value: _salahConsistency,
      options: {
        OnboardingSalahConsistency.all:
            l10n.onboardingSalahConsistencyAll,
        OnboardingSalahConsistency.most:
            l10n.onboardingSalahConsistencyMost,
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
        OnboardingPrayerMethodChoice.moonsighting:
            l10n.onboardingPrayerMethodMoonsighting,
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

  Widget _growthInterestsPage() {
    final l10n = AppLocalizations.of(context);
    final interestOptions = _interestOptions(l10n);
    return _stepCard(
      title: l10n.onboardingGrowthInterestsTitle,
      subtitle: l10n.onboardingGrowthInterestsSubtitle,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.7,
        children: interestOptions
            .map(
              (item) => _toggleCard(
                title: item.title,
                icon: item.icon,
                selected: _growthInterests.contains(item.id),
                onTap: () {
                  setState(() {
                    if (!_growthInterests.add(item.id)) {
                      _growthInterests.remove(item.id);
                    }
                  });
                },
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _arabicReadingPage() {
    final l10n = AppLocalizations.of(context);
    return _stepCard(
      title: l10n.onboardingArabicReadModeTitle,
      subtitle: l10n.onboardingArabicReadModeSubtitle,
      child: ListView(
        children: [
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
              OnboardingHarakatChoice.minimal: l10n.onboardingHarakatMinimal,
              OnboardingHarakatChoice.none: l10n.onboardingHarakatNone,
            },
            onChanged: (value) => setState(() => _harakatChoice = value),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingTextSizeTitle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Slider(
            value: _arabicTextScale,
            min: 0.85,
            max: 1.4,
            divisions: 11,
            label: _sizeLabel(l10n, _arabicTextScale),
            onChanged: (value) => setState(() => _arabicTextScale = value),
          ),
          const SizedBox(height: 8),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.onboardingSalahReminderStylesTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: AppLocalizations.of(context).accessibilityReminderHelp,
                onPressed: _showReminderHelp,
                icon: const Icon(Icons.help_outline_rounded),
              ),
            ],
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
                        OnboardingReminderChoice.notificationOnly:
                            l10n.onboardingReminderNotificationOnly,
                        OnboardingReminderChoice.adhanNotification:
                            l10n.onboardingReminderAdhanNotification,
                        OnboardingReminderChoice.forceAdhan:
                            l10n.onboardingReminderForceAdhan,
                      },
                      onChanged: (choice) =>
                          setState(() => _prayerReminders[prayer] = choice),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
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
        ],
      ),
    );
  }

  Widget _trackingPage() {
    final l10n = AppLocalizations.of(context);
    final trackingOptions = _trackingOptions(l10n);
    return _stepCard(
      title: l10n.onboardingTrackingTitle,
      subtitle: l10n.onboardingTrackingSubtitle,
      child: ListView(
        children: trackingOptions
            .map(
              (item) => CheckboxListTile(
                value: _trackingModules.contains(item.id),
                title: Text(item.title),
                onChanged: (_) {
                  setState(() {
                    if (!_trackingModules.add(item.id)) {
                      _trackingModules.remove(item.id);
                    }
                  });
                },
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _familyIntroPage() {
    final l10n = AppLocalizations.of(context);
    return _stepCard(
      title: l10n.onboardingFamilyTitle,
      subtitle: l10n.onboardingFamilySubtitle,
      child: Column(
        children: [
          _FeatureInfoCard(
            icon: Icons.groups_rounded,
            title: l10n.onboardingFamilyProfilesTitle,
            subtitle: l10n.onboardingFamilyProfilesSubtitle,
          ),
          const SizedBox(height: 8),
          _FeatureInfoCard(
            icon: Icons.person_pin_circle_outlined,
            title: l10n.onboardingFamilyPrivateJourneysTitle,
            subtitle: l10n.onboardingFamilyPrivateJourneysSubtitle,
          ),
          const SizedBox(height: 8),
          _FeatureInfoCard(
            icon: Icons.auto_stories_rounded,
            title: l10n.onboardingFamilyAgeAppropriateTitle,
            subtitle: l10n.onboardingFamilyAgeAppropriateSubtitle,
          ),
          const SizedBox(height: 8),
          _FeatureInfoCard(
            icon: Icons.favorite_outline_rounded,
            title: l10n.onboardingFamilySharedGrowthTitle,
            subtitle: l10n.onboardingFamilySharedGrowthSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _dhikrFeedbackPage() {
    final l10n = AppLocalizations.of(context);
    return _stepCard(
      title: l10n.onboardingDhikrFeedbackTitle,
      subtitle: l10n.onboardingDhikrFeedbackSubtitle,
      child: ListView(
        children: [
          Text(
            l10n.onboardingDhikrHapticTitle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          _choiceRow<OnboardingDhikrHapticLevel>(
            value: _dhikrHaptic,
            options: {
              OnboardingDhikrHapticLevel.off: l10n.onboardingOptionOff,
              OnboardingDhikrHapticLevel.light: l10n.onboardingOptionLight,
              OnboardingDhikrHapticLevel.medium: l10n.onboardingOptionMedium,
              OnboardingDhikrHapticLevel.strong: l10n.onboardingOptionStrong,
            },
            onChanged: (value) => setState(() => _dhikrHaptic = value),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.onboardingDhikrSoundTitle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          _choiceRow<OnboardingDhikrSound>(
            value: _dhikrSound,
            options: {
              OnboardingDhikrSound.off: l10n.onboardingOptionOff,
              OnboardingDhikrSound.softClick:
                  l10n.onboardingDhikrSoundSoftClick,
              OnboardingDhikrSound.tasbih:
                  l10n.onboardingDhikrSoundTasbih,
            },
            onChanged: (value) => setState(() => _dhikrSound = value),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.onboardingDhikrVisualTitle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          _choiceRow<OnboardingDhikrPulse>(
            value: _dhikrPulse,
            options: {
              OnboardingDhikrPulse.off: l10n.onboardingOptionOff,
              OnboardingDhikrPulse.subtleGlow:
                  l10n.onboardingDhikrVisualSubtleGlow,
              OnboardingDhikrPulse.pulse:
                  l10n.onboardingDhikrVisualPulseAnimation,
            },
            onChanged: (value) => setState(() => _dhikrPulse = value),
          ),
          const SizedBox(height: 10),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD8C49A).withValues(
                  alpha: _dhikrPulse == OnboardingDhikrPulse.off
                      ? 0.18
                      : (_dhikrPulse == OnboardingDhikrPulse.subtleGlow
                            ? 0.28
                            : 0.36),
                ),
              ),
              child: IconButton(
                onPressed: () => setState(() => _dhikrPreviewCount += 1),
                tooltip: AppLocalizations.of(
                  context,
                ).accessibilityIncreaseDhikrCount,
                icon: const Icon(Icons.touch_app_rounded),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              l10n.onboardingDhikrPreviewCount(_dhikrPreviewCount),
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
    if (_prayerReminders.values.any(
      (choice) => choice != OnboardingReminderChoice.notificationOnly,
    )) {
      focus.add(l10n.onboardingFocusSalahReminders);
    }

    return PremiumCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.onboardingFinalWelcomeTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.onboardingWelcomeGreeting(name)),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingFinalWelcomeBody,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingFocusListTitle,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            ...focus
                .take(3)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $item'),
                  ),
                ),
            const SizedBox(height: 12),
            const Text(
              'رَبِّ زِدْنِي عِلْمًا',
              style: TextStyle(fontSize: 30, fontFamily: 'AmiriQuran'),
            ),
            const SizedBox(height: 4),
            Text(l10n.onboardingKnowledgeDuaMeaning),
          ],
        ),
      ),
    );
  }

  Widget _stepCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(subtitle),
          ],
          const SizedBox(height: 10),
          Expanded(child: child),
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

  Widget _toggleCard({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? const Color(0xFFD8C49A).withValues(alpha: 0.24)
              : const Color(0xFFF2EBE1).withValues(alpha: 0.62),
          border: Border.all(
            color: selected
                ? const Color(0xFFD8C49A).withValues(alpha: 0.66)
                : const Color(0xFFD8C49A).withValues(alpha: 0.34),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
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

  void _previous() {
    if (_index == 0) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_index == 7 && _growthInterests.isEmpty) return;
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

    final hasPrayerReminder = _prayerReminders.isNotEmpty;
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

  PrayerNotificationMode _mapReminderChoice(OnboardingReminderChoice choice) {
    switch (choice) {
      case OnboardingReminderChoice.notificationOnly:
        return PrayerNotificationMode.notificationOnly;
      case OnboardingReminderChoice.adhanNotification:
        return PrayerNotificationMode.adhanWithSound;
      case OnboardingReminderChoice.forceAdhan:
        // Stored explicitly in onboarding preferences for future platform-specific behavior.
        return PrayerNotificationMode.adhanWithSound;
    }
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

  void _showReminderHelp() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: PremiumCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).onboardingReminderHelpTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context).onboardingReminderHelpNotificationOnly,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).onboardingReminderHelpAdhanNotification,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).onboardingReminderHelpForceAdhan,
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context).salahCloseAction),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      _LanguageChoice(id: 'system', label: l10n.onboardingLanguageSystemDefault),
      _LanguageChoice(
        id: 'en',
        label: l10n.onboardingLanguageEnglish,
        locale: const Locale('en'),
      ),
      _LanguageChoice(
        id: 'ar',
        label: l10n.onboardingLanguageArabic,
        locale: const Locale('ar'),
      ),
      _LanguageChoice(
        id: 'de',
        label: l10n.onboardingLanguageGerman,
        locale: const Locale('de'),
      ),
      _LanguageChoice(
        id: 'ur',
        label: l10n.onboardingLanguageUrdu,
        locale: const Locale('ur'),
      ),
      _LanguageChoice(
        id: 'hi',
        label: l10n.onboardingLanguageHindi,
        locale: const Locale('hi'),
      ),
      _LanguageChoice(
        id: 'id',
        label: l10n.onboardingLanguageIndonesian,
        locale: const Locale('id'),
      ),
      _LanguageChoice(
        id: 'ms',
        label: l10n.onboardingLanguageMalay,
        locale: const Locale('ms'),
      ),
      _LanguageChoice(
        id: 'tr',
        label: l10n.onboardingLanguageTurkish,
        locale: const Locale('tr'),
      ),
      _LanguageChoice(
        id: 'bn',
        label: l10n.onboardingLanguageBengali,
        locale: const Locale('bn'),
      ),
    ];
  }

  _LanguageChoice _languageChoiceForId(String id) {
    switch (id) {
      case 'en':
        return const _LanguageChoice(id: 'en', label: '', locale: Locale('en'));
      case 'ar':
        return const _LanguageChoice(id: 'ar', label: '', locale: Locale('ar'));
      case 'de':
        return const _LanguageChoice(id: 'de', label: '', locale: Locale('de'));
      case 'ur':
        return const _LanguageChoice(id: 'ur', label: '', locale: Locale('ur'));
      case 'hi':
        return const _LanguageChoice(id: 'hi', label: '', locale: Locale('hi'));
      case 'id':
        return const _LanguageChoice(id: 'id', label: '', locale: Locale('id'));
      case 'ms':
        return const _LanguageChoice(id: 'ms', label: '', locale: Locale('ms'));
      case 'tr':
        return const _LanguageChoice(id: 'tr', label: '', locale: Locale('tr'));
      case 'bn':
        return const _LanguageChoice(id: 'bn', label: '', locale: Locale('bn'));
      default:
        return const _LanguageChoice(id: 'system', label: '');
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

  List<_OnboardingOption> _trackingOptions(AppLocalizations l10n) {
    return <_OnboardingOption>[
      _OnboardingOption(
        id: _trackingSalah,
        title: l10n.onboardingTrackingSalah,
        icon: Icons.check_circle_outline,
      ),
      _OnboardingOption(
        id: _trackingDhikr,
        title: l10n.onboardingTrackingDhikr,
        icon: Icons.check_circle_outline,
      ),
      _OnboardingOption(
        id: _trackingQuranReading,
        title: l10n.onboardingTrackingQuranReading,
        icon: Icons.check_circle_outline,
      ),
      _OnboardingOption(
        id: _trackingLearning,
        title: l10n.onboardingTrackingLearning,
        icon: Icons.check_circle_outline,
      ),
      _OnboardingOption(
        id: _trackingHabitBuilding,
        title: l10n.onboardingTrackingHabitBuilding,
        icon: Icons.check_circle_outline,
      ),
      _OnboardingOption(
        id: _trackingReflection,
        title: l10n.onboardingTrackingReflection,
        icon: Icons.check_circle_outline,
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

class _FeatureInfoCard extends StatelessWidget {
  const _FeatureInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(subtitle),
              ],
            ),
          ),
        ],
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
