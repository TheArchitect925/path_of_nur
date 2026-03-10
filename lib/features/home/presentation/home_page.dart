import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/worship/domain/fasting_status.dart';
import '../../../features/worship/application/worship_tab_provider.dart';
import '../../../features/worship/application/prayer_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/shell_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
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
                const _WelcomeCarousel(),
                const SizedBox(height: 10),
                const _ModeAwareHomeCard(),
                const SizedBox(height: 10),
                const _AvatarHaloSection(),
                const SizedBox(height: 16),
                _AyahCard(
                  l10n: l10n,
                  verse: displayVerse,
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
                const SizedBox(height: 24),
                _HomeSummaryShortcutCard(l10n: l10n),
              ],
            ),
          ),
        ),
      ],
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.home_filled,
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
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF23201C),
            height: 1.15,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 10),
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
      ],
    );
  }
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
      title: '99 Names of Allah',
      subtitle: 'Arabic names, transliteration, and concise meanings.',
      keywords: ['99 names', 'asma ul husna', 'allah names', 'names of Allah'],
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
      title: l10n.navGarden,
      subtitle: l10n.profileSubtitle,
      keywords: ['profile', 'settings', 'reminders', 'preferences'],
      onSelected: (context) => context.go(NavTab.profile.path),
    ),
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
      alpha: 0.45,
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
    required this.onTap,
  });

  final AppLocalizations l10n;
  final HomeVerse verse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: _GlassCard(
        radius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          children: [
            Text(
              verse.arabic,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF1E1B18),
                fontFamily: 'serif',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              verse.transliteration,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5C5046),
                fontStyle: FontStyle.italic,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              verse.translation,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15.5,
                color: Color(0xFF42362D),
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
            const SizedBox(height: 8),
            Text(
              l10n.homeTapVerseCardHint,
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF6D5A4C),
                fontFamily: 'serif',
                letterSpacing: 0.2,
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

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final next = scheduleContext.items
        .where((item) => item.id == scheduleContext.nextPrayerId)
        .firstOrNull;
    final prayerSummary = ref.watch(prayerSummaryProvider);

    final nextName = next?.name ?? l10n.dhuhr;
    final nextArabic = next?.arabicName ?? l10n.dhuhrArabic;
    final nextAt = next?.offerTime ?? l10n.atTime.replaceFirst('at ', '');
    final remaining = next == null
        ? l10n.remainingTime
        : _formatDuration(scheduleContext.remainingToNext);

    return InkWell(
      onTap: () => context.pushNamed('salahTimes'),
      borderRadius: BorderRadius.circular(32),
      child: _GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        radius: 32,
        alpha: 0.50,
        child: Column(
          children: [
            _GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              radius: 24,
              alpha: 0.46,
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
                            remaining,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF202228),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'at $nextAt',
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
            _StatsLine(label: l10n.dhikrToday, value: '0'),
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
}

class _StatsLine extends StatelessWidget {
  const _StatsLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A423A),
            fontSize: 14.5,
            fontFamily: 'serif',
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF2F2923),
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 30,
    this.alpha = 0.58,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.4, sigmaY: 5.4),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFFF2EBE1).withValues(alpha: alpha),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color(0xFFD8C49A).withValues(alpha: 0.44),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
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

class _HomeSummaryShortcutCard extends StatelessWidget {
  const _HomeSummaryShortcutCard({required this.l10n});

  final AppLocalizations l10n;

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
