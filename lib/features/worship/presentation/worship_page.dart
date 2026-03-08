import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
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
        WorshipSegmentedControl(
          selected: activeTab,
          onChanged: (WorshipTab tab) =>
              ref.read(worshipTabProvider.notifier).state = tab,
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
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
