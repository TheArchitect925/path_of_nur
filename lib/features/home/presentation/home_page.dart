import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../features/celestial/presentation/widgets/celestial_cycle_card.dart';
import '../../../features/worship/domain/fasting_status.dart';
import '../../../features/worship/application/dhikr_controller.dart';
import '../../../features/worship/application/worship_tab_provider.dart';
import '../../../features/worship/application/prayer_controller.dart';
import '../../../features/learn/quran/application/quran_providers.dart';
import '../../../features/learn/prophets/application/daily_learning_service.dart';
import '../../../features/learn/prophets/application/prophets_repository.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_prophet_quiz_card.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_revelation_card.dart';
import '../../../features/journey/application/journey_progression_provider.dart';
import '../../../features/onboarding/application/onboarding_state_provider.dart';
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
import '../../../shared/widgets/section_title.dart';
import '../../learn/presentation/data/learn_category_catalog.dart';
import '../../learn/presentation/models/learn_category_item.dart';
import '../data/home_verses.dart';

class HomePage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
          _homeVerseLocationLabels[verseIndex %
              _homeVerseLocationLabels.length],
    );

    return Stack(
      children: [
        SafeArea(
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
                  arabicScalePercent: quranReaderSettings.arabicScalePercent,
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
                const CelestialCycleCard(),
                const SizedBox(height: 12),
                const _HomeLearningActionsCard(),
                const SizedBox(height: 24),
                _HomeSummaryShortcutCard(
                  l10n: l10n,
                  dailyBundle: ref.watch(todayDailyLearningBundleProvider),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.center,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(onboardingCompletedProvider.notifier).reset();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!context.mounted) return;
                        context.goNamed('onboarding');
                      });
                    },
                    icon: const Icon(Icons.slideshow_rounded),
                    label: const Text('Start Welcome Carousel'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          right: 18,
          bottom: 92,
          child: _FloatingShortcutDock(),
        ),
      ],
    );
  }
}

