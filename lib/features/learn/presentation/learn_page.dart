import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        const SectionTitle(
          title: 'Knowledge Pillars',
          subtitle: 'Core learning channels ready for future content.',
        ),
        ..._contentEntries(context).map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: PremiumCard(
              child: InkWell(
                onTap: () => context.pushNamed(
                  'featureSection',
                  pathParameters: {'sectionId': entry.routeId},
                ),
                child: _learningSectionTile(entry.title, entry.subtitle),
              ),
            ),
          ),
        ),
        const SectionTitle(
          title: 'Continue Learning',
          subtitle: 'Where you left off.',
        ),
        PremiumCard(
          child: InkWell(
            onTap: () => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': 'continueLearning'},
            ),
            child: ListTile(
              leading: const Icon(
                Icons.local_library,
                color: AppColors.accentGold,
              ),
              title: const Text('Life Through the Qur\'aan'),
              subtitle: const Text('Surahs 1–5 reflection set'),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceSubtle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<_LearnEntry> _contentEntries(BuildContext context) {
    return const [
      _LearnEntry(
        title: 'Qur’an',
        routeId: 'quran',
        subtitle: 'Read, revisit, and annotate selected passages.',
      ),
      _LearnEntry(
        title: 'Life Through the Qur’an',
        routeId: 'lifeThroughQuran',
        subtitle: 'Practical lessons and daily takeaways.',
      ),
      _LearnEntry(
        title: 'World Through the Qur’an',
        routeId: 'worldThroughQuran',
        subtitle: 'Contextual reflections for modern moments.',
      ),
      _LearnEntry(
        title: 'Hadith Lessons',
        routeId: 'hadithLessons',
        subtitle: 'Companion teachings with gentle prompts.',
      ),
      _LearnEntry(
        title: 'Reflections / Notes',
        routeId: 'reflections',
        subtitle: 'Capture journaling thoughts and insights.',
      ),
    ];
  }

  Widget _learningSectionTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _LearnEntry {
  const _LearnEntry({required this.title, required this.routeId, required this.subtitle});
  final String title;
  final String routeId;
  final String subtitle;
}
