import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/nav_tabs.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../features/celestial/presentation/widgets/celestial_cycle_card.dart';
import '../../../features/history/presentation/widgets/on_this_day_home_card.dart';
import '../application/home_calendar_progress_provider.dart';
import '../../../shared/content/contextual_quran_quotes.dart';
import '../../../features/worship/domain/prayer_name.dart';
import '../../../features/worship/domain/prayer_status.dart';
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
import '../../../l10n/home_prayer_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/profile/profile_logo_assets.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/shell_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/arabic_text_utils.dart';
import '../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../shared/widgets/app_layered_section_glass_card.dart';
import '../../../shared/widgets/app_salah_hero_card.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../shared/widgets/main_page_shortcut_configs.dart';
import '../../../shared/widgets/main_page_shortcut_stack.dart';
import '../../../shared/widgets/noor_glass_card.dart';
import '../../../shared/widgets/noor_liquid_glass.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/utils/compact_duration_formatter.dart';
import '../../learn/presentation/data/learn_category_catalog.dart';
import '../../learn/quran/application/quran_providers.dart';
import '../../learn/quran/presentation/widgets/quran_compact_search_results_section.dart';
import '../../learn/presentation/learn_ui_localization.dart';
import '../../learn/presentation/models/learn_category_item.dart';

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
  return _formatLocalizedCount(context, trackedPrayerTotal);
}

