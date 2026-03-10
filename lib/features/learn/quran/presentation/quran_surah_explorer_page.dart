import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../application/quran_providers.dart';

class QuranSurahExplorerPage extends ConsumerWidget {
  const QuranSurahExplorerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final surahs = ref.watch(quranFilteredSurahListProvider);

    return AppPageScaffold(
      headerIcon: Icons.explore_outlined,
      title: l10n.quranExplorerTitle,
      subtitle: l10n.quranExplorerSubtitle,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: (value) =>
                      ref.read(quranSearchQueryProvider.notifier).state = value,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: l10n.quranSearchHint,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.pushNamed('quranSearch'),
                icon: const Icon(Icons.tune_rounded, size: 18),
                tooltip: l10n.quranSearchTitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (surahs.isEmpty)
          PremiumCard(
            child: Text(l10n.quranSearchNoResults),
          )
        else
          ...surahs.map(
            (surah) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: InkWell(
                  onTap: () => context.pushNamed(
                    'quranReader',
                    pathParameters: {'surahNumber': surah.number.toString()},
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8C49A).withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          surah.number.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah.arabicName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${surah.transliteratedName} • ${surah.englishName}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6A5A4A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${surah.verseCount} ${l10n.quranAyahsLabel} • ${surah.revelationPlace}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A5A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
