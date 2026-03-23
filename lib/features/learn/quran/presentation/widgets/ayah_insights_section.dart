import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../application/quran_learning_share_service.dart';
import '../../application/quran_reflections_provider.dart';
import '../../application/quran_learning_progression_provider.dart';
import '../../domain/quran_ayah_enrichment_models.dart';
import '../../domain/quran_content_refs.dart';
import '../../domain/quran_reflection_entry.dart';
import 'quran_reflection_note_dialog.dart';

class AyahInsightsSection extends StatelessWidget {
  const AyahInsightsSection({
    super.key,
    required this.title,
    required this.entries,
    required this.items,
    this.maxItemsPerSection = 3,
    this.onOpenItem,
  });

  final String title;
  final List<QuranAyahEnrichmentEntry> entries;
  final List<QuranAyahDisplayItem> items;
  final int maxItemsPerSection;
  final ValueChanged<QuranAyahDisplayItem>? onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groupedSections = _buildSections();
    final relatedAyahs = items
        .where((item) => item.type == QuranAyahDisplayItemType.relatedAyah)
        .take(3)
        .toList(growable: false);
    if (groupedSections.isEmpty && relatedAyahs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...groupedSections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AyahInsightsDomainGroup(
              title: _domainTitle(l10n, section.domain),
              items: section.items
                  .take(maxItemsPerSection)
                  .toList(growable: false),
              onOpenItem: onOpenItem,
            ),
          ),
        ),
        if (relatedAyahs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AyahInsightsRelatedAyahsGroup(
              title: l10n.quranAyahInsightsRelatedAyahsTitle,
              items: relatedAyahs,
              onOpenItem: onOpenItem,
            ),
          ),
      ],
    );
  }

  List<_AyahInsightsDomainSection> _buildSections() {
    final entryById = <String, QuranAyahEnrichmentEntry>{
      for (final entry in entries) entry.id: entry,
    };
    final grouped = <QuranAyahEnrichmentDomain, List<_AyahInsightsBoundItem>>{};

    for (final item in items) {
      if (item.type == QuranAyahDisplayItemType.relatedAyah) continue;
      final entryId = item.sourceEnrichmentId;
      final entry = entryId == null ? null : entryById[entryId];
      if (entry == null) continue;
      grouped
          .putIfAbsent(entry.domain, () => <_AyahInsightsBoundItem>[])
          .add(_AyahInsightsBoundItem(entry: entry, item: item));
    }

    const orderedDomains = <QuranAyahEnrichmentDomain>[
      QuranAyahEnrichmentDomain.signsInCreation,
      QuranAyahEnrichmentDomain.worldNature,
      QuranAyahEnrichmentDomain.worshipRemembrance,
      QuranAyahEnrichmentDomain.characterAdab,
      QuranAyahEnrichmentDomain.tawhidBelief,
      QuranAyahEnrichmentDomain.akhirahAccountability,
      QuranAyahEnrichmentDomain.prophetsLessons,
      QuranAyahEnrichmentDomain.guidanceDailyLife,
    ];

    final sections = <_AyahInsightsDomainSection>[];
    for (final domain in orderedDomains) {
      final domainItems = grouped[domain];
      if (domainItems == null || domainItems.isEmpty) continue;
      sections.add(
        _AyahInsightsDomainSection(domain: domain, items: domainItems),
      );
    }
    return sections;
  }

  String _domainTitle(AppLocalizations l10n, QuranAyahEnrichmentDomain domain) {
    return switch (domain) {
      QuranAyahEnrichmentDomain.signsInCreation ||
      QuranAyahEnrichmentDomain.worldNature =>
        l10n.quranAyahInsightsDomainSignsInCreation,
      QuranAyahEnrichmentDomain.worshipRemembrance =>
        l10n.quranAyahInsightsDomainWorshipRemembrance,
      QuranAyahEnrichmentDomain.characterAdab =>
        l10n.quranAyahInsightsDomainCharacterAdab,
      QuranAyahEnrichmentDomain.tawhidBelief =>
        l10n.quranAyahInsightsDomainTawhidBelief,
      QuranAyahEnrichmentDomain.akhirahAccountability =>
        l10n.quranAyahInsightsDomainAkhirahAccountability,
      QuranAyahEnrichmentDomain.prophetsLessons =>
        l10n.quranAyahInsightsDomainProphetsLessons,
      QuranAyahEnrichmentDomain.guidanceDailyLife =>
        l10n.quranAyahInsightsDomainGuidanceDailyLife,
    };
  }
}

class _AyahInsightsRelatedAyahsGroup extends StatelessWidget {
  const _AyahInsightsRelatedAyahsGroup({
    required this.title,
    required this.items,
    this.onOpenItem,
  });

