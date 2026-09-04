import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_kids_ayah_insights_provider.dart';
import '../application/quran_learning_progression_provider.dart';
import '../../../../core/theme/app_palette.dart';

class QuranKidsAyahInsightsPage extends ConsumerStatefulWidget {
  const QuranKidsAyahInsightsPage({super.key});

  @override
  ConsumerState<QuranKidsAyahInsightsPage> createState() =>
      _QuranKidsAyahInsightsPageState();
}

class _QuranKidsAyahInsightsPageState
    extends ConsumerState<QuranKidsAyahInsightsPage> {
  KidsQuranAyahInsightCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sections = ref.watch(quranKidsAyahInsightSectionsProvider);
    final selectedCategory =
        _selectedCategory ??
        (sections.isEmpty ? null : sections.first.category);
    KidsQuranAyahInsightCategorySection? activeSection;
    if (selectedCategory != null) {
      for (final section in sections) {
        if (section.category == selectedCategory) {
          activeSection = section;
          break;
        }
      }
    }

    return LearnHubPageScaffold(
      showDefaultQuote: false,
      headerIcon: Icons.auto_stories_rounded,
      title: l10n.kidsQuranAyahInsightsTitle,
      subtitle: l10n.kidsQuranAyahInsightsSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsQuranAyahInsightsIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(l10n.kidsQuranAyahInsightsIntroSubtitle),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (sections.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsQuranAyahInsightsEmptyTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.kidsQuranAyahInsightsEmptySubtitle),
              ],
            ),
          )
        else ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sections
                .map(
                  (section) => ChoiceChip(
                    label: Text(_categoryTitle(l10n, section.category)),
                    selected: selectedCategory == section.category,
                    onSelected: (_) {
                      setState(() => _selectedCategory = section.category);
                    },
                  ),
                )
                .toList(growable: false),
          ),
          if (activeSection != null) ...[
            const SizedBox(height: 12),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _categoryIcon(activeSection.category),
                        color: _categoryAccent(activeSection.category),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _categoryTitle(l10n, activeSection.category),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _categorySubtitle(l10n, activeSection.category),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...activeSection.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _KidsAyahInsightCard(item: item),
              ),
            ),
          ],
        ],
      ],
    );
  }

  String _categoryTitle(
    AppLocalizations l10n,
    KidsQuranAyahInsightCategory category,
  ) {
    return switch (category) {
      KidsQuranAyahInsightCategory.signsInCreation =>
        l10n.kidsQuranAyahInsightsCategorySignsInCreation,
      KidsQuranAyahInsightCategory.prayerAndRemembrance =>
        l10n.kidsQuranAyahInsightsCategoryPrayerRemembrance,
      KidsQuranAyahInsightCategory.gratitudeAndTrust =>
        l10n.kidsQuranAyahInsightsCategoryGratitudeTrust,
      KidsQuranAyahInsightCategory.kindnessAndGoodManners =>
        l10n.kidsQuranAyahInsightsCategoryKindnessManners,
      KidsQuranAyahInsightCategory.prophetLessons =>
        l10n.kidsQuranAyahInsightsCategoryProphetLessons,
    };
  }

  String _categorySubtitle(
    AppLocalizations l10n,
    KidsQuranAyahInsightCategory category,
  ) {
    return switch (category) {
      KidsQuranAyahInsightCategory.signsInCreation =>
        l10n.kidsQuranAyahInsightsCategorySignsInCreationSubtitle,
      KidsQuranAyahInsightCategory.prayerAndRemembrance =>
        l10n.kidsQuranAyahInsightsCategoryPrayerRemembranceSubtitle,
      KidsQuranAyahInsightCategory.gratitudeAndTrust =>
        l10n.kidsQuranAyahInsightsCategoryGratitudeTrustSubtitle,
      KidsQuranAyahInsightCategory.kindnessAndGoodManners =>
        l10n.kidsQuranAyahInsightsCategoryKindnessMannersSubtitle,
      KidsQuranAyahInsightCategory.prophetLessons =>
        l10n.kidsQuranAyahInsightsCategoryProphetLessonsSubtitle,
    };
  }

  IconData _categoryIcon(KidsQuranAyahInsightCategory category) {
    return switch (category) {
      KidsQuranAyahInsightCategory.signsInCreation => Icons.wb_sunny_outlined,
      KidsQuranAyahInsightCategory.prayerAndRemembrance =>
        Icons.mosque_outlined,
      KidsQuranAyahInsightCategory.gratitudeAndTrust =>
        Icons.favorite_outline_rounded,
      KidsQuranAyahInsightCategory.kindnessAndGoodManners =>
        Icons.volunteer_activism_outlined,
      KidsQuranAyahInsightCategory.prophetLessons => Icons.menu_book_outlined,
    };
  }

  Color _categoryAccent(KidsQuranAyahInsightCategory category) {
    return switch (category) {
      KidsQuranAyahInsightCategory.signsInCreation => const Color(0xFF5E7F47),
      KidsQuranAyahInsightCategory.prayerAndRemembrance => const Color(
        0xFF476A94,
      ),
      KidsQuranAyahInsightCategory.gratitudeAndTrust => const Color(0xFF8F6A2C),
      KidsQuranAyahInsightCategory.kindnessAndGoodManners => const Color(
        0xFF9A5A64,
      ),
      KidsQuranAyahInsightCategory.prophetLessons => const Color(0xFF6E5A97),
    };
  }
}

