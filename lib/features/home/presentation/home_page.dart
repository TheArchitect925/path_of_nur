import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/nav_tabs.dart';
import '../../../core/prayer/prayer_forbidden_periods.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/occasion_theme.dart';
import '../../../features/celestial/presentation/widgets/celestial_cycle_card.dart';
import '../../../features/history/presentation/widgets/on_this_day_home_card.dart';
import '../../../features/learn/quran/application/quran_personalization_provider.dart';
import '../../../features/learn/quran/application/quran_spiritual_moment_provider.dart';
import '../../../features/learn/quran/domain/quran_personalization_models.dart';
import '../../../features/learn/quran/domain/quran_spiritual_moment_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/arabic_text_utils.dart';
import '../../../shared/widgets/app_salah_hero_card.dart';
import '../../../shared/widgets/display/expandable_tile.dart';
import '../../../shared/widgets/noor_glass_card.dart';
import '../../../shared/widgets/noor_liquid_glass.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../../worship/application/dhikr_daily_goal_provider.dart';
import '../application/home_module_prefs_provider.dart';
import '../domain/home_modules.dart';
import 'widgets/home_prayer_strip.dart';
import 'widgets/home_today_card.dart';
import '../../../shared/widgets/quick_actions_sheet.dart';
import 'widgets/occasion_offer_sheet.dart';
import 'widgets/garden_vista_home_card.dart';
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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Widget _buildModule(HomeModule module) {
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    switch (module) {
      case HomeModule.prayerStrip:
        return const Padding(
          padding: EdgeInsets.only(top: 12),
          child: HomePrayerStrip(),
        );
      case HomeModule.garden:
        if (isKidsMode) {
          return const SizedBox.shrink();
        }
        return const Padding(
          padding: EdgeInsets.only(top: 16),
          child: GardenVistaHomeCard(),
        );
      case HomeModule.today:
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
        final todayL10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ExpandableTile(
            leading: const Icon(Icons.auto_stories_rounded, size: 20),
            title: Text(todayL10n.homeTodayContentTitle),
            subtitle: Text(todayL10n.homeTodayContentSubtitle),
            // The day's ayah is primary content, so it opens expanded; the
            // control is there for readers who would rather tuck it away.
            initiallyExpanded: true,
            child: HomeTodayCard(
              quranBundle: quranBundle,
              spiritualMoment: spiritualMoment,
              showSectionTitle: false,
            ),
          ),
        );
      case HomeModule.duasNow:
        return const Padding(
          padding: EdgeInsets.only(top: 4),
          child: RightNowDuaRow(),
        );
      case HomeModule.onThisDay:
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: ExpandableTile(
            leading: const Icon(Icons.history_edu_rounded, size: 20),
            title: Text(l10n.historyOnThisDayTitle),
            subtitle: Text(l10n.historyOnThisDaySubtitle),
            child: const OnThisDayHomeCard(),
          ),
        );
      case HomeModule.celestial:
        return const Padding(
          padding: EdgeInsets.only(top: 12),
          child: CelestialCycleCard(
            collapsible: true,
            initiallyExpanded: false,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final modules = ref.watch(homeModulePrefsProvider).visible;

    return SafeArea(
      child: Stack(
        children: [
          const OccasionOfferCoordinator(),
          const QuickActionsHintCoordinator(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopGreetingBlock(l10n: l10n, userProfile: userProfile),
                const SizedBox(height: 12),
                const RamadanHeroCard(),
                _SalahSummaryCard(l10n: l10n),
                const SizedBox(height: 12),
                const _ModeAwareHomeCard(),
                for (final module in modules) _buildModule(module),
                const SizedBox(height: 18),
                const _HomeEditEntryButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Quiet entry into "Customize Home" at the bottom of the scroll.
class _HomeEditEntryButton extends StatelessWidget {
  const _HomeEditEntryButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final subtle =
        appearance?.onSurfaceSubtle ?? Theme.of(context).colorScheme.onSurface;
    return Center(
      child: TextButton.icon(
        onPressed: () => context.pushNamed('homeEdit'),
        icon: Icon(Icons.edit_outlined, size: 15, color: subtle),
        label: Text(
          l10n.homeEditEntryLabel,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: subtle),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground =
        appearance?.backgroundForeground ??
        Theme.of(context).colorScheme.onSurface;
    final iconColor = appearance?.accent ?? foreground;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.goNamed('settings'),
              borderRadius: BorderRadius.circular(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.greetingArabic,
                    textAlign: textAlignForContent(l10n.greetingArabic),
                    textDirection: textDirectionForContent(l10n.greetingArabic),
                    style: TextStyle(
                      fontSize: 14,
                      color: foreground,
                      height: 1.2,
                      fontFamily: AppFonts.latinSerif,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$_address ${userProfile.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                      letterSpacing: 0.2,
                      fontFamily: AppFonts.latinSerif,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Consumer(
                    builder: (context, ref, _) {
                      // Sacred-time greeting: Eid Mubarak on the Eid days,
                      // Jumu'ah Mubarak on Fridays, Ramadan Mubarak through
                      // the month, salam otherwise.
                      final now =
                          ref.watch(dailyNowProvider).value ?? DateTime.now();
                      final isRamadan = ref.watch(
                        specialModeProvider.select((mode) => mode.isRamadan),
                      );
                      final ramadanEndIso = ref.watch(
                        profileSettingsProvider.select(
                          (s) => s.ramadanEndDateIso,
                        ),
                      );
                      final isEid =
                          isEidAlFitrAt(
                            ramadanEndIso: ramadanEndIso,
                            now: now,
                          ) ||
                          isEidAlAdhaAt(now);
                      final isFriday = now.weekday == DateTime.friday;
                      final occasion = isEid
                          ? l10n.homeGreetingEidMubarak
                          : isFriday
                          ? l10n.homeGreetingJumuahMubarak
                          : isRamadan
                          ? l10n.homeGreetingRamadanMubarak
                          : null;
                      final appearance = Theme.of(
                        context,
                      ).extension<AppAppearanceTheme>();
                      return Text(
                        occasion ?? l10n.peaceUponYou,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: occasion != null ? 14 : 13,
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
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.pushNamed('allSearch'),
          icon: Icon(Icons.search_rounded, size: 26, color: iconColor),
          tooltip: l10n.homeSearchTooltip,
        ),
        IconButton(
          onPressed: () => context.goNamed('settings'),
          icon: Icon(Icons.settings, size: 26, color: iconColor),
          tooltip: l10n.profilePrayerSettingsTitle,
        ),
      ],
    );
  }
}

class _SalahSummaryCard extends ConsumerWidget {
  const _SalahSummaryCard({required this.l10n});


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
    final forbiddenPeriod = activeForbiddenPrayerPeriod(
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
    final dhikrDailyGoal = ref.watch(dhikrDailyGoalProvider);
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
          label:
              '${forbiddenPrayerPeriodLabel(l10n, forbiddenPeriod)} • ${l10n.homeUntilTime(forbiddenPeriod.untilTime)}',
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
      onOpenSalahTimes: () => context.pushNamed('worshipPrayerPage'),
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
