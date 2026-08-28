import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/nav_tabs.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/celestial/presentation/widgets/celestial_cycle_card.dart';
import '../../../features/history/presentation/widgets/on_this_day_home_card.dart';
import '../application/home_calendar_progress_provider.dart';
import '../../../shared/content/contextual_quran_quotes.dart';
import '../../../features/worship/presentation/widgets/salah_timings_tracker_card.dart';
import '../../../features/learn/prophets/application/daily_learning_service.dart';
import '../../../features/learn/prophets/application/prophets_repository.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_prophet_quiz_card.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_revelation_card.dart';
import '../../../features/learn/quran/application/quran_personalization_provider.dart';
import '../../../features/learn/quran/application/quran_spiritual_moment_provider.dart';
import '../../../features/learn/quran/domain/quran_personalization_models.dart';
import '../../../features/learn/quran/domain/quran_spiritual_moment_models.dart';
import '../../../features/learn/quran/presentation/widgets/quran_daily_reflection_card.dart';
import '../../../features/learn/quran/presentation/widgets/quran_personalized_recommendation_card.dart';
import '../../../features/learn/quran/presentation/widgets/quran_spiritual_moment_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/profile/profile_logo_assets.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/shell_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/arabic_text_utils.dart';
import '../../../shared/widgets/app_salah_hero_card.dart';
import '../../../shared/widgets/main_page_shortcut_configs.dart';
import '../../../shared/widgets/main_page_shortcut_stack.dart';
import '../../../shared/widgets/noor_glass_card.dart';
import '../../../shared/widgets/noor_liquid_glass.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_title.dart';
import 'widgets/ramadan_hero_card.dart';
import 'widgets/right_now_dua_row.dart';
import '../../../shared/utils/compact_duration_formatter.dart';

