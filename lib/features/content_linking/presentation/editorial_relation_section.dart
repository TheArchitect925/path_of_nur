import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../domain/editorial_relation_models.dart';

class EditorialRelationSection extends StatelessWidget {
  const EditorialRelationSection({
    super.key,
    this.title,
    required this.links,
    this.maxItems = 3,
    this.compact = false,
  });

  final String? title;
  final List<EditorialResolvedRelationLink> links;
  final int maxItems;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final visibleLinks = links.take(maxItems).toList(growable: false);
    if (visibleLinks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((title ?? '').trim().isNotEmpty) ...[
          Text(
            title!,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
        ],
        ...visibleLinks.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: entry.key == visibleLinks.length - 1 ? 0 : 10,
            ),
            child: _EditorialRelationTile(link: entry.value, compact: compact),
          );
        }),
      ],
    );
  }
}

class _EditorialRelationTile extends StatelessWidget {
  const _EditorialRelationTile({required this.link, required this.compact});

  final EditorialResolvedRelationLink link;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final relationLabel = editorialRelationTypeLabel(l10n, link.relationType);

    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: compact,
        title: Text(link.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((link.subtitle ?? '').trim().isNotEmpty)
              Text(link.subtitle!.trim()),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _RelationTypeChip(label: relationLabel),
                if ((link.editorialLabel ?? '').trim().isNotEmpty)
                  Text(
                    link.editorialLabel!.trim(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.pushNamed(
          link.routeName,
          pathParameters: link.pathParameters,
          queryParameters: link.queryParameters,
        ),
      ),
    );
  }
}

class _RelationTypeChip extends StatelessWidget {
  const _RelationTypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

String editorialRelationTypeLabel(
  AppLocalizations l10n,
  EditorialRelationType type,
) {
  switch (type) {
    case EditorialRelationType.explains:
      return l10n.editorialRelationTypeExplains;
    case EditorialRelationType.reinforces:
      return l10n.editorialRelationTypeReinforces;
    case EditorialRelationType.sameTheme:
      return l10n.editorialRelationTypeSameTheme;
    case EditorialRelationType.relatedPractice:
      return l10n.editorialRelationTypeRelatedPractice;
    case EditorialRelationType.relatedDua:
      return l10n.editorialRelationTypeRelatedDua;
    case EditorialRelationType.relatedCreationSign:
      return l10n.editorialRelationTypeRelatedCreationSign;
    case EditorialRelationType.sameLesson:
      return l10n.editorialRelationTypeSameLesson;
    case EditorialRelationType.readerFollowUp:
      return l10n.editorialRelationTypeReaderFollowUp;
  }
}
