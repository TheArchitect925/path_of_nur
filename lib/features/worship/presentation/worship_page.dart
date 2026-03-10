import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/application/special_mode_provider.dart';
import 'worship_page_legacy.dart';
import '../application/worship_tab_provider.dart';
import 'widgets/dhikr_section.dart';
import 'widgets/fasting_section.dart';
import 'widgets/khusu_section.dart';
import 'widgets/prayer_section.dart';
import 'widgets/worship_segmented_control.dart';

const bool _useLegacyWorshipPage = false;

class WorshipPage extends ConsumerWidget {
  const WorshipPage({super.key});

  Widget _buildSection(WorshipTab tab) {
    switch (tab) {
      case WorshipTab.prayer:
        return const PrayerSection(key: ValueKey('worship-prayer'));
      case WorshipTab.dhikr:
        return const DhikrSection(key: ValueKey('worship-dhikr'));
      case WorshipTab.fasting:
        return const FastingSection(key: ValueKey('worship-fasting'));
      case WorshipTab.khusu:
        return const KhusuSection(key: ValueKey('worship-khusu'));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_useLegacyWorshipPage) {
      return const WorshipPageLegacy();
    }

    final l10n = AppLocalizations.of(context);
    final WorshipTab activeTab = ref.watch(worshipTabProvider);
    final mode = ref.watch(specialModeProvider);

    return AppPageScaffold(
      headerIcon: Icons.self_improvement_rounded,
      title: l10n.worshipTitle,
      subtitle: l10n.worshipSubtitle,
      quote: const QuranQuote(
        arabic: 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
        transliteration: 'Wastaeenoo bis-sabri was-salah',
        translation: 'Seek help through patience and prayer.',
        surah: 2,
        verse: 45,
        locationLabel: 'Qur’an 2:45',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        if (mode.isKids)
          PremiumCard(
            child: Text(
              l10n.kidsWorshipHint,
              style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
            ),
          ),
        if (mode.isKids) const SizedBox(height: 12),
        const _WorshipModeCard(),
        const SizedBox(height: 12),
        WorshipSegmentedControl(
          selected: activeTab,
          onChanged: (WorshipTab tab) =>
              ref.read(worshipTabProvider.notifier).state = tab,
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Padding(
            key: ValueKey(activeTab),
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSection(activeTab),
          ),
        ),
      ],
    );
  }
}

class _WorshipModeCard extends ConsumerWidget {
  const _WorshipModeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(specialModeProvider);
    if (!mode.isRamadan && !mode.isLoss && !mode.isGentle) {
      return const SizedBox.shrink();
    }

    if (mode.isRamadan) {
      return PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.modeRamadanWorshipTitle,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.modeRamadanWorshipSubtitle,
              style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  label: Text(l10n.modeRamadanActionFasting),
                  onPressed: () => ref.read(worshipTabProvider.notifier).state =
                      WorshipTab.fasting,
                ),
                ActionChip(
                  label: Text(l10n.modeRamadanWorshipTaraweeh),
                  onPressed: () {},
                ),
                ActionChip(
                  label: Text(l10n.modeRamadanWorshipQiyam),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (mode.isLoss) {
      return PremiumCard(
        child: Text(
          l10n.modeLossWorshipSubtitle,
          style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
        ),
      );
    }

    return PremiumCard(
      child: Text(
        l10n.modeGentleWorshipSubtitle,
        style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
      ),
    );
  }
}
