import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/world_progress_provider.dart';
import '../data/world_curriculum_data.dart';
import '../domain/world_models.dart';

class WorldThemePage extends ConsumerWidget {
  const WorldThemePage({super.key, required this.themeId});

  final String themeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = worldThemeById(themeId);
    if (theme == null) {
      return AppPageScaffold(
        title: l10n.learnWorldSectionTitle,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final subcategories = worldSubcategoriesForTheme(theme.id);
    final progress = ref.watch(worldThemeProgressProvider(theme.id));

    WorldSubcategory? nextSubcategory;
    for (final sub in subcategories) {
      final p = ref.watch(worldSubcategoryProgressProvider(sub.id));
      if (p.completedLessons < p.totalLessons) {
        nextSubcategory = sub;
        break;
      }
    }

    return AppPageScaffold(
      title: theme.title,
      subtitle: theme.summary,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worldThemeWhyMattersTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(theme.whyItMatters),
              const SizedBox(height: 8),
              Text(
                l10n.worldThemeProgress(
                  progress.completedLessons,
                  progress.totalLessons,
                ),
              ),
              const SizedBox(height: 8),
              ProgressBar(value: progress.ratio, height: 8),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (nextSubcategory != null)
          CompactListTile(
            title: l10n.worldThemeNextSubcategoryTitle,
            subtitle: nextSubcategory.title,
            onTap: () => context.pushNamed(
              'worldSubcategoryDetail',
              pathParameters: {'subcategoryId': nextSubcategory!.id},
            ),
          ),
        if (nextSubcategory != null) const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worldSubcategoriesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...subcategories.map((sub) {
                final p = ref.watch(worldSubcategoryProgressProvider(sub.id));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(sub.title),
                    subtitle: Text(
                      '${sub.summary}\n${l10n.worldSubcategoryProgress(p.completedLessons, p.totalLessons)}',
                    ),
                    onTap: () => context.pushNamed(
                      'worldSubcategoryDetail',
                      pathParameters: {'subcategoryId': sub.id},
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worldSuggestedPathTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...subcategories.map(
                (sub) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• ${sub.title}'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
