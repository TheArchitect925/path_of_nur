import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/global_background.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../application/onboarding_state_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _controller;
  final _nameController = TextEditingController();

  int _step = 0;
  Locale _selectedLocale = const Locale('en');
  UserSex _selectedSex = UserSex.brother;
  PrayerMadhab _selectedMadhab = PrayerMadhab.shafii;
  PrayerCalculationMethod _selectedMethod =
      PrayerCalculationMethod.muslimWorldLeague;
  String _selectedLocation = 'Toronto, Canada';
  bool _locationRequested = false;
  bool _prayerReminders = true;
  bool _dhikrReminders = true;
  bool _quranReminders = false;
  bool _reflectionReminders = false;
  bool _fastingReminders = false;
  _ModeChoice _modeChoice = _ModeChoice.gentle;

  static const int _lastIndex = 9;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    final profile = ref.read(userProfileProvider);
    final locale = ref.read(appLocaleProvider);
    final prayer = ref.read(prayerSettingsProvider).preferences;
    final profileSettings = ref.read(profileSettingsProvider);

    _nameController.text = profile.name;
    _selectedSex = profile.sex;
    _selectedLocale = locale ?? const Locale('en');
    _selectedLocation = prayer.location;
    _selectedMadhab = prayer.madhab;
    _selectedMethod = prayer.calculationMethod;
    _prayerReminders = profileSettings.prayerReminders;
    _dhikrReminders = profileSettings.dhikrReminders;
    _quranReminders = profileSettings.quranReminders;
    _reflectionReminders = profileSettings.reflectionReminders;
    _fastingReminders = profileSettings.fastingReminders;
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

    return Scaffold(
      body: Stack(
        children: [
          const GlobalBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_step > 0)
                        IconButton(
                          onPressed: _previous,
                          icon: const Icon(Icons.chevron_left),
                        )
                      else
                        const SizedBox(width: 48),
                      const Spacer(),
                      Text(
                        '${_step + 1} / ${_lastIndex + 1}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _step == _lastIndex
                            ? null
                            : _skipCurrentStep,
                        child: Text(l10n.quranCancel),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_step + 1) / (_lastIndex + 1),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _IntroStep(
                          title: l10n.appTitle,
                          subtitle: l10n.homeWelcomeDailyIntentionSubtitle,
                        ),
                        _LanguageStep(
                          title: l10n.languageOptionsTitle,
                          subtitle: l10n.languageOptionsSubtitle,
                          selected: _selectedLocale,
                          onSelected: (value) =>
                              setState(() => _selectedLocale = value),
                          labels: _languageLabels(l10n),
                        ),
                        _SexStep(
                          title: l10n.profileAddressMeAs,
                          brother: l10n.profileBrother,
                          sister: l10n.profileSister,
                          selected: _selectedSex,
                          onChanged: (value) =>
                              setState(() => _selectedSex = value),
                        ),
                        _NameStep(
                          title: l10n.profileDisplayNameLabel,
                          subtitle: l10n.profileSummarySubtitle,
                          controller: _nameController,
                        ),
                        _IntroStep(
                          title: l10n.profilePrayerSettingsTitle,
                          subtitle: l10n.profilePrayerSettingsSubtitle,
                        ),
                        _LocationStep(
                          title: l10n.homeLocationPromptTitle,
                          subtitle: l10n.homeLocationPromptSubtitle,
                          locationRequested: _locationRequested,
                          onRequest: _requestLocation,
                        ),
                        _PrayerSetupStep(
                          title: l10n.profilePrayerSettingsTitle,
                          locationLabel: l10n.profileLocationLabel,
                          madhabLabel: l10n.profileMadhabLabel,
                          methodLabel: l10n.profileCalculationMethodLabel,
                          selectedLocation: _selectedLocation,
                          selectedMadhab: _selectedMadhab,
                          selectedMethod: _selectedMethod,
                          locations: ref.watch(
                            availablePrayerLocationsProvider,
                          ),
                          onLocationChanged: (value) =>
                              setState(() => _selectedLocation = value),
                          onMadhabChanged: (value) =>
                              setState(() => _selectedMadhab = value),
                          onMethodChanged: (value) =>
                              setState(() => _selectedMethod = value),
                        ),
                        _ReminderStep(
                          title: l10n.profileNotificationsTitle,
                          subtitle: l10n.profileNotificationsSubtitle,
                          prayerReminders: _prayerReminders,
                          dhikrReminders: _dhikrReminders,
                          quranReminders: _quranReminders,
                          reflectionReminders: _reflectionReminders,
                          fastingReminders: _fastingReminders,
                          onPrayerChanged: (value) =>
                              setState(() => _prayerReminders = value),
                          onDhikrChanged: (value) =>
                              setState(() => _dhikrReminders = value),
                          onQuranChanged: (value) =>
                              setState(() => _quranReminders = value),
                          onReflectionChanged: (value) =>
                              setState(() => _reflectionReminders = value),
                          onFastingChanged: (value) =>
                              setState(() => _fastingReminders = value),
                        ),
                        _ModeStep(
                          title: l10n.profileModesTitle,
                          subtitle: l10n.profileModesSubtitle,
                          modeChoice: _modeChoice,
                          onChanged: (value) =>
                              setState(() => _modeChoice = value),
                          ramadanTitle: l10n.profileRamadanModeTitle,
                          gentleTitle: l10n.profileGentleModeTitle,
                          lossTitle: l10n.profileLossModeTitle,
                        ),
                        _FinishStep(
                          title: l10n.navHome,
                          subtitle: l10n.onboardingDisclaimerBody,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _step == _lastIndex ? _finish : _next,
                      child: Text(
                        _step == _lastIndex
                            ? l10n.navHome
                            : l10n.learnContentContinueTitle,
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

  Map<Locale, String> _languageLabels(AppLocalizations l10n) {
    return {
      const Locale('en'): l10n.languageEnglish,
      const Locale('ar'): l10n.languageArabic,
      const Locale('id'): l10n.languageIndonesian,
      const Locale('ms'): l10n.languageMalay,
      const Locale('bn'): l10n.languageBengali,
      const Locale('ur'): l10n.languageUrdu,
      const Locale('fa'): l10n.languageFarsi,
      const Locale('fa', 'AF'): l10n.languageDari,
      const Locale('tg'): l10n.languageTajik,
      const Locale('tr'): l10n.languageTurkish,
      const Locale('hi'): l10n.languageHindi,
      const Locale('pa'): l10n.languagePunjabi,
      const Locale('ha'): l10n.languageHausa,
      const Locale('ps'): l10n.languagePashto,
      const Locale('ku'): l10n.languageKurdish,
    };
  }

  Future<void> _requestLocation() async {
    await ref.read(locationPermissionProvider.notifier).requestWhileUsingApp();
    if (mounted) {
      setState(() => _locationRequested = true);
    }
  }

  void _skipCurrentStep() {
    if (_step < _lastIndex) {
      _next();
    }
  }

  void _previous() {
    if (_step == 0) return;
    setState(() => _step -= 1);
    _controller.animateToPage(
      _step,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_step == 3 && _nameController.text.trim().isEmpty) {
      return;
    }
    if (_step >= _lastIndex) return;
    setState(() => _step += 1);
    _controller.animateToPage(
      _step,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _finish() {
    final profileNotifier = ref.read(userProfileProvider.notifier);
    final localeNotifier = ref.read(appLocaleProvider.notifier);
    final prayerNotifier = ref.read(prayerSettingsProvider.notifier);
    final settingsNotifier = ref.read(profileSettingsProvider.notifier);

    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      profileNotifier.updateName(name);
    }
    profileNotifier.updateSex(_selectedSex);
    localeNotifier.setLocale(_selectedLocale);
    prayerNotifier.updateLocation(_selectedLocation);
    prayerNotifier.updateMadhab(_selectedMadhab);
    prayerNotifier.updateMethod(_selectedMethod);

    settingsNotifier.setPrayerReminders(_prayerReminders);
    settingsNotifier.setDhikrReminders(_dhikrReminders);
    settingsNotifier.setQuranReminders(_quranReminders);
    settingsNotifier.setReflectionReminders(_reflectionReminders);
    settingsNotifier.setFastingReminders(_fastingReminders);
    settingsNotifier.setRamadanModeEnabled(_modeChoice == _ModeChoice.ramadan);
    settingsNotifier.setLossModeEnabled(_modeChoice == _ModeChoice.loss);
    settingsNotifier.setGentleModeEnabled(_modeChoice == _ModeChoice.gentle);

    ref.read(onboardingCompletedProvider.notifier).complete();
    context.go('/home');
  }
}

enum _ModeChoice { ramadan, gentle, loss }

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onSelected,
    required this.labels,
  });

  final String title;
  final String subtitle;
  final Locale selected;
  final ValueChanged<Locale> onSelected;
  final Map<Locale, String> labels;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: labels.entries.map((entry) {
                final locale = entry.key;
                final selectedNow =
                    selected.languageCode == locale.languageCode &&
                    selected.countryCode == locale.countryCode;
                return ListTile(
                  dense: true,
                  leading: Icon(
                    selectedNow
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 18,
                  ),
                  title: Text(entry.value),
                  onTap: () => onSelected(locale),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SexStep extends StatelessWidget {
  const _SexStep({
    required this.title,
    required this.brother,
    required this.sister,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final String brother;
  final String sister;
  final UserSex selected;
  final ValueChanged<UserSex> onChanged;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SegmentedButton<UserSex>(
            segments: [
              ButtonSegment(value: UserSex.brother, label: Text(brother)),
              ButtonSegment(value: UserSex.sister, label: Text(sister)),
            ],
            selected: {selected},
            onSelectionChanged: (value) => onChanged(value.first),
          ),
        ],
      ),
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.title,
    required this.subtitle,
    required this.controller,
  });

  final String title;
  final String subtitle;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLength: 26,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({
    required this.title,
    required this.subtitle,
    required this.locationRequested,
    required this.onRequest,
  });

  final String title;
  final String subtitle;
  final bool locationRequested;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          Text(
            locationRequested
                ? l10n.homeLocationEnabledWhileUsing
                : l10n.homeLocationAllowWhileUsingForPrayer,
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onRequest,
            child: Text(l10n.profileAllow),
          ),
        ],
      ),
    );
  }
}

