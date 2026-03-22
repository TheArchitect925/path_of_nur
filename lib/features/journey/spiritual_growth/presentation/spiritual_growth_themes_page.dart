import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/spiritual_growth_provider.dart';
import 'spiritual_growth_ui_helpers.dart';

class SpiritualGrowthThemesPage extends ConsumerWidget {
  const SpiritualGrowthThemesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(spiritualGrowthProfileProvider);
    final themes = ref.watch(spiritualGrowthThemeSummariesProvider);

    return AppPageScaffold(
      title: l10n.spiritualGrowthThemeSummaryTitle,
      subtitle: l10n.spiritualGrowthThemePageSubtitle,
      children: [
        if (profile.strongestTheme != null || profile.recommendedTheme != null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.spiritualGrowthThemeInsightTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (profile.strongestTheme != null)
                  Text(
                    l10n.spiritualGrowthStrongestThemeLabel(
                      spiritualGrowthThemeLabel(l10n, profile.strongestTheme!),
                    ),
                  ),
                if (profile.recommendedTheme != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.spiritualGrowthRecommendedThemeLabel(
                        spiritualGrowthThemeLabel(
                          l10n,
                          profile.recommendedTheme!,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (profile.strongestTheme != null || profile.recommendedTheme != null)
          const SizedBox(height: 12),
        ...themes.map(
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
                          spiritualGrowthThemeLabel(l10n, item.theme),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.spiritualGrowthThemeCountLabel(
                            item.activityCount.toString(),
                            item.consistencyCount.toString(),
                          ),
                        ),
                      ],
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
