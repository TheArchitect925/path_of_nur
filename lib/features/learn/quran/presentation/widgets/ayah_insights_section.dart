import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../domain/quran_ayah_enrichment_models.dart';

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
    final domainByEntryId = <String, QuranAyahEnrichmentDomain>{
      for (final entry in entries) entry.id: entry.domain,
    };
    final grouped = <QuranAyahEnrichmentDomain, List<QuranAyahDisplayItem>>{};

    for (final item in items) {
      if (item.type == QuranAyahDisplayItemType.relatedAyah) continue;
      final entryId = item.sourceEnrichmentId;
      final domain = entryId == null ? null : domainByEntryId[entryId];
      if (domain == null) continue;
      grouped.putIfAbsent(domain, () => <QuranAyahDisplayItem>[]).add(item);
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
  final List<QuranAyahDisplayItem> items;
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
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
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

  final QuranAyahDisplayItem item;
  final ValueChanged<QuranAyahDisplayItem>? onOpenItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isPrompt = item.type == QuranAyahDisplayItemType.reflectionPrompt;
    final hasTapTarget =
        item.sourceRouteName != null || item.relatedRef != null;

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
                    onOpenItem!(item);
                    return;
                  }
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
                          _typeLabel(l10n, item.type),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (item.cautionLevel != QuranAyahCautionLevel.none)
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
                            item.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (item.summary.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.summary,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ],
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
  final List<QuranAyahDisplayItem> items;
}
