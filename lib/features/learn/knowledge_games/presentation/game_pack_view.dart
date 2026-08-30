import 'package:flutter/material.dart';

import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';

/// Shared chrome for the puzzle families' pack pages.
///
/// Word search, crossword, matching, ayah completion and hadith reflection all
/// shipped the same pack page: a summary card of chips over a progress bar and
/// a resume button, then a list of puzzle cards. The five copies had drifted on
/// spacing, chip alpha and whether the whole card was tappable, and none of
/// them used the display kit. This is the one implementation they share; each
/// family supplies its own strings, chips and routes.
class GamePackChip extends StatelessWidget {
  const GamePackChip(this.label, {super.key, this.emphasis = false});

  final String label;

  /// Slightly stronger surface. Used on the summary card, where chips sit on
  /// the page background rather than inside a puzzle card.
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: emphasis ? 0.55 : 0.45),
        borderRadius: BorderRadius.circular(999),
        border: emphasis
            ? Border.all(color: scheme.outline.withValues(alpha: 0.2))
            : null,
      ),
      child: Text(label),
    );
  }
}

/// A line under an item's title — grid size, an ayah reference, a scenario
/// summary. [maxLines] clamps prose that would otherwise stretch the card.
class GamePackDetail {
  const GamePackDetail(this.text, {this.maxLines, this.subdued = false});

  final String text;
  final int? maxLines;

  /// Renders at caption weight, for a secondary line under a description.
  final bool subdued;
}

/// One puzzle within a pack.
class GamePackItem {
  const GamePackItem({
    required this.title,
    required this.chips,
    required this.onOpen,
    this.details = const <GamePackDetail>[],
    this.actionLabel,
    this.actionIcon,
  });

  final String title;
  final List<String> chips;
  final List<GamePackDetail> details;

  /// Omit both to leave the card tap as the only affordance, which is what
  /// the reflection scenarios do — their cards are prose, not a control.
  final String? actionLabel;
  final IconData? actionIcon;

  final VoidCallback onOpen;
}

class GamePackView extends StatelessWidget {
  const GamePackView({
    super.key,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    required this.summaryChips,
    required this.progress,
    required this.items,
    this.primaryActionLabel,
    this.onPrimaryAction,
  });

  final IconData headerIcon;
  final String title;
  final String subtitle;
  final List<String> summaryChips;

  /// Pack completion in [0, 1].
  final double progress;

  /// Omitted when nothing is recommendable — crossword hides the button when
  /// no puzzle fits the reader's level band.
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  final List<GamePackItem> items;

  @override
  Widget build(BuildContext context) {
    return LearnHubPageScaffold(
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chip in summaryChips)
                    GamePackChip(chip, emphasis: true),
                ],
              ),
              const SizedBox(height: 12),
              ProgressBar(value: progress, height: 8),
              if (primaryActionLabel != null) ...[
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: onPrimaryAction,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(primaryActionLabel!),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _GamePackItemCard(item: item),
          ),
      ],
    );
  }
}

class _GamePackItemCard extends StatelessWidget {
  const _GamePackItemCard({required this.item});

  final GamePackItem item;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      // The whole card opens the puzzle, and the button stays for the explicit
      // affordance. Families were previously split between the two.
      onTap: item.onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.chips.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final chip in item.chips) GamePackChip(chip)],
            ),
            const SizedBox(height: 10),
          ],
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          for (final detail in item.details) ...[
            const SizedBox(height: 6),
            Text(
              detail.text,
              maxLines: detail.maxLines,
              overflow: detail.maxLines == null ? null : TextOverflow.ellipsis,
              style: detail.subdued
                  ? Theme.of(context).textTheme.bodySmall
                  : null,
            ),
          ],
          if (item.actionLabel != null) ...[
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: item.onOpen,
              icon: Icon(item.actionIcon ?? Icons.play_arrow_rounded),
              label: Text(item.actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// The loading / error / not-found / kids-gated states every pack and home
/// page needs, in the section's own shell rather than five hand-rolled copies.
class GameStatePage extends StatelessWidget {
  const GameStatePage({
    super.key,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    this.message,
    this.isLoading = false,
  });

  final IconData headerIcon;
  final String title;
  final String subtitle;
  final String? message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return LearnHubPageScaffold(
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      children: [
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (message != null)
          PremiumCard(child: Text(message!)),
      ],
    );
  }
}
