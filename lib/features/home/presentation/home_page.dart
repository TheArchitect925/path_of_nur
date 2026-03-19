import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../features/celestial/presentation/widgets/celestial_cycle_card.dart';
import '../../../features/worship/application/dhikr_controller.dart';
import '../../../features/worship/application/prayer_controller.dart';
import '../../../features/worship/domain/prayer_name.dart';
import '../../../features/worship/domain/prayer_status.dart';
import '../../../features/learn/quran/application/quran_providers.dart';
import '../../../features/learn/prophets/application/daily_learning_service.dart';
import '../../../features/learn/prophets/application/prophets_repository.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_prophet_quiz_card.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_revelation_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/shell_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/arabic_text_utils.dart';
import '../../../shared/widgets/quran_text_span.dart';
import '../../../shared/utils/compact_duration_formatter.dart';
import '../../learn/presentation/data/learn_category_catalog.dart';
import '../../learn/presentation/models/learn_category_item.dart';
import '../data/home_verses.dart';

String _formatLocalizedCount(BuildContext context, num value) {
  return NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static final math.Random _verseRandom = math.Random();

  static const List<String> _homeVerseLocationLabels = [
    'Al-Fajr 89:1',
    'Al-Inshirah 94:5-6',
    'Al-Ankabut 29:69',
    'Al-Baqarah 2:152',
    'Al-Baqarah 2:45',
    'Az-Zumar 39:53',
    'Al-Baqarah 2:261',
    'Al-Ikhlas 112:1',
    'Al-Qalam 68:1',
    'Al-Ahzab 33:56',
    'Al-Insan 76:1',
    'At-Tawba 9:40',
    'Al-Baqarah 2:186',
    'Al-Anbiya 21:74',
    'Al-Fatihah 1:5',
    'Al-Fatihah 1:5',
    'Al-Baqarah 2:255',
    'Al-Fajr 89:2',
    'Al-Baqarah 2:286',
    'Al-Ahzab 33:43',
    'Yunus 10:49',
    'Ar-Rahman 55:28',
    'Al-Baqarah 2:286',
    'Al-Ahzab 33:43',
    'Al-Baqarah 2:186',
    'Al-Baqarah 2:286',
    'Al-Baqarah 2:286',
    'Al-Baqarah 2:286',
    'Al-Fatihah 1:1',
    'Al-Baqarah 2:286',
    'Al-Hujurat 49:13',
    'Al-Baqarah 2:286',
    'Al-Ma’idah 5:32',
    'Al-Isra 17:82',
    'Al-Tawba 9:51',
    'Al-Qiyamah 75:12',
    'An-Nisa 4:35',
    'Al-Baqarah 2:286',
    'An-Nisa 4:36',
    'Ar-Rum 30:54',
    'At-Tawba 9:40',
    'Al-Ikhlas 112:2',
    'An-Nisa 4:36',
    'Al-Baqarah 2:255',
    'Al-Anfal 8:2',
    'Al-Ma’idah 5:8',
    'Al-Baqarah 2:186',
    'Al-Imran 3:26',
    'Al-Ahzab 33:70',
    'Al-Baqarah 2:286',
    'Al-Baqarah 2:186',
    'Al-Mujadila 58:1',
    'Al-Hashr 59:23',
    'Al-Muzzammil 73:8',
    'An-Naziat 79:10',
    'Fatir 35:3',
    'Al-Mujadila 58:22',
    'Al-Baqarah 2:286',
    'Al-Baqarah 2:286',
    'Al-Baqarah 2:286',
    'Al-Fajr 89:27',
    'Al-Nasr 110:1',
    'Ad-Duha 93:3',
    'Al-Fajr 89:27',
    'Al-Hadid 57:24',
    'Al-Hadid 57:28',
    'Al-Mulk 67:15',
    'Qadr 97:5',
    'Al-Qalam 68:4',
    'Al-Mursalat 77:1',
    'Adh-Dhariyat 51:30',
  ];

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ValueNotifier<bool> _shortcutsExpanded;

  @override
  void initState() {
    super.initState();
    _shortcutsExpanded = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _shortcutsExpanded.dispose();
    super.dispose();
  }

  void _collapseShortcuts() {
    if (_shortcutsExpanded.value) {
      _shortcutsExpanded.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final quranReaderSettings = ref.watch(quranReaderSettingsProvider);
    final verseVersion = ref.watch(homeVerseVersionProvider);
    final verseIndex = verseVersion % homeQuranVerses.length;
    final verse = homeQuranVerses[verseIndex];
    final displayVerse = HomeVerse(
      arabic: verse.arabic,
      transliteration: verse.transliteration,
      translation: verse.translation,
      surah: verse.surah,
      verse: verse.verse,
      locationLabel:
          verse.locationLabel ??
          HomePage._homeVerseLocationLabels[verseIndex %
              HomePage._homeVerseLocationLabels.length],
    );

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _collapseShortcuts,
          child: SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification ||
                    notification is ScrollUpdateNotification ||
                    notification is UserScrollNotification) {
                  _collapseShortcuts();
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 136),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TopGreetingBlock(l10n: l10n, userProfile: userProfile),
                    const SizedBox(height: 12),
                    const _ModeAwareHomeCard(),
                    const SizedBox(height: 10),
                    _AyahCard(
                      l10n: l10n,
                      verse: displayVerse,
                      arabicScalePercent:
                          quranReaderSettings.arabicScalePercent,
                      transliterationScalePercent:
                          quranReaderSettings.transliterationScalePercent,
                      translationScalePercent:
                          quranReaderSettings.translationScalePercent,
                      onTap: () => ref
                          .read(homeVerseVersionProvider.notifier)
                          .update((state) {
                            final length = homeQuranVerses.length;
                            if (length <= 1) {
                              return state;
                            }
                            var next = HomePage._verseRandom.nextInt(length);
                            final current = state % length;
                            while (next == current) {
                              next = HomePage._verseRandom.nextInt(length);
                            }
                            return next;
                          }),
                    ),
                    const SizedBox(height: 14),
                    _SalahSummaryCard(l10n: l10n),
                    const SizedBox(height: 12),
                    const _DailySalahTimingsCard(),
                    const SizedBox(height: 12),
                    const CelestialCycleCard(),
                    const SizedBox(height: 12),
                    const _HomeLearningActionsCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 18,
          bottom: 92,
          child: _FloatingShortcutDock(expandedListenable: _shortcutsExpanded),
        ),
      ],
    );
  }
}

