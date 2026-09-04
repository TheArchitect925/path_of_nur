import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../domain/prophet_detail_content.dart';
import '../domain/prophet_entry.dart';
import 'prophets_metadata_localization.dart';

class ProphetDetailPage extends StatefulWidget {
  const ProphetDetailPage({
    super.key,
    required this.prophet,
    required this.content,
    required this.allProphets,
    this.isBookmarked = false,
    this.onToggleBookmark,
    this.onOpenRelatedProphet,
    this.onOpenPreviousProphet,
    this.onOpenNextProphet,
    this.previousProphetLabel,
    this.nextProphetLabel,
    this.onViewInTimeline,
    this.onViewOnMap,
    this.onViewInFamilyTree,
  });

  final ProphetEntry prophet;
  final ProphetDetailContent content;
  final List<ProphetEntry> allProphets;
  final bool isBookmarked;
  final VoidCallback? onToggleBookmark;
  final ValueChanged<String>? onOpenRelatedProphet;
  final VoidCallback? onOpenPreviousProphet;
  final VoidCallback? onOpenNextProphet;
  final String? previousProphetLabel;
  final String? nextProphetLabel;
  final VoidCallback? onViewInTimeline;
  final VoidCallback? onViewOnMap;
  final VoidCallback? onViewInFamilyTree;

  @override
  State<ProphetDetailPage> createState() => _ProphetDetailPageState();
}

