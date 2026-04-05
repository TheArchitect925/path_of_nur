# Noor Glass Global Rollout Backlog — 2026-04-03

## Enhancement options after Phase 3

- Worship prayer stats polish
  - reason: the prayer trend bars, consistency dots, and heatmap markers still rely on older raw color fills; they are functionally fine, but could later gain a more refined Noor-style framing without losing meaning
  - priority: medium
  - likely files:
    - `lib/features/worship/presentation/widgets/prayer_section.dart`

- Worship section-hub accent harmonization
  - reason: the main Worship landing actions already keep their accent colors, but we may later want to confirm their base surface layering still matches the newest Noor Glass feel exactly
  - priority: low
  - likely files:
    - `lib/features/worship/presentation/worship_page.dart`
    - `lib/shared/widgets/section_hub_scaffold.dart`

- Phase 4 prep
  - reason: `dhikr_section.dart`, `fasting_section.dart`, and `khusu_section.dart` still contain the clearest remaining worship-local micro-surfaces and parchment-style boxes
  - priority: high
  - likely files:
    - `lib/features/worship/presentation/widgets/dhikr_section.dart`
    - `lib/features/worship/presentation/widgets/fasting_section.dart`
    - `lib/features/worship/presentation/widgets/khusu_section.dart`

## Enhancement options after Phase 4

- Dhikr action-button harmonization
  - reason: the main Dhikr flow still mixes shared Noor cards with stock text/elevated button controls; that is fine functionally, but a later polish pass could make the action row feel more visually unified
  - priority: medium
  - likely files:
    - `lib/features/worship/presentation/widgets/dhikr_section.dart`

- Worship progress-indicator polish
  - reason: the linear progress bars across prayer, dhikr, and fasting are consistent enough now, but could later be tuned together if the app needs a stronger Noor-specific progress language
  - priority: low
  - likely files:
    - `lib/features/worship/presentation/widgets/prayer_section.dart`
    - `lib/features/worship/presentation/widgets/dhikr_section.dart`
    - `lib/features/worship/presentation/widgets/fasting_section.dart`

- Phase 5 prep
  - reason: Journey and growth pages are the next likely source of non-sacred parchment or neutral container drift after Worship is cleaned up
  - priority: high
  - likely files:
    - `lib/features/journey/`
    - `lib/features/journal/`
    - `lib/features/garden/`

## Enhancement options after Phase 5

- Journey dashboard/chart surface polish
  - reason: the biggest remaining journey drift is now in chart-adjacent and analytics micro-panels, especially in the growth tracking dashboard and some garden/gallery pages
  - priority: high
  - likely files:
    - `lib/features/journey/presentation/growth_tracking_dashboard_page.dart`
    - `lib/features/garden/presentation/garden_page.dart`
    - `lib/features/journey/drops/presentation/widgets/garden_gallery.dart`

- Growth browse/search localization cleanup
  - reason: a few Growth pages still have older hardcoded search/helper copy that predates the stricter localization-ready standard
  - priority: medium
  - likely files:
    - `lib/features/journey/presentation/growth_paths_page.dart`

- Phase 6 prep
  - reason: Learn landing/category/section surfaces are the next broad non-sacred area after Journey/Growth/Journal
  - priority: high
  - likely files:
    - `lib/features/learn/presentation/`
    - `lib/features/learn/**/presentation/`

## Enhancement options after Phase 6

