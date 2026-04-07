import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/content/page_description_copy.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/main_page_shortcut_configs.dart';
import '../../../../shared/widgets/main_page_shortcut_stack.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_sacred_block_chrome.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../quran/application/quran_hub_recommendations_provider.dart';
import '../../quran/application/quran_daily_reflection_provider.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/application/quran_reflections_provider.dart';
import '../../quran/application/quran_guided_learning_paths_provider.dart';
import '../../quran/application/quran_personalization_provider.dart';
import '../../quran/application/quran_spiritual_moment_provider.dart';
import '../../quran/application/quran_surah_summary_provider.dart';
import '../../quran/application/quran_user_intent_provider.dart';
import '../../quran/domain/quran_hub_recommendation_models.dart';
import '../../quran/domain/quran_personalization_models.dart';
import '../../quran/domain/quran_spiritual_moment_models.dart';
import '../../quran/domain/quran_user_intent_models.dart';
import '../../quran/presentation/quran_learning_path_copy.dart';
import '../../quran/presentation/quran_summary_theme.dart';
import '../../quran/presentation/quran_theme_copy.dart';
import '../../quran/presentation/widgets/quran_daily_reflection_card.dart';
import '../../quran/presentation/widgets/quran_personalized_recommendation_card.dart';
import '../../quran/presentation/widgets/quran_spiritual_moment_card.dart';
import '../widgets/learn_discovery_search_field.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class QuranAppHubPage extends ConsumerStatefulWidget {
  const QuranAppHubPage({super.key});

  @override
  ConsumerState<QuranAppHubPage> createState() => _QuranAppHubPageState();
}

class _QuranAppHubPageState extends ConsumerState<QuranAppHubPage> {
  late final TextEditingController _searchController;
  bool _discoverQuranExpanded = true;

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
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    ref.watch(quranBookmarksProvider);
    ref.watch(quranNotesProvider);
    ref.watch(quranReflectionsProvider);
    final userIntentSummary = ref.watch(quranUserIntentSummaryProvider);
    final recommendations = ref.watch(quranHubRecommendationsProvider);
    final personalizedBundle = ref.watch(
      quranPersonalizedRecommendationBundleProvider((
        QuranPersonalizationSurface.quranHub,
        isKidsMode,
      )),
    );
    final spiritualMoment = ref.watch(
      quranSpiritualMomentBundleProvider((
        QuranSpiritualMomentSurface.quranHub,
        isKidsMode,
        Localizations.localeOf(context).languageCode,
      )),
    );
    final summaryPalette = QuranSummaryThemePalette.resolve(context);
    final readActions = _readActions(l10n);
    final studyActions = _studyActions(l10n);
    final wordStudyActions = _wordStudyActions(l10n);
    final toolActions = _toolActions(l10n);

