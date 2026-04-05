# Noor Glass Visual QA Audit — 2026-04-03

## Confirmed misses before visual QA

### High-priority misses

- Home
  - `lib/features/home/presentation/home_page.dart`
  - `Today’s ayah` still uses its older shared sacred/reflection presentation rather than the finalized Noor hero/container language used by the newer Home cards

- Learn hubs / main Learn entry surfaces
  - `lib/features/learn/presentation/pages/learning_section_landing_page.dart`
  - broad Learn landing still contains some local surfaces and accent-driven card treatments
  - first Noor cleanup pass has now landed on:
    - `lib/features/learn/presentation/pages/learn_quizzes_hub_page.dart`
    - `lib/features/learn/presentation/pages/learn_salah_hub_page.dart`
    - `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
  - those three pages were improved, but the wider Learn family still needs follow-up polish

- Salah path and related utility cards
  - `lib/features/salah/presentation/salah_page.dart`
  - `learn_salah_hub_page.dart` has now had a Noor cleanup pass, but `salah_page.dart` still remains a real miss
  - several path chips / choice chips / utility cards still use older local chrome in the broader Salah family

- Growth main pages
  - `lib/features/journey/presentation/growth_home_page.dart`
  - `lib/features/journey/presentation/growth_tracking_dashboard_page.dart`
  - `lib/features/journey/presentation/growth_habit_dashboard_page.dart`
  - main analytics/dashboard strips still show older localized fills and non-Noor support surfaces

- Qur'an utility/support pages
  - `lib/features/learn/quran/presentation/quran_memorization_review_page.dart`
  - `lib/features/learn/quran/presentation/quran_short_surah_readiness_page.dart`
  - `lib/features/learn/quran/presentation/quran_guided_passage_readiness_page.dart`
  - `lib/features/learn/quran/presentation/quran_search_page.dart`
  - `lib/features/learn/quran/presentation/quran_notes_page.dart`
  - several stock `Chip`, `ChoiceChip`, and `ActionChip` usages remain

### Medium-priority misses

- Kids Arabic family
  - `lib/features/kids_arabic/presentation/`
  - this remains the largest untouched Noor family in the repo

- Kids Dua deeper activity pages
  - `lib/features/kids_dua_learning/presentation/kids_dua_lesson_page.dart`
  - `lib/features/kids_dua_learning/presentation/kids_dua_practice_page.dart`
  - `lib/features/kids_dua_learning/presentation/kids_dua_rewards_page.dart`
  - `lib/features/kids_dua_learning/presentation/kids_dua_story_player_page.dart`

- Bedtime player/support widgets
  - `lib/features/kids/bedtime_stories/presentation/bedtime_story_mini_player.dart`
  - `lib/features/kids/bedtime_stories/presentation/bedtime_story_cover_card.dart`
  - `lib/features/kids/bedtime_stories/presentation/bedtime_story_question_card.dart`

### Lower-priority or acceptable-for-now areas

- admin / utility pages
  - `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
  - `lib/features/editorial_dashboard/presentation/editorial_dashboard_page.dart`
  - `lib/features/wallpaper/presentation/wallpaper_library_page.dart`

- specialized high-risk Qur'an reader chrome
  - `lib/features/learn/quran/presentation/quran_reader_page.dart`
  - `lib/features/learn/quran/presentation/widgets/quran_playback_controls_card.dart`

## Recommended QA order

1. Home
2. Learn landing and section hubs
3. Salah path/cards
4. Growth pages
5. Qur'an utility/support pages
6. Kids Arabic
7. Kids Dua / Bedtime deeper activity pages

## Bottom line

The app is much closer to Noor Glass than before, but the items above are still visible misses and should not be treated as fully complete until reviewed or corrected.
