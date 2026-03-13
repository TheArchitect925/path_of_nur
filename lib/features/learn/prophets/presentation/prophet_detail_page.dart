import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
import '../domain/prophet_detail_content.dart';
import '../domain/prophet_entry.dart';

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
    return AppPageScaffold(
      scrollController: _scrollController,
      headerIcon: Icons.menu_book_rounded,
      title: widget.content.titledHonoredName,
      subtitle: widget.content.honoredArabicName,
      quote: QuranQuote(
        arabic: 'فَاقْصُصِ الْقَصَصَ لَعَلَّهُمْ يَتَفَكَّرُونَ',
        transliteration: 'Faqsusi al-qasasa la\'allahum yatafakkarun',
        translation: 'Relate the stories so that they may reflect.',
        surah: 7,
        verse: 176,
        locationLabel: 'Qur’an 7:176',
      ),
      children: [
        _heroHeader(context),
        const SizedBox(height: 10),
        _sectionJumpRow(),
        const SizedBox(height: 10),
        _sectionCard(
          _overviewKey,
          context,
          title: 'Overview',
          child: Text(widget.content.overview),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          _storyKey,
          context,
          title: 'Story',
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
          title: 'Lessons',
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
          title: 'References',
          child: _referencesBlock(),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          _reflectionKey,
          context,
          title: 'Reflect',
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
          title: 'Related',
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
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: widget.isBookmarked
                    ? 'Remove bookmark'
                    : 'Save prophet',
                onPressed: widget.onToggleBookmark,
                icon: Icon(
                  widget.isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: widget.isBookmarked
                      ? const Color(0xFF8F6A3A)
                      : AppColors.onSurfaceSubtle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(widget.content.eraTitle),
              _pill(widget.content.regionLabel),
              if (widget.content.locationLabel != null)
                _pill(widget.content.locationLabel!),
              if (widget.content.locationConfidence != null)
                _pill(widget.content.locationConfidence!.label),
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
                  label: const Text('View in Timeline'),
                ),
              if (widget.onViewOnMap != null)
                OutlinedButton.icon(
                  onPressed: widget.onViewOnMap,
                  icon: const Icon(Icons.map_rounded),
                  label: const Text('View on Map'),
                ),
              if (widget.onViewInFamilyTree != null)
                OutlinedButton.icon(
                  onPressed: widget.onViewInFamilyTree,
                  icon: const Icon(Icons.account_tree_rounded),
                  label: const Text('View in Family Tree'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionJumpRow() {
    return PremiumCard(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _jumpChip('Overview', _overviewKey),
            _jumpChip('Story', _storyKey),
            _jumpChip('Lessons', _lessonsKey),
            _jumpChip('References', _referencesKey),
            _jumpChip('Reflect', _reflectionKey),
            _jumpChip('Related', _relatedKey),
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
            color: AppColors.surface.withValues(alpha: 0.28),
            border: Border.all(
              color: AppColors.accentGoldSoft.withValues(alpha: 0.35),
            ),
          ),
          child: Text(label, style: const TextStyle(fontSize: 12.2)),
        ),
      ),
    );
  }

  Widget _referencesBlock() {
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
                    ? 'Show fewer references'
                    : 'Show all references',
              ),
            ),
          ),
      ],
    );
  }

  Widget _relatedContent(BuildContext context) {
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
            label: const Text('Open Family Tree'),
          ),
          const SizedBox(height: 12),
        ],
        if (relatedProphets.isNotEmpty) ...[
          _subheading(context, 'Related Prophets'),
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
          _subheading(context, 'Related Life Lessons'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.content.relatedLifeLessonIds
                .map((id) => _routeReadyChip('Life • $id'))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.content.relatedGrowthHabitIds.isNotEmpty) ...[
          _subheading(context, 'Related Growth Habits'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.content.relatedGrowthHabitIds
                .map((id) => _routeReadyChip('Growth • $id'))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (quranTopics.isNotEmpty) ...[
          _subheading(context, 'Related Qur’an Topics'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quranTopics
                .map((topic) => _routeReadyChip('Qur’an • $topic'))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _navigatorCard(BuildContext context) {
    return PremiumCard(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onOpenPreviousProphet,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              label: Text(widget.previousProphetLabel ?? 'Previous Prophet'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onOpenNextProphet,
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              label: Text(widget.nextProphetLabel ?? 'Next Prophet'),
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
        color: AppColors.surface.withValues(alpha: 0.3),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _routeReadyChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.26),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.30),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11.5)),
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
    final pathParameters = {'surahNumber': '${ref.surahNumber}'};
    final queryParameters = <String, String>{};
    final parsed = _parseAyahRange(ref.verseRange);
    final startAyah = ref.startAyah ?? parsed.$1;
    final endAyah = parsed.$2;
    if (startAyah != null && startAyah > 0) {
      queryParameters['ayah'] = '$startAyah';
    }
    if (endAyah != null && endAyah > 0 && endAyah >= (startAyah ?? endAyah)) {
      queryParameters['endAyah'] = '$endAyah';
    }
    context.pushNamed(
      'quranReader',
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  (int?, int?) _parseAyahRange(String range) {
    final normalized = range.replaceAll('–', '-').replaceAll('—', '-').trim();
    if (normalized.isEmpty) return (null, null);
    final firstChunk = normalized.split(',').first.trim();
    if (firstChunk.isEmpty) return (null, null);
    if (!firstChunk.contains('-')) {
      final single = int.tryParse(firstChunk);
      return (single, single);
    }
    final parts = firstChunk.split('-');
    final start = int.tryParse(parts.first.trim());
    final end = parts.length > 1 ? int.tryParse(parts[1].trim()) : null;
    return (start, end ?? start);
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({required this.item, required this.onTap});

  final QuranReferenceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.surface.withValues(alpha: 0.25),
            border: Border.all(
              color: AppColors.accentGoldSoft.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.surahName} (${item.surahNumber}:${item.verseRange})',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.label != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.label!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.open_in_new_rounded, size: 18),
            ],
          ),
        ),
      ),
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
