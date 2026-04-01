import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../analytics/application/learn_analytics_service.dart';
import '../../personalization/domain/learning_personalization_models.dart';
import '../../../../shared/widgets/premium_card.dart';

class LearnPersonalizedNextStepCard extends ConsumerWidget {
  const LearnPersonalizedNextStepCard({super.key, required this.summary});

  final LocalizedLearningPersonalizationSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(learnAnalyticsServiceProvider);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.auto_awesome_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(summary.subtitle),
                  ],
                ),
              ),
              if (summary.contextBadgeLabel != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.72),
                  ),
                  child: Text(
                    summary.contextBadgeLabel!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            summary.reasonText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (summary.progressLabel != null &&
              summary.progressValue != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: summary.progressValue!.clamp(0, 1),
                minHeight: 8,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              summary.progressLabel!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () {
                  analytics.logRecommendedActionOpened(
                    recommendationKind: summary.primaryActionLabel,
                    pathId: _pathIdFromTarget(summary.primaryActionRouteTarget),
                    sourceSurface: 'learn_landing',
                  );
                  final pathId = _pathIdFromTarget(
                    summary.primaryActionRouteTarget,
                  );
                  if (pathId != null) {
                    analytics.logRecommendedPathStarted(
                      pathId: pathId,
                      sourceSurface: 'learn_landing',
                    );
                  }
                  _open(context, summary.primaryActionRouteTarget);
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(summary.primaryActionLabel),
              ),
              if (summary.secondaryActionLabel != null &&
                  summary.secondaryActionRouteTarget != null)
                OutlinedButton.icon(
                  onPressed: () {
                    analytics.logRecommendedActionOpened(
                      recommendationKind: summary.secondaryActionLabel!,
                      pathId: _pathIdFromTarget(
                        summary.secondaryActionRouteTarget!,
                      ),
                      sourceSurface: 'learn_landing',
                    );
                    _open(context, summary.secondaryActionRouteTarget!);
                  },
                  icon: const Icon(Icons.alt_route_rounded),
                  label: Text(summary.secondaryActionLabel!),
                ),
            ],
          ),
          if (summary.secondarySuggestions.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              summary.secondarySuggestionsTitle,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...summary.secondarySuggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    analytics.logRecommendedActionOpened(
                      recommendationKind: suggestion.title,
                      pathId: suggestion.pathId,
                      sourceSurface: 'learn_landing',
                    );
                    analytics.logRecommendedPathStarted(
                      pathId: suggestion.pathId,
                      sourceSurface: 'learn_landing',
                    );
                    _open(context, suggestion.routeTarget);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.38),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion.title,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                suggestion.subtitle,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _open(BuildContext context, LearningRecommendationRouteTarget target) {
    context.pushNamed(
      target.routeName,
      pathParameters: target.pathParameters,
      queryParameters: target.queryParameters,
    );
  }

  String? _pathIdFromTarget(LearningRecommendationRouteTarget target) {
    if (target.routeName != 'learnGuidedPathDetail') {
      return null;
    }
    return target.pathParameters['pathId'];
  }
}
