import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/life_progress_provider.dart';
import '../data/life_curriculum_data.dart';
import '../domain/life_models.dart';

class LifeThemePage extends ConsumerWidget {
  const LifeThemePage({super.key, required this.themeId});

  final String themeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = lifeThemeById(themeId);
    if (theme == null) {
      return AppPageScaffold(
        headerIcon: Icons.family_restroom_rounded,
        title: l10n.learnLifeSectionTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final subcategories = lifeSubcategoriesForTheme(theme.id);
    final progress = ref.watch(lifeThemeProgressProvider(theme.id));

    LifeSubcategory? nextSubcategory;
    for (final sub in subcategories) {
      final p = ref.watch(lifeSubcategoryProgressProvider(sub.id));
      if (p.completedLessons < p.totalLessons) {
        nextSubcategory = sub;
        break;
      }
    }

    return AppPageScaffold(
      headerIcon: Icons.auto_stories_rounded,
      title: theme.title,
      subtitle: theme.summary,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lifeThemeWhyMattersTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(theme.whyItMatters),
              const SizedBox(height: 8),
              Text(
                l10n.lifeThemeProgress(
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
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.lifeThemeNextSubcategoryTitle),
              subtitle: Text(nextSubcategory.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(
                'lifeSubcategoryDetail',
                pathParameters: {'subcategoryId': nextSubcategory!.id},
              ),
            ),
          ),
        if (nextSubcategory != null) const SizedBox(height: 12),
        if (theme.id == 'family')
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.babyNamesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(l10n.babyNamesSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed('babyNamesHome'),
            ),
          ),
        if (theme.id == 'family') const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lifeSubcategoriesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...subcategories.map((sub) {
                final p = ref.watch(lifeSubcategoryProgressProvider(sub.id));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(sub.title),
                    subtitle: Text(
                      '${sub.summary}\n${l10n.lifeSubcategoryProgress(p.completedLessons, p.totalLessons)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(
                      'lifeSubcategoryDetail',
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
                l10n.lifeSuggestedPathTitle,
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
