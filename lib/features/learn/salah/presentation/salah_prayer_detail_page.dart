import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/salah_trainer_provider.dart';
import '../models/salah_trainer_models.dart';

class SalahPrayerDetailPage extends ConsumerWidget {
  const SalahPrayerDetailPage({
    super.key,
    required this.prayerId,
    this.focusSteps = false,
  });

  final SalahPrayerId prayerId;
  final bool focusSteps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prayer = ref.watch(salahTrainerPrayerByIdProvider(prayerId));
    final settings = ref.watch(prayerSettingsProvider);
    if (prayer == null) {
      return Scaffold(body: Center(child: Text(l10n.salahPrayerDetailNotFound)));
    }
    final madhhabLabel =
        prayerMadhabKey[settings.preferences.madhab] ?? "Shafi'i";
    final madhhabNote = prayer.madhhabGuidance[madhhabLabel];

    return LearnHubPageScaffold(
      title: prayer.title,
      subtitle: prayer.shortDescription,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prayer.arabicTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(prayer.sunnahRakahs),
                  _chip(prayer.fardRakahs),
                  _chip(prayer.recitationStyle),
                ],
              ),
              const SizedBox(height: 12),
              Text(prayer.overview),
              if (focusSteps) ...[
                const SizedBox(height: 10),
                Text(
                  'Step view focus enabled. Review the movement order slowly from top to bottom.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'learnSalahGuidedPrayer',
                  pathParameters: {'prayerId': prayer.id.name},
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.learnSalahHubStartGuidedSalahAction),
              ),
            ],
          ),
        ),
        if (madhhabNote != null || prayer.specialNotes.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guidance Notes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (madhhabNote != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '$madhhabLabel guidance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(madhhabNote),
                ],
                if (prayer.specialNotes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...prayer.specialNotes.map(
                    (note) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(Icons.circle, size: 6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(note)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        ...prayer.guidedRakahs.map(
          (rakah) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rakah.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...rakah.steps.map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _StepRow(step: step),
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

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final PrayerStepModel step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Icon(Icons.circle, size: 7),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (step.helperText != null) ...[
                const SizedBox(height: 3),
                Text(
                  step.helperText!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 4),
              Text(step.translation),
            ],
          ),
        ),
      ],
    );
  }
}
