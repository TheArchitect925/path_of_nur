import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/content/page_description_copy.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/application/quran_reflections_provider.dart';
import '../../quran/presentation/widgets/quran_daily_reflection_card.dart';
import '../widgets/learn_discovery_search_field.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class QuranAppHubPage extends ConsumerStatefulWidget {
  const QuranAppHubPage({super.key});

  @override
  ConsumerState<QuranAppHubPage> createState() => _QuranAppHubPageState();
}

class _QuranAppHubPageState extends ConsumerState<QuranAppHubPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
    final dailyVerse = ref.watch(quranDailyVerseProvider);
    ref.watch(quranBookmarksProvider);
    ref.watch(quranNotesProvider);
    ref.watch(quranReflectionsProvider);
    final readActions = _readActions(l10n, continueSummary);
    final toolActions = _toolActions(l10n);

    return LearnHubPageScaffold(
      showDefaultQuote: false,
      headerIcon: IslamicIcons.quran,
      title: l10n.quranHubTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.quranHub,
        kidsMode: isKidsMode,
      ),
      children: [
        PremiumCard(
          child: LearnDiscoverySearchField(
            controller: _searchController,
            hintText: l10n.searchSurahHint,
            readOnly: true,
            onTap: () => context.pushNamed('quranSearch'),
          ),
        ),
        const SizedBox(height: 12),
        _SectionHeader(title: l10n.quranHubReadQuranSectionTitle),
        const SizedBox(height: 8),
        SectionHubActionGrid(actions: readActions),
        const SizedBox(height: 12),
        const QuranDailyReflectionCard(),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranHubDailyLightTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(dailyVerse.locationLabel),
              const SizedBox(height: 4),
              Text(
                dailyVerse.translation,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'quranReader',
                  pathParameters: {
                    'surahNumber': dailyVerse.surahNumber.toString(),
                  },
                  queryParameters: {'ayah': dailyVerse.ayahNumber.toString()},
                ),
                icon: const Icon(Icons.auto_stories_rounded),
                label: Text(l10n.quranHubOpenVerseAction),
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
                l10n.quranHubRelatedToolsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranHubRelatedToolsSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: toolActions
                    .map(
                      (action) => _SecondaryToolChip(
                        label: action.title,
                        icon: action.icon,
                        onTap: action.onTap,
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<SectionHubAction> _readActions(
    AppLocalizations l10n,
    QuranContinueReadingSummary continueSummary,
  ) {
    return [
      SectionHubAction(
        title: l10n.quranHubReadQuranSectionTitle,
        subtitle: l10n.quranExplorerSubtitle,
        icon: Icons.menu_book_rounded,
        color: const Color(0xFFECE5D7),
        accentColor: const Color(0xFF6F5A3E),
        onTap: () => context.pushNamed('quranExplorer'),
      ),
      SectionHubAction(
        title: l10n.quranHubContinueSectionTitle,
        subtitle: continueSummary.locationLabel,
        icon: Icons.play_circle_fill_rounded,
        color: const Color(0xFFF0E2D6),
        accentColor: const Color(0xFF8D6143),
        onTap: () => context.pushNamed(
          'quranReader',
          pathParameters: {
            'surahNumber': continueSummary.surahNumber.toString(),
          },
          queryParameters: {'ayah': continueSummary.ayahNumber.toString()},
        ),
      ),
    ];
  }

  List<_QuranToolAction> _toolActions(AppLocalizations l10n) {
    return [
      _QuranToolAction(
        title: l10n.learnCategoryQuranLearningTitle,
        subtitle: l10n.quranHubStudySubtitle,
        icon: Icons.school_rounded,
        onTap: () => context.pushNamed('quranLearningHub'),
      ),
      _QuranToolAction(
        title: l10n.learnQuranBookmarksTitle,
        subtitle: l10n.quranHubNotesSubtitle,
        icon: Icons.bookmark_outline_rounded,
        onTap: () => context.pushNamed('quranBookmarks'),
      ),
      _QuranToolAction(
        title: l10n.quranNotesTitle,
        subtitle: l10n.quranHubNotesSubtitle,
        icon: Icons.note_alt_outlined,
        onTap: () => context.pushNamed('quranNotes'),
      ),
      _QuranToolAction(
        title: l10n.quranReflectionsHubEntryTitle,
        subtitle: l10n.quranReflectionsHubEntrySubtitle,
        icon: Icons.collections_bookmark_outlined,
        onTap: () => context.pushNamed('quranReflections'),
      ),
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SecondaryToolChip extends StatelessWidget {
  const _SecondaryToolChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _QuranToolAction {
  const _QuranToolAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}