class _FloatingQuranChip extends ConsumerWidget {
  const _FloatingQuranChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(quranReadingProgressProvider);
    final recitationSession = ref.watch(quranRecitationSessionProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final fallbackSurah = surahMap[1];
    final currentSurah = surahMap[progress.surahNumber] ?? fallbackSurah;
    final sessionSurah = recitationSession == null
        ? null
        : surahMap[recitationSession.surahNumber];
    final activeSurah = sessionSurah ?? currentSurah ?? fallbackSurah;
    final surahNumber = activeSurah?.number ?? 1;
    final ayahCount = activeSurah?.verseCount ?? 1;
    final initialAyahFromSession = recitationSession?.ayahNumber;
    final progressAyah = progress.ayahNumber;
    final ayahNumber = ayahCount > 0
        ? ((initialAyahFromSession ?? progressAyah).clamp(1, ayahCount))
        : 1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(
          'quranReader',
          pathParameters: {'surahNumber': surahNumber.toString()},
          queryParameters: {'ayah': ayahNumber.toString()},
        ),
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEAF9EB), Color(0xFFBDE0C5)],
            ),
            border: Border.all(
              color: const Color(0xFF4D8B63).withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4D8B63).withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 18,
                  color: Color(0xFF2D5E45),
                ),
                SizedBox(width: 8),
                Text(
                  l10n.quranTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D5E45),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DailySalahTimingsCard extends ConsumerWidget {
  const _DailySalahTimingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final prayerRecords = ref.watch(prayerControllerProvider);
    final currentPrayerId = scheduleContext.currentPrayerId;
    final nextPrayerId = scheduleContext.nextPrayerId;
    final statusByPrayer = {
      for (final record in prayerRecords) record.prayer: record.status,
    };

    if (scheduleContext.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return _GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      radius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                IslamicIcons.prayer,
                size: 18,
                color: Color(0xFF7A5A33),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Today\'s Salah',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF25221E),
                    fontFamily: 'serif',
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.goNamed('settings'),
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF8A7A6B),
                ),
                tooltip: AppLocalizations.of(
                  context,
                ).profilePrayerSettingsTitle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 10) / 2;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final item in scheduleContext.items)
                    SizedBox(
                      width: itemWidth,
                      child: _PrayerTimingPill(
                        prayer: _prayerNameFromScheduleId(item.id),
                        name: item.name,
                        arabicName: item.arabicName,
                        time: item.offerTime,
                        status:
                            statusByPrayer[_prayerNameFromScheduleId(
                              item.id,
                            )] ??
                            PrayerStatus.pending,
                        isCurrent: item.id == currentPrayerId,
                        isNext: item.id == nextPrayerId,
                        onToggleOffered: () => ref
                            .read(prayerControllerProvider.notifier)
                            .toggleCompleted(
                              _prayerNameFromScheduleId(item.id),
                            ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
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

  String get _profileLogoAsset {
    return userProfile.sex == UserSex.brother
        ? 'assets/icons/brotherlogo.PNG'
        : 'assets/icons/sisterlogo.PNG';
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
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF44352A),
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
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF23201C),
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
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3C2F25),
                      letterSpacing: 0.2,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.peaceUponYou,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5D4F44),
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
                        const SizedBox(width: 112, height: 112),
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

