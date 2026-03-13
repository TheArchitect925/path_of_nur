import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/faq_item.dart';
import '../repository/faq_repository.dart';

final faqRepositoryProvider = Provider<FaqRepository>((ref) {
  return FaqRepository();
});

final faqDatasetProvider = FutureProvider<FaqDataset>((ref) async {
  return ref.watch(faqRepositoryProvider).load();
});

final faqCategorySummariesProvider = FutureProvider<List<FaqCategorySummary>>((
  ref,
) async {
  return ref.watch(faqRepositoryProvider).categorySummaries();
});

final featuredFaqItemsProvider = FutureProvider<List<FaqItem>>((ref) async {
  return ref.watch(faqRepositoryProvider).featuredItems();
});

final faqItemByIdProvider = FutureProvider.family<FaqItem?, String>((
  ref,
  id,
) async {
  return ref.watch(faqRepositoryProvider).byId(id);
});

class FaqSearchQuery {
  const FaqSearchQuery({
    this.query = '',
    this.categoryId,
    this.difficulty,
    this.featuredOnly = false,
  });

  final String query;
  final String? categoryId;
  final FaqDifficulty? difficulty;
  final bool featuredOnly;
}

final faqSearchProvider = FutureProvider.family<List<FaqItem>, FaqSearchQuery>((
  ref,
  request,
) async {
  return ref
      .watch(faqRepositoryProvider)
      .search(
        query: request.query,
        categoryId: request.categoryId,
        difficulty: request.difficulty,
        featuredOnly: request.featuredOnly,
      );
});

final faqByCategoryProvider = FutureProvider.family<List<FaqItem>, String>((
  ref,
  categoryId,
) async {
  return ref.watch(faqRepositoryProvider).byCategory(categoryId);
});
