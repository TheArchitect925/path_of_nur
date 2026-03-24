import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/quran_reference_graph_provider.dart';
import '../../domain/quran_reference_models.dart';

Future<void> showQuranRelatedKnowledgeDetailSheet(
  BuildContext context, {
  required QuranRelatedKnowledgeLink link,
  String? anchorLabel,
}) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                link.title,
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      quranKnowledgeTypeLabel(l10n, link.knowledgeType),
                    ),
                  ),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      quranConnectionStrengthLabel(
                        l10n,
                        link.connectionStrength,
                      ),
                    ),
                  ),
                  if (anchorLabel?.trim().isNotEmpty ?? false)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        l10n.quranReferenceDetailCurrentAnchorChip(
                          anchorLabel!,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quranReferenceDetailWhyRelatedTitle,
                      style: Theme.of(sheetContext).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(_relationReason(l10n, link)),
                    if (link.subtitle.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.quranReferenceDetailPreviewTitle,
                        style: Theme.of(sheetContext).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(link.subtitle),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      l10n.quranReferenceDetailSourceOwnerTitle,
                      style: Theme.of(sheetContext).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(_ownerLabel(l10n, link)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.pushNamed(
                    link.routeName,
                    pathParameters: link.pathParameters,
                    queryParameters: link.queryParameters,
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(
                  l10n.quranReferenceDetailOpenDestination(
                    _actionDestinationLabel(l10n, link),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String quranRelatedKnowledgeCategoryLabel(
  AppLocalizations l10n,
  QuranRelatedKnowledgeCategory category,
) {
  switch (category) {
    case QuranRelatedKnowledgeCategory.quranInsight:
      return l10n.quranReferenceDetailCategoryQuranInsight;
    case QuranRelatedKnowledgeCategory.worldLesson:
      return l10n.quranReferenceDetailCategoryWorldLesson;
    case QuranRelatedKnowledgeCategory.worshipLesson:
      return l10n.quranReferenceDetailCategoryWorshipLesson;
    case QuranRelatedKnowledgeCategory.characterLesson:
      return l10n.quranReferenceDetailCategoryCharacterLesson;
    case QuranRelatedKnowledgeCategory.hadith:
      return l10n.quranReferenceDetailCategoryHadith;
    case QuranRelatedKnowledgeCategory.divineLife:
      return l10n.quranReferenceDetailCategoryDivineLife;
    case QuranRelatedKnowledgeCategory.prophet:
      return l10n.quranReferenceDetailCategoryProphet;
    case QuranRelatedKnowledgeCategory.learningPath:
      return l10n.quranReferenceDetailCategoryLearningPath;
    case QuranRelatedKnowledgeCategory.learningJourney:
      return l10n.quranReferenceDetailCategoryLearningJourney;
  }
}

String quranKnowledgeTypeLabel(AppLocalizations l10n, QuranKnowledgeType type) {
  return switch (type) {
    QuranKnowledgeType.quranDirect => l10n.quranReferenceKnowledgeTypeQuran,
    QuranKnowledgeType.hadith => l10n.quranReferenceKnowledgeTypeHadith,
    QuranKnowledgeType.theme => l10n.quranReferenceKnowledgeTypeTheme,
    QuranKnowledgeType.character => l10n.quranReferenceKnowledgeTypeCharacter,
    QuranKnowledgeType.seerah => l10n.quranReferenceKnowledgeTypeSeerah,
    QuranKnowledgeType.journey => l10n.quranReferenceKnowledgeTypeJourney,
    QuranKnowledgeType.signsWorld => l10n.quranReferenceKnowledgeTypeSignsWorld,
    QuranKnowledgeType.reflection => l10n.quranReferenceKnowledgeTypeReflection,
    QuranKnowledgeType.worship => l10n.quranReferenceKnowledgeTypeWorship,
    QuranKnowledgeType.lifeLesson => l10n.quranReferenceKnowledgeTypeLifeLesson,
  };
}

String quranConnectionStrengthLabel(
  AppLocalizations l10n,
  QuranConnectionStrength strength,
) {
  return switch (strength) {
    QuranConnectionStrength.direct => l10n.quranReferenceStrengthDirect,
    QuranConnectionStrength.strong => l10n.quranReferenceStrengthStrong,
    QuranConnectionStrength.related => l10n.quranReferenceStrengthRelated,
    QuranConnectionStrength.reflective => l10n.quranReferenceStrengthReflective,
  };
}

String _relationReason(AppLocalizations l10n, QuranRelatedKnowledgeLink link) {
  final explicit = link.relationReason?.trim();
  if (explicit?.isNotEmpty ?? false) return explicit!;

  return switch (link.knowledgeType) {
    QuranKnowledgeType.quranDirect =>
      l10n.quranReferenceDetailReasonKnowledgeQuran,
    QuranKnowledgeType.hadith => l10n.quranReferenceDetailReasonKnowledgeHadith,
    QuranKnowledgeType.theme => l10n.quranReferenceDetailReasonKnowledgeTheme,
    QuranKnowledgeType.character =>
      l10n.quranReferenceDetailReasonKnowledgeCharacter,
    QuranKnowledgeType.seerah => l10n.quranReferenceDetailReasonKnowledgeSeerah,
    QuranKnowledgeType.journey =>
      l10n.quranReferenceDetailReasonKnowledgeJourney,
    QuranKnowledgeType.signsWorld =>
      l10n.quranReferenceDetailReasonKnowledgeSignsWorld,
    QuranKnowledgeType.reflection =>
      l10n.quranReferenceDetailReasonKnowledgeReflection,
    QuranKnowledgeType.worship =>
      l10n.quranReferenceDetailReasonKnowledgeWorship,
    QuranKnowledgeType.lifeLesson =>
      l10n.quranReferenceDetailReasonKnowledgeLifeLesson,
  };
}

String _ownerLabel(AppLocalizations l10n, QuranRelatedKnowledgeLink link) {
  switch (link.category) {
    case QuranRelatedKnowledgeCategory.quranInsight:
      return l10n.quranHubStudySubtitle;
    case QuranRelatedKnowledgeCategory.worldLesson:
      return l10n.learnCategoryWorldCreationTitle;
    case QuranRelatedKnowledgeCategory.worshipLesson:
      return l10n.quranAyahInsightsDomainWorshipRemembrance;
    case QuranRelatedKnowledgeCategory.characterLesson:
      return l10n.learnHubCategoryCharacterAdabTitle;
    case QuranRelatedKnowledgeCategory.hadith:
      return l10n.learnCategoryHadithTitle;
    case QuranRelatedKnowledgeCategory.divineLife:
      return l10n.learnCategoryDivineLifeLessonsTitle;
    case QuranRelatedKnowledgeCategory.prophet:
      return l10n.learnHubCategoryProphetsStoriesTitle;
    case QuranRelatedKnowledgeCategory.learningPath:
      return l10n.quranAyahInsightPathsTitle;
    case QuranRelatedKnowledgeCategory.learningJourney:
      return l10n.learnHubJourneyIslandTitle;
  }
}

String _actionDestinationLabel(
  AppLocalizations l10n,
  QuranRelatedKnowledgeLink link,
) {
  switch (link.category) {
    case QuranRelatedKnowledgeCategory.quranInsight:
      return l10n.quranReferenceDetailOpenQuranInsight;
    case QuranRelatedKnowledgeCategory.worldLesson:
      return l10n.quranReferenceDetailOpenWorldLesson;
    case QuranRelatedKnowledgeCategory.worshipLesson:
      return l10n.quranReferenceDetailOpenWorshipLesson;
    case QuranRelatedKnowledgeCategory.characterLesson:
      return l10n.quranReferenceDetailOpenCharacterLesson;
    case QuranRelatedKnowledgeCategory.hadith:
      return l10n.quranReferenceDetailOpenHadithLesson;
    case QuranRelatedKnowledgeCategory.divineLife:
      return l10n.quranReferenceDetailOpenDivineLifeLesson;
    case QuranRelatedKnowledgeCategory.prophet:
      return l10n.quranReferenceDetailOpenProphetStory;
    case QuranRelatedKnowledgeCategory.learningPath:
      return l10n.quranReferenceDetailOpenLearningPath;
    case QuranRelatedKnowledgeCategory.learningJourney:
      return l10n.quranReferenceDetailOpenLearningJourney;
  }
}
