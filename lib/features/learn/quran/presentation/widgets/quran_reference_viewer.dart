import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../application/quran_ayah_enrichment_provider.dart';
import '../../domain/quran_ayah_enrichment_models.dart';
import '../../domain/quran_content_refs.dart';
import '../../application/quran_reference_graph_provider.dart';
import 'ayah_insights_section.dart';

Future<void> showQuranReferenceViewer(
  BuildContext context,
  WidgetRef ref, {
  required String referenceId,
}) {
  final reference = ref.read(quranReferenceByIdProvider(referenceId));
  if (reference == null) return Future<void>.value();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _QuranReferenceViewer(referenceId: referenceId),
  );
}

class QuranReferenceChip extends ConsumerWidget {
  const QuranReferenceChip({
    super.key,
    required this.referenceId,
    this.leading,
  });

  final String referenceId;
  final Widget? leading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reference = ref.watch(quranReferenceByIdProvider(referenceId));
    if (reference == null) return const SizedBox.shrink();
    return GestureDetector(
      onLongPress: () =>
          showQuranReferenceViewer(context, ref, referenceId: referenceId),
      child: ActionChip(
        avatar: leading,
        label: Text(
          l10n.quranReferenceViewerReferenceLabel(reference.referenceLabel),
        ),
        onPressed: () => openQuranAt(
          context,
          surahNumber: reference.surahNumber,
          ayahNumber: reference.ayahStart,
          endAyahNumber: reference.ayahEnd,
        ),
      ),
    );
  }
}

class _QuranReferenceViewer extends ConsumerWidget {
  const _QuranReferenceViewer({required this.referenceId});

  final String referenceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reference = ref.watch(quranReferenceByIdProvider(referenceId));
    final bundle = ref.watch(
      quranReferenceKnowledgeBundleProvider(referenceId),
    );
    final enrichmentEntries = reference == null
        ? const <QuranAyahEnrichmentEntry>[]
        : ref.watch(
            quranAyahEnrichmentForRangeProvider(
              QuranQuoteRef(
                surah: reference.surahNumber,
                ayah: reference.ayahStart,
                ayahEnd: reference.ayahEnd,
              ),
            ),
          );

    if (reference == null) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.quranReferenceViewerNotFound),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quranReferenceViewerReferenceLabel(reference.referenceLabel),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text('${reference.surahName} • ${reference.surahNumber}'),
            const SizedBox(height: 10),
            Text(reference.contextSummary),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: reference.topicTags
                  .map(
                    (tag) => Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(tag),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.of(context).pop();
                openQuranAt(
                  context,
                  surahNumber: reference.surahNumber,
                  ayahNumber: reference.ayahStart,
                  endAyahNumber: reference.ayahEnd,
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l10n.quranReferenceViewerOpenInReader),
            ),
            if (bundle.displayItems.isNotEmpty) ...[
              const SizedBox(height: 14),
              AyahInsightsSection(
                title: l10n.quranLearnMoreInsightsTitle,
                entries: enrichmentEntries,
                items: bundle.displayItems,
                onOpenItem: (item) {
                  Navigator.of(context).pop();
                  if (item.sourceRouteName != null) {
                    context.pushNamed(
                      item.sourceRouteName!,
                      pathParameters: item.pathParameters,
                      queryParameters: item.queryParameters,
                    );
                    return;
                  }
                  if (item.relatedRef != null) {
                    openQuranReferenceLocation(context, ref: item.relatedRef!);
                  }
                },
              ),
            ],
            if (bundle.lifeLessons.isNotEmpty) ...[
              const SizedBox(height: 14),
              _section(
                context,
                title: l10n.quranReferenceViewerRelatedLifeLessons,
                items: bundle.lifeLessons,
              ),
            ],
            if (bundle.hadithEntries.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section(
                context,
                title: l10n.quranReferenceViewerRelatedHadith,
                items: bundle.hadithEntries,
              ),
            ],
            if (bundle.prophets.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section(
                context,
                title: l10n.quranReferenceViewerRelatedProphets,
                items: bundle.prophets,
              ),
            ],
            if (bundle.journeys.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section(
                context,
                title: l10n.quranReferenceViewerRelatedJourneys,
                items: bundle.journeys,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required List<QuranRelatedKnowledgeLink> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        ...items
            .take(5)
            .map(
              (item) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(item.title),
                subtitle: Text(item.subtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    item.routeName,
                    pathParameters: item.pathParameters,
                    queryParameters: item.queryParameters,
                  );
                },
              ),
            ),
      ],
    );
  }
}