String _formatLocalizedCount(BuildContext context, num value) {
  return NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

String _formatHomePrayerTrackerTotal(
  BuildContext context, {
  required int trackedPrayerTotal,
  required bool includeTahajjudOffer,
}) {
  final total = _formatLocalizedCount(context, trackedPrayerTotal);
  if (!includeTahajjudOffer) {
    return total;
  }
  // Five daily prayers plus the optional Tahajjud offer (e.g. "5+1").
  return '$total+${_formatLocalizedCount(context, 1)}';
}

const int _shortcutDailyDhikrGoal = 500;
const double _homeFloatingShortcutBottomOffset = 92;
const double _homeFloatingShortcutContentPadding = 136;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static final math.Random _verseRandom = math.Random();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final verseVersion = ref.watch(homeVerseVersionProvider);
    final prayerCompleted = ref.watch(
      worshipSummaryProvider.select((summary) => summary.prayerCompleted),
    );
    final prayerTotal = ref.watch(
      worshipSummaryProvider.select((summary) => summary.prayerTotal),
    );
    final dhikrCount = ref.watch(
      worshipSummaryProvider.select((summary) => summary.dhikrCount),
    );
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final quranBundle = ref.watch(
      quranPersonalizedRecommendationBundleProvider((
        QuranPersonalizationSurface.home,
        isKidsMode,
      )),
    );
    final spiritualMoment = ref.watch(
      quranSpiritualMomentBundleProvider((
        QuranSpiritualMomentSurface.home,
        isKidsMode,
        Localizations.localeOf(context).languageCode,
      )),
    );
    final displayVerse =
        homeContextualQuotePool[verseVersion % homeContextualQuotePool.length];
    final includesTahajjudOffer = scheduleContext.items.any(
      (item) => item.id == 'tahajjud',
    );
    final trackedPrayerTotal = math.max(prayerTotal, 5);
    final salahProgressText =
        '${_formatLocalizedCount(context, prayerCompleted)}/${_formatHomePrayerTrackerTotal(context, trackedPrayerTotal: trackedPrayerTotal, includeTahajjudOffer: includesTahajjudOffer)}';

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              18,
              8,
              18,
              _homeFloatingShortcutContentPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopGreetingBlock(l10n: l10n, userProfile: userProfile),
                const SizedBox(height: 12),
                const RamadanHeroCard(),
                _SalahSummaryCard(l10n: l10n),
                const SizedBox(height: 12),
                const _DailySalahTimingsCard(),
                const SizedBox(height: 12),
                const _ModeAwareHomeCard(),
                const RightNowDuaRow(),
                _AyahCard(
                  verse: displayVerse,
                  onTap: () => ref
                      .read(homeVerseVersionProvider.notifier)
                      .update((state) {
                        final poolLength = homeContextualQuotePool.length;
                        if (poolLength <= 1) {
                          return state;
                        }
                        var next = HomePage._verseRandom.nextInt(poolLength);
                        final current = state % poolLength;
                        while (next == current) {
                          next = HomePage._verseRandom.nextInt(poolLength);
                        }
                        return next;
                      }),
                ),
                const SizedBox(height: 14),
                _TodayContentSection(
                  quranBundle: quranBundle,
                  spiritualMoment: spiritualMoment,
                ),
                const SizedBox(height: 14),
                const OnThisDayHomeCard(),
                const SizedBox(height: 12),
                const CelestialCycleCard(collapsible: true),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom:
                (_homeFloatingShortcutBottomOffset -
                        MediaQuery.viewPaddingOf(context).bottom)
                    .clamp(58.0, _homeFloatingShortcutBottomOffset),
            child: Align(
              alignment: Alignment.centerRight,
              child: _HomeFloatingShortcutSection(
                isKidsMode: isKidsMode,
                salahProgressText: salahProgressText,
                dhikrProgressText:
                    '${_formatLocalizedCount(context, dhikrCount)}/${_formatLocalizedCount(context, _shortcutDailyDhikrGoal)}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeFloatingShortcutSection extends StatelessWidget {
  const _HomeFloatingShortcutSection({
    required this.isKidsMode,
    required this.salahProgressText,
    required this.dhikrProgressText,
  });

  final bool isKidsMode;
  final String salahProgressText;
  final String dhikrProgressText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MainPageShortcutStack(
      items: buildHomePageShortcuts(
        l10n,
        salahProgressText: salahProgressText,
        dhikrProgressText: dhikrProgressText,
      ),
      openLabel: l10n.homeShortcutOpen,
      closeLabel: isKidsMode
          ? l10n.kidsHomeShortcutClose
          : l10n.homeShortcutClose,
      openIcon: Icons.apps_rounded,
      closeIcon: Icons.close_rounded,
    );
  }
}

class _TodayContentSection extends StatelessWidget {
  const _TodayContentSection({
    required this.quranBundle,
    required this.spiritualMoment,
  });

  final QuranRecommendationBundle? quranBundle;
  final QuranSpiritualMomentBundle? spiritualMoment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.homeTodayContentTitle,
          subtitle: l10n.homeTodayContentSubtitle,
        ),
        const QuranDailyReflectionCard(
          compact: true,
          showCompanionAction: true,
          showSecondaryActions: false,
        ),
        if (spiritualMoment != null) ...[
          const SizedBox(height: 10),
          QuranSpiritualMomentCard(
            bundle: spiritualMoment!,
            surface: QuranSpiritualMomentSurface.home,
            allowDismiss: true,
          ),
        ],
        if (quranBundle != null) ...[
          const SizedBox(height: 10),
          QuranPersonalizedRecommendationCard(
            bundle: quranBundle!,
            surface: QuranPersonalizationSurface.home,
            allowDismiss: true,
          ),
        ],
        const SizedBox(height: 10),
        PremiumCard(
          density: PremiumCardDensity.compact,
          surfaceTintColor: const Color(0xFFE7C98C),
          surfaceAlphaOverride: 0.2,
          child: const _HomeLearningActionsCard(),
        ),
      ],
    );
  }
}

class _DailySalahTimingsCard extends ConsumerWidget {
  const _DailySalahTimingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(homePrayerSelectedDateProvider);
    return SalahTimingsTrackerCard(
      selectedDate: selectedDate,
      onSelectedDateChanged: (value) {
        ref.read(homePrayerSelectedDateProvider.notifier).state = value;
      },
    );
  }
}