  final String title;
  final List<QuranAyahDisplayItem> items;
  final ValueChanged<QuranAyahDisplayItem>? onOpenItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => _AyahInsightsRelatedAyahTile(
                item: item,
                onOpenItem: onOpenItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahInsightsDomainGroup extends StatelessWidget {
  const _AyahInsightsDomainGroup({
    required this.title,
    required this.items,
    this.onOpenItem,
  });

  final String title;
  final List<_AyahInsightsBoundItem> items;
  final ValueChanged<QuranAyahDisplayItem>? onOpenItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) =>
                  _AyahInsightsItemTile(item: item, onOpenItem: onOpenItem),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahInsightsRelatedAyahTile extends ConsumerWidget {
  const _AyahInsightsRelatedAyahTile({required this.item, this.onOpenItem});

  final QuranAyahDisplayItem item;
  final ValueChanged<QuranAyahDisplayItem>? onOpenItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final relatedRef = item.relatedRef;
    if (relatedRef == null) return const SizedBox.shrink();
    final savedEntry = ref.watch(
      quranReflectionsProvider.select(
        (items) => _findSavedReflection(items, ref: relatedRef),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (onOpenItem != null) {
              onOpenItem!(item);
              return;
            }
            openQuranReferenceLocation(context, ref: relatedRef);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer.withValues(
                          alpha: 0.55,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          _relatedTypeLabel(l10n, item.relatedAyahType),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.quranReferenceViewerReferenceLabel(
                              relatedRef.locationLabel,
                            ),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (item.relatedReason?.trim().isNotEmpty ??
                              false) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.relatedReason!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        _ReflectionIconButton(
                          icon: savedEntry == null
                              ? Icons.bookmark_add_outlined
                              : Icons.bookmark_rounded,
                          tooltip: savedEntry == null
                              ? l10n.quranReflectionsSaveAction
                              : l10n.quranReflectionsSavedAction,
                          onPressed: () {
                            ref
                                .read(quranReflectionsProvider.notifier)
                                .toggleSaved(
                                  ref: relatedRef,
                                  sourceType:
                                      QuranReflectionSourceType.relatedAyah,
                                  title: l10n
                                      .quranReferenceViewerReferenceLabel(
                                        relatedRef.locationLabel,
                                      ),
                                  summary:
                                      item.relatedReason ??
                                      _relatedTypeLabel(
                                        l10n,
                                        item.relatedAyahType,
                                      ),
                                );
                          },
                        ),
                        _ReflectionIconButton(
                          icon: Icons.ios_share_rounded,
                          tooltip: l10n.quranLearningShareAction,
                          onPressed: () {
                            final text =
                                QuranLearningShareService.buildRelatedAyahShareText(
                                  ref: relatedRef,
                                  label: _relatedTypeLabel(
                                    l10n,
                                    item.relatedAyahType,
                                  ),
                                  attribution:
                                      l10n.quranLearningShareAttribution,
                                  reason: item.relatedReason,
                                );
                            QuranLearningShareService.shareText(text);
                          },
                        ),
                        _ReflectionIconButton(
                          icon: Icons.edit_note_rounded,
                          tooltip: savedEntry?.note?.trim().isNotEmpty ?? false
                              ? l10n.quranReflectionsEditNoteAction
                              : l10n.quranReflectionsAddNoteAction,
                          onPressed: () async {
                            final note = await showQuranReflectionNoteDialog(
                              context,
                              title:
                                  savedEntry?.note?.trim().isNotEmpty ?? false
                                  ? l10n.quranReflectionsEditNoteAction
                                  : l10n.quranReflectionsAddNoteAction,
                              initialNote: savedEntry?.note,
                            );
                            if (note == null) return;
                            ref
                                .read(quranReflectionsProvider.notifier)
                                .upsertNote(
                                  ref: relatedRef,
                                  sourceType:
                                      QuranReflectionSourceType.relatedAyah,
                                  title: l10n
                                      .quranReferenceViewerReferenceLabel(
                                        relatedRef.locationLabel,
                                      ),
                                  summary:
                                      item.relatedReason ??
                                      _relatedTypeLabel(
                                        l10n,
                                        item.relatedAyahType,
                                      ),
                                  note: note,
                                );
                            if (note.trim().isNotEmpty) {
                              ref
                                  .read(
                                    quranLearningProgressStateProvider.notifier,
                                  )
                                  .rewardFirstReflectionNote(
                                    ref: relatedRef,
                                    sourceSurface: 'related_ayah',
                                  );
                            }
                          },
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _relatedTypeLabel(
    AppLocalizations l10n,
    QuranRelatedAyahLinkType? type,
  ) {
    return switch (type) {
      QuranRelatedAyahLinkType.sameTheme =>
        l10n.quranAyahInsightsRelatedTypeSameTheme,
      QuranRelatedAyahLinkType.supportingInsight =>
        l10n.quranAyahInsightsRelatedTypeSupportingInsight,
      QuranRelatedAyahLinkType.continuation =>
        l10n.quranAyahInsightsRelatedTypeContinuation,
      QuranRelatedAyahLinkType.contrast =>
        l10n.quranAyahInsightsRelatedTypeContrast,
      QuranRelatedAyahLinkType.worshipConnection =>
        l10n.quranAyahInsightsRelatedTypeWorshipConnection,
      QuranRelatedAyahLinkType.characterConnection =>
        l10n.quranAyahInsightsRelatedTypeCharacterConnection,
      QuranRelatedAyahLinkType.creationConnection =>
        l10n.quranAyahInsightsRelatedTypeCreationConnection,
      QuranRelatedAyahLinkType.prophetConnection =>
        l10n.quranAyahInsightsRelatedTypeProphetConnection,
      null => l10n.quranAyahInsightsTypeRelatedAyah,
    };
  }
}

class _AyahInsightsItemTile extends ConsumerWidget {
  const _AyahInsightsItemTile({required this.item, this.onOpenItem});

  final _AyahInsightsBoundItem item;
  final ValueChanged<QuranAyahDisplayItem>? onOpenItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final displayItem = item.item;
    final entry = item.entry;
    final isCompleted = ref.watch(
      quranLearningEntryCompletedProvider(entry.id),
    );
    final isPrompt =
        displayItem.type == QuranAyahDisplayItemType.reflectionPrompt;
    final hasTapTarget =
        displayItem.sourceRouteName != null || displayItem.relatedRef != null;
    final savedEntry = ref.watch(
      quranReflectionsProvider.select(
        (items) => _findSavedReflection(
          items,
          ref: entry.ref,
          sourceEnrichmentId: entry.id,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isPrompt
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.22)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: !hasTapTarget
              ? null
              : () {
                  if (onOpenItem != null) {
                    onOpenItem!(displayItem);
                    return;
                  }
                  if (displayItem.sourceRouteName != null) {
                    context.pushNamed(
                      displayItem.sourceRouteName!,
                      pathParameters: displayItem.pathParameters,
                      queryParameters: displayItem.queryParameters,
                    );
                    return;
                  }
                  if (displayItem.relatedRef != null) {
                    openQuranReferenceLocation(
                      context,
                      ref: displayItem.relatedRef!,
                    );
                  }
                },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer.withValues(
                          alpha: 0.55,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          _typeLabel(l10n, displayItem.type),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (displayItem.cautionLevel != QuranAyahCautionLevel.none)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.quranAyahInsightsCautionLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayItem.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (displayItem.summary.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              displayItem.summary,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ] else
                            const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              if (displayItem.id == 'primary_${entry.id}')
                                _ReflectionIconButton(
                                  icon: isCompleted
                                      ? Icons.check_circle_rounded
                                      : Icons.task_alt_rounded,
                                  tooltip: isCompleted
                                      ? l10n.quranLearningStudiedAction
                                      : l10n.quranLearningMarkStudiedAction,
                                  onPressed: isCompleted
                                      ? () {}
                                      : () {
                                          ref
                                              .read(
                                                quranLearningProgressStateProvider
                                                    .notifier,
                                              )
                                              .completeEntry(
                                                entry: entry,
                                                sourceSurface: 'ayah_insights',
                                              );
                                        },
                                ),
                              _ReflectionIconButton(
                                icon: savedEntry == null
                                    ? Icons.bookmark_add_outlined
                                    : Icons.bookmark_rounded,
                                tooltip: savedEntry == null
                                    ? l10n.quranReflectionsSaveAction
                                    : l10n.quranReflectionsSavedAction,
                                onPressed: () {
                                  ref
                                      .read(quranReflectionsProvider.notifier)
                                      .toggleSaved(
                                        ref: entry.ref,
                                        sourceType: QuranReflectionSourceType
                                            .ayahInsight,
                                        title: displayItem.title,
                                        summary: displayItem.summary,
                                        sourceEnrichmentId: entry.id,
                                      );
                                },
                              ),
                              _ReflectionIconButton(
                                icon: Icons.ios_share_rounded,
                                tooltip: l10n.quranLearningShareAction,
                                onPressed: () {
                                  final text =
                                      QuranLearningShareService.buildAyahInsightShareText(
                                        ref: entry.ref,
                                        title: displayItem.title,
                                        summary: displayItem.summary,
                                        attribution:
                                            l10n.quranLearningShareAttribution,
                                        reflectionLabel: l10n
                                            .quranLearningShareReflectionLabel,
                                        reflectionPrompt:
                                            displayItem.id ==
                                                'primary_${entry.id}'
                                            ? firstReflectionPromptForEntry(
                                                entry,
                                              )
                                            : null,
                                      );
                                  QuranLearningShareService.shareText(text);
                                },
                              ),
                              _ReflectionIconButton(
                                icon: Icons.edit_note_rounded,
                                tooltip:
                                    savedEntry?.note?.trim().isNotEmpty ?? false
                                    ? l10n.quranReflectionsEditNoteAction
                                    : l10n.quranReflectionsAddNoteAction,
                                onPressed: () async {
                                  final note =
                                      await showQuranReflectionNoteDialog(
                                        context,
                                        title:
                                            savedEntry?.note
                                                    ?.trim()
                                                    .isNotEmpty ??
                                                false
                                            ? l10n.quranReflectionsEditNoteAction
                                            : l10n.quranReflectionsAddNoteAction,
                                        initialNote: savedEntry?.note,
                                      );
                                  if (note == null) return;
                                  ref
                                      .read(quranReflectionsProvider.notifier)
                                      .upsertNote(
                                        ref: entry.ref,
                                        sourceType: QuranReflectionSourceType
                                            .ayahInsight,
                                        title: displayItem.title,
                                        summary: displayItem.summary,
                                        sourceEnrichmentId: entry.id,
                                        note: note,
                                      );
                                  if (note.trim().isNotEmpty) {
                                    ref
                                        .read(
                                          quranLearningProgressStateProvider
                                              .notifier,
                                        )
                                        .rewardFirstReflectionNote(
                                          ref: entry.ref,
                                          sourceEnrichmentId: entry.id,
                                          sourceSurface: 'ayah_insights',
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (hasTapTarget) ...[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, QuranAyahDisplayItemType type) {
    return switch (type) {
      QuranAyahDisplayItemType.hadithReference =>
        l10n.quranAyahInsightsTypeHadithReference,
      QuranAyahDisplayItemType.ayahInsight =>
        l10n.quranAyahInsightsTypeAyahInsight,
      QuranAyahDisplayItemType.signsInCreation =>
        l10n.quranAyahInsightsTypeSignsInCreation,
      QuranAyahDisplayItemType.scientificReflection =>
        l10n.quranAyahInsightsTypeScientificReflection,
      QuranAyahDisplayItemType.worldCreationLesson =>
        l10n.quranAyahInsightsTypeWorldCreationLesson,
      QuranAyahDisplayItemType.worshipLesson =>
        l10n.quranAyahInsightsTypeWorshipLesson,
      QuranAyahDisplayItemType.characterLesson =>
        l10n.quranAyahInsightsTypeCharacterLesson,
      QuranAyahDisplayItemType.prophetConnection =>
        l10n.quranAyahInsightsTypeProphetConnection,
      QuranAyahDisplayItemType.relatedAyah =>
        l10n.quranAyahInsightsTypeRelatedAyah,
      QuranAyahDisplayItemType.reflectionPrompt =>
        l10n.quranAyahInsightsTypeReflectionPrompt,
      QuranAyahDisplayItemType.interpretationNote =>
        l10n.quranAyahInsightsTypeInterpretationNote,
    };
  }
}

class _AyahInsightsDomainSection {
  const _AyahInsightsDomainSection({required this.domain, required this.items});

  final QuranAyahEnrichmentDomain domain;
  final List<_AyahInsightsBoundItem> items;
}

class _AyahInsightsBoundItem {
  const _AyahInsightsBoundItem({required this.entry, required this.item});

  final QuranAyahEnrichmentEntry entry;
  final QuranAyahDisplayItem item;
}

class _ReflectionIconButton extends StatelessWidget {
  const _ReflectionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
    );
  }
}

QuranReflectionEntry? _findSavedReflection(
  List<QuranReflectionEntry> items, {
  required QuranQuoteRef ref,
  String? sourceEnrichmentId,
}) {
  for (final item in items) {
    if (sourceEnrichmentId != null && item.sourceEnrichmentId != null) {
      if (item.sourceEnrichmentId == sourceEnrichmentId) return item;
      continue;
    }
    if (item.ref.surah == ref.surah &&
        item.ref.ayah == ref.ayah &&
        item.ref.ayahEnd == ref.ayahEnd) {
      return item;
    }
  }
  return null;
}
