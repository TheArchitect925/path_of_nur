import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../data/important_hadith_data.dart';

class ImportantHadithDetailPage extends StatelessWidget {
  const ImportantHadithDetailPage({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = importantHadithByNumber(number);
    if (entry == null) {
      return AppPageScaffold(
        headerIcon: Icons.menu_book_rounded,
        title: l10n.learnHadithSectionTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final previous = importantHadithByNumber(number - 1);
    final next = importantHadithByNumber(number + 1);

    return AppPageScaffold(
      headerIcon: Icons.auto_stories_rounded,
      title: 'Hadith ${entry.number}',
      subtitle: entry.title,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.collectionTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (entry.arabicTitle != null && entry.arabicTitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    entry.arabicTitle!,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.learnContentOverviewTitle,
          body: entry.summary,
        ),
        _SectionCard(
          title: l10n.learnContentReflectionPromptTitle,
          body: entry.practicalReflection,
        ),
        _SectionCard(
          title: l10n.learnContentThemesTitle,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: entry.themes
                .map((tag) => Chip(label: Text(tag)))
                .toList(growable: false),
          ),
        ),
        _SectionCard(title: 'Source', body: entry.source),
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: previous == null
                      ? null
                      : () => context.pushReplacementNamed(
                          'hadithImportantDetail',
                          pathParameters: {
                            'number': previous.number.toString(),
                          },
                        ),
                  child: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: next == null
                      ? null
                      : () => context.pushReplacementNamed(
                          'hadithImportantDetail',
                          pathParameters: {'number': next.number.toString()},
                        ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.lifeAddReflectionTitle),
            subtitle: Text(l10n.lifeAddReflectionSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed('journalCreate'),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, this.body, this.child});

  final String title;
  final String? body;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (body != null) Text(body!),
            child ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
