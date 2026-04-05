# Noor Glass Post-Rollout Audit — 2026-04-03

## Overall state

The main runtime app experience is substantially aligned to Noor Glass after the 10-phase rollout. The biggest broad parchment drift was removed from:

- Home
- Settings/Profile support pages
- Worship main support surfaces
- Journey/Growth main support surfaces
- Learn landing/category entry surfaces
- Qur'an non-sacred support surfaces
- Dua/Hadith support/detail surfaces
- Kids Dua and Bedtime Stories main browsing/dashboard flows

The remaining drift is now concentrated in specialized or unreviewed feature families rather than the main shared app paths.

## Strongly aligned areas

- `lib/features/home/presentation/`
- `lib/features/profile/presentation/` support pages touched in Phase 1
- `lib/features/worship/presentation/` main prayer/dhikr/fasting/khusu surfaces touched in Phases 3–4
- `lib/features/journey/presentation/` main browse/path/today surfaces touched in Phase 5
- `lib/features/learn/presentation/widgets/` shared landing/category widgets touched in Phase 6
- `lib/features/learn/quran/presentation/` shared non-sacred support slices touched in Phase 7
- `lib/features/learn/dua/presentation/dua_hub_page.dart`
- `lib/features/learn/hadith/presentation/` support slices touched in Phase 8
- `lib/features/kids_dua_learning/presentation/` landing/category/my-day slices touched in Phases 9–10
- `lib/features/kids/bedtime_stories/presentation/` library/landing/dashboard/family/player-sheet slices touched in Phases 9–10

## Missed or still drifting areas

### 1. Kids Arabic family

This is the largest untouched kids-family surface cluster after the main rollout.

Examples:

- `lib/features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart`
- `lib/features/kids_arabic/presentation/kids_arabic_practice_page.dart`
- `lib/features/kids_arabic/presentation/kids_arabic_progress_map_page.dart`
- `lib/features/kids_arabic/presentation/kids_arabic_rewards_page.dart`
- `lib/features/kids_arabic/presentation/kids_arabic_words_page.dart`
- `lib/features/kids_arabic/presentation/kids_arabic_reading_mode_page.dart`

Why it matters:

- many cards still use local warm parchment or white box styling
- this is now the biggest visible non-Noor family in the repo

Classification:

- real miss

### 2. Qur'an utility/readiness/review pages

Several pages still use stock chip families or local parchment-like utility panels.

Examples:

- `lib/features/learn/quran/presentation/quran_memorization_review_page.dart`
- `lib/features/learn/quran/presentation/quran_short_surah_readiness_page.dart`
- `lib/features/learn/quran/presentation/quran_guided_passage_readiness_page.dart`
- `lib/features/learn/quran/presentation/quran_search_page.dart`
- `lib/features/learn/quran/presentation/quran_notes_page.dart`

Why it matters:

- these are non-sacred utility/support surfaces that should match Noor Glass
- they still contain stock `Chip`, `ChoiceChip`, or `ActionChip` patterns

Classification:

- real miss

### 3. Qur'an reader and advanced support chrome

Examples:

- `lib/features/learn/quran/presentation/quran_reader_page.dart`
- `lib/features/learn/quran/presentation/widgets/quran_playback_controls_card.dart`

Why it matters:

- visible but high-risk
- lots of support chips and local helper panels remain

Classification:

- known deferred/high-risk, not a rollout failure

### 4. Journey/Growth analytics dashboards

Examples:

- `lib/features/journey/presentation/growth_tracking_dashboard_page.dart`
- `lib/features/journey/presentation/growth_habit_dashboard_page.dart`

Why it matters:

- chart cells, stat strips, and analytics helper panels still use older localized fills

Classification:

- minor-to-medium drift

### 5. Learn feature-specific hubs and deeper support pages

Examples:

- `lib/features/learn/presentation/pages/learn_quizzes_hub_page.dart`
- `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
- `lib/features/learn/presentation/pages/learn_explore_all_knowledge_page.dart`
- `lib/features/learn/content/presentation/learn_notes_browse_page.dart`

Why it matters:

- these still contain stock chip families and some local container styling

Classification:

- moderate drift

### 6. Kids Dua deeper lesson/practice/reward surfaces

Examples:

- `lib/features/kids_dua_learning/presentation/kids_dua_lesson_page.dart`
- `lib/features/kids_dua_learning/presentation/kids_dua_practice_page.dart`
- `lib/features/kids_dua_learning/presentation/kids_dua_story_player_page.dart`
- `lib/features/kids_dua_learning/presentation/kids_dua_rewards_page.dart`

Why it matters:

- main browsing flows are aligned, but deeper activity/lesson micro-surfaces still use older local boxes

Classification:

- real remaining drift

### 7. Bedtime mini-player and some player-adjacent widgets

Examples:

- `lib/features/kids/bedtime_stories/presentation/bedtime_story_mini_player.dart`
- `lib/features/kids/bedtime_stories/presentation/bedtime_story_cover_card.dart`
- `lib/features/kids/bedtime_stories/presentation/bedtime_story_question_card.dart`

Why it matters:

- smaller, but still part of a visible kids-family runtime flow

Classification:

- minor drift

### 8. Specialized/admin/utility areas outside the main user journey

Examples:

- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
- `lib/features/editorial_dashboard/presentation/editorial_dashboard_page.dart`
- `lib/features/wallpaper/presentation/wallpaper_library_page.dart`

Why it matters:

- still use stock chip patterns and local surfaces
- lower priority unless they are part of your visual QA target

Classification:

- acceptable to leave for now unless you want full-repo strictness

## Shared widget layer checks

Mostly fine, but a few shared widgets still own local decorative logic by design:

- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/prayer_location_picker_sheet.dart`
- `lib/shared/widgets/shortcut_dock.dart`
- `lib/shared/widgets/segmented_pill_control.dart`

These are not necessarily mistakes, but they are worth watching during visual QA because shared-level drift is more visible across the app.

## Recommended visual QA order

1. Home
2. Worship
3. Learn landing/category pages
4. Qur'an utility pages
5. Kids Dua
6. Bedtime Stories
7. Kids Arabic
8. Journey/Growth dashboards

## Bottom line

If the goal is:

- main app experience aligned to Noor Glass

then the rollout is in good shape.

If the goal is:

- every notable runtime surface in the repo aligned to Noor Glass

then the biggest remaining misses are:

1. Kids Arabic
2. Qur'an utility/readiness/review pages
3. Kids Dua deeper lesson/practice/rewards/player surfaces
4. Journey/Growth analytics dashboards
5. a smaller set of admin/utility feature pages
