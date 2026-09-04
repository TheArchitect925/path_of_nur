import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/hadith_narrator_repository.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_narrator_models.dart';
import 'hadith_reader_continuity.dart';
import 'widgets/hadith_browse_helpers.dart';

class HadithNarratorPage extends ConsumerWidget {
  const HadithNarratorPage({super.key, required this.narratorId});

  final String narratorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(hadithNarratorDetailProvider(narratorId));
    if (detail == null) {
      return AppPageScaffold(
        title: l10n.hadithPageTitle,
        children: [PremiumCard(child: Text(l10n.hadithNarratorNotFoundBody))],
      );
    }

    final laneContext = HadithReaderLaneContext(
      kind: HadithReaderLaneKind.narrator,
      laneId: detail.id,
      laneTitle: detail.displayName,
      orderedLessonIds: detail.entries
          .map((entry) => entry.id)
          .toList(growable: false),
      returnRouteName: 'hadithNarratorDetail',
      returnPathParameters: {'narratorId': detail.id},
    );

    return AppPageScaffold(
      title: detail.displayName,
      bodySlivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.hadithNarratorHadithSectionTitle(detail.hadithCount),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverList.builder(
            itemCount: detail.entries.length,
            itemBuilder: (context, index) {
              final entry = detail.entries[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == detail.entries.length - 1 ? 0 : 10,
                ),
                child: _HadithNarratorEntryCard(
                  entry: entry,
                  onTap: () => pushHadithLessonDetail(
                    context,
                    lessonId: entry.id,
                    laneContext: laneContext,
                  ),
                ),
              );
            },
          ),
        ),
      ],
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (detail.profile != null) ...[
                Text(
                  _roleLabel(l10n, detail.profile!.role),
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(_summaryText(l10n, detail.profile!.summaryKind)),
              ] else
                Text(l10n.hadithNarratorFallbackSummary),
              if (detail.aliases.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  l10n.hadithNarratorAliasesTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: detail.aliases
                      .map(
                        (alias) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.68),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(alias),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ],
          ),
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hadithNarratorInLibraryTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _NarratorStatChip(
                    value: detail.hadithCount.toString(),
                    label: l10n.hadithNarratorStatHadith,
                  ),
                  _NarratorStatChip(
                    value: detail.sourceCount.toString(),
                    label: l10n.hadithNarratorStatSources,
                  ),
                  _NarratorStatChip(
                    value: detail.themeCount.toString(),
                    label: l10n.hadithNarratorStatThemes,
                  ),
                  _NarratorStatChip(
                    value: detail.collectionCount.toString(),
                    label: l10n.hadithNarratorStatCollections,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _roleLabel(AppLocalizations l10n, HadithNarratorRole role) {
    return switch (role) {
      HadithNarratorRole.companion => l10n.hadithNarratorRoleCompanion,
      HadithNarratorRole.motherOfBelievers =>
        l10n.hadithNarratorRoleMotherOfBelievers,
      HadithNarratorRole.scholarCompanion =>
        l10n.hadithNarratorRoleScholarCompanion,
    };
  }

  String _summaryText(
    AppLocalizations l10n,
    HadithNarratorSummaryKind summaryKind,
  ) {
    return switch (summaryKind) {
      HadithNarratorSummaryKind.abuHurairah =>
        l10n.hadithNarratorSummaryAbuHurairah,
      HadithNarratorSummaryKind.aishah => l10n.hadithNarratorSummaryAishah,
      HadithNarratorSummaryKind.abdullahIbnUmar =>
        l10n.hadithNarratorSummaryAbdullahIbnUmar,
      HadithNarratorSummaryKind.anasIbnMalik =>
        l10n.hadithNarratorSummaryAnasIbnMalik,
      HadithNarratorSummaryKind.jabirIbnAbdullah =>
        l10n.hadithNarratorSummaryJabirIbnAbdullah,
      HadithNarratorSummaryKind.abdullahIbnAbbas =>
        l10n.hadithNarratorSummaryAbdullahIbnAbbas,
    };
  }
}

class _NarratorStatChip extends StatelessWidget {
  const _NarratorStatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _HadithNarratorEntryCard extends StatelessWidget {
  const _HadithNarratorEntryCard({required this.entry, required this.onTap});

  final HadithEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final preview = hadithCardPreviewText(entry);

    return PremiumCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(preview, maxLines: 4, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 10),
              Text(
                [
                  entry.displaySourceCollectionTitle,
                  if ((entry.displaySourceReference ?? '').trim().isNotEmpty)
                    entry.displaySourceReference!.trim(),
                ].join(' • '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
