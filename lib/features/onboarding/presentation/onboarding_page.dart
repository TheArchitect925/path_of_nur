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

  late final PageController _controller;
  late final TextEditingController _nameController;

  int _index = 0;

  bool _showShahada = false;
  bool _showAllahuAkbar = false;
  bool _showBismillah = false;

  _LanguageChoice _languageChoice = _languageChoices.first;
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
    'Understanding the Qur’an',
    'Strengthening my Salah',
    'Daily inspiration',
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
        ..addAll(existing.growthInterests);
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
        ..addAll(existing.trackingModules);
      _dhikrHaptic = existing.dhikrHaptic;
      _dhikrSound = existing.dhikrSound;
      _dhikrPulse = existing.dhikrPulse;
      _sex = existing.addressPreference;
      if (existing.userName.trim().isNotEmpty) {
        _nameController.text = existing.userName;
      }
      _LanguageChoice? language;
      for (final item in _languageChoices) {
        if (item.id == existing.languageChoiceId) {
          language = item;
          break;
        }
      }
      if (language != null) _languageChoice = language;
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
                        TextButton(onPressed: _next, child: const Text('Skip'))
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
                        'You can change this anytime in Settings.',
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
                            ? 'Begin your journey'
                            : 'Continue',
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
    return PremiumCard(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 450),
              opacity: _showShahada ? 1 : 0,
              child: const Column(
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
                    'I bear witness that there is no god except Allah,\nand I bear witness that Muhammad ﷺ is the Messenger of Allah.',
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
              child: const Column(
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
                  Text('Bismillahir-Rahmanir-Rahim'),
                  SizedBox(height: 6),
                  Text(
                    'In the name of Allah, the Most Compassionate, the Most Merciful.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'May this journey bring khayr, consistency, and closeness to Allah.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _languagePage() {
    return _stepCard(
      title: 'Choose your language',
      subtitle: 'Select the language you would like to use in the app.',
      child: ListView(
        children: _languageChoices
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
    return _choicePage<OnboardingAgeRange>(
      title: 'Which age range are you in?',
      subtitle:
          'Path of Nur adjusts some guidance, tone, and family-related recommendations based on your stage of life so the experience feels more relevant and supportive.',
      value: _ageRange,
      options: const {
        OnboardingAgeRange.under18: 'Under 18',
        OnboardingAgeRange.age18_24: '18-24',
        OnboardingAgeRange.age25_34: '25-34',
        OnboardingAgeRange.age35_44: '35-44',
        OnboardingAgeRange.age45_54: '45-54',
        OnboardingAgeRange.age55Plus: '55+',
      },
      onChanged: (value) => setState(() => _ageRange = value),
    );
  }

  Widget _experiencePage() {
    return _choicePage<OnboardingIslamExperience>(
      title: 'Which description fits your journey with Islam best?',
      subtitle:
          'We use this to set a better starting tone, pacing, and learning depth for your experience. Your selection is saved and used to shape guidance across the app.',
      value: _islamExperience,
      options: const {
        OnboardingIslamExperience.exploring: 'Exploring Islam',
        OnboardingIslamExperience.newToIslam: 'New to Islam',
        OnboardingIslamExperience.bornStillLearning:
            'Born Muslim, still learning',
        OnboardingIslamExperience.practicingRegularly: 'Practicing regularly',
        OnboardingIslamExperience.advanced: 'Experienced / advanced',
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
    return _choicePage<OnboardingSalahConsistency>(
      title: 'How consistent is your Salah currently?',
      subtitle: 'Choose the option that best reflects where you are right now.',
      value: _salahConsistency,
      options: const {
        OnboardingSalahConsistency.all: 'I pray all prayers consistently',
        OnboardingSalahConsistency.most: 'I pray most prayers',
        OnboardingSalahConsistency.sometimes: 'I pray sometimes',
        OnboardingSalahConsistency.rarely: 'I rarely pray',
        OnboardingSalahConsistency.justStarted: 'I am just getting started',
      },
      onChanged: (value) => setState(() => _salahConsistency = value),
    );
  }

  Widget _prayerMethodPage() {
    return _choicePage<OnboardingPrayerMethodChoice>(
      title: 'Salah time calculation method',
      subtitle:
          'Choose how salah times should be calculated for your location.',
      value: _methodChoice,
      options: const {
        OnboardingPrayerMethodChoice.muslimWorldLeague: 'Muslim World League',
        OnboardingPrayerMethodChoice.isna:
            'Islamic Society of North America (ISNA)',
        OnboardingPrayerMethodChoice.ummAlQura: 'Umm Al-Qura University',
        OnboardingPrayerMethodChoice.egyptian:
            'Egyptian General Authority of Survey',
        OnboardingPrayerMethodChoice.karachi:
            'University of Islamic Sciences, Karachi',
        OnboardingPrayerMethodChoice.moonsighting: 'Moonsighting Committee',
      },
      onChanged: (value) => setState(() => _methodChoice = value),
    );
  }

  Widget _madhabPage() {
    return _choicePage<PrayerMadhab>(
      title: 'Which Madhab do you follow?',
      subtitle:
          'This affects how Asr salah time is calculated. If you are unsure, you can keep the default.',
      value: _madhab,
      options: const {
        PrayerMadhab.hanafi: 'Hanafi',
        PrayerMadhab.shafii: 'Shafi\'i',
        PrayerMadhab.maliki: 'Maliki',
        PrayerMadhab.hanbali: 'Hanbali',
      },
      onChanged: (value) => setState(() => _madhab = value),
    );
  }

  Widget _growthInterestsPage() {
    return _stepCard(
      title: 'What would you like to grow in?',
      subtitle:
          'Select the areas you would like Path of Nur to help you with. You can choose multiple.',
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.7,
        children: _interestOptions
            .map(
              (item) => _toggleCard(
                title: item.$1,
                icon: item.$2,
                selected: _growthInterests.contains(item.$1),
                onTap: () {
                  setState(() {
                    if (!_growthInterests.add(item.$1)) {
                      _growthInterests.remove(item.$1);
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
    return _stepCard(
      title: 'How would you like to read Arabic?',
      subtitle: 'Choose the reading style that feels most comfortable for you.',
      child: ListView(
        children: [
          _choiceRow<OnboardingArabicReadMode>(
            value: _arabicReadMode,
            options: const {
              OnboardingArabicReadMode.noArabicYet:
                  'I do not know any Arabic yet',
              OnboardingArabicReadMode.arabicOnly: 'Arabic only',
              OnboardingArabicReadMode.arabicTransliteration:
                  'Arabic + Transliteration',
              OnboardingArabicReadMode.arabicTranslation:
                  'Arabic + Translation',
              OnboardingArabicReadMode.arabicTransliterationTranslation:
                  'Arabic + Transliteration + Translation',
            },
            onChanged: (value) => setState(() => _arabicReadMode = value),
          ),
          const SizedBox(height: 12),
          const Text(
            'Harakat / pronunciation marks',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          _choiceRow<OnboardingHarakatChoice>(
            value: _harakatChoice,
            options: const {
              OnboardingHarakatChoice.full: 'Full harakat',
              OnboardingHarakatChoice.minimal: 'Minimal harakat',
              OnboardingHarakatChoice.none: 'None',
            },
            onChanged: (value) => setState(() => _harakatChoice = value),
          ),
          const SizedBox(height: 12),
          const Text(
            'Text size',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Slider(
            value: _arabicTextScale,
            min: 0.85,
            max: 1.4,
            divisions: 11,
            label: _sizeLabel(_arabicTextScale),
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
                  const Text('Bismillahir-Rahmanir-Rahim'),
                if (_arabicReadMode ==
                        OnboardingArabicReadMode.arabicTranslation ||
                    _arabicReadMode ==
                        OnboardingArabicReadMode
                            .arabicTransliterationTranslation)
                  const Text(
                    'In the name of Allah, the Most Compassionate, the Most Merciful.',
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
    return _stepCard(
      title: 'How would you like to be reminded?',
      subtitle:
          'Choose your preferred reminders for salah and daily spiritual routines.',
      child: ListView(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Salah reminder styles',
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
                      _prayerLabel(prayer),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    _choiceRow<OnboardingReminderChoice>(
                      value: _prayerReminders[prayer]!,
                      options: const {
                        OnboardingReminderChoice.notificationOnly:
                            'Notification only',
                        OnboardingReminderChoice.adhanNotification:
                            'Adhan notification',
                        OnboardingReminderChoice.forceAdhan: 'Force Adhan',
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
            title: const Text('Daily Qur\'an reading reminder'),
            onChanged: (value) => setState(() => _dailyQuranReminder = value),
          ),
          SwitchListTile(
            value: _dailyLessonReminder,
            title: const Text('Daily lesson reminder'),
            onChanged: (value) => setState(() => _dailyLessonReminder = value),
          ),
        ],
      ),
    );
  }

  Widget _trackingPage() {
    return _stepCard(
      title: 'What would you like to track?',
      subtitle:
          'Choose the areas you would like Path of Nur to help you track over time. You can choose multiple.',
      child: ListView(
        children: _trackingOptions
            .map(
              (item) => CheckboxListTile(
                value: _trackingModules.contains(item),
                title: Text(item),
                onChanged: (_) {
                  setState(() {
                    if (!_trackingModules.add(item)) {
                      _trackingModules.remove(item);
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
    return _stepCard(
      title: 'Grow together with family',
      subtitle:
          'Path of Nur can support individual journeys while also helping families grow together.',
      child: const Column(
        children: [
          _FeatureInfoCard(
            icon: Icons.groups_rounded,
            title: 'Family profiles',
            subtitle:
                'Create profiles for family members from the Profiles page.',
          ),
          SizedBox(height: 8),
          _FeatureInfoCard(
            icon: Icons.person_pin_circle_outlined,
            title: 'Private journeys for each member',
            subtitle: 'Each profile can keep separate progress and reminders.',
          ),
          SizedBox(height: 8),
          _FeatureInfoCard(
            icon: Icons.auto_stories_rounded,
            title: 'Age-appropriate learning',
            subtitle: 'Content can adapt to stage and experience level.',
          ),
          SizedBox(height: 8),
          _FeatureInfoCard(
            icon: Icons.favorite_outline_rounded,
            title: 'Shared encouragement and growth',
            subtitle: 'Build consistency together over time.',
          ),
        ],
      ),
    );
  }

  Widget _dhikrFeedbackPage() {
    return _stepCard(
      title: 'Dhikr counter feedback',
      subtitle: 'Choose how the dhikr counter should respond when you tap.',
      child: ListView(
        children: [
          const Text(
            'Haptic feedback',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          _choiceRow<OnboardingDhikrHapticLevel>(
            value: _dhikrHaptic,
            options: const {
              OnboardingDhikrHapticLevel.off: 'Off',
              OnboardingDhikrHapticLevel.light: 'Light',
              OnboardingDhikrHapticLevel.medium: 'Medium',
              OnboardingDhikrHapticLevel.strong: 'Strong',
            },
            onChanged: (value) => setState(() => _dhikrHaptic = value),
          ),
          const SizedBox(height: 10),
          const Text(
            'Sound feedback',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          _choiceRow<OnboardingDhikrSound>(
            value: _dhikrSound,
            options: const {
              OnboardingDhikrSound.off: 'Off',
              OnboardingDhikrSound.softClick: 'Soft click',
              OnboardingDhikrSound.tasbih: 'Tasbih bead sound',
            },
            onChanged: (value) => setState(() => _dhikrSound = value),
          ),
          const SizedBox(height: 10),
          const Text(
            'Visual feedback',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          _choiceRow<OnboardingDhikrPulse>(
            value: _dhikrPulse,
            options: const {
              OnboardingDhikrPulse.off: 'Off',
              OnboardingDhikrPulse.subtleGlow: 'Subtle glow',
              OnboardingDhikrPulse.pulse: 'Pulse animation',
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
          Center(child: Text('Preview count: $_dhikrPreviewCount')),
        ],
      ),
    );
  }

  Widget _identityPage() {
    return _stepCard(
      title: 'How should we address you?',
      subtitle:
          'Choose your greeting and add your name if you would like a more personal welcome.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Greeting', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          _choiceRow<UserSex>(
            value: _sex,
            options: const {
              UserSex.brother: 'Brother',
              UserSex.sister: 'Sister',
            },
            onChanged: (value) => setState(() => _sex = value),
          ),
          const SizedBox(height: 12),
          const Text('Name', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Optional',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Opacity(
            opacity: 0.7,
            child: Text(
              'Your name is optional and only used to personalize your experience within the app.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _finalWelcomePage() {
    final name = _nameController.text.trim().isEmpty
        ? 'Friend'
        : _nameController.text.trim();
    final focus = <String>[];
    focus.addAll(_growthInterests.take(2));
    if (_salahConsistency.index >= OnboardingSalahConsistency.sometimes.index) {
      focus.add('Salah consistency');
    }
    if (_prayerReminders.values.any(
      (choice) => choice != OnboardingReminderChoice.notificationOnly,
    )) {
      focus.add('Salah reminders');
    }

    return PremiumCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Path of Nur',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Assalamu Alaikum, $name.'),
            const SizedBox(height: 8),
            const Text(
              'Your journey begins now. Path of Nur is ready to support you through learning, reflection, remembrance, and steady growth.',
            ),
            const SizedBox(height: 12),
            const Text(
              'You chose to focus on:',
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
            const Text('My Lord, increase me in knowledge.'),
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

  String _prayerLabel(String prayer) {
    switch (prayer) {
      case 'fajr':
        return 'Fajr';
      case 'dhuhr':
        return 'Dhuhr';
      case 'asr':
        return 'Asr';
      case 'maghrib':
        return 'Maghrib';
      case 'isha':
        return 'Isha';
      case 'tahajjud':
        return 'Tahajjud';
      default:
        return prayer;
    }
  }

  String _sizeLabel(double value) {
    if (value < 0.93) return 'Small';
    if (value < 1.03) return 'Medium';
    if (value < 1.17) return 'Large';
    return 'Extra large';
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
      _trackingModules.contains('Dhikr tracking') ||
          _growthInterests.contains('Dhikr and remembrance'),
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
                  'Adhan reminder options',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Notification only: a standard reminder without adhan audio.',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Adhan notification: sends a reminder with adhan-style audio when the prayer begins.',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Force Adhan: will play Adhan audio even if the phone is set to silent.',
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
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

const _languageChoices = <_LanguageChoice>[
  _LanguageChoice(id: 'system', label: 'System Default'),
  _LanguageChoice(id: 'en', label: 'English', locale: Locale('en')),
  _LanguageChoice(id: 'ar', label: 'Arabic (العربية)', locale: Locale('ar')),
  _LanguageChoice(id: 'de', label: 'German (Deutsch)', locale: Locale('de')),
  _LanguageChoice(id: 'ur', label: 'Urdu (اردو)', locale: Locale('ur')),
  _LanguageChoice(id: 'hi', label: 'Hindi (हिंदी)', locale: Locale('hi')),
  _LanguageChoice(id: 'id', label: 'Indonesian', locale: Locale('id')),
  _LanguageChoice(id: 'ms', label: 'Malay', locale: Locale('ms')),
  _LanguageChoice(id: 'tr', label: 'Turkish', locale: Locale('tr')),
  _LanguageChoice(id: 'bn', label: 'Bengali', locale: Locale('bn')),
];

const _interestOptions = <(String, IconData)>[
  ('Understanding the Qur’an', Icons.menu_book_rounded),
  ('Learning Hadith', Icons.auto_stories_rounded),
  ('Stories of the Prophets', Icons.history_edu_rounded),
  ('Strengthening my Salah', Icons.mosque_rounded),
  ('Dhikr and remembrance', Icons.favorite_outline_rounded),
  ('Building better habits', Icons.timeline_rounded),
  ('Learning about the world through the Qur’an', Icons.public_rounded),
  ('Islamic knowledge', Icons.school_rounded),
  ('Personal growth and discipline', Icons.self_improvement_rounded),
  ('Daily inspiration', Icons.wb_sunny_outlined),
];

const _trackingOptions = <String>[
  'Salah tracking',
  'Dhikr tracking',
  'Qur’an reading progress',
  'Learning progress',
  'Habit building',
  'Reflection / journaling',
];
