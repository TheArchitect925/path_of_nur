import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/assistant_provider.dart';

class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(assistantProvider);
    final notifier = ref.read(assistantProvider.notifier);
    final modePrompts = ref.watch(assistantModeAwarePromptProvider);
    final quickActions = ref.watch(assistantQuickActionsProvider);

    return AppPageScaffold(
      headerIcon: Icons.smart_toy_outlined,
      title: l10n.assistantTitle,
      subtitle: l10n.assistantSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.assistantQuickPromptsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: modePrompts
                    .map(
                      (prompt) => ActionChip(
                        label: Text(prompt),
                        onPressed: () {
                          _controller.text = prompt;
                          notifier.send(prompt);
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.assistantRecentPromptsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              if (state.recentPrompts.isEmpty)
                Text(l10n.assistantEmptyState)
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.recentPrompts
                      .take(6)
                      .map(
                        (prompt) => ActionChip(
                          label: Text(prompt),
                          onPressed: () {
                            _controller.text = prompt;
                          },
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.assistantQuickActionsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickActions
                    .map(
                      (item) => FilledButton.tonal(
                        onPressed: () => context.pushNamed(item.routeName),
                        child: Text(_actionLabel(l10n, item.routeName)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.messages.isEmpty)
                Text(l10n.assistantEmptyState)
              else
                ...state.messages.map(
                  (message) => Align(
                    alignment: message.role == AssistantRole.user
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: message.role == AssistantRole.user
                            ? const Color(0xFFE6DCCF)
                            : const Color(0xFFF2E8DA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message.text),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: l10n.assistantInputHint,
                  ),
                  onSubmitted: (value) {
                    notifier.send(value);
                    _controller.clear();
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  notifier.send(_controller.text);
                  _controller.clear();
                },
                icon: const Icon(Icons.send_rounded),
              ),
              IconButton(
                onPressed: notifier.clear,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _actionLabel(AppLocalizations l10n, String routeName) {
    switch (routeName) {
      case 'learnLifeLanding':
        return l10n.navLearning;
      case 'quranExplorer':
        return l10n.learnTabQuran;
      case 'journalTimeline':
        return l10n.journalTitle;
      case 'circlesDiscovery':
        return l10n.circlesTitle;
      default:
        return l10n.assistantTitle;
    }
  }
}
