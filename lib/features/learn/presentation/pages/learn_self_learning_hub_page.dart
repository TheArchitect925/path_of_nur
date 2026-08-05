import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../application/learn_hub_providers.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_hub_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class LearnSelfLearningHubPage extends ConsumerWidget {
  const LearnSelfLearningHubPage({super.key});

  static const Set<LearnHubCategoryId> _excludedCategories = {
    LearnHubCategoryId.notes,
    LearnHubCategoryId.toolsExplore,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final categories = ref.watch(learnHubCategoriesProvider);
    final moduleCategories = categories
        .where((category) => !_excludedCategories.contains(category.id))
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: Icons.auto_stories_rounded,
      title: l10n.learnHubMainIslandSelfLearningTitle,
      subtitle: l10n.learnHubMainIslandSelfLearningSubtitle,
      quoteHeader: const LearningHubRabbiZidniIlmaHeader(),
      children: [
        _SectionHeader(
          title: l10n.learnSelfLearningModulesTitle,
          subtitle: l10n.learnSelfLearningModulesSubtitle,
        ),
        const SizedBox(height: 10),
        SectionHubActionGrid(
          actions: [
            for (final category in moduleCategories)
              _buildAction(context, analytics: analytics, category: category),
          ],
        ),
      ],
    );
  }

  SectionHubAction _buildAction(
    BuildContext context, {
    required LearnAnalyticsService analytics,
    required LearnHubCategoryDescriptor category,
  }) {
    final style = LearnHubTaxonomy.styleFor(category.id);
    return SectionHubAction(
      title: category.title,
      subtitle: category.subtitle,
      icon: style.icon,
      color: style.baseColor,
      accentColor: style.accentColor,
      onTap: () {
        analytics.logPrimaryCardOpened(
          cardId: 'self_learning_${LearnHubTaxonomy.categorySlug(category.id)}',
          sourceSurface: 'learn_self_learning',
          domain: LearnHubTaxonomy.categorySlug(category.id),
          audience: category.id == LearnHubCategoryId.kidsLearning
              ? LearnAnalyticsAudience.kids
              : LearnAnalyticsAudience.general,
        );
        context.pushNamed(
          category.routeTarget.routeName,
          pathParameters: category.routeTarget.pathParameters,
          queryParameters: category.routeTarget.queryParameters,
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}
