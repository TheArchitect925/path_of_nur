import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_experience_provider.dart';
import '../application/kids_dua_progress_provider.dart';
import '../application/kids_dua_repository.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_localized_content.dart';

class KidsDuaRewardsPage extends ConsumerWidget {
  const KidsDuaRewardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rewards = ref.watch(kidsDuaRewardsProvider);
    final state = ref.watch(kidsDuaLearningProvider);
    final summary = ref.watch(kidsDuaProgressSummaryProvider);
    final categoryProgress = ref.watch(kidsDuaCategoryProgressListProvider);
    final unlockedStickers = ref.watch(kidsDuaUnlockedStickersProvider);
    final lockedStickers = ref.watch(kidsDuaLockedStickersProvider);
    final unlockedRewards = rewards
        .where((reward) => state.unlockedRewardIds.contains(reward.id))
        .toList(growable: false);
    final lockedRewards = rewards
        .where((reward) => !state.unlockedRewardIds.contains(reward.id))
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.kidsDuaRewardsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8EF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7D7BE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsDuaRewardsEncouragement,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _Pill(
                      label: l10n.kidsDuaLearnedCountValue(
                        summary.learnedLessons,
                      ),
                    ),
                    _Pill(
                      label: l10n.kidsDuaCategoryCountValue(
                        summary.completedCategories,
                      ),
                    ),
                    _Pill(
                      label: l10n.kidsDuaRewardsCountValue(
                        state.unlockedRewardIds.length,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.kidsDuaStickerCollectionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          if (unlockedStickers.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8DDD0)),
              ),
              child: Text(
                l10n.kidsDuaStickerCollectionEmpty,
                style: const TextStyle(color: Color(0xFF675B4E)),
              ),
            )
          else
            ...unlockedStickers.map(
              (sticker) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StickerTile(sticker: sticker, unlocked: true),
              ),
            ),
          ...lockedStickers.map(
            (sticker) => Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _StickerTile(sticker: sticker, unlocked: false),
            ),
          ),
          const SizedBox(height: 16),
          if (unlockedRewards.isNotEmpty) ...[
            Text(
              l10n.kidsDuaRewardsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...unlockedRewards.map(
              (reward) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RewardTile(reward: reward, unlocked: true),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            l10n.kidsDuaCategoriesTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...categoryProgress.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8DDD0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.category.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      l10n.kidsDuaCategoryProgressValue(
                        item.learnedCount,
                        item.totalCount,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...lockedRewards.map(
            (reward) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RewardTile(reward: reward, unlocked: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickerTile extends StatelessWidget {
  const _StickerTile({required this.sticker, required this.unlocked});

  final KidsDuaSticker sticker;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked ? Colors.white : const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: sticker.color.withValues(
              alpha: unlocked ? 1 : 0.35,
            ),
            child: Icon(sticker.icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              localizedKidsDuaRewardTitle(l10n, sticker.titleKey),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            unlocked
                ? l10n.kidsDuaStatusLearned
                : l10n.kidsDuaStickerLockedLabel,
            style: const TextStyle(color: Color(0xFF675B4E)),
          ),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.reward, required this.unlocked});

  final KidsDuaRewardItem reward;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked ? Colors.white : const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: reward.color.withValues(
              alpha: unlocked ? 1 : 0.35,
            ),
            child: Icon(reward.icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedKidsDuaRewardTitle(l10n, reward.titleKey),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  localizedKidsDuaRewardSubtitle(l10n, reward.subtitleKey),
                  style: const TextStyle(color: Color(0xFF675B4E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE4D7C8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