class _FloatingQuranChip extends ConsumerWidget {
  const _FloatingQuranChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final ayahNumber =
        ayahCount > 0
            ? ((initialAyahFromSession ?? progressAyah).clamp(1, ayahCount))
            : 1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(
          'quranReader',
          pathParameters: {'surahNumber': surahNumber.toString()},
          queryParameters: {
            'ayah': ayahNumber.toString(),
          },
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
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book_rounded, size: 18, color: Color(0xFF2D5E45)),
                SizedBox(width: 8),
                Text(
                  'Quran',
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
              tooltip: l10n.profileTitle,
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
            onTap: () => context.goNamed('profilePage'),
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
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(IslamicIcons.qibla, size: 18, color: Color(0xFF5C4325)),
                SizedBox(width: 8),
                Text(
                  'Qibla',
                  style: TextStyle(
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

class _FloatingShortcutDock extends ConsumerStatefulWidget {
  const _FloatingShortcutDock();

  @override
  ConsumerState<_FloatingShortcutDock> createState() =>
      _FloatingShortcutDockState();
}

class _FloatingShortcutDockState extends ConsumerState<_FloatingShortcutDock> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
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
      const _ShortcutDockItem(
        keyName: 'quran',
        child: _FloatingQuranChip(),
      ),
      _ShortcutDockItem(
        keyName: 'salah',
        child: _FloatingSalahChip(
          statusText: '${worship.prayerCompleted}/${worship.prayerTotal}',
          badgeIcon: missedCount > 0 ? Icons.error_outline_rounded : null,
          badgeColor: const Color(0xFFC96A2B),
          badgeTooltip: missedCount > 0 ? '$missedCount missed' : null,
        ),
      ),
      _ShortcutDockItem(
        keyName: 'dhikr',
        child: _FloatingDhikrChip(
          statusText: '${worship.dhikrCount}/$dhikrDailyGoal',
          statusCaption: 'Daily',
          badgeIcon: dhikrDailyGoal > 0 &&
                  worship.dhikrCount >= dhikrDailyGoal
              ? Icons.check_circle_rounded
              : null,
          badgeColor: const Color(0xFF5E8A43),
          badgeTooltip: dhikrDailyGoal > 0 &&
                  worship.dhikrCount >= dhikrDailyGoal
              ? 'Daily dhikr goal reached'
              : null,
        ),
      ),
      const _ShortcutDockItem(
        keyName: 'qibla',
        child: _FloatingQiblaChip(),
      ),
    ];

    shortcutItems.sort((a, b) {
      final baseOrder = {
        'quran': 0,
        'salah': 1,
        'dhikr': 2,
        'qibla': 3,
      };
      final aOrder = isPrayerUrgent && a.keyName == 'salah'
          ? -1
          : baseOrder[a.keyName] ?? 99;
      final bOrder = isPrayerUrgent && b.keyName == 'salah'
          ? -1
          : baseOrder[b.keyName] ?? 99;
      return aOrder.compareTo(bOrder);
    });

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
          child: !_expanded
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
          label: _expanded ? 'Close' : 'Shortcuts',
          icon: _expanded ? Icons.close_rounded : Icons.apps_rounded,
          textColor: const Color(0xFF4E4034),
          borderColor: const Color(0xFF8C775D),
          shadowColor: const Color(0xFF8C775D),
          gradient: const [Color(0xFFF7F0E1), Color(0xFFE3D2B4)],
          onTap: () => setState(() => _expanded = !_expanded),
        ),
      ],
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
    return _FloatingShortcutChip(
      label: 'Salah',
      statusText: statusText,
      badgeIcon: badgeIcon,
      badgeColor: badgeColor,
      badgeTooltip: badgeTooltip,
      icon: Icons.checklist_rounded,
      textColor: const Color(0xFF69411A),
      borderColor: const Color(0xFF9F7A42),
      shadowColor: const Color(0xFF9F7A42),
      gradient: const [Color(0xFFF8E6D2), Color(0xFFE7BE8E)],
      onTap: () {
        ref.read(worshipTabProvider.notifier).state = WorshipTab.prayer;
        goToTab(context, NavTab.worship);
      },
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
    return _FloatingShortcutChip(
      label: 'Dhikr',
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
      onTap: () {
        ref.read(worshipTabProvider.notifier).state = WorshipTab.dhikr;
        goToTab(context, NavTab.worship);
      },
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
  const _ShortcutDockItem({
    required this.keyName,
    required this.child,
  });

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
      title: 'Qibla Finder',
      subtitle: 'Compass guidance toward the Kaaba',
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
      title: 'Quran Top Words',
      subtitle: 'Learn frequent Quran words from your source document.',
      keywords: [
        'top 500 words',
        'quran words',
        'vocabulary',
        'transliteration',
      ],
      onSelected: (context) => context.pushNamed('quranTopWords'),
    ),
    _HomeSearchDestination(
      title: '99 Names of الله',
      subtitle: 'Arabic names, transliteration, and concise meanings.',
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
      title: 'Islamic Guidance Hub',
      subtitle: 'Hajj, Umrah, New/Revert Muslim support and practice guides.',
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
      title: 'Quran 50 Lessons Mapping',
      subtitle: 'Source-to-category mapping from the lessons PDF.',
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
      title: '50 Important Ahadith',
      subtitle: 'Core hadith collection from your uploaded learning source.',
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
      title: l10n.profileTitle,
      subtitle: l10n.profileSubtitle,
      keywords: ['profile', 'settings', 'reminders', 'preferences'],
      onSelected: (context) => context.goNamed('profilePage'),
    ),
    ..._learnCategorySearchDestinations(),
  ];
}

