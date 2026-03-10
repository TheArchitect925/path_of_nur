import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
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

class _LearnContentDetailPageState extends ConsumerState<LearnContentDetailPage> {
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

    return AppPageScaffold(
      headerIcon: _headerIcon(widget.category),
      title: topic.title,
      subtitle: topic.subtitle,
      quote: const QuranQuote(
        arabic: 'وَقُلْ رَبِّ زِدْنِي عِلْمًا',
        transliteration: 'Wa qul rabbi zidni ilma',
        translation: 'My Lord, increase me in knowledge.',
        surah: 20,
        verse: 114,
        locationLabel: 'Taha 20:114',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        _ContentSection(
          title: l10n.learnContentOverviewTitle,
          child: Text(topic.overview, style: const TextStyle(height: 1.45)),
        ),
        if (catalog != null)
          _ContentSection(
            title: l10n.learnContentModeFocusTitle,
            child: Text(
              mode.isKids
                  ? catalog.kidsSnippet
                  : (catalogForMode(mode.activeMode, kidsMode: false)
                          .where((item) => item.topicId == topic.id)
                          .firstOrNull
                          ?.teaser ??
                      catalog.teaser),
              style: const TextStyle(height: 1.4),
            ),
          ),
        _ContentSection(
          title: l10n.learnContentThemesTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: topic.keyThemes
                .map(
                  (theme) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(Icons.circle, size: 6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(theme)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        if (catalog != null && catalog.reflectionPrompts.isNotEmpty)
          _ContentSection(
            title: l10n.learnContentReflectionIdeasTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: catalog.reflectionPrompts
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $item'),
                      ))
                  .toList(),
            ),
          ),
        _ContentSection(
          title: l10n.learnContentReferencesTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: topic.referencePlaceholders
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '• $item',
                      style: const TextStyle(color: Color(0xFF6A5A4A)),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        _ContentSection(
          title: l10n.learnContentReflectionPromptTitle,
          child: Text(topic.reflectionPrompt, style: const TextStyle(height: 1.45)),
        ),
        _ContentSection(
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
                        final next = ((progress?.reflectionProgress ?? 0) + 0.25)
                            .clamp(0.0, 1.0);
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
        _ContentSection(
          title: l10n.learnContentRelatedTopicsTitle,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topic.relatedTopics
                .map(
                  (related) => ActionChip(
                    label: Text(related.title),
                    onPressed: () => context.pushNamed(
                      'learnContentDetail',
                      pathParameters: {
                        'category': _categoryParam(widget.category),
                        'topicId': related.topicId,
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        _ContentSection(
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

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
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
