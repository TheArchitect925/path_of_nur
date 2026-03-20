import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../models/faq_item.dart';
import '../providers/faq_providers.dart';
import '../widgets/faq_question_tile.dart';

enum FaqCategoryFilter { all, featured, beginner, intermediate }

class FaqCategoryPage extends ConsumerStatefulWidget {
  const FaqCategoryPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<FaqCategoryPage> createState() => _FaqCategoryPageState();
}

class _FaqCategoryPageState extends ConsumerState<FaqCategoryPage> {
  FaqCategoryFilter _filter = FaqCategoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final datasetAsync = ref.watch(faqDatasetProvider);
    final itemsAsync = ref.watch(faqByCategoryProvider(widget.categoryId));
    final l10n = AppLocalizations.of(context);

    return datasetAsync.when(
      data: (dataset) => itemsAsync.when(
        data: (items) {
          final title = dataset.categoryLabel(widget.categoryId);
          final filtered = _applyFilter(items);
          return AppPageScaffold(
            title: title,
            subtitle: l10n.batch9FaqBrowseSubtitle,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: FaqCategoryFilter.values
                      .map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_filterLabel(filter)),
                            selected: _filter == filter,
                            onSelected: (_) => setState(() => _filter = filter),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                const PremiumCard(
                  child: Text(
                    'No questions match this filter right now.',
                  ),
                )
              else
                ...filtered.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FaqQuestionTile(
                      item: item,
                      onTap: () => context.pushNamed(
                        'faqDetail',
                        pathParameters: {'faqId': item.id},
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => AppPageScaffold(
          title: l10n.batch9FaqTitle,
          subtitle: l10n.batch9FaqBrowseSubtitle,
          children: const [Center(child: CircularProgressIndicator())],
        ),
        error: (error, _) => AppPageScaffold(
          title: l10n.batch9FaqTitle,
          subtitle: l10n.batch9FaqBrowseSubtitle,
          children: [Center(child: Text('Unable to load category. $error'))],
        ),
      ),
      loading: () => AppPageScaffold(
        title: l10n.batch9FaqTitle,
        subtitle: l10n.batch9FaqBrowseSubtitle,
        children: const [Center(child: CircularProgressIndicator())],
      ),
      error: (error, _) => AppPageScaffold(
        title: l10n.batch9FaqTitle,
        subtitle: l10n.batch9FaqBrowseSubtitle,
        children: [Center(child: Text('Unable to load category. $error'))],
      ),
    );
  }

  List<FaqItem> _applyFilter(List<FaqItem> items) {
    switch (_filter) {
      case FaqCategoryFilter.all:
        return items;
      case FaqCategoryFilter.featured:
        return items.where((item) => item.isFeatured).toList(growable: false);
      case FaqCategoryFilter.beginner:
        return items
            .where((item) => item.difficulty == FaqDifficulty.beginner)
            .toList(growable: false);
      case FaqCategoryFilter.intermediate:
        return items
            .where((item) => item.difficulty == FaqDifficulty.intermediate)
            .toList(growable: false);
    }
  }

  String _filterLabel(FaqCategoryFilter filter) {
    switch (filter) {
      case FaqCategoryFilter.all:
        return 'All';
      case FaqCategoryFilter.featured:
        return 'Featured';
      case FaqCategoryFilter.beginner:
        return 'Beginner';
      case FaqCategoryFilter.intermediate:
        return 'Intermediate';
    }
  }
}
