# Noor Glass Global Rollout Plan — 2026-04-03

## Target

Move the app onto one primary visual language:

- `Noor Glass` as the main default runtime theme
- colored accent cards keep their identity colors
- parchment-style local containers should be replaced with Noor Glass-compatible shared surfaces

## Phase breakdown

### Phase 1 — Settings / Profile family
- Scope:
  - `SettingsPage` support pages
  - profile summary / what’s new / coming soon / help guide surfaces
- Goal:
  - remove page-local parchment boxes inside the settings/profile family
  - keep accent chips and status colors where they are intentional

### Phase 2 — Home final cleanup
- Scope:
  - remaining Home-local micro-surfaces
  - modal sheets and helper chips under `home_page.dart`
- Goal:
  - finish the last local warm/parchment drift on Home

### Phase 3 — Worship prayer surfaces
- Scope:
  - prayer section and prayer-related utility surfaces
- Goal:
  - unify prayer-facing non-sacred containers onto Noor Glass while preserving prayer-status colors

### Phase 4 — Worship dhikr / fasting / khusu
- Scope:
  - `dhikr_section.dart`
  - `fasting_section.dart`
  - `khusu_section.dart`
- Goal:
  - remove remaining parchment/micro-surface drift in Worship support sections

### Phase 5 — Journey / Growth family
- Scope:
  - growth home / browse / paths / calendar / stats-adjacent summary surfaces
- Goal:
  - replace local parchment or neutral boxes with Noor Glass-aligned surfaces

### Phase 6 — Learn landing / category / section surfaces
- Scope:
  - learn landing and category/island families
  - reusable Learn entry surfaces
- Goal:
  - make non-sacred Learn containers read as Noor Glass while keeping tasteful accents

### Phase 7 — Qur’an non-sacred support surfaces
- Scope:
  - Qur’an hub utility cards
  - non-sacred recommendation / search / summary support cards
- Goal:
  - keep sacred blocks on sanctuary styling
  - move utility/support containers to Noor Glass

### Phase 8 — Dua / Hadith / Stories / support detail pages
- Scope:
  - non-sacred detail/support panels in learning domains
- Goal:
  - preserve sacred/devotional blocks where appropriate, unify everything else

### Phase 9 — Kids / family non-sacred surfaces
- Scope:
  - kids-family support pages and non-sacred browsing containers
- Goal:
  - align family-friendly surfaces with Noor Glass while preserving accent identity

### Phase 10 — Final audit + micro-surface cleanup
- Scope:
  - remaining outliers
  - small chips, badges, helper panels, and residual local decorations
- Goal:
  - close the last visible drift and prepare the follow-up recommendations

## Phase 1 audit findings

- Shared `PremiumCard` surfaces already respond well to the new solid Noor Glass theme.
- The biggest Phase 1 drift is inside the settings/profile family where some nested subpanels still use page-local parchment fills.
- The most visible local drift found for Phase 1:
  - `lib/features/profile/presentation/profile_summary_page.dart`
  - `lib/features/profile/presentation/profile_coming_soon_page.dart`
  - `lib/features/profile/presentation/help_guide_detail_page.dart`
- The main settings and help-guide landing shells are already mostly on shared surfaces, so Phase 1 should be a contained cleanup rather than a redesign.

## Progress notes

### Phase 1 complete
- `lib/features/profile/presentation/profile_summary_page.dart`
  - replaced local parchment value tiles with shared Noor-compatible panel surfaces
- `lib/features/profile/presentation/profile_coming_soon_page.dart`
  - replaced local parchment icon container with shared panel styling
- `lib/features/profile/presentation/help_guide_detail_page.dart`
  - moved numbered step badges onto shared pill styling while keeping accent cues

### Phase 2 complete
- `lib/features/home/presentation/home_page.dart`
  - moved selected calendar cells, welcome icon panel, prayer hero stats layer, and prayer hero icon tile onto shared Noor-compatible surfaces
- kept prayer/status accent colors intact while removing the last Home-local parchment drift

### Phase 3 complete
- `lib/features/worship/presentation/worship_section_pages.dart`
  - moved prayer-related tracking link cards off local parchment styling and onto shared Noor card/panel surfaces
- `lib/features/worship/presentation/widgets/prayer_section.dart`
  - replaced prayer-page default `Chip` surfaces with shared Noor pill surfaces for sister-cycle focus tags and Qada queue pills
- prayer status colors and data markers remain intact; this phase targeted only the non-sacred container drift

### Phase 4 complete
- `lib/features/worship/presentation/widgets/dhikr_section.dart`
  - moved the anti-rush dialog off custom parchment chrome and onto a shared Noor-compatible card surface
  - replaced the phrase selection pills with shared Noor pill styling while preserving gold selection cues
- `lib/features/worship/presentation/widgets/fasting_section.dart`
  - moved fasting type and fasting status selectors onto shared Noor pill styling while preserving selection accents
- `lib/features/worship/presentation/widgets/khusu_section.dart`
  - moved focus-card icon tiles onto shared Noor panel styling with the same gold emphasis
- worship behavior, sacred text content, and functional status meaning remain unchanged

### Phase 5 complete
- `lib/features/journey/presentation/widgets/growth_ui_helpers.dart`
  - added shared Noor pill/panel helpers for Journey/Growth pages to reuse instead of repeating parchment box styles
- `lib/features/journey/presentation/growth_path_detail_page.dart`
  - moved path-detail metadata and milestone pills onto shared Noor pill styling
- `lib/features/journey/presentation/growth_journey_page.dart`
  - moved unlock/theme chips onto shared Noor pill styling
  - replaced older local subtle text colors with shared Noor subtle text
