import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_hadith_provider.dart';
import '../domain/hadith_foundation_models.dart';
import '../../../../core/theme/app_icons.dart';

class KidsHadithPage extends ConsumerWidget {
  const KidsHadithPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(kidsHadithEntriesProvider);

    return LearnHubPageScaffold(
      showDefaultQuote: false,
      headerIcon: AppIcons.hadith,
      title: l10n.kidsHadithPageTitleText,
      subtitle: l10n.kidsHadithPageSubtitleText,
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.island,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsHadithIntroTitleText,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(l10n.kidsHadithIntroSubtitleText),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Row(
            children: [
              const Icon(Icons.auto_stories_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.kidsHadithStoriesCardTitleText,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.kidsHadithStoriesCardSubtitleText),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('learnKidsHadithStories'),
                child: Text(l10n.kidsHadithStoriesOpenActionText),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _KidsHadithCard(entry: entry),
          ),
        ),
      ],
    );
  }
}

class _KidsHadithCard extends StatelessWidget {
  const _KidsHadithCard({required this.entry});

  final HadithEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (entry.hasArabicMatn) ...[
            Text(
              entry.arabicMatn!,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(height: 1.7),
            ),
            const SizedBox(height: 10),
          ],
          Text(entry.hadithText),
          const SizedBox(height: 10),
          Text(entry.sourceLabel, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          Text(
            l10n.kidsHadithMeaningTitleText,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(entry.meaning),
          if (entry.lessons.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.kidsHadithLessonTitleText,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(entry.lessons.first),
          ],
        ],
      ),
    );
  }
}