class _ProphetDetailPageState extends State<ProphetDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _storyKey = GlobalKey();
  final GlobalKey _lessonsKey = GlobalKey();
  final GlobalKey _referencesKey = GlobalKey();
  final GlobalKey _reflectionKey = GlobalKey();
  final GlobalKey _relatedKey = GlobalKey();
  bool _referencesExpanded = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      scrollController: _scrollController,
      headerIcon: Icons.menu_book_rounded,
      title: widget.content.titledHonoredName,
      subtitle: widget.content.honoredArabicName,
      quote: buildProphetStoriesQuote(),
      children: [
        _heroHeader(context),
        const SizedBox(height: 10),
        _sectionJumpRow(),
        const SizedBox(height: 10),
        _sectionCard(
          _overviewKey,
          context,
          title: l10n.prophetsDetailOverviewTitle,
          child: Text(widget.content.overview),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          _storyKey,
          context,
          title: l10n.prophetsDetailStoryTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.content.storySections
                .map(
                  (section) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
                        Text(section.content),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          _lessonsKey,
          context,
          title: l10n.prophetsDetailLessonsTitle,
          child: Column(
            children: widget.content.keyLessons
                .map(
                  (lesson) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFB98E52),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(lesson.description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          _referencesKey,
          context,
          title: l10n.prophetsDetailReferencesTitle,
          child: _referencesBlock(),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          _reflectionKey,
          context,
          title: l10n.prophetsDetailReflectTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.content.reflectionPrompts
                .map(
                  (prompt) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('• $prompt'),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          _relatedKey,
          context,
          title: l10n.prophetsDetailRelatedTitle,
          child: _relatedContent(context),
        ),
        if (widget.onOpenPreviousProphet != null ||
            widget.onOpenNextProphet != null) ...[
          const SizedBox(height: 10),
          _navigatorCard(context),
        ],
      ],
    );
  }

  Widget _heroHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.content.honoredName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.content.honoredArabicName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.palette.onSurfaceSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: widget.isBookmarked
                    ? l10n.prophetsRemoveBookmark
                    : l10n.prophetsSaveBookmark,
                onPressed: widget.onToggleBookmark,
                icon: Icon(
                  widget.isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: widget.isBookmarked
                      ? const Color(0xFF8F6A3A)
                      : context.palette.onSurfaceSubtle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(localizedProphetEraTitle(l10n, widget.prophet.eraGroup)),
              _pill(widget.content.regionLabel),
              if (widget.content.locationLabel != null)
                _pill(widget.content.locationLabel!),
              if (widget.content.locationConfidence != null)
                _pill(
                  localizedProphetLocationConfidenceLabel(
                    l10n,
                    widget.content.locationConfidence!,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(widget.content.shortSummary),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              if (widget.onViewInTimeline != null)
                OutlinedButton.icon(
                  onPressed: widget.onViewInTimeline,
                  icon: const Icon(Icons.timeline_rounded),
                  label: Text(l10n.prophetsViewInTimeline),
                ),
              if (widget.onViewOnMap != null)
                OutlinedButton.icon(
                  onPressed: widget.onViewOnMap,
                  icon: const Icon(Icons.map_rounded),
                  label: Text(l10n.prophetsViewOnMap),
                ),
              if (widget.onViewInFamilyTree != null)
                OutlinedButton.icon(
                  onPressed: widget.onViewInFamilyTree,
                  icon: const Icon(Icons.account_tree_rounded),
                  label: Text(l10n.prophetsViewInFamilyTree),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionJumpRow() {
    final l10n = AppLocalizations.of(context);
    return AppHeroGlassShell(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      tintColor: context.palette.accent,
      surfaceAlphaOverride: 0.2,
      radius: 36,
      borderColor: const Color(0x42FFFFFF),
      highlightGradientColors: const [
        Color(0x24FFFFFF),
        Colors.transparent,
        Color(0x16E8C98F),
      ],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _jumpChip(l10n.prophetsDetailOverviewTitle, _overviewKey),
            _jumpChip(l10n.prophetsDetailStoryTitle, _storyKey),
            _jumpChip(l10n.prophetsDetailLessonsTitle, _lessonsKey),
            _jumpChip(l10n.prophetsDetailReferencesTitle, _referencesKey),
            _jumpChip(l10n.prophetsDetailReflectTitle, _reflectionKey),
            _jumpChip(l10n.prophetsDetailRelatedTitle, _relatedKey),
          ],
        ),
      ),
    );
  }

  Widget _jumpChip(String label, GlobalKey key) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => _jumpTo(key),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: context.palette.surface.withValues(alpha: 0.28),
            border: Border.all(
              color: context.palette.accentSoft.withValues(alpha: 0.35),
            ),
          ),
          child: Text(label, style: const TextStyle(fontSize: 12.2)),
        ),
      ),
    );
  }

  Widget _referencesBlock() {
    final l10n = AppLocalizations.of(context);
    final refs = widget.content.quranReferences;
    final visible = _referencesExpanded || refs.length <= 4
        ? refs
        : refs.take(4).toList();
    return Column(
      children: [
        ...visible.map(
          (ref) => _ReferenceTile(
            item: ref,
            onTap: () => _openQuranReference(context, ref),
          ),
        ),
        if (refs.length > 4)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () =>
                  setState(() => _referencesExpanded = !_referencesExpanded),
              icon: Icon(
                _referencesExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
              label: Text(
                _referencesExpanded
                    ? l10n.learningReferencesShowLess
                    : l10n.learningReferencesShowAll,
              ),
            ),
          ),
      ],
    );
  }

  Widget _relatedContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final relatedProphets = widget.content.relatedProphetIds
        .map(
          (id) => widget.allProphets.where((item) => item.id == id).firstOrNull,
        )
        .whereType<ProphetEntry>()
        .toList();

    final quranTopics = widget.content.quranReferences
        .map((item) => item.surahName)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.onViewInFamilyTree != null) ...[
          OutlinedButton.icon(
            onPressed: widget.onViewInFamilyTree,
            icon: const Icon(Icons.account_tree_rounded),
            label: Text(l10n.prophetsOpenFamilyTree),
          ),
          const SizedBox(height: 12),
        ],
        if (relatedProphets.isNotEmpty) ...[
          _subheading(context, l10n.prophetsRelatedProphetsTitle),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: relatedProphets
                .map(
                  (entry) => ActionChip(
                    label: Text(entry.honoredName),
                    onPressed: widget.onOpenRelatedProphet == null
                        ? null
                        : () => widget.onOpenRelatedProphet!(entry.id),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.content.relatedLifeLessonIds.isNotEmpty) ...[
          _subheading(context, l10n.prophetsRelatedLifeLessonsTitle),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.content.relatedLifeLessonIds
                .map(
                  (id) => _routeReadyChip(
                    l10n.prophetsLifeChip(id),
                    onTap: () => context.pushNamed(
                      'lifeLessonDetail',
                      pathParameters: {'lessonId': id},
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.content.relatedGrowthHabitIds.isNotEmpty) ...[
          _subheading(context, l10n.prophetsRelatedGrowthHabitsTitle),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.content.relatedGrowthHabitIds
                .map(
                  (id) => _routeReadyChip(
                    l10n.prophetsGrowthChip(id),
                    onTap: () => context.pushNamed(
                      'growthHabitDetail',
                      pathParameters: {'habitId': id},
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (quranTopics.isNotEmpty) ...[
          _subheading(context, l10n.prophetsRelatedQuranTopicsTitle),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quranTopics
                .map(
                  (topic) => _routeReadyChip(
                    l10n.prophetsQuranChip(topic),
                    onTap: () => context.pushNamed('quranTopicExplorer'),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _navigatorCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onOpenPreviousProphet,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              label: Text(
                widget.previousProphetLabel ??
                    l10n.prophetsPreviousProphetFallback,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onOpenNextProphet,
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              label: Text(
                widget.nextProphetLabel ?? l10n.prophetsNextProphetFallback,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
    GlobalKey key,
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      key: key,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _subheading(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.palette.surface.withValues(alpha: 0.3),
        border: Border.all(
          color: context.palette.accentSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _routeReadyChip(String text, {VoidCallback? onTap}) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 11.5)),
      onPressed: onTap,
      backgroundColor: context.palette.surface.withValues(alpha: 0.26),
      side: BorderSide(
        color: context.palette.accentSoft.withValues(alpha: 0.30),
      ),
    );
  }

  void _jumpTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      alignment: 0.08,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _openQuranReference(BuildContext context, QuranReferenceItem ref) {
    openQuranReferenceRange(
      context,
      surahNumber: ref.surahNumber,
      verseRange: ref.verseRange,
      fallbackStartAyah: ref.startAyah,
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({required this.item, required this.onTap});

  final QuranReferenceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QuranReferenceLinkTile(
      referenceLabel:
          '${item.surahName} (${item.surahNumber}:${item.verseRange})',
      surahNumber: item.surahNumber,
      verseRange: item.verseRange,
      fallbackStartAyah: item.startAyah,
      subtitle: item.label,
      onTapOverride: onTap,
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