class _FloatingQiblaChip extends StatelessWidget {
  const _FloatingQiblaChip();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed('qiblaFinder'),
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF5E6C7), Color(0xFFE1C48F)],
            ),
            border: Border.all(
              color: const Color(0xFF8A6A3D).withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A6A3D).withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  IslamicIcons.qibla,
                  size: 18,
                  color: Color(0xFF5C4325),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.homeShortcutQiblaLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5C4325),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerTimingPill extends StatelessWidget {
  const _PrayerTimingPill({
    required this.prayer,
    required this.name,
    required this.arabicName,
    required this.time,
    required this.status,
    required this.isCurrent,
    required this.isNext,
    required this.onToggleOffered,
  });

  final PrayerName prayer;
  final String name;
  final String arabicName;
  final String time;
  final PrayerStatus status;
  final bool isCurrent;
  final bool isNext;
  final VoidCallback onToggleOffered;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = _paletteForPrayer(prayer);
    final accent = isCurrent
        ? palette.strong
        : isNext
        ? palette.base
        : palette.muted;
    final background = isCurrent
        ? palette.base.withValues(alpha: 0.34)
        : isNext
        ? palette.base.withValues(alpha: 0.26)
        : palette.soft;
    final isCompleted = status == PrayerStatus.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(prayer.icon, size: 15, color: accent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2F2923),
                    fontFamily: 'serif',
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: onToggleOffered,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xFF5E8A43).withValues(alpha: 0.14)
                        : const Color(0xFFF7F1E8),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 18,
                    color: isCompleted
                        ? const Color(0xFF5E8A43)
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
              color: Color(0xFF5F554B),
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
              color: Color(0xFF2F2923),
              fontFamily: 'serif',
            ),
          ),
          if (isCompleted) ...[
            const SizedBox(height: 4),
            Text(
              l10n.homePrayerOfferedStatus,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5E8A43),
              ),
            ),
          ],
        ],
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
    case 'isha':
    default:
      return PrayerName.isha;
  }
}

