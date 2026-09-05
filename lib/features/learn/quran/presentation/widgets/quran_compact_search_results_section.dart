import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../application/quran_providers.dart';
import '../../application/quran_search_support.dart';
import 'quran_search_highlight_text.dart';

class QuranCompactSearchResultsSection extends ConsumerWidget {
  const QuranCompactSearchResultsSection({
    super.key,
    required this.query,
    this.maxResults = 3,
    this.showSeeAllAction = true,
  });

  final String query;
  final int maxResults;
  final bool showSeeAllAction;

  QuranSearchPresentationMetadata _buildCompactMetadata(
    QuranSearchResult result,
    String query,
  ) {
    final metadata = buildQuranSearchPresentationMetadata(
      field: result.matchField,
      query: query,
      sourceText: result.matchText,
      maxWords: 8,
    );
    if (metadata.snippetText.trim().isNotEmpty) {
      return metadata;
    }
    return QuranSearchPresentationMetadata(
      field: result.matchField,
      snippetText: result.snippetText,
      highlightTerms: result.highlightTerms,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final resultsAsync = ref.watch(
      quranTextSearchResultsProvider(
        QuranTextSearchQuery(query: trimmedQuery, maxResults: 7000),
      ),
    );
    final allResults =
        resultsAsync.asData?.value ?? const <QuranSearchResult>[];
    final results = allResults.take(maxResults).toList(growable: false);
    final totalResults = allResults.length;

    if (results.isEmpty && !resultsAsync.isLoading) {
      return const SizedBox.shrink();
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quranSearchTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              if (showSeeAllAction)
                TextButton(
                  onPressed: () => context.pushNamed(
                    'quranSearch',
                    queryParameters: {'q': trimmedQuery},
                  ),
                  child: Text(l10n.quranSearchTitle),
                ),
            ],
          ),
          if (resultsAsync.isLoading && results.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else ...[
            ...results.map((result) {
              final compactMetadata = _buildCompactMetadata(
                result,
                trimmedQuery,
              );
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  result.ayah == null
                      ? result.surah.transliteratedName
                      : '${result.surah.transliteratedName} ${result.ayah!.ayahNumber}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (result.ayah?.arabic.trim().isNotEmpty == true &&
                        result.matchField == QuranSearchMatchField.arabic)
                      QuranSearchHighlightedText(
                        text: compactMetadata.snippetText,
                        highlightTerms: compactMetadata.highlightTerms,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppFonts.quranArabic,
                        ),
                      ),
                    if (result.matchField ==
                        QuranSearchMatchField.transliteration)
                      QuranSearchHighlightedText(
                        text: compactMetadata.snippetText,
                        highlightTerms: compactMetadata.highlightTerms,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (result.matchField ==
                            QuranSearchMatchField.translation ||
                        result.matchField == QuranSearchMatchField.surah)
                      QuranSearchHighlightedText(
                        text: compactMetadata.snippetText,
                        highlightTerms: compactMetadata.highlightTerms,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else if (result.ayah?.translation.trim().isNotEmpty == true)
                      Text(
                        result.ayah!.translation,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      QuranSearchHighlightedText(
                        text: compactMetadata.snippetText,
                        highlightTerms: compactMetadata.highlightTerms,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                isThreeLine: result.ayah != null,
                onTap: () {
                  ref
                      .read(quranRecentSearchesProvider.notifier)
                      .addSearch(trimmedQuery);
                  openQuranReaderLocation(
                    context,
                    surahNumber: result.surah.number,
                    ayahNumber: result.ayah?.ayahNumber,
                    searchQuery: trimmedQuery,
                    searchMatchField: result.matchField,
                  );
                },
              );
            }),
            if (showSeeAllAction)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.quranSearchMoreResultsAction),
                subtitle: Text(l10n.quranSearchResultCountLabel(totalResults)),
                onTap: () => context.pushNamed(
                  'quranSearch',
                  queryParameters: {'q': trimmedQuery},
                ),
              ),
          ],
        ],
      ),
    );
  }
}
