import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/spiritual_growth_provider.dart';
import 'spiritual_growth_ui_helpers.dart';

class SpiritualGrowthIntentionPickerPage extends ConsumerWidget {
  const SpiritualGrowthIntentionPickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
    final ranked = ref.watch(spiritualGrowthRankedIntentionsProvider);
    final selectedId = ref.watch(
      spiritualGrowthControllerProvider.select(
        (value) => value.selectedIntentionFor(todayKey),
      ),
    );
    final suggested = ref.watch(spiritualGrowthSuggestedIntentionProvider);

    return AppPageScaffold(
      title: l10n.spiritualGrowthChooseIntentionAction,
      subtitle: l10n.spiritualGrowthChooseIntentionPageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.spiritualGrowthSuggestedIntentionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                spiritualGrowthTitleFromKey(l10n, suggested.titleKey),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(spiritualGrowthSubtitleFromKey(l10n, suggested.descriptionKey)),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  ref
                      .read(spiritualGrowthControllerProvider.notifier)
                      .chooseIntention(dateKey: todayKey, intentionId: suggested.id);
                  Navigator.of(context).maybePop();
                },
                child: Text(l10n.spiritualGrowthAcceptIntentionAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...ranked.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spiritualGrowthTitleFromKey(l10n, item.titleKey),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          spiritualGrowthSubtitleFromKey(
                            l10n,
                            item.descriptionKey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          spiritualGrowthThemeLabel(l10n, item.theme),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6A5A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(spiritualGrowthControllerProvider.notifier)
                          .chooseIntention(
                            dateKey: todayKey,
                            intentionId: item.id,
                          );
                      Navigator.of(context).maybePop();
                    },
                    icon: Icon(
                      selectedId == item.id
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
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