    return LearnHubPageScaffold(
      ownsBackground: false,
      showDefaultQuote: false,
      headerIcon: IslamicIcons.quran,
      title: l10n.quranAppHubTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.quranHub,
        kidsMode: isKidsMode,
      ),
      floatingBottom: MainPageShortcutStack(
        items: buildQuranPageShortcuts(l10n),
        openLabel: l10n.learnShortcutOpen,
        closeLabel: l10n.learnShortcutClose,
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
        _QuranDiscoverCard(
          title: l10n.quranDiscoverSectionTitle,
          subtitle: l10n.quranDiscoverSectionSubtitle,
          isExpanded: _discoverQuranExpanded,
          onToggle: () {
            setState(() => _discoverQuranExpanded = !_discoverQuranExpanded);
          },
          child: Column(
            children: [
              _QuranHubSacredLinkCard(
                title: l10n.quranSummaryIslandTitle,
                subtitle: l10n.quranSummaryIslandSubtitle,
                icon: Icons.auto_stories_rounded,
                accentColor: summaryPalette.goldAccent,
                iconFill: summaryPalette.numberFill,
                onTap: () => context.pushNamed('quranSummaryPage'),
              ),
              const SizedBox(height: 12),
              _QuranHubSacredLinkCard(
                title: l10n.quranThemeDiscoveryIslandTitle,
                subtitle: l10n.quranThemeDiscoveryIslandSubtitle,
                icon: Icons.account_tree_outlined,
                accentColor: summaryPalette.goldAccent,
                iconFill: summaryPalette.numberFill,
                onTap: () => context.pushNamed('quranTopicExplorer'),
              ),
              const SizedBox(height: 12),
              _QuranHubSacredLinkCard(
                title: l10n.quranPathwaysIslandTitle,
                subtitle: l10n.quranPathwaysIslandSubtitle,
                icon: Icons.route_rounded,
                accentColor: summaryPalette.goldAccent,
                iconFill: summaryPalette.numberFill,
                onTap: () => context.pushNamed('quranLearningPaths'),
              ),
              if (spiritualMoment != null) ...[
                const SizedBox(height: 12),
                QuranSpiritualMomentCard(
                  bundle: spiritualMoment,
                  surface: QuranSpiritualMomentSurface.quranHub,
                  allowDismiss: true,
                ),
              ],
              if (personalizedBundle != null) ...[
                const SizedBox(height: 12),
                QuranPersonalizedRecommendationCard(
                  bundle: personalizedBundle,
                  surface: QuranPersonalizationSurface.quranHub,
                  allowDismiss: true,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionHeader(title: l10n.quranHubWordToolsTitle),
        const SizedBox(height: 6),
        Text(
          l10n.quranHubWordToolsSubtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color:
                appearance?.glassOnSurfaceSubtle ?? AppColors.onSurfaceSubtle,
          ),
        ),
        const SizedBox(height: 10),
        SectionHubActionGrid(actions: wordStudyActions),
        const SizedBox(height: 12),
        _SectionHeader(title: l10n.quranHubStudyToolsTitle),
        const SizedBox(height: 6),
        Text(
          l10n.quranHubStudyToolsSubtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color:
                appearance?.glassOnSurfaceSubtle ?? AppColors.onSurfaceSubtle,
          ),
        ),
        const SizedBox(height: 10),
        SectionHubActionGrid(actions: studyActions),
        const SizedBox(height: 12),
        const QuranDailyReflectionCard(showSecondaryActions: false),
        const SizedBox(height: 12),
        if (recommendations.isNotEmpty)
          _QuranRecommendationSection(recommendations: recommendations),
        if (recommendations.isNotEmpty) const SizedBox(height: 12),
        _QuranIntentFocusCard(summary: userIntentSummary),
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
                  color:
                      appearance?.glassOnSurfaceSubtle ??
                      AppColors.onSurfaceSubtle,
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

  List<SectionHubAction> _readActions(AppLocalizations l10n) {
    return [
      SectionHubAction(
        title: l10n.quranHubReadQuranSectionTitle,
        subtitle: l10n.quranExplorerSubtitle,
        icon: Icons.menu_book_rounded,
        color: const Color(0xFFECE5D7),
        accentColor: const Color(0xFF6F5A3E),
        onTap: () => context.pushNamed('quranExplorer'),
      ),
    ];
  }

  List<_QuranToolAction> _toolActions(AppLocalizations l10n) {
    return [
      _QuranToolAction(
        title: l10n.quranHubMemorizeTitle,
        subtitle: l10n.quranHubMemorizeSubtitle,
        icon: Icons.repeat_rounded,
        onTap: () => context.pushNamed('quranMemorizationReview'),
      ),
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

  List<SectionHubAction> _studyActions(AppLocalizations l10n) {
    return [
      SectionHubAction(
        title: l10n.quranKnowledgeSearchTitle,
        subtitle: l10n.quranKnowledgeSearchSubtitle,
        icon: Icons.manage_search_rounded,
        color: const Color(0xFFE5EBF5),
        accentColor: const Color(0xFF4A628A),
        onTap: () => context.pushNamed('quranKnowledgeSearch'),
      ),
      SectionHubAction(
        title: l10n.quranSurahInsightsBrowseTitle,
        subtitle: l10n.quranSurahInsightsBrowseSubtitle,
        icon: Icons.auto_stories_rounded,
        color: const Color(0xFFE7ECDD),
        accentColor: const Color(0xFF5A7146),
        onTap: () => context.pushNamed('quranSurahInsightsBrowse'),
      ),
      SectionHubAction(
        title: l10n.quranLearningPathsTitle,
        subtitle: l10n.quranLearningPathsHubSubtitle,
        icon: Icons.route_rounded,
        color: const Color(0xFFE9E6F3),
        accentColor: const Color(0xFF6A5891),
        onTap: () => context.pushNamed('quranLearningPaths'),
      ),
      SectionHubAction(
        title: l10n.quranTopicsTitle,
        subtitle: l10n.quranHubTopicsSubtitle,
        icon: Icons.account_tree_outlined,
        color: const Color(0xFFF0E6D8),
        accentColor: const Color(0xFF8A6243),
        onTap: () => context.pushNamed('quranTopicExplorer'),
      ),
    ];
  }

  List<SectionHubAction> _wordStudyActions(AppLocalizations l10n) {
    return [
      SectionHubAction(
        title: l10n.quranTopWordsTitle,
        subtitle: l10n.quranTopWordsSubtitle,
        icon: Icons.translate_rounded,
        color: const Color(0xFFE8E4F4),
        accentColor: const Color(0xFF675796),
        onTap: () => context.pushNamed('quranTopWords'),
      ),
      SectionHubAction(
        title: l10n.quranWordReviewTitle,
        subtitle: l10n.quranWordReviewSubtitle,
        icon: Icons.style_outlined,
        color: const Color(0xFFE6ECEA),
        accentColor: const Color(0xFF4F6F67),
        onTap: () => context.pushNamed('quranWordReview'),
      ),
    ];
  }
}

class _QuranRecommendationSection extends ConsumerWidget {
  const _QuranRecommendationSection({required this.recommendations});

  final List<QuranHubRecommendation> recommendations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final primary = recommendations.first;
    final secondary = recommendations.skip(1).toList(growable: false);

    return QuranSacredBlockChrome(
      child: PremiumCard(
        surfaceTreatment: AppSurfaceTreatment.denseSanctuary,
        surfaceVariant: AppSurfaceVariant.panel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quranCompanionSectionTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.quranCompanionSectionSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _QuranCompanionPrimaryCard(recommendation: primary),
            if (secondary.isNotEmpty) const SizedBox(height: 10),
            for (var index = 0; index < secondary.length; index++) ...[
              _QuranCompanionSecondaryCard(recommendation: secondary[index]),
              if (index + 1 < secondary.length) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuranCompanionPrimaryCard extends ConsumerWidget {
  const _QuranCompanionPrimaryCard({required this.recommendation});

  final QuranHubRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = QuranSummaryThemePalette.resolve(context);
    final content = _resolveRecommendationContent(context, ref, recommendation);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.card,
      treatment: AppSurfaceTreatment.denseSanctuary,
      tintColor: palette.goldAccent,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => _openRecommendation(context, recommendation),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: surfaceStyle.decoration(radius: 24, includeShadow: false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _QuranCompanionReasonChip(label: content.reasonLabel),
                      if (content.badgeLabel != null)
                        _QuranCompanionReasonChip(
                          label: content.badgeLabel!,
                          tone: QuranFeatureRevelationTone.madani,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: AppSurfaceTheme.resolve(
                    context,
                    variant: AppSurfaceVariant.pill,
                    treatment: AppSurfaceTreatment.denseSanctuary,
                    tintColor: palette.goldAccent,
                  ).decoration(radius: 14, includeShadow: false),
                  child: Icon(content.icon, color: palette.goldAccent),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              content.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              content.subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: palette.supportText),
            ),
            if (content.description != null) ...[
              const SizedBox(height: 10),
              Text(
                content.description!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.supportText),
              ),
            ],
            if (recommendation.showsProgress) ...[
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: recommendation.progressRatio,
                minHeight: 7,
                backgroundColor: palette.progressTrack,
                valueColor: AlwaysStoppedAnimation<Color>(palette.progressFill),
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).quranCompanionProgressLabel(
                  recommendation.progressCompleted ?? 0,
                  recommendation.progressTotal ?? 0,
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.supportText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuranCompanionSecondaryCard extends ConsumerWidget {
  const _QuranCompanionSecondaryCard({required this.recommendation});

  final QuranHubRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = QuranSummaryThemePalette.resolve(context);
    final content = _resolveRecommendationContent(context, ref, recommendation);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      treatment: AppSurfaceTreatment.denseSanctuary,
      tintColor: palette.goldAccent,
    );
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      treatment: AppSurfaceTreatment.denseSanctuary,
      tintColor: palette.goldAccent,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openRecommendation(context, recommendation),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: surfaceStyle.decoration(radius: 18, includeShadow: false),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: iconStyle.decoration(
                  radius: 12,
                  includeShadow: false,
                ),
                child: Icon(content.icon, color: palette.goldAccent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.reasonLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.goldAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.supportText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: palette.supportText),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuranHubSacredLinkCard extends StatelessWidget {
  const _QuranHubSacredLinkCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.iconFill,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color iconFill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      surfaceTreatment: AppSurfaceTreatment.denseSanctuary,
      surfaceVariant: AppSurfaceVariant.panel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    AppSurfaceTheme.resolve(
                          context,
                          variant: AppSurfaceVariant.pill,
                          treatment: AppSurfaceTreatment.denseSanctuary,
                          tintColor: accentColor,
                        )
                        .decoration(radius: 16, includeShadow: false)
                        .copyWith(color: iconFill, gradient: null),
                child: Icon(icon, color: accentColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuranDiscoverCard extends StatelessWidget {
  const _QuranDiscoverCard({
    required this.title,
    required this.subtitle,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: AppSurfaceTheme.resolve(
                      context,
                      variant: AppSurfaceVariant.pill,
                      treatment: AppSurfaceTreatment.denseSanctuary,
                      tintColor: const Color(0xFFE7C98C),
                    ).decoration(radius: 16, includeShadow: false),
                    child: const Icon(
                      IslamicIcons.quran,
                      color: Color(0xFF7A6241),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color:
                                    appearance?.glassOnSurfaceSubtle ??
                                    AppColors.onSurfaceSubtle,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    turns: isExpanded ? 0.5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 28,
                      color: Color(0xFF7A6241),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(padding: const EdgeInsets.only(top: 12), child: child),
        ],
      ),
    );
  }
}

class _ResolvedRecommendationContent {
  const _ResolvedRecommendationContent({
    required this.title,
    required this.subtitle,
    required this.reasonLabel,
    required this.icon,
    this.description,
    this.badgeLabel,
  });

  final String title;
  final String subtitle;
  final String reasonLabel;
  final String? description;
  final String? badgeLabel;
  final IconData icon;
}

class _QuranCompanionReasonChip extends StatelessWidget {
  const _QuranCompanionReasonChip({
    required this.label,
    this.tone = QuranFeatureRevelationTone.neutral,
  });

  final String label;
  final QuranFeatureRevelationTone tone;

  @override
  Widget build(BuildContext context) {
    final palette = QuranSummaryThemePalette.resolve(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: _quranReasonChipDecoration(
        context,
        fill: palette.chipFillForTone(tone),
        border: palette.chipBorderForTone(tone),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: palette.chipTextForTone(tone),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

_ResolvedRecommendationContent _resolveRecommendationContent(
  BuildContext context,
  WidgetRef ref,
  QuranHubRecommendation recommendation,
) {
  final l10n = AppLocalizations.of(context);
  final dailySummary = ref.watch(quranDailyCompanionSummaryProvider);
  final surah = recommendation.surahNumber == null
      ? null
      : ref.watch(quranSurahSummaryEntryProvider(recommendation.surahNumber!));
  final topic = recommendation.topicId == null
      ? null
      : ref.watch(quranHubRecommendationTopicProvider(recommendation.topicId!));
  final path = recommendation.pathId == null
      ? null
      : ref.watch(quranGuidedLearningPathByIdProvider(recommendation.pathId!));

  final reasonLabel = _recommendationReasonLabel(l10n, recommendation.reason);
  final icon = _recommendationIcon(recommendation.type);

  switch (recommendation.type) {
    case QuranHubRecommendationType.resumePathway:
      final pathTitle = path == null
          ? l10n.quranLearningPathsTitle
          : localizedQuranLearningPathTitle(l10n, path.id);
      final pathSubtitle = path == null
          ? l10n.quranLearningPathsSubtitle
          : localizedQuranLearningPathSubtitle(l10n, path.id);
      return _ResolvedRecommendationContent(
        title: l10n.quranCompanionResumePathTitle(pathTitle),
        subtitle: pathSubtitle,
        description: l10n.quranCompanionResumePathDescription,
        reasonLabel: reasonLabel,
        badgeLabel: l10n.quranCompanionResumeBadge,
        icon: icon,
      );
    case QuranHubRecommendationType.continueSurah:
      final surahName = surah?.transliteratedName ?? l10n.quranSummaryPageTitle;
      return _ResolvedRecommendationContent(
        title: l10n.quranCompanionContinueSurahTitle(surahName),
        subtitle: surah == null
            ? '${recommendation.surahNumber}:${recommendation.ayahNumber}'
            : '${surah.transliteratedName} ${recommendation.surahNumber}:${recommendation.ayahNumber}',
        description: l10n.quranCompanionContinueSurahDescription,
        reasonLabel: reasonLabel,
        badgeLabel:
            recommendation.reason == QuranHubRecommendationReason.keepMomentum
            ? l10n.quranCompanionMomentumBadge
            : null,
        icon: icon,
      );
    case QuranHubRecommendationType.themeSuggestion:
    case QuranHubRecommendationType.relatedFollowUp:
      final themeTitle = topic == null
          ? l10n.quranTopicsTitle
          : localizedQuranTopicTitle(l10n, topic.definition.id);
      final themeDescription = topic == null
          ? l10n.quranThemeDiscoveryPageSubtitle
          : localizedQuranTopicDescription(l10n, topic.definition.id);
      return _ResolvedRecommendationContent(
        title: l10n.quranCompanionExploreThemeTitle(themeTitle),
        subtitle: themeDescription,
        description:
            recommendation.type == QuranHubRecommendationType.relatedFollowUp
            ? l10n.quranCompanionRelatedThemeDescription
            : l10n.quranCompanionThemeDescription,
        reasonLabel: reasonLabel,
        badgeLabel:
            recommendation.reason ==
                QuranHubRecommendationReason.basedOnGrowthFocus
            ? l10n.quranCompanionFocusBadge
            : null,
        icon: icon,
      );
    case QuranHubRecommendationType.pathwaySuggestion:
    case QuranHubRecommendationType.growthFocusPick:
      final pathTitle = path == null
          ? l10n.quranLearningPathsTitle
          : localizedQuranLearningPathTitle(l10n, path.id);
      final pathSubtitle = path == null
          ? l10n.quranLearningPathsSubtitle
          : localizedQuranLearningPathSubtitle(l10n, path.id);
      return _ResolvedRecommendationContent(
        title: l10n.quranCompanionPathwayTitle(pathTitle),
        subtitle: pathSubtitle,
        description: l10n.quranCompanionPathwayDescription,
        reasonLabel: reasonLabel,
        badgeLabel:
            recommendation.reason ==
                QuranHubRecommendationReason.basedOnGrowthFocus
            ? l10n.quranCompanionFocusBadge
            : null,
        icon: icon,
      );
    case QuranHubRecommendationType.reflectionPrompt:
      final surahName = surah?.transliteratedName ?? l10n.quranSummaryPageTitle;
      return _ResolvedRecommendationContent(
        title: l10n.quranCompanionStartHereTitle(surahName),
        subtitle: surah?.summary ?? l10n.quranCompanionStartHereDescription,
        reasonLabel: reasonLabel,
        icon: icon,
      );
    case QuranHubRecommendationType.timeOfDayPick:
      return _ResolvedRecommendationContent(
        title: l10n.quranCompanionTimeOfDayTitle,
        subtitle:
            '${dailySummary.reflection.assignment.entry.ref.surah}:${dailySummary.reflection.assignment.entry.ref.ayah} • ${l10n.quranDailyCompanionSubtitle}',
        description: l10n.quranCompanionTimeOfDayDescription,
        reasonLabel: reasonLabel,
        badgeLabel: l10n.quranCompanionMomentBadge,
        icon: icon,
      );
    case QuranHubRecommendationType.fridayPick:
      final surahName = surah?.transliteratedName ?? 'Al-Kahf';
      return _ResolvedRecommendationContent(
        title: l10n.quranCompanionFridayTitle(surahName),
        subtitle: surah?.summary ?? l10n.quranCompanionFridayDescription,
        description: l10n.quranCompanionFridayDescription,
        reasonLabel: reasonLabel,
        badgeLabel: l10n.quranCompanionFridayBadge,
        icon: icon,
      );
  }
}

void _openRecommendation(
  BuildContext context,
  QuranHubRecommendation recommendation,
) {
  context.pushNamed(
    recommendation.routeName,
    pathParameters: recommendation.pathParameters,
    queryParameters: recommendation.queryParameters,
  );
}

IconData _recommendationIcon(QuranHubRecommendationType type) {
  return switch (type) {
    QuranHubRecommendationType.resumePathway => Icons.route_rounded,
    QuranHubRecommendationType.continueSurah => Icons.play_circle_fill_rounded,
    QuranHubRecommendationType.themeSuggestion => Icons.account_tree_outlined,
    QuranHubRecommendationType.pathwaySuggestion => Icons.route_rounded,
    QuranHubRecommendationType.reflectionPrompt => Icons.menu_book_rounded,
    QuranHubRecommendationType.timeOfDayPick => Icons.wb_twilight_rounded,
    QuranHubRecommendationType.fridayPick => Icons.today_rounded,
    QuranHubRecommendationType.relatedFollowUp => Icons.link_rounded,
    QuranHubRecommendationType.growthFocusPick => Icons.track_changes_rounded,
  };
}

String _recommendationReasonLabel(
  AppLocalizations l10n,
  QuranHubRecommendationReason reason,
) {
  return switch (reason) {
    QuranHubRecommendationReason.continueWhereLeftOff =>
      l10n.quranCompanionReasonContinue,
    QuranHubRecommendationReason.forThisMorning =>
      l10n.quranCompanionReasonMorning,
    QuranHubRecommendationReason.forThisAfternoon =>
      l10n.quranCompanionReasonAfternoon,
    QuranHubRecommendationReason.forThisEvening =>
      l10n.quranCompanionReasonEvening,
    QuranHubRecommendationReason.forTonight => l10n.quranCompanionReasonNight,
    QuranHubRecommendationReason.basedOnRecentReading =>
      l10n.quranCompanionReasonRecent,
    QuranHubRecommendationReason.basedOnGrowthFocus =>
      l10n.quranCompanionReasonFocus,
    QuranHubRecommendationReason.fridayReflection =>
      l10n.quranCompanionReasonFriday,
    QuranHubRecommendationReason.connectedToYourJourney =>
      l10n.quranCompanionReasonJourney,
    QuranHubRecommendationReason.keepMomentum =>
      l10n.quranCompanionReasonMomentum,
    QuranHubRecommendationReason.startHere => l10n.quranCompanionReasonStart,
  };
}

class _QuranIntentFocusCard extends ConsumerWidget {
  const _QuranIntentFocusCard({required this.summary});

  final QuranUserIntentSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedIntent = summary.selectedIntent;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranUserIntentTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.quranUserIntentSubtitle),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: QuranUserIntent.values
                .map((intent) {
                  final selected = selectedIntent == intent;
                  return InkWell(
                    onTap: () {
                      final notifier = ref.read(
                        quranUserIntentStateProvider.notifier,
                      );
                      notifier.setIntent(intent);
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: _quranIntentPillDecoration(
                        context,
                        selected: selected,
                      ),
                      child: Text(_intentLabel(l10n, intent)),
                    ),
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 10),
          if (selectedIntent != null) ...[
            Text(
              l10n.quranUserIntentRecommendedTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(_intentRecommendationSubtitle(l10n, selectedIntent)),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () => _openIntentRecommendation(
                context,
                ref,
                intent: selectedIntent,
                summary: summary,
              ),
              icon: Icon(_intentIcon(selectedIntent)),
              label: Text(_intentActionLabel(l10n, selectedIntent)),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () =>
                  ref.read(quranUserIntentStateProvider.notifier).clearIntent(),
              icon: const Icon(Icons.close_rounded),
              label: Text(l10n.quranUserIntentClearAction),
            ),
          ],
        ],
      ),
    );
  }
}

String _intentLabel(AppLocalizations l10n, QuranUserIntent intent) {
  return switch (intent) {
    QuranUserIntent.understand => l10n.quranUserIntentUnderstandLabel,
    QuranUserIntent.reflect => l10n.quranUserIntentReflectLabel,
    QuranUserIntent.memorize => l10n.quranUserIntentMemorizeLabel,
    QuranUserIntent.themes => l10n.quranUserIntentThemesLabel,
    QuranUserIntent.guidedPath => l10n.quranUserIntentGuidedPathLabel,
  };
}

String _intentActionLabel(AppLocalizations l10n, QuranUserIntent intent) {
  return switch (intent) {
    QuranUserIntent.understand => l10n.quranSurahInsightsBrowseTitle,
    QuranUserIntent.reflect => l10n.quranDailyCompanionTitle,
    QuranUserIntent.memorize => l10n.quranHubMemorizeTitle,
    QuranUserIntent.themes => l10n.quranTopicsTitle,
    QuranUserIntent.guidedPath => l10n.quranLearningPathsTitle,
  };
}

String _intentRecommendationSubtitle(
  AppLocalizations l10n,
  QuranUserIntent intent,
) {
  return switch (intent) {
    QuranUserIntent.understand => l10n.quranUserIntentUnderstandRecommendation,
    QuranUserIntent.reflect => l10n.quranUserIntentReflectRecommendation,
    QuranUserIntent.memorize => l10n.quranUserIntentMemorizeRecommendation,
    QuranUserIntent.themes => l10n.quranUserIntentThemesRecommendation,
    QuranUserIntent.guidedPath => l10n.quranUserIntentGuidedPathRecommendation,
  };
}

IconData _intentIcon(QuranUserIntent intent) {
  return switch (intent) {
    QuranUserIntent.understand => Icons.auto_stories_rounded,
    QuranUserIntent.reflect => Icons.wb_twilight_rounded,
    QuranUserIntent.memorize => Icons.repeat_rounded,
    QuranUserIntent.themes => Icons.account_tree_outlined,
    QuranUserIntent.guidedPath => Icons.route_rounded,
  };
}

void _openIntentRecommendation(
  BuildContext context,
  WidgetRef ref, {
  required QuranUserIntent intent,
  required QuranUserIntentSummary summary,
}) {
  switch (intent) {
    case QuranUserIntent.understand:
      context.pushNamed('quranSurahInsightsBrowse');
      break;
    case QuranUserIntent.reflect:
      context.pushNamed('quranDailyCompanion');
      break;
    case QuranUserIntent.memorize:
      context.pushNamed('quranMemorizationReview');
      break;
    case QuranUserIntent.themes:
      context.pushNamed('quranTopicExplorer');
      break;
    case QuranUserIntent.guidedPath:
      final path = summary.suggestedPath;
      if (path != null) {
        final firstStep = path.steps.first;
        ref
            .read(quranGuidedLearningContinuityProvider.notifier)
            .markStepOpened(pathId: path.id, stepId: firstStep.id);
        context.pushNamed(
          'quranLearningPathDetail',
          pathParameters: {'pathId': path.id},
        );
      } else {
        context.pushNamed('quranLearningPaths');
      }
      break;
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: _secondaryToolChipDecoration(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
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

BoxDecoration _quranReasonChipDecoration(
  BuildContext context, {
  required Color fill,
  required Color border,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: fill,
  );
  return BoxDecoration(
    color: style.backgroundColor,
    gradient: style.gradient,
    borderRadius: BorderRadius.circular(999),
    border: Border.all(color: border),
    boxShadow: style.boxShadows,
  );
}

BoxDecoration _quranIntentPillDecoration(
  BuildContext context, {
  required bool selected,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: selected
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.14)
        : null,
  );
  return style.decoration(radius: 999);
}

BoxDecoration _secondaryToolChipDecoration(BuildContext context) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
  );
  return style.decoration(radius: 999);
}
