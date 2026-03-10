import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../application/quran_providers.dart';

class QuranBookmarksPage extends ConsumerWidget {
  const QuranBookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookmarks = ref.watch(quranBookmarksProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final notifier = ref.read(quranBookmarksProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.bookmark_outline_rounded,
      title: l10n.learnQuranBookmarksTitle,
      subtitle: l10n.quranBookmarksPageSubtitle,
      children: [
        if (bookmarks.isEmpty)
          PremiumCard(
            child: Text(l10n.quranBookmarksEmpty),
          )
        else
          ...bookmarks.map((bookmark) {
            final surah = surahMap[bookmark.surahNumber];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => context.pushNamed(
                          'quranReader',
                          pathParameters: {
                            'surahNumber': bookmark.surahNumber.toString(),
                          },
                          queryParameters: {
                            'ayah': bookmark.ayahNumber.toString(),
                          },
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah?.transliteratedName ?? l10n.quranUnknownSurah,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${bookmark.surahNumber}:${bookmark.ayahNumber}',
                              style: const TextStyle(color: Color(0xFF6A5A4A)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => notifier.remove(bookmark.createdAtIso),
                      icon: const Icon(Icons.delete_outline_rounded),
                      tooltip: l10n.quranRemoveBookmark,
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