class _TopGreetingBlock extends StatelessWidget {
  const _TopGreetingBlock({required this.l10n, required this.userProfile});

  final AppLocalizations l10n;
  final UserProfileState userProfile;

  String get _address {
    return userProfile.sex == UserSex.brother
        ? l10n.profileBrother
        : l10n.profileSister;
  }

  String get _profileLogoAsset {
    return resolveProfileLogoAsset(userProfile.sex);
  }

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground =
        appearance?.backgroundForeground ??
        Theme.of(context).colorScheme.onSurface;
    final iconColor = appearance?.accent ?? foreground;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(IslamicIcons.mosque, size: 24, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  l10n.navHome,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                    fontFamily: AppFonts.latinSerif,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => context.pushNamed('allSearch'),
              icon: Icon(Icons.search_rounded, size: 30, color: iconColor),
              tooltip: l10n.homeSearchTooltip,
            ),
            IconButton(
              onPressed: () => context.goNamed('settings'),
              icon: Icon(Icons.settings, size: 30, color: iconColor),
              tooltip: l10n.profilePrayerSettingsTitle,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          l10n.greetingArabic,
          textAlign: textAlignForContent(l10n.greetingArabic),
          textDirection: textDirectionForContent(l10n.greetingArabic),
          style: TextStyle(
            fontSize: 20,
            color: foreground,
            height: 1.15,
            fontFamily: AppFonts.latinSerif,
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.goNamed('settings'),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Text(
                    '$_address ${userProfile.name}',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                      letterSpacing: 0.2,
                      fontFamily: AppFonts.latinSerif,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer(
                    builder: (context, ref, _) {
                      // Sacred-time greeting: Jumu'ah Mubarak on Fridays,
                      // Ramadan Mubarak through the month, salam otherwise.
                      final now =
                          ref.watch(dailyNowProvider).value ?? DateTime.now();
                      final isRamadan = ref.watch(
                        specialModeProvider.select((mode) => mode.isRamadan),
                      );
                      final isFriday = now.weekday == DateTime.friday;
                      final occasion = isFriday
                          ? l10n.homeGreetingJumuahMubarak
                          : isRamadan
                          ? l10n.homeGreetingRamadanMubarak
                          : null;
                      final appearance = Theme.of(
                        context,
                      ).extension<AppAppearanceTheme>();
                      return Text(
                        occasion ?? l10n.peaceUponYou,
                        style: TextStyle(
                          fontSize: occasion != null ? 16 : 15,
                          fontWeight: occasion != null
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: occasion != null
                              ? (appearance?.accent ?? foreground)
                              : foreground,
                          fontFamily: AppFonts.latinSerif,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    _profileLogoAsset,
                    width: 112,
                    height: 112,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          width: 112,
                          height: 112,
                          child: Icon(Icons.account_circle_rounded, size: 64),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AyahCard extends StatelessWidget {
  const _AyahCard({required this.verse, required this.onTap});

  final QuranQuote verse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QuranQuoteBlock(
      quote: verse,
      onTap: onTap,
      margin: EdgeInsets.zero,
      arabicTransform: (arabic) => arabic,
      transliterationTransform: (transliteration) => transliteration,
      translationTransform: (translation) => translation,
    );
  }
}

class _SalahSummaryCard extends ConsumerWidget {
  const _SalahSummaryCard({required this.l10n});

  static const _zenithForbiddenLead = Duration(minutes: 5);
  static const _sunsetForbiddenLead = Duration(minutes: 20);

  final AppLocalizations l10n;

  Future<void> _showLocationPicker(
    BuildContext context,
    WidgetRef ref,
    String currentLocationLabel,
  ) async {
    final service = ref.read(prayerLocationSearchServiceProvider);
    final recentLocations = ref.read(prayerRecentLocationsProvider);
    final selection = await showModalBottomSheet<PrayerLocationPickerSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PrayerLocationPickerSheet(
        currentLocationLabel: currentLocationLabel,
        recentLocations: recentLocations,
        onSearch: service.search,
      ),
    );
    if (selection == null) return;
    final notifier = ref.read(prayerSettingsProvider.notifier);
    if (selection.useDeviceLocation) {
      final permissionNotifier = ref.read(locationPermissionProvider.notifier);
      await permissionNotifier.requestWhileUsingApp();
      notifier.useCurrentLocation();
      return;
    }
    if (selection.latitude == null || selection.longitude == null) return;
    await ref
        .read(prayerRecentLocationsStoreProvider)
        .save(
          PrayerRecentLocation(
            label: selection.label,
            latitude: selection.latitude!,
            longitude: selection.longitude!,
          ),
        );
    notifier.setManualLocation(
      label: selection.label,
      latitude: selection.latitude!,
      longitude: selection.longitude!,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(homeDashboardSummaryProvider);
    final worship = summary.worship;
    final journey = summary.journey;
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final prayerSettings = ref.watch(prayerSettingsProvider);
    final prayerLocation = ref.watch(prayerLocationProvider);
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider);
    final todaySchedule = buildPrayerScheduleForDate(
      date: DateTime(now.year, now.month, now.day),
      latitude: prayerLocation.latitude,
      longitude: prayerLocation.longitude,
      settings: prayerSettings.preferences,
    ).toList(growable: false);
    final next = scheduleContext.items
        .where((item) => item.id == scheduleContext.nextPrayerId)
        .firstOrNull;
    final current = scheduleContext.items
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final forbiddenPeriod = _activeForbiddenPeriod(
      l10n,
      scheduleContext.items,
      now,
    );

    final nextName = next == null
        ? localizedPrayerNameForDate(prayerId: 'dhuhr', l10n: l10n, date: now)
        : localizedPrayerNameForDate(prayerId: next.id, l10n: l10n, date: now);
    final nextArabic = next == null
        ? arabicPrayerNameForDate(prayerId: 'dhuhr', date: now)
        : arabicPrayerNameForDate(prayerId: next.id, date: now);
    final nextAt = next?.offerTime ?? l10n.atTime.replaceFirst('at ', '');
    final currentEndsIn = current == null
        ? null
        : _formatDuration(
            context,
            l10n,
            current.overdueDateTime.difference(now),
          );
    final offerByLabel = l10n.homePrayerBeginsAt(nextAt);
    final offerByValue = nextAt;
    final includesTahajjudOffer = todaySchedule.any(
      (item) => item.id == 'tahajjud',
    );
    final trackedPrayerTotal = math.max(worship.prayerTotal, 5);
    final prayerCompletedValue = l10n.homeFractionValue(
      _formatLocalizedCount(context, worship.prayerCompleted),
      _formatHomePrayerTrackerTotal(
        context,
        trackedPrayerTotal: trackedPrayerTotal,
        includeTahajjudOffer: includesTahajjudOffer,
      ),
    );
    final dhikrDailyGoal = math.max(worship.dhikrTarget, 500);
    final dhikrValue = l10n.homeFractionValue(
      _formatLocalizedCount(context, worship.dhikrCount),
      _formatLocalizedCount(context, dhikrDailyGoal),
    );
    final locationLabel =
        displayLocation.valueOrNull ??
        (prayerSettings.preferences.useDeviceLocation
            ? l10n.settingsCurrentLocation
            : prayerSettings.preferences.location);

    final metaChips = <AppSalahHeroMetaChipData>[
      if (forbiddenPeriod != null)
        AppSalahHeroMetaChipData(
          icon: Icons.block_rounded,
          label: '${forbiddenPeriod.label} • ${forbiddenPeriod.value}',
          color: const Color(0xFFD01919),
        )
      else if (current != null) ...[
        AppSalahHeroMetaChipData(
          icon: Icons.timelapse_rounded,
          label:
              '${l10n.homeTimeRemainingToOffer(current.name)} • ${currentEndsIn ?? current.overdueAt}',
        ),
        if (current.hasDelayedMakeUpWindow)
          AppSalahHeroMetaChipData(
            icon: Icons.warning_amber_rounded,
            label: l10n.homePrayerBecomesQada(
              current.name,
              current.name,
              current.overdueAt,
            ),
            color: const Color(0xFF9A6D16),
          ),
      ],
    ];

    return AppSalahHeroCard(
      locationLabel: locationLabel,
      nextName: nextName,
      nextArabic: nextArabic,
      offerByLabel: offerByLabel,
      offerByValue: offerByValue,
      stats: [
        AppSalahHeroStat(
          title: l10n.homeShortcutSalahLabel,
          value: prayerCompletedValue,
          subtitle: l10n.homeShortcutDailyCaption,
          icon: Icons.checklist_rounded,
          tint: const Color(0xFF9F7A42),
        ),
        AppSalahHeroStat(
          title: l10n.homeShortcutDhikrLabel,
          value: dhikrValue,
          subtitle: l10n.homeShortcutDailyCaption,
          icon: Icons.favorite_outline_rounded,
          tint: const Color(0xFF8F7547),
        ),
        AppSalahHeroStat(
          title: l10n.streakLabel,
          value: _formatLocalizedCount(context, journey.currentStreakDays),
          subtitle: l10n.homeDaysLabel,
          icon: Icons.local_fire_department_outlined,
          tint: const Color(0xFFB56D43),
        ),
      ],
      metaChips: metaChips,
      onOpenSalahTimes: () => context.pushNamed('salahTimes'),
      onOpenLocationPicker: () =>
          _showLocationPicker(context, ref, locationLabel),
    );
  }

  String _formatDuration(
    BuildContext context,
    AppLocalizations l10n,
    Duration value,
  ) {
    return formatCompactDuration(
      value,
      localeName: l10n.localeName,
      hourSuffix: l10n.durationCompactHourSuffix,
      minuteSuffix: l10n.durationCompactMinuteSuffix,
    );
  }

  _ForbiddenPrayerPeriod? _activeForbiddenPeriod(
    AppLocalizations l10n,
    List<PrayerScheduleItem> items,
    DateTime now,
  ) {
    PrayerScheduleItem? itemById(String id) =>
        items.where((item) => item.id == id).firstOrNull;

    final fajr = itemById('fajr');
    if (fajr != null) {
      final sunriseStart = fajr.overdueDateTime;
      final sunriseEnd = fajr.makeUpFromDateTime;
      if (!now.isBefore(sunriseStart) && now.isBefore(sunriseEnd)) {
        return _ForbiddenPrayerPeriod(
          label: l10n.homePrayerForbiddenSunrise,
          value: l10n.homeUntilTime(fajr.makeUpFrom),
        );
      }
    }

    final dhuhr = itemById('dhuhr');
    if (dhuhr != null) {
      final zenithStart = dhuhr.windowStartDateTime.subtract(
        _zenithForbiddenLead,
      );
      final zenithEnd = dhuhr.windowStartDateTime;
      if (!now.isBefore(zenithStart) && now.isBefore(zenithEnd)) {
        return _ForbiddenPrayerPeriod(
          label: l10n.homePrayerForbiddenZenith,
          value: l10n.homeUntilTime(dhuhr.windowStart),
        );
      }
    }

    final maghrib = itemById('maghrib');
    if (maghrib != null) {
      final sunsetStart = maghrib.windowStartDateTime.subtract(
        _sunsetForbiddenLead,
      );
      final sunsetEnd = maghrib.windowStartDateTime;
      if (!now.isBefore(sunsetStart) && now.isBefore(sunsetEnd)) {
        return _ForbiddenPrayerPeriod(
          label: l10n.homePrayerForbiddenSunset,
          value: l10n.homeUntilTime(maghrib.windowStart),
        );
      }
    }

    return null;
  }
}

class _ForbiddenPrayerPeriod {
  const _ForbiddenPrayerPeriod({required this.label, required this.value});

  final String label;
  final String value;
}

class _ModeAwareHomeCard extends ConsumerWidget {
  const _ModeAwareHomeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(homeDashboardSummaryProvider);
    final mode = summary.mode.activeMode;
    if ((mode == AppSpecialMode.none || mode == AppSpecialMode.gentle) &&
        !summary.mode.isKidsMode) {
      return const SizedBox.shrink();
    }

    String title;
    String subtitle;
    IconData icon;
    List<Widget> actions;

    switch (mode) {
      case AppSpecialMode.ramadan:
        title = l10n.modeRamadanHomeTitle;
        subtitle = l10n.modeRamadanHomeSubtitle;
        icon = Icons.nightlight_round;
        actions = [
          _ModeActionChip(
            icon: Icons.fastfood_outlined,
            label: l10n.modeRamadanActionFasting,
            onTap: () => context.pushNamed('worshipFastingPage'),
          ),
          _ModeActionChip(
            icon: Icons.menu_book_outlined,
            label: l10n.modeRamadanActionQuran,
            onTap: () => context.pushNamed('quranExplorer'),
          ),
          _ModeActionChip(
            icon: Icons.rate_review_outlined,
            label: l10n.modeRamadanActionReflect,
            onTap: () => context.pushNamed('learnNotesLanding'),
          ),
        ];
        break;
      case AppSpecialMode.loss:
        title = l10n.modeLossHomeTitle;
        subtitle = l10n.modeLossHomeSubtitle;
        icon = Icons.favorite_border;
        actions = [
          _ModeActionChip(
            icon: Icons.self_improvement_rounded,
            label: l10n.modeLossActionDhikr,
            onTap: () => goToTab(context, NavTab.worship),
          ),
          _ModeActionChip(
            icon: Icons.spa_outlined,
            label: l10n.modeLossActionKhusu,
            onTap: () => context.pushNamed('khusuFocus'),
          ),
          _ModeActionChip(
            icon: Icons.menu_book_outlined,
            label: l10n.modeLossActionMercy,
            onTap: () => context.pushNamed('quranExplorer'),
          ),
        ];
        break;
      case AppSpecialMode.unwell:
        title = l10n.settingsCareModeUnwellTitle;
        subtitle = l10n.settingsCareModeUnwellBody;
        icon = Icons.local_hospital_outlined;
        actions = [
          _ModeActionChip(
            icon: Icons.self_improvement_rounded,
            label: l10n.modeLossActionDhikr,
            onTap: () => goToTab(context, NavTab.worship),
          ),
          _ModeActionChip(
            icon: Icons.menu_book_outlined,
            label: l10n.modeRamadanActionQuran,
            onTap: () => context.pushNamed('quranExplorer'),
          ),
        ];
        break;
      case AppSpecialMode.gentle:
        return const SizedBox.shrink();
      case AppSpecialMode.none:
        if (!summary.mode.isKidsMode) return const SizedBox.shrink();
        title = l10n.kidsModeTitle;
        subtitle = l10n.kidsHomeHint;
        icon = Icons.child_care_outlined;
        actions = [
          _ModeActionChip(
            icon: Icons.menu_book_outlined,
            label: l10n.kidsHomeQuickLearning,
            onTap: () => goToTab(context, NavTab.learn),
          ),
          _ModeActionChip(
            icon: Icons.auto_stories_outlined,
            label: l10n.kidsHomeQuickJournal,
            onTap: () => context.pushNamed('journalTimeline'),
          ),
        ];
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        density: PremiumCardDensity.compact,
        surfaceTintColor: const Color(0xFFE6B85F),
        surfaceAlphaOverride: 0.32,
        leading: Icon(icon, color: AppColors.accentGoldSoft),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.latinSerif,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: const TextStyle(height: 1.35)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}

class _HomeLearningActionsCard extends ConsumerWidget {
  const _HomeLearningActionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dailyBundle = ref.watch(todayDailyLearningBundleProvider);
    final dailyController = ref.read(dailyLearningControllerProvider.notifier);
    final allProphets = ref.watch(prophetsProvider);

    void openProphetById(String prophetId) {
      context.pushNamed(
        'learnProphetsHub',
        queryParameters: {'prophet': prophetId},
      );
    }

    void openDailyItem() {
      final item = dailyBundle.item;
      dailyController.markTodayCardOpened();
      final linkedProphetId = item.linkedProphetId;
      if (linkedProphetId != null &&
          allProphets.any((entry) => entry.id == linkedProphetId)) {
        dailyController.markTodayLinkedProphetOpened(linkedProphetId);
        openProphetById(linkedProphetId);
        return;
      }
      context.pushNamed(
        'learnProphetsHub',
        queryParameters: const {'tab': 'stories'},
      );
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyRevelationCard(
          item: dailyBundle.item,
          isOpened: dailyBundle.status.cardOpened,
          onOpen: openDailyItem,
          onTakeQuiz: () => context.pushNamed(
            'learnProphetsHub',
            queryParameters: {'tab': 'quiz'},
          ),
          showPracticeLesson: dailyBundle.item.linkedGrowthHabitId != null,
          surfaceTreatment: AppSurfaceTreatment.standard,
          onPracticeLesson: () {
            final habitId = dailyBundle.item.linkedGrowthHabitId;
            if (habitId != null && habitId.trim().isNotEmpty) {
              context.go('/journey/habit/$habitId');
              return;
            }
            context.go('/journey/habits');
          },
        ),
        const SizedBox(height: 10),
        DailyProphetQuizCard(
          question: dailyBundle.quizQuestion,
          isAnswered: dailyBundle.status.quizAnswered,
          selectedIndex: dailyBundle.status.quizSelectedIndex,
          surfaceTreatment: AppSurfaceTreatment.standard,
          onSelectAnswer: (selected) {
            dailyController.answerTodayQuiz(
              questionId: dailyBundle.quizQuestion.id,
              selectedIndex: selected,
              correctIndex: dailyBundle.quizQuestion.correctAnswerIndex,
            );
          },
          onReviewProphet: () =>
              openProphetById(dailyBundle.quizQuestion.relatedProphetId),
          onOpenFullQuiz: () => context.pushNamed(
            'learnProphetsHub',
            queryParameters: {'tab': 'quiz'},
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _QuickActionButton(
              icon: Icons.auto_stories_rounded,
              label: l10n.homeDailyLearningProphetsQuiz,
              onTap: () => context.pushNamed(
                'learnProphetsHub',
                queryParameters: {'tab': 'quiz'},
              ),
            ),
            _QuickActionButton(
              icon: Icons.quiz_rounded,
              label: l10n.homeDailyLearningIslamicTrivia,
              onTap: () => context.pushNamed(
                'learnQuizzesHub',
                queryParameters: {'filter': 'trivia'},
              ),
            ),
            _QuickActionButton(
              icon: Icons.route_rounded,
              label: l10n.homeDailyLearningKnowledgePaths,
              onTap: () => context.pushNamed('learnTriviaKnowledgePaths'),
            ),
            _QuickActionButton(
              icon: Icons.replay_circle_filled_rounded,
              label: l10n.homeDailyLearningReviewMistakes,
              onTap: () => context.pushNamed('learnTriviaReview'),
            ),
          ],
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeDailyLearningQuizzesTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(l10n.homeDailyLearningQuizzesSubtitle),
        const SizedBox(height: 10),
        content,
      ],
    );
  }
}

class _ModeActionChip extends StatelessWidget {
  const _ModeActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: NoorGlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          surfaceVariant: AppSurfaceVariant.pill,
          surfaceTintColor: AppColors.accentGold,
          surfaceAlphaOverride: 0.18,
          includeShadow: false,
          mode: NoorLiquidGlassMode.fake,
          borderRadius: 14,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color:
                    Theme.of(
                      context,
                    ).extension<AppAppearanceTheme>()?.onSurface ??
                    AppColors.onSurface,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: NoorGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        surfaceVariant: AppSurfaceVariant.pill,
        surfaceTintColor: AppColors.accentGold,
        surfaceAlphaOverride: 0.18,
        includeShadow: false,
        mode: NoorLiquidGlassMode.fake,
        borderRadius: 14,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accentGold, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
