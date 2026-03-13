import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/arabic_text_utils.dart';
import '../../../shared/widgets/global_background.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';

class SalahTimesPage extends ConsumerWidget {
  const SalahTimesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final settings = ref.watch(prayerSettingsProvider);
    final schedule = ref.watch(prayerScheduleProvider);
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const GlobalBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: const Color(0xFF3C2F25),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        IslamicIcons.prayer,
                        color: Color(0xFF3C2F25),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Salah Timings',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF32251D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  QuranQuoteBlock(
                    quote: const QuranQuote(
                      arabic: 'إِنَّ الصَّلَاةَ نُورٌ',
                      transliteration: 'Innas salahu nuru',
                      translation:
                          'Prayer is light; use it with clarity and consistency.',
                      surah: 9,
                      verse: 18,
                      locationLabel: 'Qur’an 9:18',
                    ),
                    onTap: () => openQuranQuoteLocation(
                      context,
                      const QuranQuote(
                        arabic: 'إِنَّ الصَّلَاةَ نُورٌ',
                        transliteration: 'Innas salahu nuru',
                        translation:
                            'Prayer is light; use it with clarity and consistency.',
                        surah: 9,
                        verse: 18,
                        locationLabel: 'Qur’an 9:18',
                      ),
                    ),
                    compact: true,
                  ),
                  Text(
                    '${settings.preferences.location} · ${_madhabLabel(settings.preferences.madhab)} · ${_methodLabel(settings.preferences.calculationMethod)}',
                    style: const TextStyle(
                      color: Color(0xFF4D4036),
                      fontSize: 12.8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: schedule.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final entry = schedule[index];
                        final isNext = scheduleContext.nextPrayerId == entry.id;
                        final isCurrent =
                            scheduleContext.currentPrayerId == entry.id;
                        final offerStatus = _offerTimingText(entry, now);
                        return PremiumCard(
                          surfaceAlphaOverride: 0.9,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isNext || isCurrent)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color:
                                          (isCurrent
                                                  ? const Color(0xFF8FAF89)
                                                  : const Color(0xFFB58D46))
                                              .withValues(alpha: 0.2),
                                      border: Border.all(
                                        color: isCurrent
                                            ? const Color(0xFF8FAF89)
                                            : const Color(0xFFB58D46),
                                      ),
                                    ),
                                    child: Text(
                                      isCurrent
                                          ? l10n.salahCurrentPrayerBadge
                                          : l10n.salahNextPrayerBadge,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.name,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'serif',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF33281F),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            entry.arabicName,
                                            textAlign: textAlignForContent(
                                              entry.arabicName,
                                            ),
                                            textDirection:
                                                textDirectionForContent(
                                                  entry.arabicName,
                                                ),
                                            style: AppTextStyles.arabicLearning(
                                              size: 18,
                                              color: const Color(0xFF3F332C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: AppColors.accentGoldSoft,
                                        ),
                                      ),
                                      child: Text(
                                        '${entry.totalRakats} Rakats',
                                        style: const TextStyle(
                                          color: Color(0xFF5B6B5C),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _MetaRow(
                                  label: 'Offer time',
                                  value: entry.offerTime,
                                ),
                                const SizedBox(height: 6),
                                _MetaRow(
                                  label: 'Offer Window',
                                  value:
                                      '${entry.windowStart} to ${entry.windowEnd}',
                                ),
                                const SizedBox(height: 6),
                                _MetaRow(
                                  label: 'Becomes qada after',
                                  value: entry.overdueAt,
                                ),
                                const SizedBox(height: 6),
                                _MetaRow(
                                  label: 'Time remaining to offer',
                                  value: offerStatus,
                                ),
                                if (entry.hasDelayedMakeUpWindow) ...[
                                  const SizedBox(height: 6),
                                  _MetaRow(
                                    label: 'Make up from',
                                    value: entry.makeUpFrom,
                                  ),
                                ],
                                const SizedBox(height: 6),
                                _MetaRow(
                                  label: 'Qada rule',
                                  value: entry.qadaRuleSummary,
                                ),
                                const SizedBox(height: 6),
                                _MetaRow(
                                  label: 'Category',
                                  value: entry.category,
                                ),
                                const SizedBox(height: 12),
                                _NotificationButtons(
                                  l10n: l10n,
                                  active:
                                      settings.notificationModes[entry.id] ??
                                      PrayerNotificationMode.none,
                                  onSelect: (mode) => ref
                                      .read(prayerSettingsProvider.notifier)
                                      .updateNotificationMode(entry.id, mode),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
}

String _offerTimingText(PrayerScheduleItem entry, DateTime now) {
  if (now.isBefore(entry.windowStartDateTime)) {
    return 'Starts in ${_formatDuration(entry.windowStartDateTime.difference(now))}';
  }
  if (now.isBefore(entry.overdueDateTime)) {
    return _formatDuration(entry.overdueDateTime.difference(now));
  }
  return 'Offer window ended';
}

String _formatDuration(Duration value) {
  if (value.isNegative) return '0m';
  final totalMinutes = value.inMinutes;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours <= 0) return '${minutes}m';
  return '${hours}h ${minutes}m';
}

class _NotificationButtons extends StatelessWidget {
  const _NotificationButtons({
    required this.l10n,
    required this.active,
    required this.onSelect,
  });

  final AppLocalizations l10n;
  final PrayerNotificationMode active;
  final ValueChanged<PrayerNotificationMode> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _NotificationButton(
          icon: Icons.notifications_off_outlined,
          label: l10n.salahNotificationOff,
          selected: active == PrayerNotificationMode.none,
          onPressed: () => onSelect(PrayerNotificationMode.none),
        ),
        _NotificationButton(
          icon: Icons.notifications_none,
          label: 'Notification',
          selected: active == PrayerNotificationMode.notificationOnly,
          onPressed: () => onSelect(PrayerNotificationMode.notificationOnly),
        ),
        _NotificationButton(
          icon: Icons.volume_up,
          label: 'Adhan',
          selected: active == PrayerNotificationMode.adhanWithSound,
          onPressed: () => onSelect(PrayerNotificationMode.adhanWithSound),
        ),
        _NotificationButton(
          icon: Icons.alarm,
          label: 'Before qaza',
          selected: active == PrayerNotificationMode.reminderBeforeQaza,
          onPressed: () => onSelect(PrayerNotificationMode.reminderBeforeQaza),
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF3A2F28),
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      backgroundColor: selected
          ? const Color(0xFFB58D46)
          : const Color(0xFFF4EEE7).withValues(alpha: 0.85),
      avatar: Icon(
        icon,
        size: 15,
        color: selected ? Colors.white : const Color(0xFF6A5A4A),
      ),
      onPressed: onPressed,
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4F4137),
              fontWeight: FontWeight.w600,
              fontSize: 12.8,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Color(0xFF2F2620),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

String _madhabLabel(PrayerMadhab madhab) {
  switch (madhab) {
    case PrayerMadhab.shafii:
      return 'Shafi\'i';
    case PrayerMadhab.hanafi:
      return 'Hanafi';
    case PrayerMadhab.maliki:
      return 'Maliki';
    case PrayerMadhab.hanbali:
      return 'Hanbali';
  }
}

String _methodLabel(PrayerCalculationMethod method) {
  switch (method) {
    case PrayerCalculationMethod.muslimWorldLeague:
      return 'MWL';
    case PrayerCalculationMethod.egyptian:
      return 'Egyptian';
    case PrayerCalculationMethod.isna:
      return 'ISNA';
    case PrayerCalculationMethod.karachi:
      return 'Karachi';
    case PrayerCalculationMethod.ummAlQura:
      return 'Umm al-Qura';
  }
}
