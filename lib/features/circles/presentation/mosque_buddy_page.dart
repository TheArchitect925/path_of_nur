import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';

const _buddyInterests = <String>[
  'Masjid',
  'Learning',
  'Sports',
  'Family',
  'Volunteering',
  'Community',
  'Qur\'an',
  'Study',
  'Hiking',
];

const _availabilityWindows = <String>[
  'Fajr',
  'Dhuhr',
  'Asr',
  'Maghrib',
  'Isha',
];

class MosqueBuddyPage extends ConsumerWidget {
  const MosqueBuddyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(circlesProvider);
    final prefs = state.buddyPreferences;
    final matches = ref.watch(mosqueBuddyMatchesProvider);
    final notifier = ref.read(circlesProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.mosque_outlined,
      title: l10n.circlesMosqueBuddyPrefsTitle,
      subtitle: l10n.circlesMosqueBuddyPrefsSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.circlesBuddyDistance}: ${prefs.maxDistanceKm} km',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Slider(
                value: prefs.maxDistanceKm.toDouble(),
                min: 2,
                max: 40,
                divisions: 19,
                label: '${prefs.maxDistanceKm} km',
                onChanged: (value) => notifier.setBuddyPreferences(
                  prefs.copyWith(maxDistanceKm: value.round()),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${l10n.circlesBuddyPrayerConsistency}: ${prefs.prayerHabits}/5',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Slider(
                value: prefs.prayerHabits.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) => notifier.setBuddyPreferences(
                  prefs.copyWith(prayerHabits: value.round()),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.circlesBuddyInterests,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buddyInterests
                    .map(
                      (interest) => FilterChip(
                        label: Text(interest),
                        selected: prefs.interests.contains(interest),
                        onSelected: (selected) {
                          final next = Set<String>.from(prefs.interests);
                          if (selected) {
                            next.add(interest);
                          } else {
                            next.remove(interest);
                          }
                          notifier.setBuddyPreferences(
                            prefs.copyWith(interests: next),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.circlesBuddyAvailability,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availabilityWindows
                    .map(
                      (slot) => FilterChip(
                        label: Text(slot),
                        selected: prefs.availabilityWindows.contains(slot),
                        onSelected: (selected) {
                          final next = Set<String>.from(
                            prefs.availabilityWindows,
                          );
                          if (selected) {
                            next.add(slot);
                          } else {
                            next.remove(slot);
                          }
                          notifier.setBuddyPreferences(
                            prefs.copyWith(availabilityWindows: next),
                          );
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
                l10n.circlesBuddyMatchesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (matches.isEmpty)
                Text(l10n.circlesNoMatches)
              else
                ...matches.map(
                  (candidate) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F3EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidate.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${candidate.city} • ${candidate.distanceKm} km • ${candidate.prayerHabits}/5',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${candidate.interests.join(', ')} | ${candidate.availabilityWindows.join(', ')}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