_PrayerColorPalette _paletteForPrayer(PrayerName prayer) {
  switch (prayer) {
    case PrayerName.fajr:
      return const _PrayerColorPalette(
        base: Color(0xFF87AFC7),
        strong: Color(0xFF587D9A),
        muted: Color(0xFF70889A),
        soft: Color(0xFFE6F0F5),
      );
    case PrayerName.dhuhr:
      return const _PrayerColorPalette(
        base: Color(0xFFD4A74F),
        strong: Color(0xFF9A6D16),
        muted: Color(0xFFA58850),
        soft: Color(0xFFF6ECD7),
      );
    case PrayerName.asr:
      return const _PrayerColorPalette(
        base: Color(0xFFC9824F),
        strong: Color(0xFF9C5F34),
        muted: Color(0xFFA67B62),
        soft: Color(0xFFF5E6DC),
      );
    case PrayerName.maghrib:
      return const _PrayerColorPalette(
        base: Color(0xFFC56A63),
        strong: Color(0xFF94443E),
        muted: Color(0xFFA46B67),
        soft: Color(0xFFF6E1E0),
      );
    case PrayerName.isha:
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

class _FloatingShortcutDock extends ConsumerWidget {
  const _FloatingShortcutDock({required this.expandedListenable});

  final ValueNotifier<bool> expandedListenable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final worship = ref.watch(worshipSummaryProvider);
    final prayerRecords = ref.watch(prayerControllerProvider);
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final dhikrDailyGoal = math.max(worship.dhikrTarget, 500);
    final missedCount = prayerRecords
        .where((record) => record.status.name == 'missed')
        .length;
    final currentPrayer = scheduleContext.items
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final timeUntilCurrentEnds = currentPrayer?.overdueDateTime.difference(now);
    final isPrayerUrgent =
        (timeUntilCurrentEnds != null &&
            !timeUntilCurrentEnds.isNegative &&
            timeUntilCurrentEnds <= const Duration(minutes: 60)) ||
        (!scheduleContext.remainingToNext.isNegative &&
            scheduleContext.remainingToNext <= const Duration(minutes: 30));

    final shortcutItems = <_ShortcutDockItem>[
      const _ShortcutDockItem(keyName: 'quran', child: _FloatingQuranChip()),
      _ShortcutDockItem(
        keyName: 'salah',
        child: _FloatingSalahChip(
          statusText: l10n.homeFractionValue(
            _formatLocalizedCount(context, worship.prayerCompleted),
            _formatLocalizedCount(context, worship.prayerTotal),
          ),
          badgeIcon: missedCount > 0 ? Icons.error_outline_rounded : null,
          badgeColor: const Color(0xFFC96A2B),
          badgeTooltip: missedCount > 0
              ? (isKidsMode
                    ? l10n.kidsHomeShortcutMissedCount(missedCount)
                    : l10n.homeShortcutMissedCount(missedCount))
              : null,
        ),
      ),
      _ShortcutDockItem(
        keyName: 'dhikr',
        child: _FloatingDhikrChip(
          statusText: l10n.homeFractionValue(
            _formatLocalizedCount(context, worship.dhikrCount),
            _formatLocalizedCount(context, dhikrDailyGoal),
          ),
          statusCaption: isKidsMode
              ? l10n.kidsHomeShortcutDailyCaption
              : l10n.homeShortcutDailyCaption,
          badgeIcon: dhikrDailyGoal > 0 && worship.dhikrCount >= dhikrDailyGoal
              ? Icons.check_circle_rounded
              : null,
          badgeColor: const Color(0xFF5E8A43),
          badgeTooltip:
              dhikrDailyGoal > 0 && worship.dhikrCount >= dhikrDailyGoal
              ? (isKidsMode
                    ? l10n.kidsHomeShortcutDailyDhikrGoalReached
                    : l10n.homeShortcutDailyDhikrGoalReached)
              : null,
        ),
      ),
      const _ShortcutDockItem(keyName: 'qibla', child: _FloatingQiblaChip()),
    ];

    shortcutItems.sort((a, b) {
      final baseOrder = {'quran': 0, 'salah': 1, 'dhikr': 2, 'qibla': 3};
      final aOrder = isPrayerUrgent && a.keyName == 'salah'
          ? -1
          : baseOrder[a.keyName] ?? 99;
      final bOrder = isPrayerUrgent && b.keyName == 'salah'
          ? -1
          : baseOrder[b.keyName] ?? 99;
      return aOrder.compareTo(bOrder);
    });

    return ValueListenableBuilder<bool>(
      valueListenable: expandedListenable,
      builder: (context, expanded, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: 1,
                    child: child,
                  ),
                );
              },
              child: !expanded
                  ? const SizedBox.shrink()
                  : Column(
                      key: const ValueKey('expanded-shortcuts'),
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final item in shortcutItems) ...[
                          item.child,
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
            ),
            _FloatingShortcutChip(
              label: expanded
                  ? (isKidsMode
                        ? l10n.kidsHomeShortcutClose
                        : l10n.homeShortcutClose)
                  : (isKidsMode
                        ? l10n.kidsHomeShortcutOpen
                        : l10n.homeShortcutOpen),
              icon: expanded ? Icons.close_rounded : Icons.apps_rounded,
              textColor: const Color(0xFF4E4034),
              borderColor: const Color(0xFF8C775D),
              shadowColor: const Color(0xFF8C775D),
              gradient: const [Color(0xFFF7F0E1), Color(0xFFE3D2B4)],
              onTap: () => expandedListenable.value = !expanded,
            ),
          ],
        );
      },
    );
  }
}

