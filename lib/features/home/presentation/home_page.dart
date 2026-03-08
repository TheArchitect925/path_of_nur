import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/state/shell_state.dart';
import '../../../shared/state/location_permission_state.dart';
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
      locationLabel: verse.locationLabel ??
          _homeVerseLocationLabels[verseIndex % _homeVerseLocationLabels.length],
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
                _ExistingSections(l10n: l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TopGreetingBlock extends StatelessWidget {
  const _TopGreetingBlock({
    required this.l10n,
    required this.userProfile,
  });

  final AppLocalizations l10n;
  final UserProfileState userProfile;

  String get _address {
    return userProfile.sex == UserSex.brother ? 'Brother' : 'Sister';
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
                  'Home',
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
              onPressed: () => context.goNamed('settings'),
              icon: const Icon(
                Icons.settings,
                size: 30,
                color: Color(0xFF7A5A33),
              ),
              tooltip: 'Settings',
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

class _WelcomeCarousel extends StatelessWidget {
  const _WelcomeCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: PageView(
        physics: const BouncingScrollPhysics(),
        children: const [
          _LocationPermissionCarouselCard(),
          _WelcomeCarouselCard(
            icon: Icons.wb_sunny_outlined,
            title: 'Daily Intention',
            subtitle: 'Start the day with gentle focus, reflection, and consistency.',
          ),
          _WelcomeCarouselCard(
            icon: Icons.schedule_rounded,
            title: 'Prayer Rhythm',
            subtitle: 'Today’s next salah and guidance are synced and visible below.',
          ),
          _WelcomeCarouselCard(
            icon: Icons.favorite_outline_rounded,
            title: 'Dhikr & Quiet',
            subtitle: 'Choose calm moments to track reminders and intention.',
          ),
        ],
      ),
    );
  }
}

class _LocationPermissionCarouselCard extends ConsumerWidget {
  const _LocationPermissionCarouselCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationPermissionProvider);
    final locationNotifier = ref.read(locationPermissionProvider.notifier);

    String subtitle;
    IconData statusIcon;
    Color statusColor;

    if (locationState.isGranted) {
      subtitle = 'Location access is enabled while you use the app.';
      statusIcon = Icons.check_circle_outline;
      statusColor = const Color(0xFF6E8E63);
    } else if (locationState.status == PermissionStatus.denied) {
      subtitle =
          'Allow location only while using the app for accurate prayer times.';
      statusIcon = Icons.location_on_outlined;
      statusColor = const Color(0xFF8F6E40);
    } else if (locationState.isPermanentlyDenied) {
      subtitle =
          'Location access is blocked. Open settings to enable while using app.';
      statusIcon = Icons.warning_amber_rounded;
      statusColor = const Color(0xFF8B6A3A);
    } else {
      subtitle = 'Location permission status can be updated anytime.';
      statusIcon = Icons.info_outline;
      statusColor = const Color(0xFF7A6A56);
    }

    return _GlassCard(
      radius: 22,
      alpha: 0.45,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF2E8DC).withValues(alpha: 0.7),
                  border: Border.all(
                    color: const Color(0xFFD8C49A).withValues(alpha: 0.45),
                  ),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Use location while using app?',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A3027),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Enable foreground location for accurate prayer times.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF65584A),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              locationState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : TextButton(
                      onPressed: locationState.isPermanentlyDenied
                          ? locationNotifier.openSystemSettings
                          : locationNotifier.requestWhileUsingApp,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        locationState.isPermanentlyDenied ? 'Settings' : 'Allow',
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF65584A),
              height: 1.2,
            ),
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
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3027),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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
            const Text(
              'Tap this card to change verse',
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

class _SalahSummaryCard extends StatelessWidget {
  const _SalahSummaryCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
                            l10n.dhuhr,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF202228),
                              fontFamily: 'serif',
                              height: 1.0,
                            ),
                          ),
                          Text(
                            l10n.dhuhrArabic,
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
                            l10n.remainingTime,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF202228),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.atTime,
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
            _StatsLine(label: l10n.salahCompleted, value: '0 / 5'),
            const Divider(height: 12, color: Color(0x28BFAE98)),
            _StatsLine(label: l10n.dhikrToday, value: '0'),
            const Divider(height: 12, color: Color(0x28BFAE98)),
            _StatsLine(label: l10n.salahStreak, value: '1 day'),
          ],
        ),
      ),
    );
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

class _ExistingSections extends StatelessWidget {
  const _ExistingSections({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.homeSectionDailyNurTitle,
          subtitle: l10n.homeSectionDailyNurSubtitle,
        ),
        PremiumCard(
          child: InkWell(
            onTap: () => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': 'home-daily-nur'},
            ),
            child: _MetricRow(
              leftTitle: l10n.prayersCompletedLabel,
              leftValue: '3 / 5',
              rightTitle: l10n.dhikrSessionsLabel,
              rightValue: l10n.oneToday,
            ),
          ),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.homePrayerSummaryTitle,
          subtitle: l10n.homePrayerSummarySubtitle,
        ),
        PremiumCard(
          child: _SimpleList(
            items: {
              l10n.prayerHistory: 'home-prayer-summary',
              l10n.missedReminder: 'worshipSummary',
              l10n.gentleSchedule: 'prayer',
            },
            onTap: (key) => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': key},
            ),
          ),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.homeDhikrLearningTitle,
          subtitle: l10n.homeDhikrLearningSubtitle,
        ),
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: _ShortcutButton(
                  icon: Icons.format_quote,
                  label: l10n.navDhikr,
                  subtitle: l10n.start33Recitation,
                  sectionId: 'home-dhikr-quick',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ShortcutButton(
                  icon: Icons.import_contacts,
                  label: l10n.quranTitle,
                  subtitle: l10n.resumeWhereLeft,
                  sectionId: 'home-quran-continue',
                ),
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
            l10n.reflectionQuote,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.homeLevelStreakTitle,
          subtitle: l10n.homeLevelStreakSubtitle,
        ),
        PremiumCard(
          child: _MetricRow(
            leftTitle: l10n.levelLabel,
            leftValue: '4',
            rightTitle: l10n.streakLabel,
            rightValue: l10n.sevenDays,
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.leftTitle,
    required this.leftValue,
    required this.rightTitle,
    required this.rightValue,
  });

  final String leftTitle;
  final String leftValue;
  final String rightTitle;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ValueTile(title: leftTitle, value: leftValue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ValueTile(title: rightTitle, value: rightValue),
        ),
      ],
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

class _SimpleList extends StatelessWidget {
  const _SimpleList({required this.items, required this.onTap});

  final Map<String, String> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.entries
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () => onTap(item.value),
                child: Row(
                  children: [
                    const Icon(
                      Icons.fiber_manual_record,
                      size: 8,
                      color: AppColors.homeAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(item.key),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.sectionId,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        'featureSection',
        pathParameters: {'sectionId': sectionId},
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accentGoldSoft.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accentGold),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