List<_HomeSearchDestination> _learnCategorySearchDestinations() {
  _HomeSearchDestination destinationForCategory(LearnCategoryItem item) {
    return _HomeSearchDestination(
      title: item.title,
      subtitle:
          item.description ??
          'Learn category • ${item.sectionType.replaceAll('-', ' ')}',
      keywords: [...item.searchKeywords, ...item.tags, item.sectionType],
      onSelected: (context) => context.pushNamed(
        item.routeName,
        pathParameters: item.pathParameters,
        queryParameters: item.queryParameters,
      ),
    );
  }

  return [
    ...LearnCategoryCatalog.items.map(destinationForCategory),
    ...LearnCategoryCatalog.otherLinks.map(destinationForCategory),
    ...LearnCategoryCatalog.searchOnlyLinks.map(destinationForCategory),
  ];
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
    await ref.read(prayerRecentLocationsStoreProvider).save(
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
    final forbiddenPeriod = _activeForbiddenPeriod(scheduleContext.items, now);

    final nextName = next?.name ?? l10n.dhuhr;
    final nextArabic = next?.arabicName ?? l10n.dhuhrArabic;
    final nextAt = next?.offerTime ?? l10n.atTime.replaceFirst('at ', '');
    final currentEndsIn = current == null
        ? null
        : _formatDuration(current.overdueDateTime.difference(now));
    final todayStart = DateTime(now.year, now.month, now.day);
    final dhikrCompletedToday = dhikrState.recentSessions
        .where((session) => !session.finishedAt.isBefore(todayStart))
        .fold<int>(0, (sum, session) => sum + session.count);
    final dhikrToday = dhikrCompletedToday + dhikrState.currentCount;
    const dhikrDailyGoal = 500;
    final hasReachedDhikrDailyGoal = dhikrToday >= dhikrDailyGoal;
    final offerByLabel = 'Begins at';
    final offerByValue = nextAt;
    final locationLabel = displayLocation.valueOrNull ??
        (prayerSettings.preferences.useDeviceLocation
            ? 'Current location'
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
                label: 'Time remaining to offer ${current.name}',
                value: currentEndsIn ?? current.overdueAt,
              ),
              if (current.hasDelayedMakeUpWindow) ...[
                const Divider(height: 12, color: Color(0x28BFAE98)),
                _StatsLine(
                  label: '${current.name} becomes qada',
                  value: current.overdueAt,
                ),
              ],
              const SizedBox(height: 10),
            ],
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => _showLocationPicker(
                context,
                ref,
                locationLabel,
              ),
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
              value: '${prayerSummary.completed} / ${prayerSummary.total}',
            ),
            const Divider(height: 12, color: Color(0x28BFAE98)),
            _StatsLine(
              label: l10n.dhikrToday,
              value: '$dhikrToday / $dhikrDailyGoal',
              trailingIcon: hasReachedDhikrDailyGoal
                  ? Icons.check_circle_rounded
                  : null,
              trailingIconColor: const Color(0xFF5E8A43),
              onTap: () {
                ref.read(worshipTabProvider.notifier).state = WorshipTab.dhikr;
                goToTab(context, NavTab.worship);
              },
            ),
            const Divider(height: 12, color: Color(0x28BFAE98)),
            _StatsLine(
              label: l10n.salahStreak,
              value: '1 ${l10n.homeDaysLabel}',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration value) {
    if (value.isNegative) return '0m';
    final totalMinutes = value.inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours <= 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }

  _ForbiddenPrayerPeriod? _activeForbiddenPeriod(
    List<PrayerScheduleItem> items,
    DateTime now,
  ) {
    PrayerScheduleItem? itemById(String id) => items
        .where((item) => item.id == id)
        .firstOrNull;

    final fajr = itemById('fajr');
    if (fajr != null) {
      final sunriseStart = fajr.overdueDateTime;
      final sunriseEnd = fajr.makeUpFromDateTime;
      if (!now.isBefore(sunriseStart) && now.isBefore(sunriseEnd)) {
        return _ForbiddenPrayerPeriod(
          label: 'Prayer not allowed now • Sunrise',
          value: 'Until ${fajr.makeUpFrom}',
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
          label: 'Prayer not allowed now • Zenith',
          value: 'Until ${dhuhr.windowStart}',
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
          label: 'Prayer not allowed now • Sunset',
          value: 'Until ${maghrib.windowStart}',
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
          Icon(
            trailingIcon,
            size: 16,
            color: trailingIconColor ?? valueColor,
          ),
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

class _DailyBadgeTile extends ConsumerWidget {
  const _DailyBadgeTile({required this.badge});

  final JourneyDailyBadge badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spec = _dailyBadgeSpec(badge.id);
    final active = badge.earnedToday;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openBadgeDestination(context, ref, badge.id),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 124,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: active
                  ? [
                      spec.base.withValues(alpha: 0.28),
                      spec.accent.withValues(alpha: 0.22),
                    ]
                  : [const Color(0xFFF6F0E6), const Color(0xFFE7DCC8)],
            ),
            border: Border.all(
              color: active
                  ? spec.accent.withValues(alpha: 0.45)
                  : const Color(0x28BFAE98),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: spec.accent.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? spec.accent.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.75),
                    ),
                    child: Icon(
                      spec.icon,
                      size: 16,
                      color: active ? spec.accent : const Color(0xFF7A6858),
                    ),
                  ),
                  const Spacer(),
                  if (active)
                    Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: spec.accent,
                    ),
                ],
              ),
              const Spacer(),
              Text(
                badge.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF352B23),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${badge.earnedCount} earned',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: active ? spec.accent : const Color(0xFF6F6256),
                ),
              ),
              if (active) ...[
                const SizedBox(height: 4),
                Text(
                  'Earned today',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: spec.accent,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _DailyBadgeSpec _dailyBadgeSpec(String id) {
    switch (id) {
      case 'all_prayers':
        return const _DailyBadgeSpec(
          icon: Icons.task_alt_rounded,
          base: Color(0xFFE4F2E2),
          accent: Color(0xFF5E8D58),
        );
      case 'daily_dhikr':
        return const _DailyBadgeSpec(
          icon: Icons.favorite_rounded,
          base: Color(0xFFF6EACB),
          accent: Color(0xFFB98A2F),
        );
      case 'quran_return':
        return const _DailyBadgeSpec(
          icon: Icons.menu_book_rounded,
          base: Color(0xFFE2F2E8),
          accent: Color(0xFF4D8B63),
        );
      case 'reflection':
        return const _DailyBadgeSpec(
          icon: Icons.edit_note_rounded,
          base: Color(0xFFECE3F7),
          accent: Color(0xFF8C6AA8),
        );
      case 'perfect_day':
        return const _DailyBadgeSpec(
          icon: Icons.workspace_premium_rounded,
          base: Color(0xFFF7E6C2),
          accent: Color(0xFFD29B28),
        );
      case 'no_missed_prayers':
        return const _DailyBadgeSpec(
          icon: Icons.shield_moon_rounded,
          base: Color(0xFFE4F1EC),
          accent: Color(0xFF4D7A6B),
        );
      case 'before_sunrise_fajr':
        return const _DailyBadgeSpec(
          icon: Icons.wb_twilight_rounded,
          base: Color(0xFFFCE7CD),
          accent: Color(0xFFC07A1E),
        );
      case 'streak_3':
        return const _DailyBadgeSpec(
          icon: Icons.local_fire_department_rounded,
          base: Color(0xFFF8E1D8),
          accent: Color(0xFFC85E34),
        );
      default:
        return const _DailyBadgeSpec(
          icon: Icons.emoji_events_rounded,
          base: Color(0xFFF3ECE2),
          accent: Color(0xFF8A755A),
        );
    }
  }

  void _openBadgeDestination(BuildContext context, WidgetRef ref, String id) {
    switch (id) {
      case 'all_prayers':
      case 'no_missed_prayers':
      case 'before_sunrise_fajr':
        ref.read(worshipTabProvider.notifier).state = WorshipTab.prayer;
        goToTab(context, NavTab.worship);
        return;
      case 'daily_dhikr':
        ref.read(worshipTabProvider.notifier).state = WorshipTab.dhikr;
        goToTab(context, NavTab.worship);
        return;
      case 'quran_return':
        context.pushNamed('quranExplorer');
        return;
      case 'reflection':
        context.pushNamed('learnNotesLanding');
        return;
      case 'perfect_day':
      case 'streak_3':
        context.pushNamed('profileSummary');
        return;
    }
  }
}

class _DailyBadgeSpec {
  const _DailyBadgeSpec({
    required this.icon,
    required this.base,
    required this.accent,
  });

  final IconData icon;
  final Color base;
  final Color accent;
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
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppColors.glassSurfaceAlpha),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: AppColors.accentGold.withValues(
            alpha: AppColors.glassBorderAlpha,
          ),
          width: 1.0,
        ),
      ),
      child: child,
    );
  }
}