class _FloatingSalahChip extends ConsumerWidget {
  const _FloatingSalahChip({
    this.statusText,
    this.badgeIcon,
    this.badgeColor,
    this.badgeTooltip,
  });

  final String? statusText;
  final IconData? badgeIcon;
  final Color? badgeColor;
  final String? badgeTooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    return _FloatingShortcutChip(
      label: isKidsMode
          ? l10n.kidsHomeShortcutSalahLabel
          : l10n.homeShortcutSalahLabel,
      statusText: statusText,
      badgeIcon: badgeIcon,
      badgeColor: badgeColor,
      badgeTooltip: badgeTooltip,
      icon: Icons.checklist_rounded,
      textColor: const Color(0xFF69411A),
      borderColor: const Color(0xFF9F7A42),
      shadowColor: const Color(0xFF9F7A42),
      gradient: const [Color(0xFFF8E6D2), Color(0xFFE7BE8E)],
      onTap: () => context.pushNamed('worshipPrayerPage'),
    );
  }
}

class _FloatingDhikrChip extends ConsumerWidget {
  const _FloatingDhikrChip({
    this.statusText,
    this.statusCaption,
    this.badgeIcon,
    this.badgeColor,
    this.badgeTooltip,
  });

  final String? statusText;
  final String? statusCaption;
  final IconData? badgeIcon;
  final Color? badgeColor;
  final String? badgeTooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    return _FloatingShortcutChip(
      label: isKidsMode
          ? l10n.kidsHomeShortcutDhikrLabel
          : l10n.homeShortcutDhikrLabel,
      statusText: statusText,
      statusCaption: statusCaption,
      badgeIcon: badgeIcon,
      badgeColor: badgeColor,
      badgeTooltip: badgeTooltip,
      icon: Icons.favorite_outline_rounded,
      textColor: const Color(0xFF5D4520),
      borderColor: const Color(0xFF8F7547),
      shadowColor: const Color(0xFF8F7547),
      gradient: const [Color(0xFFF6EFD8), Color(0xFFE1D0A0)],
      onTap: () => context.pushNamed('worshipDhikrPage'),
    );
  }
}

