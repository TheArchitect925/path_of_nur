import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../learn/presentation/widgets/learn_discovery_search_field.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../domain/arabic_learning_search_models.dart';
import '../arabic_learning_lesson_pack_localizations.dart';
import '../../../../core/theme/app_fonts.dart';

enum ArabicLearningDiscoveryVariant { kids, adult }

class ArabicLearningDiscoverySearchSection extends StatelessWidget {
  const ArabicLearningDiscoverySearchSection({
    super.key,
    required this.variant,
    required this.controller,
    required this.selectedFilters,
    required this.results,
    required this.onChanged,
    required this.onClear,
    required this.onToggleFilter,
    required this.onOpenResult,
  });

  final ArabicLearningDiscoveryVariant variant;
  final TextEditingController controller;
  final Set<ArabicLearningSearchFilter> selectedFilters;
  final List<ArabicLearningSearchItem> results;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<ArabicLearningSearchFilter> onToggleFilter;
  final ValueChanged<ArabicLearningSearchItem> onOpenResult;

  bool get _isKids => variant == ArabicLearningDiscoveryVariant.kids;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = controller.text.trim();
    final hasSearchState = query.isNotEmpty || selectedFilters.isNotEmpty;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isKids
              ? l10n.arabicLearningSearchKidsTitle
              : l10n.arabicLearningSearchAdultTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          _isKids
              ? l10n.arabicLearningSearchKidsSubtitle
              : l10n.arabicLearningSearchAdultSubtitle,
        ),
        const SizedBox(height: 12),
        LearnDiscoverySearchField(
          controller: controller,
          hintText: _isKids
              ? l10n.arabicLearningSearchKidsHint
              : l10n.arabicLearningSearchAdultHint,
          onChanged: onChanged,
          onClear: onClear,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ArabicLearningSearchFilter.values
              .map(
                (filter) => FilterChip(
                  label: Text(_labelForFilter(l10n, filter)),
                  selected: selectedFilters.contains(filter),
                  onSelected: (_) => onToggleFilter(filter),
                ),
              )
              .toList(growable: false),
        ),
        if (hasSearchState) ...[
          const SizedBox(height: 14),
          if (results.isEmpty)
            _EmptyState(isKids: _isKids)
          else
            Column(
              children: results
                  .take(8)
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ResultCard(
                        item: item,
                        isKids: _isKids,
                        onOpen: item.isAvailable
                            ? () => onOpenResult(item)
                            : null,
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ],
    );

    if (_isKids) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3EA),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5D8C5)),
        ),
        child: body,
      );
    }
    return PremiumCard(child: body);
  }

  String _labelForFilter(
    AppLocalizations l10n,
    ArabicLearningSearchFilter filter,
  ) {
    switch (filter) {
      case ArabicLearningSearchFilter.packs:
        return l10n.arabicLearningSearchFilterPacks;
      case ArabicLearningSearchFilter.letters:
        return l10n.arabicLearningSearchFilterLetters;
      case ArabicLearningSearchFilter.words:
        return l10n.arabicLearningSearchFilterWords;
      case ArabicLearningSearchFilter.phrases:
        return l10n.arabicLearningSearchFilterPhrases;
      case ArabicLearningSearchFilter.review:
        return l10n.arabicLearningSearchFilterReview;
      case ArabicLearningSearchFilter.continueFlow:
        return l10n.arabicLearningSearchFilterContinue;
      case ArabicLearningSearchFilter.quranBridge:
        return l10n.arabicLearningSearchFilterQuranBridge;
    }
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.item,
    required this.isKids,
    required this.onOpen,
  });

  final ArabicLearningSearchItem item;
  final bool isKids;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isAvailable ? Colors.white : const Color(0xFFF2EEE7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: item.isAvailable
                ? (isKids ? const Color(0xFFE0D1BD) : const Color(0xFFD8D5CF))
                : const Color(0xFFD8CFC2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _typeLabel(l10n),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6A5A46),
                            ),
                      ),
                      if (!item.isAvailable)
                        Text(
                          l10n.arabicLearningSearchLockedLabel,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF8A6C49),
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (item.arabicText case final arabicText?)
                    Text(
                      arabicText,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize:
                            item.type == ArabicLearningSearchItemType.letter
                            ? 30
                            : 26,
                        fontFamily: AppFonts.quranArabic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (item.arabicText != null) const SizedBox(height: 6),
                  Text(
                    item.type == ArabicLearningSearchItemType.lessonPack
                        ? localizedArabicLearningLessonPackTitle(l10n, item.id)
                        : item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.type == ArabicLearningSearchItemType.lessonPack) ...[
                    const SizedBox(height: 4),
                    Text(
                      localizedArabicLearningLessonPackSubtitle(l10n, item.id),
                    ),
                  ] else if (item.meaning case final meaning?) ...[
                    const SizedBox(height: 4),
                    Text(meaning),
                  ] else if (item.subtitle case final subtitle?) ...[
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: onOpen,
              child: Text(
                item.isAvailable
                    ? l10n.arabicLearningSearchOpenAction
                    : l10n.arabicLearningSearchLockedLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n) {
    switch (item.type) {
      case ArabicLearningSearchItemType.lessonPack:
        return l10n.arabicLearningSearchTypeLessonPack;
      case ArabicLearningSearchItemType.letter:
        return l10n.arabicLearningSearchTypeLetter;
      case ArabicLearningSearchItemType.word:
        return l10n.arabicLearningSearchTypeWord;
      case ArabicLearningSearchItemType.phrase:
        return l10n.arabicLearningSearchTypePhrase;
      case ArabicLearningSearchItemType.reviewTarget:
        return l10n.arabicLearningSearchTypeReview;
      case ArabicLearningSearchItemType.continueTarget:
        return l10n.arabicLearningSearchTypeContinue;
      case ArabicLearningSearchItemType.quranBridgeSnippet:
        return l10n.arabicLearningSearchTypeQuranBridge;
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isKids});

  final bool isKids;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isKids ? const Color(0xFFFFFBF4) : const Color(0xFFFBFAF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DDCD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHubSearchEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.arabicLearningSearchNoResultsBody),
        ],
      ),
    );
  }
}
