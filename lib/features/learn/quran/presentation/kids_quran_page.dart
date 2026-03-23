import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/kids_learning_localizations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_providers.dart';
import '../domain/quran_surah.dart';

class KidsQuranPage extends ConsumerWidget {
  const KidsQuranPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final surahs = ref.watch(quranRepositoryProvider).getSurahs();

    return LearnHubPageScaffold(
      showDefaultQuote: false,
      headerIcon: Icons.auto_stories_rounded,
      title: l10n.kidsQuranPageTitleText,
      subtitle: l10n.kidsQuranPageSubtitleText,
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.island,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsQuranIntroTitleText,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(l10n.kidsQuranIntroSubtitleText),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...surahs.map(
          (surah) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _KidsQuranSurahTile(surah: surah),
          ),
        ),
      ],
    );
  }
}

class _KidsQuranSurahTile extends StatelessWidget {
  const _KidsQuranSurahTile({required this.surah});

  final QuranSurah surah;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: InkWell(
        onTap: () => context.pushNamed(
          'learnKidsQuranSurah',
          pathParameters: {'surahNumber': surah.number.toString()},
        ),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF6EEE2),
                ),
                child: Center(
                  child: Text(
                    '${surah.number}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.arabicName,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.kidsQuranSurahSubtitleText(surah)),
                    const SizedBox(height: 4),
                    Text(
                      l10n.kidsQuranSurahMetaText(surah),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonal(
                onPressed: () => context.pushNamed(
                  'learnKidsQuranSurah',
                  pathParameters: {'surahNumber': surah.number.toString()},
                ),
                child: Text(l10n.kidsQuranOpenSurahActionText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