class _FloatingShortcutChip extends StatelessWidget {
  const _FloatingShortcutChip({
    required this.label,
    required this.icon,
    required this.textColor,
    required this.borderColor,
    required this.shadowColor,
    required this.gradient,
    required this.onTap,
    this.statusText,
    this.statusCaption,
    this.badgeIcon,
    this.badgeColor,
    this.badgeTooltip,
  });

  final String label;
  final IconData icon;
  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
  final List<Color> gradient;
  final VoidCallback onTap;
  final String? statusText;
  final String? statusCaption;
  final IconData? badgeIcon;
  final Color? badgeColor;
  final String? badgeTooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            border: Border.all(color: borderColor.withValues(alpha: 0.32)),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    letterSpacing: 0.2,
                  ),
                ),
                if (statusText != null && statusText!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(alpha: 0.34),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (statusCaption != null &&
                            statusCaption!.isNotEmpty) ...[
                          Text(
                            statusCaption!,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: textColor.withValues(alpha: 0.78),
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          statusText!,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (badgeIcon != null) ...[
                  const SizedBox(width: 6),
                  Tooltip(
                    message: badgeTooltip ?? '',
                    child: Icon(
                      badgeIcon,
                      size: 16,
                      color: badgeColor ?? textColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutDockItem {
  const _ShortcutDockItem({required this.keyName, required this.child});

  final String keyName;
  final Widget child;
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
      title: l10n.learnLifeSectionTitle,
      subtitle: l10n.learnLifeSectionSubtitle,
      keywords: ['life', 'family', 'character'],
      onSelected: (context) => context.pushNamed('learnLifeLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchGuidanceHubTitle,
      subtitle: l10n.homeSearchGuidanceHubSubtitle,
      keywords: [
        'hajj',
        'umrah',
        'new muslim',
        'revert',
        'itikaf',
        'dos and donts',
        'sisters',
      ],
      onSelected: (context) => context.pushNamed('islamicGuides'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchQuranLessonsMappingTitle,
      subtitle: l10n.homeSearchQuranLessonsMappingSubtitle,
      keywords: [
        '50 lessons',
        'quran lessons',
        'source mapping',
        'yaqeen books',
      ],
      onSelected: (context) => context.pushNamed('quranLessonsMapping'),
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
      title: item.title,
      subtitle:
          item.description ??
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
    required this.onTap,
  });

  final String query;
  final List<_HomeSearchDestination> items;
  final String emptyLabel;
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

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: const TextStyle(color: Color(0xFF65584A)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemBuilder: (context, index) {
        final item = filtered[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => onTap(item),
        );
      },
      separatorBuilder: (_, index) => const Divider(height: 1),
      itemCount: filtered.length,
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
    return _GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF2E8DC).withValues(alpha: 0.7),
              border: Border.all(
                color: const Color(0xFFD8C49A).withValues(alpha: 0.45),
              ),
            ),
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
                    color: Color(0xFF3A3027),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resolvedSubtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF65584A),
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
  const _AyahCard({
    required this.l10n,
    required this.verse,
    required this.arabicScalePercent,
    required this.transliterationScalePercent,
    required this.translationScalePercent,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final HomeVerse verse;
  final int arabicScalePercent;
  final int transliterationScalePercent;
  final int translationScalePercent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveArabicSize = 34 * (arabicScalePercent / 100.0);
    final effectiveTransliterationSize =
        16 * (transliterationScalePercent / 100.0);
    final effectiveTranslationSize = 15.5 * (translationScalePercent / 100.0);
    final baseArabicStyle = AppTextStyles.quranVerse(
      size: effectiveArabicSize,
      color: const Color(0xFF1E1B18),
    ).copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.3, height: 1.9);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: _GlassCard(
        radius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          children: [
            Text.rich(
              buildQuranTextWithColoredHarakat(verse.arabic, baseArabicStyle),
              textAlign: textAlignForContent(verse.arabic),
              textDirection: textDirectionForContent(verse.arabic),
              strutStyle: StrutStyle(
                fontFamily: baseArabicStyle.fontFamily,
                fontSize: baseArabicStyle.fontSize,
                height: baseArabicStyle.height,
                forceStrutHeight: true,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              verse.transliteration,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: effectiveTransliterationSize,
                color: const Color(0xFF5C5046),
                fontStyle: FontStyle.italic,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              verse.translation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: effectiveTranslationSize,
                color: const Color(0xFF42362D),
                fontFamily: 'serif',
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              verse.locationText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF6D5A4C),
                fontFamily: 'serif',
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
      ),
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
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final prayerSettings = ref.watch(prayerSettingsProvider);
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider);
    final dhikrState = ref.watch(dhikrControllerProvider);
    final next = scheduleContext.items
        .where((item) => item.id == scheduleContext.nextPrayerId)
        .firstOrNull;
    final current = scheduleContext.items
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final prayerSummary = ref.watch(prayerSummaryProvider);
    final forbiddenPeriod = _activeForbiddenPeriod(
      l10n,
      scheduleContext.items,
      now,
    );

    final nextName = next?.name ?? l10n.dhuhr;
    final nextArabic = next?.arabicName ?? l10n.dhuhrArabic;
    final nextAt = next?.offerTime ?? l10n.atTime.replaceFirst('at ', '');
    final currentEndsIn = current == null
        ? null
        : _formatDuration(
            context,
            l10n,
            current.overdueDateTime.difference(now),
          );
    final todayStart = DateTime(now.year, now.month, now.day);
    final dhikrCompletedToday = dhikrState.recentSessions
        .where((session) => !session.finishedAt.isBefore(todayStart))
        .fold<int>(0, (sum, session) => sum + session.count);
    final dhikrToday = dhikrCompletedToday + dhikrState.currentCount;
    const dhikrDailyGoal = 500;
    final hasReachedDhikrDailyGoal = dhikrToday >= dhikrDailyGoal;
    final offerByLabel = l10n.homePrayerBeginsAt(nextAt);
    final offerByValue = nextAt;
    final locationLabel =
        displayLocation.valueOrNull ??
        (prayerSettings.preferences.useDeviceLocation
            ? l10n.settingsCurrentLocation
            : prayerSettings.preferences.location);

    return InkWell(
      onTap: () => context.pushNamed('salahTimes'),
      borderRadius: BorderRadius.circular(32),
      child: _GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        radius: 32,
        child: Column(
          children: [
            if (forbiddenPeriod != null) ...[
              _StatsLine(
                label: forbiddenPeriod.label,
                value: forbiddenPeriod.value,
                labelColor: const Color(0xFFD01919),
                valueColor: const Color(0xFFD01919),
              ),
              const SizedBox(height: 10),
            ] else if (current != null) ...[
              _StatsLine(
                label: l10n.homeTimeRemainingToOffer(
                  current.name,
                  currentEndsIn ?? current.overdueAt,
                  current.name,
                ),
                value: currentEndsIn ?? current.overdueAt,
              ),
              if (current.hasDelayedMakeUpWindow) ...[
                const Divider(height: 12, color: Color(0x28BFAE98)),
                _StatsLine(
                  label: l10n.homePrayerBecomesQada(
                    current.name,
                    current.name,
                    current.overdueAt,
                  ),
                  value: current.overdueAt,
                ),
              ],
              const SizedBox(height: 10),
            ],
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => _showLocationPicker(context, ref, locationLabel),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFF7A5A33),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF4D4036),
                          fontSize: 12.8,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF7A5A33),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Color(0xFF7A5A33),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              radius: 24,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.nextSalah,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF25221E),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.allSalahTimes,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF98C3A0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        size: 24,
                        color: Color(0xFF9BC5A0),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nextName,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF202228),
                              fontFamily: 'serif',
                              height: 1.0,
                            ),
                          ),
                          Text(
                            nextArabic,
                            textAlign: textAlignForContent(nextArabic),
                            textDirection: textDirectionForContent(nextArabic),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF2D3137),
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            offerByLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF202228),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            offerByValue,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF50545A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: scheduleContext.progressToNext,
                backgroundColor: const Color(0x22BFAE98),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF9BC5A0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _StatsLine(
              label: l10n.salahCompleted,
              value: l10n.homeFractionValue(
                _formatCount(context, prayerSummary.completed),
                _formatCount(context, prayerSummary.total),
              ),
            ),
            const Divider(height: 12, color: Color(0x28BFAE98)),
            _StatsLine(
              label: l10n.dhikrToday,
              value: l10n.homeFractionValue(
                _formatCount(context, dhikrToday),
                _formatCount(context, dhikrDailyGoal),
              ),
              trailingIcon: hasReachedDhikrDailyGoal
                  ? Icons.check_circle_rounded
                  : null,
              trailingIconColor: const Color(0xFF5E8A43),
              onTap: () => context.pushNamed('worshipDhikrPage'),
            ),
            const Divider(height: 12, color: Color(0x28BFAE98)),
            _StatsLine(label: l10n.salahStreak, value: l10n.homeDaysCount(1)),
          ],
        ),
      ),
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

  String _formatCount(BuildContext context, num value) =>
      _formatLocalizedCount(context, value);

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

