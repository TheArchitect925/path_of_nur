import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../shared/presentation/learning_detail_page.dart';
import '../../shared/presentation/learning_lessons.dart';
import '../../shared/presentation/learning_reflection.dart';
import '../../shared/presentation/learning_related_content.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/learn_progress_provider.dart';
import '../data/learn_content_catalog.dart';
import '../data/learn_content_data.dart';
import '../domain/learn_topic_category.dart';

class LearnContentDetailPage extends ConsumerStatefulWidget {
  const LearnContentDetailPage({
    super.key,
    required this.category,
    required this.topicId,
  });

  final LearnTopicCategory category;
  final String topicId;

  @override
  ConsumerState<LearnContentDetailPage> createState() =>
      _LearnContentDetailPageState();
}

class _LearnContentDetailPageState
    extends ConsumerState<LearnContentDetailPage> {
  bool _tracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tracked) return;
    _tracked = true;
    Future<void>.microtask(
      () => ref
          .read(learnProgressProvider.notifier)
          .touchTopic(widget.category, widget.topicId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topic = topicById(widget.category, widget.topicId);
    if (topic == null) {
      return AppPageScaffold(
        headerIcon: Icons.article_outlined,
        title: l10n.learnContentTopicLabel,
        subtitle: l10n.learnContentUnavailableSubtitle,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final progress = ref.watch(learnProgressProvider).byTopicId[widget.topicId];
    final progressNotifier = ref.read(learnProgressProvider.notifier);
    final mode = ref.watch(specialModeProvider);
    final catalog = catalogByTopicId(topic.id);

    final modeFocus = catalog != null
        ? (mode.isKids
              ? catalog.kidsSnippet
              : (catalogForMode(mode.activeMode, kidsMode: false)
                        .where((item) => item.topicId == topic.id)
                        .firstOrNull
                        ?.teaser ??
                    catalog.teaser))
        : null;

    final relatedTopicLinks = topic.relatedTopics
        .map(
          (related) => LearningRelatedLink(
            label: related.title,
            onTap: () => context.pushNamed(
              'learnContentDetail',
              pathParameters: {
                'category': _categoryParam(widget.category),
                'topicId': related.topicId,
              },
            ),
          ),
        )
        .toList(growable: false);
    // These generic lesson pages still carry placeholder scaffolding rather
    // than structured source-backed references. Hide them from v1 until the
    // content model exposes real references.
    const referenceItems = <LearningReferenceItem>[];

    return LearningDetailPage(
      headerIcon: _headerIcon(widget.category),
      title: topic.title,
      subtitle: topic.subtitle,
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      sections: [
        LearningSection(
          title: l10n.learnContentOverviewTitle,
          body: topic.overview,
        ),
        if (modeFocus != null)
          LearningSection(
            title: l10n.learnContentModeFocusTitle,
            body: modeFocus,
          ),
        LearningSection(
          title: l10n.learnContentThemesTitle,
          child: LearningLessons(
            items: topic.keyThemes
                .map((theme) => LearningLessonItem(title: theme))
                .toList(growable: false),
          ),
        ),
        if (catalog != null && catalog.reflectionPrompts.isNotEmpty)
          LearningSection(
            title: l10n.learnContentReflectionIdeasTitle,
            child: LearningReflection(prompts: catalog.reflectionPrompts),
          ),
        if (referenceItems.isNotEmpty)
          LearningSection(
            title: l10n.learnContentReferencesTitle,
            child: LearningReferences(items: referenceItems),
          ),
        LearningSection(
          title: l10n.learnContentReflectionPromptTitle,
          child: LearningReflection(prompts: [topic.reflectionPrompt]),
        ),
        LearningSection(
          title: l10n.learnContentProgressTitle,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => progressNotifier.setCompleted(
                        widget.category,
                        widget.topicId,
                        !(progress?.completed ?? false),
                      ),
                      child: Text(
                        (progress?.completed ?? false)
                            ? l10n.learnContentMarkIncomplete
                            : l10n.learnContentMarkComplete,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => progressNotifier.toggleSaved(
                        widget.category,
                        widget.topicId,
                      ),
                      child: Text(
                        (progress?.saved ?? false)
                            ? l10n.learnContentSaved
                            : l10n.learnContentSave,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => progressNotifier.toggleFavorite(
                        widget.category,
                        widget.topicId,
                      ),
                      child: Text(
                        (progress?.favorite ?? false)
                            ? l10n.learnContentFavorited
                            : l10n.learnContentFavorite,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        final next =
                            ((progress?.reflectionProgress ?? 0) + 0.25).clamp(
                              0.0,
                              1.0,
                            );
                        progressNotifier.updateReflectionProgress(
                          widget.category,
                          widget.topicId,
                          next,
                        );
                      },
                      child: Text(
                        l10n.learnContentReflectionProgress(
                          ((progress?.reflectionProgress ?? 0) * 100).round(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        LearningSection(
          title: l10n.learnContentRelatedTopicsTitle,
          child: LearningRelatedContent(items: relatedTopicLinks),
        ),
        LearningSection(
          title: l10n.learnContentContinueTitle,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  topic.nextTopicId == null
                      ? l10n.learnContentPathComplete
                      : l10n.learnContentPathContinue,
                ),
              ),
              if (topic.nextTopicId != null)
                IconButton(
                  onPressed: () => context.pushNamed(
                    'learnContentDetail',
                    pathParameters: {
                      'category': _categoryParam(widget.category),
                      'topicId': topic.nextTopicId!,
                    },
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

String _categoryParam(LearnTopicCategory category) {
  switch (category) {
    case LearnTopicCategory.life:
      return 'life';
    case LearnTopicCategory.world:
      return 'world';
    case LearnTopicCategory.hadith:
      return 'hadith';
  }
}

IconData _headerIcon(LearnTopicCategory category) {
  switch (category) {
    case LearnTopicCategory.life:
      return Icons.family_restroom_rounded;
    case LearnTopicCategory.world:
      return Icons.public_rounded;
    case LearnTopicCategory.hadith:
      return Icons.menu_book_rounded;
  }
}