class _KidsAyahInsightCard extends ConsumerWidget {
  const _KidsAyahInsightCard({required this.item});

  final KidsQuranAyahInsightItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = item.entry;
    final isCompleted = ref.watch(
      quranLearningEntryCompletedProvider(entry.id),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7DBC8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _itemTitle(l10n, item.id),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _itemSummary(l10n, item.id),
            style: const TextStyle(color: Color(0xFF5E5347), height: 1.4),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.kidsQuranAyahInsightsLittleLessonTitle,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(_itemLesson(l10n, item.id)),
          const SizedBox(height: 10),
          Text(
            l10n.kidsQuranAyahInsightsGentleQuestionTitle,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(_itemPrompt(l10n, item.id)),
          const SizedBox(height: 12),
          QuranReferenceLinkTile.forRef(
            referenceLabel: l10n.quranReferenceViewerReferenceLabel(
              entry.ref.locationLabel,
            ),
            ref: entry.ref,
            subtitle: l10n.kidsQuranAyahInsightsOpenAyahHint,
            margin: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () =>
                    openQuranReferenceLocation(context, ref: entry.ref),
                icon: const Icon(Icons.auto_stories_rounded),
                label: Text(l10n.kidsQuranAyahInsightsOpenAyahAction),
              ),
              isCompleted
                  ? FilledButton.tonalIcon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle_rounded),
                      label: Text(l10n.kidsQuranAyahInsightsLearnedAction),
                    )
                  : OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(quranLearningProgressStateProvider.notifier)
                            .completeEntry(
                              entry: entry,
                              sourceSurface: 'kids_ayah_insights',
                            );
                      },
                      icon: const Icon(Icons.task_alt_rounded),
                      label: Text(l10n.kidsQuranAyahInsightsMarkLearnedAction),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  String _itemTitle(AppLocalizations l10n, String id) {
    switch (id) {
      case 'signs_sun_moon_10_5':
        return l10n.kidsQuranAyahInsightTitleSunMoon;
      case 'signs_animals_24_45':
        return l10n.kidsQuranAyahInsightTitleAnimals;
      case 'worship_salah_20_14':
        return l10n.kidsQuranAyahInsightTitlePrayer;
      case 'worship_dhikr_2_152':
        return l10n.kidsQuranAyahInsightTitleRememberAllah;
      case 'worship_gratitude_31_12':
        return l10n.kidsQuranAyahInsightTitleGratitude;
      case 'worship_reliance_33_3':
        return l10n.kidsQuranAyahInsightTitleTrustAllah;
      case 'character_parents_17_23_24':
        return l10n.kidsQuranAyahInsightTitleKindToParents;
      case 'character_good_conduct_41_34':
        return l10n.kidsQuranAyahInsightTitleGoodManners;
      case 'prophets_reliance_26_62':
        return l10n.kidsQuranAyahInsightTitleMusaTrust;
      case 'prophets_trials_21_83_84':
        return l10n.kidsQuranAyahInsightTitleAyyubPatience;
    }
    return item.entry.title;
  }

  String _itemSummary(AppLocalizations l10n, String id) {
    switch (id) {
      case 'signs_sun_moon_10_5':
        return l10n.kidsQuranAyahInsightSummarySunMoon;
      case 'signs_animals_24_45':
        return l10n.kidsQuranAyahInsightSummaryAnimals;
      case 'worship_salah_20_14':
        return l10n.kidsQuranAyahInsightSummaryPrayer;
      case 'worship_dhikr_2_152':
        return l10n.kidsQuranAyahInsightSummaryRememberAllah;
      case 'worship_gratitude_31_12':
        return l10n.kidsQuranAyahInsightSummaryGratitude;
      case 'worship_reliance_33_3':
        return l10n.kidsQuranAyahInsightSummaryTrustAllah;
      case 'character_parents_17_23_24':
        return l10n.kidsQuranAyahInsightSummaryKindToParents;
      case 'character_good_conduct_41_34':
        return l10n.kidsQuranAyahInsightSummaryGoodManners;
      case 'prophets_reliance_26_62':
        return l10n.kidsQuranAyahInsightSummaryMusaTrust;
      case 'prophets_trials_21_83_84':
        return l10n.kidsQuranAyahInsightSummaryAyyubPatience;
    }
    return item.entry.summary;
  }

  String _itemLesson(AppLocalizations l10n, String id) {
    switch (id) {
      case 'signs_sun_moon_10_5':
        return l10n.kidsQuranAyahInsightLessonSunMoon;
      case 'signs_animals_24_45':
        return l10n.kidsQuranAyahInsightLessonAnimals;
      case 'worship_salah_20_14':
        return l10n.kidsQuranAyahInsightLessonPrayer;
      case 'worship_dhikr_2_152':
        return l10n.kidsQuranAyahInsightLessonRememberAllah;
      case 'worship_gratitude_31_12':
        return l10n.kidsQuranAyahInsightLessonGratitude;
      case 'worship_reliance_33_3':
        return l10n.kidsQuranAyahInsightLessonTrustAllah;
      case 'character_parents_17_23_24':
        return l10n.kidsQuranAyahInsightLessonKindToParents;
      case 'character_good_conduct_41_34':
        return l10n.kidsQuranAyahInsightLessonGoodManners;
      case 'prophets_reliance_26_62':
        return l10n.kidsQuranAyahInsightLessonMusaTrust;
      case 'prophets_trials_21_83_84':
        return l10n.kidsQuranAyahInsightLessonAyyubPatience;
    }
    return item.entry.body;
  }

  String _itemPrompt(AppLocalizations l10n, String id) {
    switch (id) {
      case 'signs_sun_moon_10_5':
        return l10n.kidsQuranAyahInsightPromptSunMoon;
      case 'signs_animals_24_45':
        return l10n.kidsQuranAyahInsightPromptAnimals;
      case 'worship_salah_20_14':
        return l10n.kidsQuranAyahInsightPromptPrayer;
      case 'worship_dhikr_2_152':
        return l10n.kidsQuranAyahInsightPromptRememberAllah;
      case 'worship_gratitude_31_12':
        return l10n.kidsQuranAyahInsightPromptGratitude;
      case 'worship_reliance_33_3':
        return l10n.kidsQuranAyahInsightPromptTrustAllah;
      case 'character_parents_17_23_24':
        return l10n.kidsQuranAyahInsightPromptKindToParents;
      case 'character_good_conduct_41_34':
        return l10n.kidsQuranAyahInsightPromptGoodManners;
      case 'prophets_reliance_26_62':
        return l10n.kidsQuranAyahInsightPromptMusaTrust;
      case 'prophets_trials_21_83_84':
        return l10n.kidsQuranAyahInsightPromptAyyubPatience;
    }
    return '';
  }
}