class _PrayerSetupStep extends StatelessWidget {
  const _PrayerSetupStep({
    required this.title,
    required this.locationLabel,
    required this.madhabLabel,
    required this.methodLabel,
    required this.selectedLocation,
    required this.selectedMadhab,
    required this.selectedMethod,
    required this.locations,
    required this.onLocationChanged,
    required this.onMadhabChanged,
    required this.onMethodChanged,
  });

  final String title;
  final String locationLabel;
  final String madhabLabel;
  final String methodLabel;
  final String selectedLocation;
  final PrayerMadhab selectedMadhab;
  final PrayerCalculationMethod selectedMethod;
  final List<String> locations;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<PrayerMadhab> onMadhabChanged;
  final ValueChanged<PrayerCalculationMethod> onMethodChanged;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey(selectedLocation),
              initialValue: selectedLocation,
              decoration: InputDecoration(labelText: locationLabel),
              items: locations
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onLocationChanged(value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PrayerMadhab>(
              key: ValueKey(selectedMadhab),
              initialValue: selectedMadhab,
              decoration: InputDecoration(labelText: madhabLabel),
              items: PrayerMadhab.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(prayerMadhabLabels[prayerMadhabKey[value]!]!),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onMadhabChanged(value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PrayerCalculationMethod>(
              key: ValueKey(selectedMethod),
              initialValue: selectedMethod,
              decoration: InputDecoration(labelText: methodLabel),
              items: PrayerCalculationMethod.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(prayerMethodLabels[prayerMethodKey[value]!]!),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onMethodChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderStep extends StatelessWidget {
  const _ReminderStep({
    required this.title,
    required this.subtitle,
    required this.prayerReminders,
    required this.dhikrReminders,
    required this.quranReminders,
    required this.reflectionReminders,
    required this.fastingReminders,
    required this.onPrayerChanged,
    required this.onDhikrChanged,
    required this.onQuranChanged,
    required this.onReflectionChanged,
    required this.onFastingChanged,
  });

  final String title;
  final String subtitle;
  final bool prayerReminders;
  final bool dhikrReminders;
  final bool quranReminders;
  final bool reflectionReminders;
  final bool fastingReminders;
  final ValueChanged<bool> onPrayerChanged;
  final ValueChanged<bool> onDhikrChanged;
  final ValueChanged<bool> onQuranChanged;
  final ValueChanged<bool> onReflectionChanged;
  final ValueChanged<bool> onFastingChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 10),
          SwitchListTile(
            value: prayerReminders,
            title: Text(l10n.profilePrayerReminders),
            onChanged: onPrayerChanged,
          ),
          SwitchListTile(
            value: dhikrReminders,
            title: Text(l10n.profileDhikrReminders),
            onChanged: onDhikrChanged,
          ),
          SwitchListTile(
            value: quranReminders,
            title: Text(l10n.profileQuranReminders),
            onChanged: onQuranChanged,
          ),
          SwitchListTile(
            value: reflectionReminders,
            title: Text(l10n.profileReflectionReminders),
            onChanged: onReflectionChanged,
          ),
          SwitchListTile(
            value: fastingReminders,
            title: Text(l10n.profileFastingReminders),
            onChanged: onFastingChanged,
          ),
        ],
      ),
    );
  }
}

class _ModeStep extends StatelessWidget {
  const _ModeStep({
    required this.title,
    required this.subtitle,
    required this.modeChoice,
    required this.onChanged,
    required this.ramadanTitle,
    required this.gentleTitle,
    required this.lossTitle,
  });

  final String title;
  final String subtitle;
  final _ModeChoice modeChoice;
  final ValueChanged<_ModeChoice> onChanged;
  final String ramadanTitle;
  final String gentleTitle;
  final String lossTitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          SegmentedButton<_ModeChoice>(
            segments: [
              ButtonSegment(
                value: _ModeChoice.gentle,
                label: Text(gentleTitle),
              ),
              ButtonSegment(
                value: _ModeChoice.ramadan,
                label: Text(ramadanTitle),
              ),
              ButtonSegment(value: _ModeChoice.loss, label: Text(lossTitle)),
            ],
            selected: {modeChoice},
            onSelectionChanged: (value) => onChanged(value.first),
          ),
        ],
      ),
    );
  }
}

class _FinishStep extends StatelessWidget {
  const _FinishStep({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }
}
