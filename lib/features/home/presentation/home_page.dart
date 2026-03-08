import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/worship/domain/fasting_status.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
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
                _HomeDashboardSections(l10n: l10n),
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
        final prayerProgressText = '${worship.prayerCompleted} / ${worship.prayerTotal}';
        final dhikrProgressText = '${worship.dhikrCount} / ${worship.dhikrTarget}';

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
                          value: '${journey.currentStreakDays} ${l10n.homeDaysLabel}',
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
                      backgroundColor: AppColors.surfaceSoft.withValues(alpha: 0.6),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.homeAccent),
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
                    onTap: () => goToTab(context, NavTab.learn),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnFeaturedLife,
                    value: _lifeTopicLabel(l10n, learn.featuredLifeTopic),
                    onTap: () => goToTab(context, NavTab.learn),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnFeaturedWorld,
                    value: _worldTopicLabel(l10n, learn.featuredWorldTopic),
                    onTap: () => goToTab(context, NavTab.learn),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnFeaturedHadith,
                    value: _hadithTopicLabel(l10n, learn.featuredHadithTopic),
                    onTap: () => goToTab(context, NavTab.learn),
                  ),
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeLearnResumeNotes,
                    value: learn.resumeNoteTitle,
                    onTap: () => goToTab(context, NavTab.learn),
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
                  const Divider(height: 12, color: Color(0x28BFAE98)),
                  _SummaryRow(
                    label: l10n.homeCurrentStreakTitle,
                    value: '${journey.currentStreakDays} ${l10n.homeDaysLabel}',
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
                children: [
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
                ],
              ),
            ),
            const SizedBox(height: 10),
            PremiumCard(
              child: Row(
                children: [
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
                l10n.homeReflectionReminder,
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
          const Icon(Icons.chevron_right, size: 18, color: AppColors.onSurfaceSubtle),
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