- Learn feature-page chip cleanup
  - reason: many shared Learn entry surfaces are now aligned, but several feature-specific hubs still use their own local `ChoiceChip`, `ActionChip`, and parchment metadata chip patterns
  - priority: high
  - likely files:
    - `lib/features/learn/presentation/pages/learn_quizzes_hub_page.dart`
    - `lib/features/learn/presentation/pages/learn_salah_hub_page.dart`
    - `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
    - `lib/features/learn/dua/presentation/dua_hub_page.dart`

- Learn localization hygiene
  - reason: some Learn pages still have older hardcoded helper/search copy that predates the stricter localization-ready standard
  - priority: medium
  - likely files:
    - `lib/features/learn/presentation/pages/growth_paths_page.dart`
    - `lib/features/learn/presentation/pages/*`

- Phase 7 prep
  - reason: Qur’an non-sacred support surfaces are the next most important domain-specific surface family after the shared Learn entry widgets
  - priority: high
  - likely files:
    - `lib/features/learn/quran/presentation/`

## Enhancement options after Phase 7

- Qur’an utility-page chip sweep
  - reason: several Qur’an support pages still use local `Chip`, `ChoiceChip`, and `ActionChip` styling beyond the shared/support slice cleaned in Phase 7
  - priority: high
  - likely files:
    - `lib/features/learn/quran/presentation/quran_memorization_review_page.dart`
    - `lib/features/learn/quran/presentation/quran_short_surah_readiness_page.dart`
    - `lib/features/learn/quran/presentation/quran_guided_passage_readiness_page.dart`
    - `lib/features/learn/quran/presentation/quran_search_page.dart`

- Qur’an reader utility polish
  - reason: the reader has many mixed support chips and helper panels, but it is a high-risk surface and should be handled separately from the simpler support-page sweep
  - priority: medium
  - likely files:
    - `lib/features/learn/quran/presentation/quran_reader_page.dart`
    - `lib/features/learn/quran/presentation/widgets/quran_playback_controls_card.dart`

- Phase 8 prep
  - reason: non-sacred support/detail surfaces in Dua, Hadith, and related learning pages are the next major domain after Qur’an support surfaces
  - priority: high
  - likely files:
    - `lib/features/learn/dua/presentation/`
    - `lib/features/learn/hadith/presentation/`
    - adjacent non-sacred support detail pages

## Enhancement options after Phase 8

- Dua support-page chip sweep
  - reason: the Dua hub is aligned now, but some supporting pages still use localized one-off chip/panel styling beyond the hub filter/meta family
  - priority: medium
  - likely files:
    - `lib/features/learn/dua/presentation/dua_detail_page.dart`

- Hadith quiz and path support polish
  - reason: Hadith preview/path badges are aligned, but quiz/session milestone chips and some path-support surfaces still use local styles
  - priority: medium
  - likely files:
    - `lib/features/learn/hadith/presentation/hadith_quiz_session_page.dart`
    - `lib/features/learn/hadith/presentation/hadith_learning_path_page.dart`

- Phase 9 prep
  - reason: kids/family non-sacred browsing and support pages are the next broad surface family after the adult learning/support domains
  - priority: high
  - likely files:
    - `lib/features/kids_dua_learning/presentation/`
    - `lib/features/kids/bedtime_stories/presentation/`

## Enhancement options after Phase 9

- Kids story player and family-mode support polish
  - reason: the kids/family browsing surfaces are aligned now, but the bedtime story player/family-mode flows still contain local chips and helper panels outside this browsing/dashboard pass
  - priority: high
  - likely files:
    - `lib/features/kids/bedtime_stories/presentation/bedtime_story_family_mode_page.dart`
    - `lib/features/kids/bedtime_stories/presentation/bedtime_story_full_player_sheet.dart`
    - `lib/features/kids/bedtime_stories/presentation/bedtime_story_mini_player.dart`

- Kids dua lesson/practice micro-surface cleanup
  - reason: the kids dua landing/category entry surfaces are aligned, but lesson, practice, tap-repeat, and my-day pages still carry older local support boxes and chips
  - priority: high
  - likely files:
    - `lib/features/kids_dua_learning/presentation/kids_dua_lesson_page.dart`
    - `lib/features/kids_dua_learning/presentation/kids_dua_my_day_page.dart`
    - `lib/features/kids_dua_learning/presentation/kids_dua_practice_page.dart`
    - `lib/features/kids_dua_learning/presentation/kids_dua_tap_repeat_view.dart`

- Kids family dashboard accent pass
  - reason: the parent dashboard now uses Noor-compatible surfaces, but a later polish pass could tune how much accent tint the badges and stat cards carry so the kids area feels cohesive without losing warmth
  - priority: medium
  - likely files:
    - `lib/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart`

- Phase 10 prep
  - reason: the last rollout step should be a final outlier audit focused on remaining chips, helper panels, player sheets, quizzes, and micro-surfaces across the app
  - priority: high
  - likely files:
    - `lib/features/kids/`
    - `lib/features/worship/`
    - `lib/features/learn/`
    - `lib/features/journey/`

## Enhancement options after Phase 10

- Qur’an utility chip completion pass
  - reason: several Qur’an support and readiness pages still use stock `Chip`, `ChoiceChip`, and `ActionChip` patterns outside the earlier Noor cleanup slices
  - priority: high
  - likely files:
    - `lib/features/learn/quran/presentation/quran_memorization_review_page.dart`
    - `lib/features/learn/quran/presentation/quran_short_surah_readiness_page.dart`
    - `lib/features/learn/quran/presentation/quran_guided_passage_readiness_page.dart`
    - `lib/features/learn/quran/presentation/quran_search_page.dart`

- Kids lesson/player micro-surface polish
  - reason: the main kids browsing and dashboard flows are aligned, but some lesson, practice, drawing, player, and story-play surfaces still carry older local support boxes
  - priority: high
  - likely files:
    - `lib/features/kids_dua_learning/presentation/kids_dua_lesson_page.dart`
    - `lib/features/kids_dua_learning/presentation/kids_dua_practice_page.dart`
    - `lib/features/kids_dua_learning/presentation/kids_dua_story_player_page.dart`
    - `lib/features/kids_dua_learning/presentation/kids_dua_rewards_page.dart`
    - `lib/features/kids/bedtime_stories/presentation/bedtime_story_mini_player.dart`

- Journey and worship analytics polish
  - reason: most main cards are aligned now, but some chart cells, dashboard strips, and analytics helper panels still use older localized fills
  - priority: medium
  - likely files:
    - `lib/features/journey/presentation/growth_tracking_dashboard_page.dart`
    - `lib/features/journey/presentation/growth_habit_dashboard_page.dart`
    - `lib/features/worship/presentation/widgets/prayer_section.dart`

- Final global audit follow-up
  - reason: if you want a true zero-drift finish later, the next step is a repo-wide grep-and-polish pass for every remaining local chip/panel pattern
  - priority: medium
  - likely files:
    - `lib/features/`
    - `lib/shared/widgets/`
