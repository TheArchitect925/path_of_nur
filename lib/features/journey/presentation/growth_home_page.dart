import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'growth_habits_page.dart';
import 'growth_journey_page.dart';
import 'growth_paths_page.dart';
import 'growth_reflection_page.dart';
import 'growth_today_page.dart';
import 'widgets/growth_segmented_control.dart';

class GrowthHomePage extends ConsumerWidget {
  const GrowthHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tab = ref.watch(growthInternalTabProvider);
    final growthVisual = ref.watch(growthGardenProgressProvider);
    final nextUnlock = ref.watch(growthNextUnlockPreviewProvider);
    final unlocked = ref.watch(growthUnlockedRewardsProvider);
    final trackedHabits = ref.watch(
      growthAllHabitsProvider.select(
        (habits) => habits
            .where(
              (habit) =>
                  habit.active &&
                  habit.showInToday &&
                  !habit.hidden &&
                  !habit.archived,
            )
            .length,
      ),
    );
    final privateMode = ref.watch(growthControllerProvider).privateMode;
    ref.watch(growthControllerProvider);
    ref.read(growthControllerProvider.notifier).refreshDailySchedules();

    return AppPageScaffold(
      headerIcon: IslamicIcons.tasbih,
      title: l10n.journeyTitle,
      subtitle:
          'Build consistent righteous habits through guided paths, reflection, and gentle progress.',
      quote: const QuranQuote(
        arabic: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
        transliteration: 'Wa qul rabbi zidni ilma',
        translation: 'My Lord, increase me in knowledge.',
        surah: 20,
        verse: 114,
        locationLabel: 'Qur’an 20:114',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EEE3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                privateMode ? 'Progress Continuing' : 'Growth in Motion',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '${growthVisual.currentStageLabel} · ${growthVisual.stageSubtitle}',
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: growthVisual.stageProgress),
              ),
              const SizedBox(height: 8),
              Text(
                nextUnlock == null
                    ? 'All seeded unlocks are present. Keep walking the path.'
                    : 'Next unlock: ${nextUnlock.title}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6A5A4A),
                ),
              ),
              Text(
                privateMode
                    ? '${unlocked.length} symbolic gifts present'
                    : '${unlocked.length} calm gifts present',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6A5A4A),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => context.pushNamed('growthHabitsDeepLink'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1E8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE0C9A6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D7B9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.checklist_rtl_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Habit Tracker',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trackedHabits == 0
                            ? 'No habits selected yet. Start with a small pack.'
                            : '$trackedHabits habit${trackedHabits == 1 ? '' : 's'} selected for tracking.',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6A5A4A),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
        GrowthSegmentedControl(
          selected: tab,
          onChanged: (next) =>
              ref.read(growthInternalTabProvider.notifier).state = next,
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 230),
          child: Padding(
            key: ValueKey(tab),
            padding: const EdgeInsets.only(bottom: 16),
            child: switch (tab) {
              GrowthInternalTab.today => const GrowthTodayPage(),
              GrowthInternalTab.paths => const GrowthPathsPage(),
              GrowthInternalTab.habits => const GrowthHabitsPage(),
              GrowthInternalTab.journey => const GrowthJourneyPage(),
              GrowthInternalTab.reflection => const GrowthReflectionPage(),
            },
          ),
        ),
      ],
    );
  }
}
