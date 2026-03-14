import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/segmented_pill_control.dart';
import '../../creation_explorer/data/creation_explorer_catalog.dart';
import '../application/creation_challenge_services.dart';
import '../data/creation_challenge_catalog.dart';
import '../domain/creation_challenge_models.dart';

enum _CreationChallengeTab { today, history }

class CreationChallengesPage extends ConsumerStatefulWidget {
  const CreationChallengesPage({super.key});

  @override
  ConsumerState<CreationChallengesPage> createState() => _CreationChallengesPageState();
}

class _CreationChallengesPageState extends ConsumerState<CreationChallengesPage> {
  _CreationChallengeTab _tab = _CreationChallengeTab.today;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(creationChallengeServiceProvider.notifier).markViewed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(currentCreationChallengesProvider);
    final streak = ref.watch(creationChallengeStreakProvider);
    final state = ref.watch(creationChallengeServiceProvider);
    return AppPageScaffold(
      headerIcon: Icons.flag_circle_rounded,
      title: 'Creation Challenges',
      subtitle: 'Quiet prompts that help you notice creation with more intention.',
      children: [
        SegmentedPillControl<_CreationChallengeTab>(
          items: _CreationChallengeTab.values,
          selectedItem: _tab,
          labelBuilder: (tab) => tab == _CreationChallengeTab.today ? 'Today' : 'History',
          onChanged: (value) => setState(() => _tab = value),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(context, 'Daily streak', streak == 0 ? 'A new streak begins today.' : '$streak days'),
              _pill(context, 'Completed', '${state.completions.length}'),
              _pill(context, 'Recent', '${state.history.where((item) => item.completed).take(7).length} this week'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_tab == _CreationChallengeTab.today) ...[
          for (final slot in ChallengeSlot.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ChallengeCard(summary: summaries.firstWhere((item) => item.slot == slot)),
            ),
        ] else ...[
          ...state.history.take(24).map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_historyTitle(entry.challengeId)),
                  subtitle: Text(
                    '${entry.completed ? 'Completed' : 'Skipped'} • ${_dateLabel(entry.date)}',
                  ),
                  trailing: Icon(
                    entry.completed ? Icons.check_circle_rounded : Icons.remove_circle_outline_rounded,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _pill(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text('$label: $value'),
    );
  }

  String _historyTitle(String challengeId) {
    return creationChallengePool.firstWhere((item) => item.id == challengeId).title;
  }

  String _dateLabel(DateTime value) {
    return MaterialLocalizations.of(context).formatMediumDate(value);
  }
}

class _ChallengeCard extends ConsumerWidget {
  const _ChallengeCard({required this.summary});

  final CreationChallengeSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenge = summary.challenge;
    final category = challenge.targetCategoryId == null ? null : creationCategoryById[challenge.targetCategoryId!];
    final verse = challenge.verseId == null ? null : creationVerseById[challenge.verseId!];
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: (category?.colorTheme ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.16),
                child: Icon(
                  challenge.icon,
                  color: category?.colorTheme ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_slotLabel(summary.slot), style: Theme.of(context).textTheme.labelLarge),
                    Text(challenge.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(challenge.subtitle),
                  ],
                ),
              ),
              _statusChip(context),
            ],
          ),
          const SizedBox(height: 12),
          Text(challenge.description),
          if (verse != null) ...[
            const SizedBox(height: 10),
            Text(verse.ayahReference, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('"${verse.translation}"'),
          ],
          if (challenge.reflectionPrompt != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(challenge.reflectionPrompt!),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text('+${challenge.rewardDrops} drop'),
              const Spacer(),
              if (summary.isCompleted)
                const Text('Completed')
              else ...[
                if (challenge.completionRule == CreationChallengeRuleType.manualConfirm)
                  OutlinedButton(
                    onPressed: () => ref.read(creationChallengeServiceProvider.notifier).completeManually(challenge.id),
                    child: const Text('Mark complete'),
                  )
                else
                  FilledButton.tonal(
                    onPressed: () => _openChallenge(context, ref, challenge),
                    child: Text(_ctaLabel(challenge)),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => ref.read(creationChallengeServiceProvider.notifier).skipChallenge(summary.slot),
                  child: const Text('Skip'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context) {
    final (label, icon) = switch (summary.status) {
      CreationChallengeStatus.completed => ('Completed', Icons.check_circle_rounded),
      CreationChallengeStatus.expired => ('Expired', Icons.schedule_rounded),
      CreationChallengeStatus.available => ('Open', Icons.radio_button_unchecked_rounded),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  String _slotLabel(ChallengeSlot slot) {
    switch (slot) {
      case ChallengeSlot.daily:
        return 'Today’s Challenge';
      case ChallengeSlot.bonus:
        return 'Bonus Challenge';
      case ChallengeSlot.weekly:
        return 'Weekly Reflection';
    }
  }

  String _ctaLabel(CreationChallenge challenge) {
    switch (challenge.targetExplorerMode) {
      case CreationExplorerMode.skyExplorer:
        return 'Open Sky Explorer';
      case CreationExplorerMode.creationExplorer:
        return 'Open Creation Explorer';
      case CreationExplorerMode.journal:
        return 'Open Journal';
      case null:
        return challenge.challengeType == CreationChallengeType.reflect ? 'Reflect now' : 'Open';
    }
  }

  Future<void> _openChallenge(BuildContext context, WidgetRef ref, CreationChallenge challenge) async {
    await ref.read(creationChallengeServiceProvider.notifier).startChallenge(challenge.id);
    switch (challenge.targetExplorerMode) {
      case CreationExplorerMode.skyExplorer:
        if (context.mounted) context.pushNamed('skyExplorer');
        break;
      case CreationExplorerMode.creationExplorer:
      case CreationExplorerMode.journal:
        if (context.mounted) context.pushNamed('creationExplorer');
        break;
      case null:
        break;
    }
  }
}
