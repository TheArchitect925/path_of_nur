import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/learn_tab_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';
import 'widgets/learn_segmented_control.dart';
import 'widgets/learn_tab_content.dart';

class LearnPage extends ConsumerWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activeTab = ref.watch(learnTabProvider);
    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.learnTitle,
      subtitle: l10n.learnSubtitle,
      quote: const QuranQuote(
        arabic: 'وَاقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
        transliteration: 'Waqra bi-ismi rabbika alladhi khalaq',
        translation: 'Read in the name of your Lord who created everything.',
        surah: 96,
        verse: 1,
        locationLabel: 'Qur’an 96:1',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        LearnSegmentedControl(
          selected: activeTab,
          onChanged: (tab) => ref.read(learnTabProvider.notifier).state = tab,
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
            child: LearnTabContent(tab: activeTab),
          ),
        ),
      ],
    );
  }
}
