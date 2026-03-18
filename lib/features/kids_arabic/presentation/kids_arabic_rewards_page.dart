import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../data/kids_arabic_letters_data.dart';
import 'kids_arabic_localized_content.dart';

class KidsArabicRewardsPage extends ConsumerWidget {
  const KidsArabicRewardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(kidsArabicProgressProvider);
    return LearnHubPageScaffold(
      headerIcon: Icons.emoji_events_rounded,
      title: l10n.kidsArabicRewardsTitle,
      subtitle: l10n.kidsArabicRewardsSubtitle,
      children: [
        ...kidsArabicStickerDefinitions.map(
          (sticker) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: progress.earnedStickerIds.contains(sticker.id)
                    ? const Color(0xFFF8F2E8)
                    : const Color(0xFFF5F1EB),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: progress.earnedStickerIds.contains(sticker.id)
                      ? sticker.color.withValues(alpha: 0.45)
                      : const Color(0xFFE4D8CC),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: sticker.color.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(sticker.icon, color: sticker.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizedKidsArabicStickerTitle(l10n, sticker.id),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E261F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizedKidsArabicStickerSubtitle(l10n, sticker.id),
                          style: const TextStyle(
                            color: Color(0xFF675B4E),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    progress.earnedStickerIds.contains(sticker.id)
                        ? l10n.kidsArabicStickerEarned
                        : l10n.kidsArabicStickerLocked,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: progress.earnedStickerIds.contains(sticker.id)
                          ? const Color(0xFF52713A)
                          : const Color(0xFF8A6C49),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
