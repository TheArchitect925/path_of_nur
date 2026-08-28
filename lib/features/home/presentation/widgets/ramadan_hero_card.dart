import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../profile/application/profile_settings_provider.dart';

/// The Ramadan hero: "Ramadan · Day N" with the countdown that matters right
/// now — iftar while the fast is on, suhoor's end through the night. Renders
/// nothing outside Ramadan (mode toggle or saved date window).
class RamadanHeroCard extends ConsumerWidget {
  const RamadanHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialMode = ref.watch(specialModeProvider);
    if (!specialMode.isRamadan && !specialMode.ramadanDateWindowActive) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final startIso = ref.watch(
      profileSettingsProvider.select((s) => s.ramadanStartDateIso),
    );

    PrayerScheduleItem? itemById(String id) {
      for (final item in scheduleContext.items) {
        if (item.id == id) return item;
      }
      return null;
    }

    final fajr = itemById('fajr');
    final maghrib = itemById('maghrib');

    String headline;
    String? detail;
    IconData icon;
    if (fajr != null && now.isBefore(fajr.windowStartDateTime)) {
      // Night's end: suhoor closes at fajr.
      icon = Icons.wb_twilight_rounded;
      headline = l10n.homeRamadanSuhoorEndsIn(
        _formatCountdown(fajr.windowStartDateTime.difference(now)),
      );
      detail = l10n.homeRamadanSuhoorEndsAt(fajr.windowStart);
    } else if (maghrib != null && now.isBefore(maghrib.windowStartDateTime)) {
      // Fasting hours: count down to iftar.
      icon = Icons.nightlight_round;
      headline = l10n.homeRamadanIftarIn(
        _formatCountdown(maghrib.windowStartDateTime.difference(now)),
      );
      detail = l10n.homeRamadanIftarAt(maghrib.windowStart);
    } else if (fajr != null) {
      // Evening: iftar has passed; suhoor ends around fajr tomorrow
      // (today's time is a close approximation one day ahead).
      icon = Icons.wb_twilight_rounded;
      headline = l10n.homeRamadanSuhoorEndsAt(fajr.windowStart);
      detail = null;
    } else {
      icon = Icons.nightlight_round;
      headline = l10n.modeRamadanHomeSubtitle;
      detail = null;
    }

    final day = _ramadanDayNumber(startIso, now);
    final eyebrow = day == null
        ? l10n.homeGreetingRamadanMubarak
        : l10n.homeRamadanDayLabel(day);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        density: PremiumCardDensity.compact,
        onTap: () => context.pushNamed('worshipFastingPage'),
        child: Row(
          children: [
            Icon(icon, size: 30, color: appearance?.accent),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: appearance?.accent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    headline,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (detail != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: appearance?.onSurfaceSubtle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: appearance?.onSurfaceSubtle,
            ),
          ],
        ),
      ),
    );
  }
}

/// 1-based day of Ramadan from the saved start date; null when the start
/// date is missing, unparseable, or [now] falls outside days 1–30.
int? _ramadanDayNumber(String? startIso, DateTime now) {
  if (startIso == null) return null;
  final start = DateTime.tryParse(startIso);
  if (start == null) return null;
  // UTC dates: local midnights across a DST change are not whole days apart.
  final startDay = DateTime.utc(start.year, start.month, start.day);
  final today = DateTime.utc(now.year, now.month, now.day);
  final day = today.difference(startDay).inDays + 1;
  if (day < 1 || day > 30) return null;
  return day;
}

String _formatCountdown(Duration remaining) {
  final clamped = remaining.isNegative ? Duration.zero : remaining;
  final hours = clamped.inHours;
  final minutes = clamped.inMinutes % 60;
  if (hours <= 0) return '${minutes}m';
  return '${hours}h ${minutes}m';
}
