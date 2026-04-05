import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../application/quran_ayah_enrichment_provider.dart';
import '../../domain/quran_ayah_enrichment_models.dart';
import '../../domain/quran_content_refs.dart';
import '../../domain/quran_reference_models.dart';
import '../../application/quran_reference_graph_provider.dart';
import 'ayah_insights_section.dart';
import 'quran_related_reference_detail_sheet.dart';

Future<void> showQuranReferenceViewer(
  BuildContext context,
  WidgetRef ref, {
  required String referenceId,
  String? anchorLabel,
  String? relationReason,
}) {
  final reference = ref.read(quranReferenceByIdProvider(referenceId));
  if (reference == null) return Future<void>.value();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _QuranReferenceViewer(
      referenceId: referenceId,
      anchorLabel: anchorLabel,
      relationReason: relationReason,
    ),
  );
}

class QuranReferenceChip extends ConsumerWidget {
  const QuranReferenceChip({
    super.key,
    required this.referenceId,
    this.leading,
    this.anchorLabel,
    this.relationReason,
  });

  final String referenceId;
  final Widget? leading;
  final String? anchorLabel;
  final String? relationReason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reference = ref.watch(quranReferenceByIdProvider(referenceId));
    if (reference == null) return const SizedBox.shrink();
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => showQuranReferenceViewer(
        context,
        ref,
        referenceId: referenceId,
        anchorLabel: anchorLabel,
        relationReason: relationReason,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: style.decoration(radius: 999, includeShadow: false),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 6)],
            Text(
              l10n.quranReferenceViewerReferenceLabel(reference.referenceLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuranReferenceViewer extends ConsumerWidget {
  const _QuranReferenceViewer({
    required this.referenceId,
    this.anchorLabel,
    this.relationReason,
  });

  final String referenceId;
  final String? anchorLabel;
  final String? relationReason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final reference = ref.watch(quranReferenceByIdProvider(referenceId));
    final bundle = ref.watch(
      quranReferenceKnowledgeBundleProvider(referenceId),
    );
    final enrichmentEntries = reference == null
        ? const <QuranAyahEnrichmentEntry>[]
        : ref.watch(
            quranAyahEnrichmentForRangeLocalizedProvider((
              QuranQuoteRef(
                surah: reference.surahNumber,
                ayah: reference.ayahStart,
                ayahEnd: reference.ayahEnd,
              ),
              languageCode,
            )),
          );
    final localizedDisplayItems = reference == null
        ? const <QuranAyahDisplayItem>[]
        : ref.watch(
            quranAyahDisplayItemsForRangeLocalizedProvider((
              QuranQuoteRef(
                surah: reference.surahNumber,
                ayah: reference.ayahStart,
                ayahEnd: reference.ayahEnd,
              ),
              languageCode,
            )),
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
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ReferenceViewerChip(
                  label: quranKnowledgeTypeLabel(
                    l10n,
                    QuranKnowledgeType.quranDirect,
                  ),
                ),
                _ReferenceViewerChip(
                  label: quranConnectionStrengthLabel(
                    l10n,
                    QuranConnectionStrength.direct,
                  ),
                ),
                if (anchorLabel?.trim().isNotEmpty ?? false)
                  _ReferenceViewerChip(
                    label: l10n.quranReferenceDetailCurrentAnchorChip(
                      anchorLabel!,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${reference.surahName} • ${reference.surahNumber}'),
            const SizedBox(height: 12),
            Text(
              l10n.quranReferenceDetailWhyRelatedTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              relationReason?.trim().isNotEmpty ?? false
                  ? relationReason!
                  : anchorLabel?.trim().isNotEmpty ?? false
                  ? l10n.quranReferenceDetailReasonQuranReferenceLinked
                  : reference.contextSummary,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: reference.topicTags
                  .map((tag) => _ReferenceViewerChip(label: tag))
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
            if (localizedDisplayItems.isNotEmpty) ...[
              const SizedBox(height: 14),
              AyahInsightsSection(
                title: l10n.quranLearnMoreInsightsTitle,
                entries: enrichmentEntries,
                items: localizedDisplayItems,
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
                anchorLabel: l10n.quranReferenceViewerReferenceLabel(
                  reference.referenceLabel,
                ),
              ),
            ],
            if (bundle.hadithEntries.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section(
                context,
                title: l10n.quranReferenceViewerRelatedHadith,
                items: bundle.hadithEntries,
                anchorLabel: l10n.quranReferenceViewerReferenceLabel(
                  reference.referenceLabel,
                ),
              ),
            ],
            if (bundle.prophets.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section(
                context,
                title: l10n.quranReferenceViewerRelatedProphets,
                items: bundle.prophets,
                anchorLabel: l10n.quranReferenceViewerReferenceLabel(
                  reference.referenceLabel,
                ),
              ),
            ],
            if (bundle.journeys.isNotEmpty) ...[
              const SizedBox(height: 10),
              _section(
                context,
                title: l10n.quranReferenceViewerRelatedJourneys,
                items: bundle.journeys,
                anchorLabel: l10n.quranReferenceViewerReferenceLabel(
                  reference.referenceLabel,
                ),
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
    required String anchorLabel,
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
                onTap: () => showQuranRelatedKnowledgeDetailSheet(
                  context,
                  link: item,
                  anchorLabel: anchorLabel,
                ),
              ),
            ),
      ],
    );
  }
}

class _ReferenceViewerChip extends StatelessWidget {
  const _ReferenceViewerChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(label),
    );
  }
}