class _StatsLine extends StatelessWidget {
  const _StatsLine({
    required this.label,
    required this.value,
    this.labelColor = const Color(0xFF4A423A),
    this.valueColor = const Color(0xFF2F2923),
    this.trailingIcon,
    this.trailingIconColor,
    this.onTap,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 14.5,
            fontFamily: 'serif',
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            fontFamily: 'serif',
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 6),
          Icon(trailingIcon, size: 16, color: trailingIconColor ?? valueColor),
        ],
      ],
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: content,
      ),
    );
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
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.card,
    );
    return Container(
      padding: padding,
      decoration: surfaceStyle.decoration(radius: radius),
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

    return PremiumCard(
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
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
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
      context.pushNamed('learnProphetsHub');
    }

    return PremiumCard(
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
          children: [
            const SizedBox(height: 10),
            DailyRevelationCard(
              item: dailyBundle.item,
              isOpened: dailyBundle.status.cardOpened,
              onOpen: openDailyItem,
              onTakeQuiz: () => context.pushNamed(
                'learnProphetsHub',
                queryParameters: {'tab': 'quiz'},
              ),
              showPracticeLesson: dailyBundle.item.linkedGrowthHabitId != null,
              onPracticeLesson: () {
                final habitId = dailyBundle.item.linkedGrowthHabitId;
                if (habitId != null && habitId.trim().isNotEmpty) {
                  context.go('/journey/habit/$habitId');
                  return;
                }
                context.go('/journey/growth/habits');
              },
            ),
            const SizedBox(height: 10),
            DailyProphetQuizCard(
              question: dailyBundle.quizQuestion,
              isAnswered: dailyBundle.status.quizAnswered,
              selectedIndex: dailyBundle.status.quizSelectedIndex,
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
                  onTap: () => context.pushNamed('learnIslamicTrivia'),
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
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.onSurface),
      label: Text(label),
      onPressed: onTap,
      side: BorderSide(color: AppColors.accentGoldSoft.withValues(alpha: 0.35)),
      backgroundColor: AppColors.surface.withValues(alpha: 0.25),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accentGoldSoft.withValues(alpha: 0.4),
          ),
        ),
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