- `lib/features/journey/presentation/growth_today_page.dart`
  - moved seasonal journey chips onto shared Noor pill styling
  - aligned helper text colors with the shared Noor text language
- `lib/features/journey/presentation/growth_paths_page.dart`
  - moved path icon tiles off parchment icon boxes and onto shared Noor panel styling
  - aligned subtitle color with shared Noor text
- `lib/features/journal/presentation/journal_timeline_page.dart`
  - moved tiny filter/history chips onto shared Noor pill styling
- `lib/features/journal/presentation/journal_entry_detail_page.dart`
  - moved detail chips onto shared Noor pill styling
- this phase focused on the clearest non-sacred helper-panel and pill drift in Journey/Growth/Journal, while leaving larger chart/gallery surfaces for later phases

### Phase 6 complete
- `lib/features/learn/presentation/widgets/learn_segmented_control.dart`
  - moved the shared Learn segmented control onto Noor-compatible shared panel/pill surfaces
- `lib/features/learn/presentation/widgets/learn_personalized_next_step_card.dart`
  - moved the context badge and secondary suggestion panels onto shared Noor pill/panel surfaces
- `lib/features/learn/presentation/widgets/learn_category_card.dart`
  - aligned the category-card dust/accent treatment with the shared Noor accent palette
- `lib/features/learn/presentation/pages/learn_category_page.dart`
  - moved category badge chips onto shared Noor pill styling while preserving category accent color
- `lib/features/learn/presentation/widgets/learn_cards.dart`
  - moved shared Learn action-card icon tiles onto Noor panel styling
- this phase focused on the shared Learn landing/category entry surfaces first, so many Learn entrypoints now inherit Noor Glass more consistently without a broad feature-page rewrite

### Phase 7 complete
- `lib/features/learn/quran/presentation/widgets/quran_feature_components.dart`
  - moved shared Qur’an filter chips off stock `ChoiceChip` styling and onto Noor-compatible shared pill surfaces
- `lib/features/learn/quran/presentation/widgets/quran_reference_viewer.dart`
  - moved the reference chip and viewer metadata/topic chips onto shared Noor pill styling
- `lib/features/learn/quran/presentation/quran_daily_companion_page.dart`
  - moved daily companion metadata chips and journey-context chips onto shared Noor pill styling
- sacred Qur’an blocks and verse presentation were intentionally left unchanged; this phase targeted only non-sacred Qur’an support surfaces

### Phase 8 complete
- `lib/features/learn/dua/presentation/dua_hub_page.dart`
  - moved Dua hub filter chips and category action chips onto Noor-compatible shared pill surfaces
  - moved category/meta chips onto Noor-compatible pill styling while preserving Dua accent identity
- `lib/features/learn/hadith/presentation/hadith_theme_page.dart`
  - moved Hadith preview badges onto Noor-compatible shared pill styling
- `lib/features/learn/hadith/presentation/hadith_learning_path_page.dart`
  - moved path milestone badges onto Noor-compatible shared pill styling
- `lib/features/kids/bedtime_stories/presentation/bedtime_story_detail_page.dart`
  - moved story-detail support meta chips onto Noor-compatible shared pill styling
- sacred/devotional primary blocks were intentionally left unchanged; this phase targeted non-sacred support/detail surfaces

### Phase 9 complete
- `lib/features/kids_dua_learning/presentation/kids_dua_landing_page.dart`
  - moved kids dua hero, light, feature, category, and quick-entry containers onto shared Noor panel/island surfaces
  - moved kids dua icon tiles and stat pills onto shared Noor panel/pill styling while preserving the playful gold accent language
- `lib/features/kids_dua_learning/presentation/kids_dua_category_page.dart`
  - moved the category progress card, lesson cards, icon tiles, and level/status chips onto shared Noor panel/pill surfaces
- `lib/features/kids/bedtime_stories/presentation/bedtime_stories_page.dart`
  - moved the bedtime hero count chip, story-list cover tiles, and metadata chips onto shared Noor panel/pill surfaces
- `lib/features/kids/bedtime_stories/presentation/kids_story_library_page.dart`
  - moved story-list icon tiles and info chips onto shared Noor panel/pill surfaces
- `lib/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart`
  - replaced family-mode learner `ChoiceChip` controls with shared Noor pill surfaces
  - moved helper badges and icon tiles in the parent dashboard onto shared Noor panel/pill surfaces
- this phase intentionally focused on kids/family browsing and dashboard chrome, while leaving sacred lesson content and larger player/quiz surfaces for later phases

### Phase 10 complete
- `lib/features/kids_dua_learning/presentation/kids_dua_my_day_page.dart`
  - moved the My Day hero, progress panel, guidance cards, section cards, status badges, and dua rows onto shared Noor panel/island/pill surfaces
- `lib/features/kids/bedtime_stories/presentation/bedtime_story_family_mode_page.dart`
  - moved learner cards and archived rows onto Noor panel surfaces
  - replaced avatar `ChoiceChip` selectors and current-learner tags with shared Noor pill surfaces
- `lib/features/kids/bedtime_stories/presentation/bedtime_story_full_player_sheet.dart`
  - moved the player sheet shell, handle, and support chips onto shared Noor-compatible surfaces
- final audit status
  - the biggest cross-app parchment drift has been removed from Home, Worship, Journey, Learn, Qur’an support surfaces, Dua/Hadith support pages, Settings/Profile support pages, and the main Kids/Family browsing/dashboard flows
  - remaining drift is now mostly limited to specialized or high-complexity micro-surfaces such as some player/quiz/support widgets, analytics/chart cells, and a handful of legacy feature-specific helper panels
