import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../application/quran_providers.dart';

class QuranSearchPage extends ConsumerWidget {
  const QuranSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(quranSearchQueryProvider);
    final results = ref.watch(quranSearchResultsProvider);
    final recent = ref.watch(quranRecentSearchesProvider);

    return AppPageScaffold(
      headerIcon: Icons.search,
      title: l10n.quranSearchTitle,
      subtitle: l10n.quranSearchSubtitle,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            autofocus: true,
            onChanged: (value) =>
                ref.read(quranSearchQueryProvider.notifier).state = value,
            onSubmitted: (value) =>
                ref.read(quranRecentSearchesProvider.notifier).addSearch(value),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: l10n.quranSearchHint,
              suffixIcon: IconButton(
                onPressed: () =>
                    ref.read(quranSearchQueryProvider.notifier).state = '',
                icon: const Icon(Icons.close, size: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (query.trim().isEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranRecentSearches,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                if (recent.isEmpty)
                  Text(l10n.quranSearchNoRecent)
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recent
                        .map(
                          (item) => ActionChip(
                            label: Text(item),
                            onPressed: () {
                              ref.read(quranSearchQueryProvider.notifier).state = item;
                            },
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      ref.read(quranRecentSearchesProvider.notifier).clear(),
                  child: Text(l10n.quranClearRecent),
                ),
              ],
            ),
          ),
        ] else if (results.isEmpty) ...[
          PremiumCard(child: Text(l10n.quranSearchNoResults)),
        ] else ...[
          ...results.map(
            (result) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    result.ayah == null
                        ? result.surah.transliteratedName
                        : '${result.surah.transliteratedName} ${result.ayah!.ayahNumber}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    result.matchText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref.read(quranRecentSearchesProvider.notifier).addSearch(query);
                    context.pushNamed(
                      'quranReader',
                      pathParameters: {
                        'surahNumber': result.surah.number.toString(),
                      },
                      queryParameters: result.ayah == null
                          ? const {}
                          : {'ayah': result.ayah!.ayahNumber.toString()},
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
