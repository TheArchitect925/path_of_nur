import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';

class KidsStarterPathNextStepsPage extends StatelessWidget {
  const KidsStarterPathNextStepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const analytics = LearnAnalyticsService();
    return LearnHubPageScaffold(
      headerIcon: Icons.celebration_rounded,
      title: l10n.learnKidsStarterNextStepsTitle,
      subtitle: l10n.learnKidsStarterNextStepsSubtitle,
      showDefaultQuote: false,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnKidsStarterNextStepsIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.learnKidsStarterNextStepsIntroBody),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () {
                  analytics.logPrimaryCardOpened(
                    cardId: 'kids_dua_bismillah',
                    sourceSurface: 'kids_starter_next_steps',
                    domain: 'kids',
                    audience: LearnAnalyticsAudience.kids,
                  );
                  context.pushNamed(
                    'kidsDuaLesson',
                    pathParameters: const <String, String>{
                      'lessonId': 'bismillah',
                    },
                  );
                },
                icon: const Icon(Icons.favorite_border_rounded),
                label: Text(l10n.learnKidsStarterNextStepsOpenDuaAction),
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
                l10n.learnKidsStarterNextStepsSectionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.learnKidsStarterNextStepsSectionSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              _LaneCard(
                icon: Icons.translate_rounded,
                title: l10n.kidsArabicHomeTitle,
                helperText: l10n.learnKidsStarterNextStepsArabicHint,
                onPressed: () {
                  analytics.logRelatedContentOpened(
                    sourceId: 'kids_starter_next_steps',
                    targetId: 'kids_arabic',
                    sourceSurface: 'kids_starter_next_steps',
                  );
                  context.pushNamed('kidsArabicHome');
                },
              ),
              const SizedBox(height: 12),
              _LaneCard(
                icon: Icons.auto_stories_rounded,
                title: l10n.learnHubMainIslandStoriesTitle,
                helperText: l10n.learnKidsStarterNextStepsStoriesHint,
                onPressed: () {
                  analytics.logRelatedContentOpened(
                    sourceId: 'kids_starter_next_steps',
                    targetId: 'kids_stories',
                    sourceSurface: 'kids_starter_next_steps',
                  );
                  context.pushNamed('learnKidsProphetStories');
                },
              ),
              const SizedBox(height: 12),
              _LaneCard(
                icon: Icons.favorite_rounded,
                title: l10n.kidsDuaLandingTitle,
                helperText: l10n.learnKidsStarterNextStepsDuasHint,
                onPressed: () {
                  analytics.logRelatedContentOpened(
                    sourceId: 'kids_starter_next_steps',
                    targetId: 'kids_duas',
                    sourceSurface: 'kids_starter_next_steps',
                  );
                  context.pushNamed('kidsDuaLanding');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LaneCard extends StatelessWidget {
  const _LaneCard({
    required this.icon,
    required this.title,
    required this.helperText,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String helperText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
        color: accent.withValues(alpha: 0.04),
      ),
      child: PremiumCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(helperText),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      AppLocalizations.of(
                        context,
                      ).guidedLearningPathStepOpenAction,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