// ignore: unused_element
class _HomeDashboardSections extends StatelessWidget {
  const _HomeDashboardSections({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final summary = ref.watch(homeDashboardSummaryProvider);
        final worship = summary.worship;
        final learn = summary.learn;
        final journey = summary.journey;
        final mode = summary.mode.activeMode;
        final assistant = summary.assistant;
        final circles = summary.circles;
        final ocean = summary.ocean;
        final journal = summary.journal;
        final wallpaper = summary.wallpaper;
        final prayerProgressText =
            '${worship.prayerCompleted} / ${worship.prayerTotal}';
        final dhikrProgressText =
            '${worship.dhikrCount} / ${worship.dhikrTarget}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionTitle(
              title: l10n.homeOverviewHeroTitle,
              subtitle: l10n.homeOverviewHeroSubtitle,
            ),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ValueTile(
                          title: l10n.homePrayerProgressTitle,
                          value: prayerProgressText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ValueTile(
                          title: l10n.homeDhikrProgressTitle,
                          value: dhikrProgressText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ValueTile(
                          title: l10n.homeCurrentStreakTitle,
                          value:
                              '${journey.currentStreakDays} ${l10n.homeDaysLabel}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ValueTile(
                          title: l10n.homeXpLevelTitle,
                          value: '${l10n.levelLabel} ${journey.level}',
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: journey.xpProgress,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceSoft.withValues(
                        alpha: 0.6,
                      ),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.homeAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${journey.nextLevelXpRemaining} ${l10n.homeXpToNextLevel}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (journey.dailyBadges.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'Daily badges',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4D4036),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 98,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: journey.dailyBadges.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final badge = journey.dailyBadges[index];
                          return _DailyBadgeTile(badge: badge);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(
              title: l10n.homeWorshipSummaryTitle,
              subtitle: l10n.homeWorshipSummarySubtitle,
            ),
            PremiumCard(
              child: Column(
                children: [
                  _SummaryRow(
                    label: l10n.homePrayerProgressTitle,
                    value: prayerProgressText,
                    onTap: () => goToTab(context, NavTab.worship),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeDhikrProgressTitle,
                    value: dhikrProgressText,
                    onTap: () => goToTab(context, NavTab.worship),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeFastingStatusTitle,
                    value: _fastingLabel(l10n, worship.fastingStatus),
                    onTap: () => goToTab(context, NavTab.worship),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeKhusuQuickEntryTitle,
                    value: l10n.homeKhusuQuickEntryValue,
                    onTap: () => context.pushNamed('khusuFocus'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(
              title: l10n.homeLearnSummaryTitle,
              subtitle: l10n.homeLearnSummarySubtitle,
            ),
            PremiumCard(
              child: Column(
                children: [
                  _SummaryRow(
                    label: l10n.homeLearnContinueQuran,
                    value: '${learn.continueSurahName} ${learn.continueAyah}',
                    onTap: () => context.pushNamed('quranExplorer'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnFeaturedLife,
                    value: _lifeTopicLabel(l10n, learn.featuredLifeTopic),
                    onTap: () => context.pushNamed('learnLifeLanding'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnFeaturedWorld,
                    value: _worldTopicLabel(l10n, learn.featuredWorldTopic),
                    onTap: () => context.pushNamed('learnWorldLanding'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnFeaturedHadith,
                    value: _hadithTopicLabel(l10n, learn.featuredHadithTopic),
                    onTap: () => context.pushNamed('learnHadithLanding'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnResumeNotes,
                    value: learn.resumeNoteTitle == 'Reflection Draft'
                        ? l10n.homeLearnResumeNotesValue
                        : learn.resumeNoteTitle,
                    onTap: () => context.pushNamed('learnNotesLanding'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(
              title: l10n.homeJourneySummaryTitle,
              subtitle: l10n.homeJourneySummarySubtitle,
            ),
            PremiumCard(
              child: Column(
                children: [
                  _SummaryRow(
                    label: l10n.homeXpLevelTitle,
                    value: '${l10n.levelLabel} ${journey.level}',
                    onTap: () => goToTab(context, NavTab.journey),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeJourneyXpProgressTitle,
                    value: '${journey.xp} XP',
                    onTap: () => goToTab(context, NavTab.journey),
                  ),
                  if (mode != AppSpecialMode.gentle)
                    const Divider(height: 12, color: Color(0x28BFAE98)),
                  if (mode != AppSpecialMode.gentle)
                    _SummaryRow(
                      label: l10n.homeCurrentStreakTitle,
                      value:
                          '${journey.currentStreakDays} ${l10n.homeDaysLabel}',
                      onTap: () => goToTab(context, NavTab.journey),
                    ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeJourneyDailyRingsTitle,
                    value:
                        'P ${_pct(journey.ringPrayer)} · D ${_pct(journey.ringDhikr)} · Q ${_pct(journey.ringQuran)}',
                    onTap: () => goToTab(context, NavTab.journey),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeJourneyNextUnlockTitle,
                    value: _nextUnlockLabel(l10n, journey.nextUnlockPreviewKey),
                    onTap: () => goToTab(context, NavTab.journey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(
              title: l10n.homeQuickActionsTitle,
              subtitle: l10n.homeQuickActionsSubtitle,
            ),
            PremiumCard(
              child: Row(
                children: [..._quickActionsPrimary(context, ref, l10n, mode)],
              ),
            ),
            const SizedBox(height: 10),
            PremiumCard(
              child: Row(
                children: [..._quickActionsSecondary(context, l10n, mode)],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(
              title: l10n.homeEcosystemSummaryTitle,
              subtitle: l10n.homeEcosystemSummarySubtitle,
            ),
            PremiumCard(
              child: Column(
                children: [
                  _SummaryRow(
                    label: l10n.oceanTitle,
                    value: '${ocean.totalDrops}',
                    onTap: () => context.pushNamed('oceanDrops'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.wallpaperLibraryTitle,
                    value:
                        '${wallpaper.unlockedCount} • ${wallpaper.selectedTitle}',
                    onTap: () => context.pushNamed('wallpaperLibrary'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.circlesTitle,
                    value:
                        '${circles.joinedCount} • ${circles.featuredCircleTitle}',
                    onTap: () => context.pushNamed('circlesDiscovery'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.journalTitle,
                    value:
                        '${journal.entriesCount} • ${journal.favoriteEntries}',
                    onTap: () => context.pushNamed('journalTimeline'),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.assistantTitle,
                    value:
                        '${assistant.recentMessages} • ${assistant.recentPrompts}',
                    onTap: () => context.pushNamed('assistant'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(
              title: l10n.homeReflectionTitle,
              subtitle: l10n.homeReflectionSubtitle,
            ),
            PremiumCard(
              child: Text(
                summary.mode.isKidsMode
                    ? l10n.kidsHomeReflectionHint
                    : l10n.homeReflectionReminder,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _pct(double value) => '${(value.clamp(0, 1) * 100).round()}%';

  String _lifeTopicLabel(AppLocalizations l10n, LearnLifeTopic topic) {
    switch (topic) {
      case LearnLifeTopic.marriage:
        return l10n.learnLifeMarriage;
      case LearnLifeTopic.parents:
        return l10n.learnLifeParents;
      case LearnLifeTopic.children:
        return l10n.learnLifeChildren;
      case LearnLifeTopic.wealth:
        return l10n.learnLifeWealth;
      case LearnLifeTopic.patience:
        return l10n.learnLifePatience;
      case LearnLifeTopic.justice:
        return l10n.learnLifeJustice;
      case LearnLifeTopic.character:
        return l10n.learnLifeCharacter;
      case LearnLifeTopic.gratitude:
        return l10n.learnLifeGratitude;
    }
  }

  String _worldTopicLabel(AppLocalizations l10n, LearnWorldTopic topic) {
    switch (topic) {
      case LearnWorldTopic.moon:
        return l10n.learnWorldMoon;
      case LearnWorldTopic.bees:
        return l10n.learnWorldBees;
      case LearnWorldTopic.mountains:
        return l10n.learnWorldMountains;
      case LearnWorldTopic.rain:
        return l10n.learnWorldRain;
      case LearnWorldTopic.oceans:
        return l10n.learnWorldOceans;
      case LearnWorldTopic.animals:
        return l10n.learnWorldAnimals;
      case LearnWorldTopic.plants:
        return l10n.learnWorldPlants;
      case LearnWorldTopic.nightAndDay:
        return l10n.learnWorldNightDay;
    }
  }

  String _hadithTopicLabel(AppLocalizations l10n, LearnHadithTopic topic) {
    switch (topic) {
      case LearnHadithTopic.lifeLessons:
        return l10n.learnHadithLifeLessonsTitle;
      case LearnHadithTopic.worldLessons:
        return l10n.learnHadithWorldLessonsTitle;
      case LearnHadithTopic.characterAndManners:
        return l10n.learnHadithCharacterTitle;
      case LearnHadithTopic.worshipAndIntention:
        return l10n.learnHadithWorshipTitle;
      case LearnHadithTopic.familyAndSociety:
        return l10n.learnHadithFamilyTitle;
    }
  }

  String _nextUnlockLabel(AppLocalizations l10n, String unlockKey) {
    switch (unlockKey) {
      case 'wallpaper':
        return l10n.journeyUnlockWallpaper;
      case 'reflection':
        return l10n.journeyUnlockReflection;
      case 'theme':
        return l10n.journeyUnlockTheme;
      default:
        return l10n.journeyUnlockFuture;
    }
  }

  String _fastingLabel(AppLocalizations l10n, FastingStatus status) {
    switch (status) {
      case FastingStatus.notFasting:
        return l10n.homeFastingNotFasting;
      case FastingStatus.intending:
        return l10n.homeFastingIntending;
      case FastingStatus.completed:
        return l10n.homeFastingCompleted;
      case FastingStatus.broken:
        return l10n.homeFastingBroken;
    }
  }

  List<Widget> _quickActionsPrimary(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppSpecialMode mode,
  ) {
    if (mode == AppSpecialMode.ramadan) {
      return [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.fastfood_outlined,
            label: l10n.modeRamadanActionFasting,
            onTap: () {
              ref.read(worshipTabProvider.notifier).state = WorshipTab.fasting;
              goToTab(context, NavTab.worship);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.menu_book_outlined,
            label: l10n.modeRamadanActionQuran,
            onTap: () => context.pushNamed('quranExplorer'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.rate_review_outlined,
            label: l10n.modeRamadanActionReflect,
            onTap: () => context.pushNamed('learnNotesLanding'),
          ),
        ),
      ];
    }

    if (mode == AppSpecialMode.loss) {
      return [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.self_improvement_outlined,
            label: l10n.modeLossActionDhikr,
            onTap: () => goToTab(context, NavTab.worship),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.spa_outlined,
            label: l10n.modeLossActionKhusu,
            onTap: () => context.pushNamed('khusuFocus'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.menu_book_outlined,
            label: l10n.modeLossActionMercy,
            onTap: () => context.pushNamed('quranExplorer'),
          ),
        ),
      ];
    }

    if (mode == AppSpecialMode.gentle) {
      return [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.today_outlined,
            label: l10n.modeGentleActionOneStep,
            onTap: () => goToTab(context, NavTab.worship),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.auto_stories_outlined,
            label: l10n.modeGentleActionReflect,
            onTap: () => context.pushNamed('learnNotesLanding'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.menu_book_outlined,
            label: l10n.navLearning,
            onTap: () => goToTab(context, NavTab.learn),
          ),
        ),
      ];
    }

    return [
      Expanded(
        child: _QuickActionButton(
          icon: Icons.self_improvement_outlined,
          label: l10n.navDhikr,
          onTap: () => goToTab(context, NavTab.worship),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _QuickActionButton(
          icon: Icons.menu_book_outlined,
          label: l10n.navLearning,
          onTap: () => goToTab(context, NavTab.learn),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _QuickActionButton(
          icon: Icons.route_outlined,
          label: l10n.navPrayer,
          onTap: () => goToTab(context, NavTab.journey),
        ),
      ),
    ];
  }

  List<Widget> _quickActionsSecondary(
    BuildContext context,
    AppLocalizations l10n,
    AppSpecialMode mode,
  ) {
    if (mode == AppSpecialMode.ramadan) {
      return [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.settings_outlined,
            label: l10n.profileTitle,
            onTap: () => context.goNamed('settings'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.spa_outlined,
            label: l10n.homeKhusuQuickEntryShort,
            onTap: () => context.pushNamed('khusuFocus'),
          ),
        ),
      ];
    }

    return [
      Expanded(
        child: _QuickActionButton(
          icon: Icons.settings_outlined,
          label: l10n.profileTitle,
          onTap: () => context.goNamed('settings'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _QuickActionButton(
          icon: Icons.smart_toy_outlined,
          label: l10n.assistantTitle,
          onTap: () => context.pushNamed('assistant'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _QuickActionButton(
          icon: Icons.spa_outlined,
          label: l10n.homeKhusuQuickEntryShort,
          onTap: () => context.pushNamed('khusuFocus'),
        ),
      ),
    ];
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
            onTap: () {
              ref.read(worshipTabProvider.notifier).state = WorshipTab.fasting;
              goToTab(context, NavTab.worship);
            },
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
            label: l10n.navLearning,
            onTap: () => goToTab(context, NavTab.learn),
          ),
          _ModeActionChip(
            icon: Icons.auto_stories_outlined,
            label: l10n.journalTitle,
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
    final dailyBundle = ref.watch(todayDailyLearningBundleProvider);
    final dailyController = ref.read(dailyLearningControllerProvider.notifier);
    final allProphets = ref.watch(prophetsProvider);

    void openProphetById(String prophetId) {
      context.pushNamed(
        'learnSectionHub',
        pathParameters: {'sectionId': 'prophets'},
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
        'learnSectionHub',
        pathParameters: {'sectionId': 'prophets'},
      );
    }

    return PremiumCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          title: const Text(
            'Daily learning & quizzes',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: const Text(
            'Keep daily revelation, prophet review, trivia, and guided quizzes in one place.',
          ),
          children: [
            const SizedBox(height: 10),
            DailyRevelationCard(
              item: dailyBundle.item,
              isOpened: dailyBundle.status.cardOpened,
              onOpen: openDailyItem,
              onTakeQuiz: () => context.pushNamed(
                'learnSectionHub',
                pathParameters: {'sectionId': 'prophets'},
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
                'learnSectionHub',
                pathParameters: {'sectionId': 'prophets'},
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
                  label: 'Prophets Quiz',
                  onTap: () => context.pushNamed(
                    'learnSectionHub',
                    pathParameters: {'sectionId': 'prophets'},
                    queryParameters: {'tab': 'quiz'},
                  ),
                ),
                _QuickActionButton(
                  icon: Icons.quiz_rounded,
                  label: 'Islamic Trivia',
                  onTap: () => context.pushNamed('learnIslamicTrivia'),
                ),
                _QuickActionButton(
                  icon: Icons.route_rounded,
                  label: 'Knowledge Paths',
                  onTap: () => context.pushNamed('learnTriviaKnowledgePaths'),
                ),
                _QuickActionButton(
                  icon: Icons.replay_circle_filled_rounded,
                  label: 'Review Mistakes',
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

class _HomeSummaryShortcutCard extends StatelessWidget {
  const _HomeSummaryShortcutCard({
    required this.l10n,
    required this.dailyBundle,
  });

  final AppLocalizations l10n;
  final DailyLearningBundle dailyBundle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeOverviewHeroTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.homeOverviewHeroSubtitle,
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('profileSummary'),
                  icon: const Icon(Icons.summarize_outlined),
                  label: Text(l10n.homeOverviewHeroTitle),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => context.goNamed('settings'),
                  icon: const Icon(Icons.settings_outlined),
                  label: Text(l10n.profilePrayerSettingsTitle),
                ),
              ),
            ],
          ),
        ],
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF4A423A),
                fontSize: 14.5,
                fontFamily: 'serif',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF2F2923),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif',
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.onSurfaceSubtle,
          ),
        ],
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

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
