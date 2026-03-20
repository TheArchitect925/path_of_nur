import '../data/faq_seed_data.dart';
import '../models/faq_item.dart';

class FaqRepository {
  FaqRepository();
  FaqDataset? _cache;

  Future<FaqDataset> load() async {
    if (_cache != null) return _cache!;
    _cache = faqSeedDataset;
    return _cache!;
  }

  Future<List<FaqItem>> allItems() async => (await load()).items;

  Future<List<FaqCategorySummary>> categorySummaries() async {
    final dataset = await load();
    final grouped = groupByCategory(dataset.items);
    final summaries =
        grouped.entries
            .map((entry) {
              final items = entry.value;
              final featuredCount = items
                  .where((item) => item.isFeatured)
                  .length;
              return FaqCategorySummary(
                id: entry.key,
                title: dataset.categoryLabel(entry.key),
                subtitle: _categorySubtitle(entry.key),
                questionCount: items.length,
                featuredCount: featuredCount,
              );
            })
            .toList(growable: false)
          ..sort((a, b) => a.title.compareTo(b.title));
    return summaries;
  }

  Future<List<FaqItem>> featuredItems() async {
    final items = await allItems();
    final featured =
        items.where((item) => item.isFeatured).toList(growable: false)
          ..sort((a, b) => a.question.compareTo(b.question));
    return featured;
  }

  Future<List<FaqItem>> byCategory(String categoryId) async {
    final items = await allItems();
    return items
        .where((item) => item.category == categoryId)
        .toList(growable: false)
      ..sort((a, b) => a.question.compareTo(b.question));
  }

  Future<FaqItem?> byId(String id) async {
    final items = await allItems();
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<List<FaqItem>> search({
    String query = '',
    String? categoryId,
    FaqDifficulty? difficulty,
    bool featuredOnly = false,
  }) async {
    final items = await allItems();
    final normalized = query.trim().toLowerCase();
    final results =
        items
            .where((item) {
              if (categoryId != null &&
                  categoryId.isNotEmpty &&
                  item.category != categoryId) {
                return false;
              }
              if (difficulty != null && item.difficulty != difficulty) {
                return false;
              }
              if (featuredOnly && !item.isFeatured) {
                return false;
              }
              if (normalized.isEmpty) return true;
              final haystack = [
                item.question,
                item.shortAnswer,
                item.answer,
                item.misconceptionTag ?? '',
                ...item.relatedTopics,
              ].join(' ').toLowerCase();
              return haystack.contains(normalized);
            })
            .toList(growable: false)
          ..sort((a, b) {
            if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
            return a.question.compareTo(b.question);
          });
    return results;
  }

  Map<String, List<FaqItem>> groupByCategory(List<FaqItem> items) {
    final grouped = <String, List<FaqItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => <FaqItem>[]).add(item);
    }
    return grouped;
  }

  String _categorySubtitle(String categoryId) {
    switch (categoryId) {
      case 'foundations_of_islam':
        return 'Core beliefs, identity, and first principles.';
      case 'worship_and_practice':
        return 'Salah, fasting, charity, and lived practice.';
      case 'misconceptions_about_islam':
        return 'Calm clarifications on common misunderstandings.';
      case 'women_in_islam':
        return 'Questions about dignity, rights, and responsibilities.';
      case 'science_and_quran':
        return 'How Muslims approach science and the Qur’an carefully.';
      case 'quran_and_revelation':
        return 'Revelation, preservation, and the role of the Qur’an.';
      case 'prophets_and_history':
        return 'Prophets, continuity, and sacred history.';
      case 'ethics_and_lifestyle':
        return 'Character, conduct, and everyday moral questions.';
      case 'afterlife_and_purpose':
        return 'Purpose, accountability, and what comes after death.';
      case 'islam_in_the_modern_world':
        return 'Living Islam with clarity in contemporary life.';
      default:
        return 'Browse common questions in this area.';
    }
  }
}
