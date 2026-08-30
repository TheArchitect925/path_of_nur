import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../application/quran_providers.dart';

class QuranWordReviewPage extends ConsumerStatefulWidget {
  const QuranWordReviewPage({super.key});

  @override
  ConsumerState<QuranWordReviewPage> createState() =>
      _QuranWordReviewPageState();
}

class _QuranWordReviewPageState extends ConsumerState<QuranWordReviewPage> {
  var _index = 0;
  var _revealed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deck = ref.watch(quranWordReviewDeckProvider);
    final favoritesNotifier = ref.read(quranWordFavoritesProvider.notifier);
    final reviewNotifier = ref.read(quranWordReviewProgressProvider.notifier);

    if (deck.isEmpty) {
      return AppPageScaffold(
        headerIcon: Icons.style_outlined,
        title: l10n.quranWordReviewTitle,
        subtitle: l10n.quranWordReviewSubtitle,
        children: [PremiumCard(child: Text(l10n.quranWordReviewEmpty))],
      );
    }

    final safeIndex = _index.clamp(0, deck.length - 1);
    final word = deck[safeIndex];

    return AppPageScaffold(
      headerIcon: Icons.style_outlined,
      title: l10n.quranWordReviewTitle,
      subtitle: l10n.quranWordReviewProgressLabel(safeIndex + 1, deck.length),
      children: [
        PremiumCard(
          child: Column(
            children: [
              Text(
                word.arabic,
                style: AppTextStyles.arabicLearning(
                  size: 56,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              if (_revealed) ...[
                Text(
                  word.transliteration,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.gloss,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ] else
                Text(
                  l10n.quranWordReviewRevealHint,
                  style: TextStyle(color: context.palette.onSurfaceSubtle),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _revealed = !_revealed),
                      child: Text(
                        _revealed
                            ? l10n.quranWordReviewHide
                            : l10n.quranWordReviewReveal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        reviewNotifier.grade(word.arabic, 1);
                        favoritesNotifier.markReviewed(word.arabic);
                        setState(() {
                          _revealed = false;
                          _index = (_index + 1) % deck.length;
                        });
                      },
                      child: Text(l10n.quranWordReviewAgain),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        reviewNotifier.grade(word.arabic, 3);
                        favoritesNotifier.markReviewed(word.arabic);
                        setState(() {
                          _revealed = false;
                          _index = (_index + 1) % deck.length;
                        });
                      },
                      child: Text(l10n.quranWordReviewEasy),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