const int _shortcutDailyDhikrGoal = 500;
const double _homeFloatingShortcutBottomOffset = 92;
const double _homeFloatingShortcutContentPadding = 136;
const Color _homePrimaryTextColor = Color(0xFF25221E);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static final math.Random _verseRandom = math.Random();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeTextTheme = Theme.of(context).textTheme.apply(
      bodyColor: _homePrimaryTextColor,
      displayColor: _homePrimaryTextColor,
    );
    final l10n = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final verseVersion = ref.watch(homeVerseVersionProvider);
    final worshipSummary = ref.watch(worshipSummaryProvider);
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
    final trackedPrayerTotal = math.max(worshipSummary.prayerTotal, 5);
    final salahProgressText =
        '${_formatLocalizedCount(context, worshipSummary.prayerCompleted)}/${_formatHomePrayerTrackerTotal(context, trackedPrayerTotal: trackedPrayerTotal, includeTahajjudOffer: includesTahajjudOffer)}';

    return Theme(
      data: Theme.of(context).copyWith(textTheme: homeTextTheme),
      child: SafeArea(
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
                  const _ModeAwareHomeCard(),
                  const SizedBox(height: 10),
                  _SalahSummaryCard(l10n: l10n),
                  const SizedBox(height: 12),
                  const _DailySalahTimingsCard(),
                  const SizedBox(height: 12),
                  const OnThisDayHomeCard(),
                  const SizedBox(height: 12),
                  const CelestialCycleCard(collapsible: true),
                  const SizedBox(height: 12),
                  _TodayContentSection(
                    quranBundle: quranBundle,
                    spiritualMoment: spiritualMoment,
                  ),
                  const SizedBox(height: 14),
                  const _HomeTestingRoutePills(),
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
                      '${_formatLocalizedCount(context, worshipSummary.dhikrCount)}/${_formatLocalizedCount(context, _shortcutDailyDhikrGoal)}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTestingRoutePills extends StatelessWidget {
  const _HomeTestingRoutePills();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _HomeNoorCardShell(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          AppLayeredGlassPillButton(
            label: l10n.homeTestOnboardingPill,
            onPressed: () => context.go('/onboarding?preview=1'),
          ),
          AppLayeredGlassPillButton(
            label: l10n.homeTestLoadingScreenPill,
            onPressed: () => context.go('/startup'),
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
    return AppHeroGlassShell(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      tintColor: const Color(0xFFE7C98C),
      surfaceAlphaOverride: 0.2,
      radius: 36,
      borderColor: const Color(0x42FFFFFF),
      highlightGradientColors: const [
        Color(0x24FFFFFF),
        Colors.transparent,
        Color(0x16E8C98F),
      ],
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          initiallyExpanded: false,
          title: Text(
            l10n.homeTodayContentTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(l10n.homeTodayContentSubtitle),
          children: [
            const SizedBox(height: 10),
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
            const _HomeLearningActionsCard(expandable: false),
          ],
        ),
      ),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  IslamicIcons.mosque,
                  size: 24,
                  color: Color(0xFF6E563E),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.navHome,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _homePrimaryTextColor,
                    fontFamily: 'serif',
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                showSearch<void>(
                  context: context,
                  delegate: _HomeGlobalSearchDelegate(
                    l10n: l10n,
                    destinations: _buildHomeSearchDestinations(l10n),
                  ),
                );
              },
              icon: const Icon(
                Icons.search_rounded,
                size: 30,
                color: Color(0xFF7A5A33),
              ),
              tooltip: l10n.homeSearchTooltip,
            ),
            IconButton(
              onPressed: () => context.goNamed('settings'),
              icon: const Icon(
                Icons.settings,
                size: 30,
                color: Color(0xFF7A5A33),
              ),
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
            color: _homePrimaryTextColor,
            height: 1.15,
            fontFamily: 'serif',
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
                      color: _homePrimaryTextColor,
                      letterSpacing: 0.2,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.peaceUponYou,
                    style: TextStyle(
                      fontSize: 15,
                      color: _homePrimaryTextColor,
                      fontFamily: 'serif',
                    ),
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

class _PrayerTimingPill extends StatelessWidget {
  const _PrayerTimingPill({
    required this.prayerId,
    required this.name,
    required this.arabicName,
    required this.time,
    required this.status,
    required this.isCurrent,
    required this.isNext,
    required this.hasPostSalahDhikr,
    this.completionDetail,
    required this.onToggleOffered,
    this.onOpenDetails,
    this.onMarkPostSalahDhikr,
  });

  final String prayerId;
  final String name;
  final String arabicName;
  final String time;
  final PrayerStatus status;
  final bool isCurrent;
  final bool isNext;
  final bool hasPostSalahDhikr;
  final String? completionDetail;
  final VoidCallback? onToggleOffered;
  final VoidCallback? onOpenDetails;
  final VoidCallback? onMarkPostSalahDhikr;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = _paletteForPrayerId(prayerId);
    final accent = isCurrent
        ? palette.strong
        : isNext
        ? palette.base
        : palette.muted;
    final isCompleted = status == PrayerStatus.completed;
    final pillBackgroundTint =
        Color.lerp(
          palette.soft,
          palette.base,
          isCurrent ? 0.62 : (isNext ? 0.48 : 0.34),
        ) ??
        palette.base;
    final innerCardTop =
        Color.lerp(palette.soft, Colors.white, isCurrent ? 0.18 : 0.30) ??
        palette.soft;
    final innerCardBottom =
        Color.lerp(
          palette.soft,
          palette.base,
          isCurrent ? 0.26 : (isNext ? 0.20 : 0.14),
        ) ??
        palette.base;
    final innerBorderColor =
        Color.lerp(
          Colors.white.withValues(alpha: 0.88),
          palette.base.withValues(alpha: isCurrent ? 0.42 : 0.30),
          isCurrent ? 0.52 : (isNext ? 0.40 : 0.28),
        ) ??
        Colors.white.withValues(alpha: 0.88);
    final pillContent = NoorGlassCard(
      padding: const EdgeInsets.all(4),
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: pillBackgroundTint,
      surfaceAlphaOverride: isCurrent ? 0.34 : (isNext ? 0.30 : 0.26),
      includeShadow: false,
      mode: NoorLiquidGlassMode.fake,
      borderRadius: 28,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: innerBorderColor),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              innerCardTop.withValues(alpha: 0.92),
              innerCardBottom.withValues(alpha: 0.86),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconForPrayerId(prayerId), size: 15, color: accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w700,
                      color: _homePrimaryTextColor,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: isCompleted ? onToggleOffered : onOpenDetails,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFF5E8A43).withValues(alpha: 0.14)
                          : (onOpenDetails ?? onToggleOffered) == null
                          ? const Color(0xFFF1ECE4)
                          : const Color(0xFFF7F1E8),
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 18,
                      color: isCompleted
                          ? const Color(0xFF5E8A43)
                          : (onOpenDetails ?? onToggleOffered) == null
                          ? const Color(0xFFB4A594)
                          : const Color(0xFF7D705F),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              arabicName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              textDirection: textDirectionForContent(arabicName),
              style: const TextStyle(
                fontSize: 15,
                color: _homePrimaryTextColor,
                fontFamily: 'serif',
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _homePrimaryTextColor,
                fontFamily: 'serif',
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(height: 4),
              Text(
                completionDetail ?? l10n.homePrayerOfferedStatus,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _homePrimaryTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homePrayerCompletedTapHintText,
                style: const TextStyle(
                  fontSize: 11,
                  color: _homePrimaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: hasPostSalahDhikr,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: onMarkPostSalahDhikr == null
                          ? null
                          : (_) => onMarkPostSalahDhikr?.call(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hasPostSalahDhikr
                          ? l10n.homePrayerPostSalahDhikrLoggedText
                          : l10n.homePrayerPostSalahDhikrActionText,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: _homePrimaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onOpenDetails ?? onToggleOffered,
        child: pillContent,
      ),
    );
  }
}

PrayerName _prayerNameFromScheduleId(String id) {
  switch (id) {
    case 'fajr':
      return PrayerName.fajr;
    case 'dhuhr':
      return PrayerName.dhuhr;
    case 'asr':
      return PrayerName.asr;
    case 'maghrib':
      return PrayerName.maghrib;
    case 'tahajjud':
      return PrayerName.tahajjud;
    case 'isha':
    default:
      return PrayerName.isha;
  }
}

IconData _iconForPrayerId(String prayerId) {
  switch (prayerId) {
    case 'fajr':
      return PrayerName.fajr.icon;
    case 'dhuhr':
      return PrayerName.dhuhr.icon;
    case 'asr':
      return PrayerName.asr.icon;
    case 'maghrib':
      return PrayerName.maghrib.icon;
    case 'tahajjud':
      return IslamicIcons.lantern;
    case 'isha':
    default:
      return PrayerName.isha.icon;
  }
}

_PrayerColorPalette _paletteForPrayerId(String prayerId) {
  switch (prayerId) {
    case 'fajr':
      return const _PrayerColorPalette(
        base: Color(0xFF87AFC7),
        strong: Color(0xFF587D9A),
        muted: Color(0xFF70889A),
        soft: Color(0xFFE6F0F5),
      );
    case 'dhuhr':
      return const _PrayerColorPalette(
        base: Color(0xFFD4A74F),
        strong: Color(0xFF9A6D16),
        muted: Color(0xFFA58850),
        soft: Color(0xFFF6ECD7),
      );
    case 'asr':
      return const _PrayerColorPalette(
        base: Color(0xFFC9824F),
        strong: Color(0xFF9C5F34),
        muted: Color(0xFFA67B62),
        soft: Color(0xFFF5E6DC),
      );
    case 'maghrib':
      return const _PrayerColorPalette(
        base: Color(0xFFC56A63),
        strong: Color(0xFF94443E),
        muted: Color(0xFFA46B67),
        soft: Color(0xFFF6E1E0),
      );
    case 'tahajjud':
      return const _PrayerColorPalette(
        base: Color(0xFF7A5EA8),
        strong: Color(0xFF56407C),
        muted: Color(0xFF7C6A96),
        soft: Color(0xFFECE6F6),
      );
    case 'isha':
    default:
      return const _PrayerColorPalette(
        base: Color(0xFF6B6FAF),
        strong: Color(0xFF474C84),
        muted: Color(0xFF717499),
        soft: Color(0xFFE6E8F7),
      );
  }
}

class _PrayerColorPalette {
  const _PrayerColorPalette({
    required this.base,
    required this.strong,
    required this.muted,
    required this.soft,
  });

  final Color base;
  final Color strong;
  final Color muted;
  final Color soft;
}

class _HomeSearchDestination {
  const _HomeSearchDestination({
    required this.title,
    required this.subtitle,
    required this.keywords,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final List<String> keywords;
  final void Function(BuildContext context) onSelected;
}

List<_HomeSearchDestination> _buildHomeSearchDestinations(
  AppLocalizations l10n,
) {
  return [
    _HomeSearchDestination(
      title: l10n.navHome,
      subtitle: l10n.homeOverviewHeroSubtitle,
      keywords: ['home', 'dashboard', 'overview'],
      onSelected: (context) => context.go(NavTab.home.path),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchQiblaFinderTitle,
      subtitle: l10n.homeSearchQiblaFinderSubtitle,
      keywords: ['qibla', 'direction', 'compass', 'kaaba', 'ar qibla'],
      onSelected: (context) => context.pushNamed('qiblaFinder'),
    ),
    _HomeSearchDestination(
      title: l10n.worshipTitle,
      subtitle: l10n.worshipSubtitle,
      keywords: ['worship', 'prayer', 'dhikr', 'fasting', 'khusu'],
      onSelected: (context) => context.go(NavTab.worship.path),
    ),
    _HomeSearchDestination(
      title: l10n.worshipTitle,
      subtitle: l10n.worshipSubtitle,
      keywords: [
        'salah',
        'prayer times',
        'fajr',
        'dhuhr',
        'asr',
        'maghrib',
        'isha',
      ],
      onSelected: (context) => context.pushNamed('salahTimes'),
    ),
    _HomeSearchDestination(
      title: l10n.navLearning,
      subtitle: l10n.learnSubtitle,
      keywords: ['learn', 'quran', 'life', 'world', 'hadith', 'notes'],
      onSelected: (context) => context.go(NavTab.learn.path),
    ),
    _HomeSearchDestination(
      title: l10n.quranExplorerTitle,
      subtitle: l10n.quranExplorerSubtitle,
      keywords: ['surah', 'quran', 'reader', 'explorer'],
      onSelected: (context) => context.pushNamed('quranExplorer'),
    ),
    _HomeSearchDestination(
      title: l10n.quranSearchTitle,
      subtitle: l10n.quranSearchSubtitle,
      keywords: ['quran search', 'ayah', 'surah search'],
      onSelected: (context) => context.pushNamed('quranSearch'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchQuranTopWordsTitle,
      subtitle: l10n.homeSearchQuranTopWordsSubtitle,
      keywords: [
        'top 500 words',
        'quran words',
        'vocabulary',
        'transliteration',
      ],
      onSelected: (context) => context.pushNamed('quranTopWords'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchNamesOfAllahTitle,
      subtitle: l10n.homeSearchNamesOfAllahSubtitle,
      keywords: ['99 names', 'asma ul husna', 'allah names', 'names of الله'],
      onSelected: (context) => context.pushNamed('quranNamesOfAllah'),
    ),
    _HomeSearchDestination(
      title: l10n.historyArchiveTitle,
      subtitle: l10n.historyArchiveSubtitle,
      keywords: [
        'on this day',
        'history archive',
        'historical calendar',
        'islamic history',
      ],
      onSelected: (context) => context.pushNamed('learnHistoryArchive'),
    ),
    _HomeSearchDestination(
      title: l10n.learnLifeSectionTitle,
      subtitle: l10n.learnLifeSectionSubtitle,
      keywords: ['life', 'family', 'character'],
      onSelected: (context) => context.pushNamed('learnLifeLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.babyNamesTitle,
      subtitle: l10n.babyNamesSubtitle,
      keywords: ['baby', 'names', 'family names', 'muslim baby names'],
      onSelected: (context) => context.pushNamed('babyNamesHome'),
    ),
    _HomeSearchDestination(
      title: l10n.learnWorldSectionTitle,
      subtitle: l10n.learnWorldSectionSubtitle,
      keywords: ['world', 'creation', 'signs'],
      onSelected: (context) => context.pushNamed('learnWorldLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.learnHadithSectionTitle,
      subtitle: l10n.learnHadithSectionSubtitle,
      keywords: ['hadith', 'manners', 'character'],
      onSelected: (context) => context.pushNamed('learnHadithLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchImportantHadithTitle,
      subtitle: l10n.homeSearchImportantHadithSubtitle,
      keywords: ['important ahadith', 'hadith 50', 'nawawi', 'hadith study'],
      onSelected: (context) => context.pushNamed('learnHadithImportant'),
    ),
    _HomeSearchDestination(
      title: l10n.learnNotesSectionTitle,
      subtitle: l10n.learnNotesSectionSubtitle,
      keywords: ['notes', 'reflection', 'journal notes'],
      onSelected: (context) => context.pushNamed('learnNotesLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.assistantTitle,
      subtitle: l10n.assistantSubtitle,
      keywords: ['assistant', 'help', 'guide'],
      onSelected: (context) => context.pushNamed('assistant'),
    ),
    _HomeSearchDestination(
      title: l10n.circlesTitle,
      subtitle: l10n.circlesSubtitle,
      keywords: ['community', 'circles', 'groups'],
      onSelected: (context) => context.pushNamed('circlesDiscovery'),
    ),
    _HomeSearchDestination(
      title: l10n.journalTitle,
      subtitle: l10n.journalSubtitle,
      keywords: ['journal', 'timeline', 'memories', 'reflection'],
      onSelected: (context) => context.pushNamed('journalTimeline'),
    ),
    _HomeSearchDestination(
      title: l10n.navPrayer,
      subtitle: l10n.journeySubtitle,
      keywords: ['journey', 'xp', 'streak', 'rings'],
      onSelected: (context) => context.go(NavTab.journey.path),
    ),
    _HomeSearchDestination(
      title: l10n.oceanTitle,
      subtitle: l10n.oceanSubtitle,
      keywords: ['ocean', 'drops', 'rewards'],
      onSelected: (context) => context.pushNamed('oceanDrops'),
    ),
    _HomeSearchDestination(
      title: l10n.wallpaperLibraryTitle,
      subtitle: l10n.wallpaperLibrarySubtitle,
      keywords: ['wallpaper', 'rewards', 'background'],
      onSelected: (context) => context.pushNamed('wallpaperLibrary'),
    ),
    _HomeSearchDestination(
      title: l10n.profilePrayerSettingsTitle,
      subtitle: l10n.profilePrayerSettingsSubtitle,
      keywords: ['profile', 'settings', 'reminders', 'preferences'],
      onSelected: (context) => context.goNamed('settings'),
    ),
    ..._learnCategorySearchDestinations(l10n),
  ];
}

List<_HomeSearchDestination> _learnCategorySearchDestinations(
  AppLocalizations l10n,
) {
  _HomeSearchDestination destinationForCategory(LearnCategoryItem item) {
    final categoryLabel = item.sectionType.replaceAll('-', ' ');
    return _HomeSearchDestination(
      title: item.localizedTitle(l10n),
      subtitle:
          item.localizedDescription(l10n) ??
          l10n.homeLearnCategoryFallbackSubtitle(categoryLabel),
      keywords: [...item.searchKeywords, ...item.tags, item.sectionType],
      onSelected: (context) => context.pushNamed(
        item.routeName,
        pathParameters: item.pathParameters,
        queryParameters: item.queryParameters,
      ),
    );
  }

  return [...LearnCategoryCatalog.searchableItems.map(destinationForCategory)];
}

class _HomeGlobalSearchDelegate extends SearchDelegate<void> {
  _HomeGlobalSearchDelegate({required this.l10n, required this.destinations});

  final AppLocalizations l10n;
  final List<_HomeSearchDestination> destinations;

  @override
  String get searchFieldLabel => l10n.homeSearchHint;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear_rounded),
          tooltip: l10n.homeSearchClearTooltip,
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
      tooltip: l10n.homeSearchCloseTooltip,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchResultList(
      query: query,
      items: destinations,
      emptyLabel: l10n.homeSearchNoResults,
      onRunQuery: (value) => query = value,
      onTap: (item) {
        close(context, null);
        item.onSelected(context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchResultList(
      query: query,
      items: destinations,
      emptyLabel: l10n.homeSearchNoResults,
      onRunQuery: (value) => query = value,
      onTap: (item) {
        close(context, null);
        item.onSelected(context);
      },
    );
  }
}

class _SearchResultList extends StatelessWidget {
  const _SearchResultList({
    required this.query,
    required this.items,
    required this.emptyLabel,
    required this.onRunQuery,
    required this.onTap,
  });

  final String query;
  final List<_HomeSearchDestination> items;
  final String emptyLabel;
  final ValueChanged<String> onRunQuery;
  final ValueChanged<_HomeSearchDestination> onTap;

  @override
  Widget build(BuildContext context) {
    final trimmed = query.trim().toLowerCase();
    final filtered = trimmed.isEmpty
        ? items
        : items.where((item) {
            final haystack =
                '${item.title} ${item.subtitle} ${item.keywords.join(' ')}'
                    .toLowerCase();
            return haystack.contains(trimmed);
          }).toList();
    return Consumer(
      builder: (context, ref, _) {
        final quranResults = trimmed.isEmpty
            ? const <QuranSearchResult>[]
            : ref
                      .watch(
                        quranTextSearchResultsProvider(
                          QuranTextSearchQuery(query: query, maxResults: 3),
                        ),
                      )
                      .asData
                      ?.value ??
                  const <QuranSearchResult>[];

        if (filtered.isEmpty && quranResults.isEmpty) {
          return Center(
            child: Text(
              emptyLabel,
              style: const TextStyle(color: _homePrimaryTextColor),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            if (trimmed.isNotEmpty) ...[
              QuranCompactSearchResultsSection(query: query, maxResults: 3),
              if (filtered.isNotEmpty) const SizedBox(height: 10),
            ],
            ...List<Widget>.generate(filtered.length, (index) {
              final item = filtered[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.subtitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => onTap(item),
                  ),
                  if (index != filtered.length - 1) const Divider(height: 1),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}

// ignore: unused_element
class _WelcomeCarousel extends StatelessWidget {
  const _WelcomeCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: PageView(
        physics: const BouncingScrollPhysics(),
        children: const [
          _WelcomeCarouselCard(
            icon: Icons.wb_sunny_outlined,
            title: 'homeWelcomeDailyIntentionTitle',
            subtitle: 'homeWelcomeDailyIntentionSubtitle',
          ),
          _WelcomeCarouselCard(
            icon: Icons.schedule_rounded,
            title: 'homeWelcomePrayerRhythmTitle',
            subtitle: 'homeWelcomePrayerRhythmSubtitle',
          ),
          _WelcomeCarouselCard(
            icon: Icons.favorite_outline_rounded,
            title: 'homeWelcomeDhikrQuietTitle',
            subtitle: 'homeWelcomeDhikrQuietSubtitle',
          ),
        ],
      ),
    );
  }
}

class _WelcomeCarouselCard extends StatelessWidget {
  const _WelcomeCarouselCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resolvedTitle = _localize(context, title, l10n);
    final resolvedSubtitle = _localize(context, subtitle, l10n);
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: const Color(0xFF8F6E40),
      surfaceAlphaOverride: 0.20,
    );
    return _GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: iconStyle.decoration(radius: 12, includeShadow: false),
            child: Icon(icon, color: const Color(0xFF8F6E40)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  resolvedTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w600,
                    color: _homePrimaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resolvedSubtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: _homePrimaryTextColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localize(
    BuildContext context,
    String keyOrText,
    AppLocalizations l10n,
  ) {
    switch (keyOrText) {
      case 'homeWelcomeDailyIntentionTitle':
        return l10n.homeWelcomeDailyIntentionTitle;
      case 'homeWelcomeDailyIntentionSubtitle':
        return l10n.homeWelcomeDailyIntentionSubtitle;
      case 'homeWelcomePrayerRhythmTitle':
        return l10n.homeWelcomePrayerRhythmTitle;
      case 'homeWelcomePrayerRhythmSubtitle':
        return l10n.homeWelcomePrayerRhythmSubtitle;
      case 'homeWelcomeDhikrQuietTitle':
        return l10n.homeWelcomeDhikrQuietTitle;
      case 'homeWelcomeDhikrQuietSubtitle':
        return l10n.homeWelcomeDhikrQuietSubtitle;
      default:
        return keyOrText;
    }
  }
}

// ignore: unused_element
class _AvatarHaloSection extends StatelessWidget {
  const _AvatarHaloSection();

  @override
  Widget build(BuildContext context) {
    final double size = math.min(MediaQuery.of(context).size.width - 40, 300);
    final double inner = size * 0.53;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0EADD).withValues(alpha: 0.33),
                border: Border.all(
                  color: const Color(0xFFD8C28D).withValues(alpha: 0.64),
                  width: 1.8,
                ),
              ),
            ),
            Container(
              width: inner,
              height: inner,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE9ED98).withValues(alpha: 0.42),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF4F386).withValues(alpha: 0.62),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: inner - 8,
              height: inner - 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEEFA7C).withValues(alpha: 0.84),
                  width: 3.5,
                ),
              ),
            ),
            CircleAvatar(
              radius: inner * 0.38,
              backgroundColor: const Color(0xFFF8EFE2),
              child: CircleAvatar(
                radius: inner * 0.365,
                backgroundColor: const Color(0xFFEFDFC9),
                child: Icon(
                  Icons.person,
                  size: inner * 0.42,
                  color: const Color(0xFF61422D).withValues(alpha: 0.86),
                ),
              ),
            ),
          ],
        ),
      ),
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

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 30,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return _HomeNoorCardShell(padding: padding, radius: radius, child: child);
  }
}

class _HomeNoorCardShell extends StatelessWidget {
  const _HomeNoorCardShell({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 30,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AppLayeredSectionGlassCard(
      contentPadding: padding,
      outerRadius: radius + 2,
      innerRadius: radius - 8,
      surfaceVariant: AppSurfaceVariant.card,
      surfaceTreatment: AppSurfaceTreatment.standard,
      surfaceTintColor: const Color(0xFFE6B85F),
      surfaceAlphaOverride: 0.32,
      includeShadow: true,
      child: child,
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

    return _HomeNoorCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentGoldSoft),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: _homePrimaryTextColor, height: 1.35),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}

class _HomeLearningActionsCard extends ConsumerWidget {
  const _HomeLearningActionsCard({this.expandable = true});

  final bool expandable;

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

    if (!expandable) {
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

    return NoorGlassCard(
      includeShadow: true,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          title: Text(
            l10n.homeDailyLearningQuizzesTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(l10n.homeDailyLearningQuizzesSubtitle),
          children: [const SizedBox(height: 10), content],
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
              Icon(icon, size: 16, color: AppColors.onSurface),
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
