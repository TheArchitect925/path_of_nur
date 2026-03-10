import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../data/important_hadith_data.dart';
import '../domain/important_hadith.dart';

class ImportantHadithCollectionPage extends StatefulWidget {
  const ImportantHadithCollectionPage({super.key});

  @override
  State<ImportantHadithCollectionPage> createState() =>
      _ImportantHadithCollectionPageState();
}

class _ImportantHadithCollectionPageState
    extends State<ImportantHadithCollectionPage> {
  static const _allCollections = 'all';

  String _query = '';
  String _collection = _allCollections;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final collectionIds = importantHadithCollectionOrder();
    final visible = _visibleEntries();

    return AppPageScaffold(
      headerIcon: Icons.library_books_rounded,
      title: '50 Important Ahadith',
      subtitle: 'Curated from your uploaded source and grouped by study path.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeSearchHint,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search hadith title, number, or theme',
                  prefixIcon: Icon(Icons.search_rounded),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: _collection == _allCollections,
                        onSelected: (_) =>
                            setState(() => _collection = _allCollections),
                      ),
                    ),
                    ...collectionIds.map((collectionId) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            importantHadithCollectionTitle(collectionId),
                          ),
                          selected: _collection == collectionId,
                          onSelected: (_) =>
                              setState(() => _collection = collectionId),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Source',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text(
              'The 50 Important Ahadith (Quran Memorization Guide, 2022)',
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (visible.isEmpty)
          PremiumCard(child: Text(l10n.learnResumeTopicSubtitleEmpty))
        else
          ...visible.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Hadith ${item.number}: ${item.title}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(item.summary),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(
                    'hadithImportantDetail',
                    pathParameters: {'number': item.number.toString()},
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  List<ImportantHadithEntry> _visibleEntries() {
    final query = _query.trim().toLowerCase();
    return importantHadithEntries
        .where((item) {
          if (_collection != _allCollections &&
              item.collectionId != _collection) {
            return false;
          }
          if (query.isEmpty) return true;
          return item.title.toLowerCase().contains(query) ||
              item.number.toString() == query ||
              item.collectionTitle.toLowerCase().contains(query) ||
              item.themes.any((tag) => tag.toLowerCase().contains(query));
        })
        .toList(growable: false);
  }
}
