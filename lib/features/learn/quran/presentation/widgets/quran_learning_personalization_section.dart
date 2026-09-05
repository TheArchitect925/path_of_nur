import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../application/quran_learning_personalization_provider.dart';
import '../../domain/quran_ayah_enrichment_models.dart';

class QuranLearningPersonalizationSection extends ConsumerWidget {
  const QuranLearningPersonalizationSection({
    super.key,
    this.wrapInCard = true,
  });

  final bool wrapInCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(quranLearningPersonalizationSummaryProvider);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quranLearningContinueTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (summary.hasSignals) ...[
          FilledButton.tonalIcon(
            onPressed: () => openQuranAt(
              context,
              surahNumber: summary.continueAyah.surahNumber,
              ayahNumber: summary.continueAyah.ayahNumber,
            ),
            icon: const Icon(Icons.play_circle_outline_rounded),
            label: Text(l10n.quranLearningContinueLastAyahAction),
          ),
          const SizedBox(height: 6),
          Text(
            summary.continueAyah.locationLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ] else
          Text(
            l10n.quranLearningContinueEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (summary.hasSignals &&
            (summary.continuePath != null ||
                summary.continueDomain != null)) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (summary.continuePath != null)
                ActionChip(
                  avatar: const Icon(Icons.route_rounded, size: 18),
                  label: Text(l10n.quranLearningResumePathAction),
                  onPressed: () => context.pushNamed(
                    'quranAyahInsightsPathDetail',
                    pathParameters: {'pathId': summary.continuePath!.path.id},
                  ),
                ),
              if (summary.continueDomain != null)
                ActionChip(
                  avatar: const Icon(Icons.auto_awesome_rounded, size: 18),
                  label: Text(l10n.quranLearningReturnToDomainAction),
                  onPressed: () => context.pushNamed(
                    'quranAyahInsightsDomain',
                    pathParameters: {'domainId': summary.continueDomain!.id},
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        Text(
          l10n.quranLearningSuggestedTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (summary.hasSignals) ...[
          if (summary.nextPathEntry != null)
            _SuggestionTile(
              icon: Icons.skip_next_rounded,
              title: l10n.quranLearningNextInPathTitle,
              subtitle:
                  '${summary.nextPathEntry!.ref.locationLabel} • ${summary.nextPathEntry!.title}',
              onTap: () {
                ref
                    .read(quranLearningPersonalizationStateProvider.notifier)
                    .markPathOpened(
                      pathId: summary.continuePath!.path.id,
                      entryId: summary.nextPathEntry!.id,
                    );
                openQuranReferenceLocation(
                  context,
                  ref: summary.nextPathEntry!.ref,
                );
              },
            ),
          if (summary.suggestedDomain != null)
            _SuggestionTile(
              icon: Icons.explore_rounded,
              title: l10n.quranLearningMoreInDomainTitle,
              subtitle: _categoryTitle(l10n, summary.suggestedDomain!.id),
              onTap: () {
                ref
                    .read(quranLearningPersonalizationStateProvider.notifier)
                    .markDomainOpened(summary.suggestedDomain!.id);
                context.pushNamed(
                  'quranAyahInsightsDomain',
                  pathParameters: {'domainId': summary.suggestedDomain!.id},
                );
              },
            ),
          if (summary.suggestedTag != null)
            _SuggestionTile(
              icon: Icons.search_rounded,
              title: l10n.quranLearningExploreThemeTitle,
              subtitle: _tagLabel(l10n, summary.suggestedTag!),
              onTap: () => context.pushNamed(
                'quranKnowledgeSearch',
                queryParameters: {'q': _tagLabel(l10n, summary.suggestedTag!)},
              ),
            ),
        ] else ...[
          Text(
            l10n.quranLearningSuggestedEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('quranAyahInsightsPaths'),
                icon: const Icon(Icons.route_rounded),
                label: Text(l10n.quranLearningStartPathAction),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('quranAyahInsightsBrowse'),
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(l10n.quranAyahInsightsBrowseAction),
              ),
            ],
          ),
        ],
      ],
    );

    if (!wrapInCard) {
      return content;
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [content],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}

String _categoryTitle(AppLocalizations l10n, String categoryId) {
  switch (categoryId) {
    case 'signs-in-creation':
      return l10n.quranAyahInsightsDomainSignsInCreation;
    case 'worship-remembrance':
      return l10n.quranAyahInsightsDomainWorshipRemembrance;
    case 'character-adab':
      return l10n.quranAyahInsightsDomainCharacterAdab;
    case 'tawhid-belief':
      return l10n.quranAyahInsightsDomainTawhidBelief;
    case 'akhirah-accountability':
      return l10n.quranAyahInsightsDomainAkhirahAccountability;
    case 'prophets-lessons':
      return l10n.quranAyahInsightsDomainProphetsLessons;
    case 'guidance-daily-life':
      return l10n.quranAyahInsightsDomainGuidanceDailyLife;
    default:
      return l10n.quranAyahInsightsBrowseTitle;
  }
}

String _tagLabel(AppLocalizations l10n, QuranAyahEnrichmentTag tag) {
  switch (tag) {
    case QuranAyahEnrichmentTag.sabr:
      return l10n.quranAyahInsightsBrowseTagSabr;
    case QuranAyahEnrichmentTag.shukr:
      return l10n.quranAyahInsightsBrowseTagShukr;
    case QuranAyahEnrichmentTag.tawakkul:
      return l10n.quranAyahInsightsBrowseTagTawakkul;
    case QuranAyahEnrichmentTag.mercy:
      return l10n.quranAyahInsightsBrowseTagMercy;
    case QuranAyahEnrichmentTag.repentance:
      return l10n.quranAyahInsightsBrowseTagRepentance;
    case QuranAyahEnrichmentTag.justice:
      return l10n.quranAyahInsightsBrowseTagJustice;
    case QuranAyahEnrichmentTag.sincerity:
      return l10n.quranAyahInsightsBrowseTagSincerity;
    case QuranAyahEnrichmentTag.guidance:
      return l10n.quranAyahInsightsBrowseTagGuidance;
    case QuranAyahEnrichmentTag.signs:
      return l10n.quranAyahInsightsBrowseTagSigns;
    case QuranAyahEnrichmentTag.creation:
      return l10n.quranAyahInsightsBrowseTagCreation;
    case QuranAyahEnrichmentTag.prophets:
      return l10n.quranAyahInsightsBrowseTagProphets;
    case QuranAyahEnrichmentTag.worship:
      return l10n.quranAyahInsightsBrowseTagWorship;
  }
}
