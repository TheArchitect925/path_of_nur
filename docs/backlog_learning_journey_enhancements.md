# Learning Journey Enhancement Backlog

These are follow-on refinements after the current stage-wiring pass.

## Highest value next

- Add route-safe initial section support for `QuranTeachingSectionPage` so Arabic journey stages can land directly in:
  - recommended lesson
  - daily review
  - review mistakes
  - listen only
- Add a dedicated Wudu confidence page covering:
  - common beginner mistakes
  - what breaks wudu
  - short self-check before salah
- Add a curated Qur'anic word grouping layer for:
  - recurring roots
  - thematic clusters
  - memorization sets

## Content wiring improvements

- Add prophet-specific deep links from journey stages into:
  - prophet story detail
  - timeline segment
  - map context
- Add dedicated Hadith path deep links so a journey stage can open:
  - a starter path
  - a specific review mode
  - a daily reflection view
- Add stage-specific trivia path entry so "Practice a session" can land in:
  - the active knowledge path
  - the current stage quiz

## Placeholder reduction

- Replace remaining partial/placeholder stages in:
  - `Understand What You Recite`
  - `Reading Basics`
  - `Timeline of Islam`
  - `Daily Wisdom`
  - `Tajweed Basics`

## Metadata cleanup

- Add a small internal audit table for every journey stage with:
  - `real`
  - `partial`
  - `placeholder`
  - owning route/page
  - best related tools

## Next content pass after recitation/reading

- Localize the previously-added Seerah, Dhikr, Dua, and Aqeedah lesson bodies instead of leaving them as English-only legacy lesson content.
- Add dedicated lesson-backed stages for:
  - `Timeline of Islam`
  - `Daily Wisdom`
  - `Tajweed Basics`
- Add stage-specific entry hints for:
  - Hadith paths
  - Trivia knowledge path stages
  - Prophets detail deep links

## Localization follow-ups
- Localize model-backed journey registry titles, subtitles, descriptions, stage summaries, and legacy lesson bodies through a dedicated localized metadata layer instead of English fallback model data.
- Move Today’s Light fallback titles/subtitles out of provider-level English literals and into locale-aware helpers or localized UI mapping.
- Add translated values for the new Learning Journey ARB keys beyond the current English fallback copies.

## Next deep-content build options
- Localize the newly added expanded lesson bodies in `learning_journey_lesson_content.dart` through a dedicated lesson-content localization layer once the wording is approved.
- Split mid-tier journey lesson content into domain files: Qur’an paths, fiqh, timeline, tajweed, daily wisdom, and stories/signs.
- Add stage-specific deep links into trivia paths, daily wisdom detail pages, and richer Qur’anic Arabic audio drills once those destination states are stable.

## Advanced content follow-ups
- Localize the remaining older seeded lesson bodies that still live only in `learning_journey_lesson_content.dart`, especially fiqh, timeline, tajweed, daily wisdom, and stories/signs stages added in the previous pass.
- Add stage-specific destination states so related tools can land on the exact Prophet, Qur’anic Arabic, or daily wisdom context instead of broad hubs.
- Replace the last registry-backed English titles, subtitles, summaries, and mapping notes with an id-based localized metadata layer.

## Enhancement options from cross-journey + character pass
- Add journey-aware recommended next stages so lesson pages can deep-link directly into the next unfinished stage, not only the journey detail page.
- Localize registry-backed island, journey, and stage metadata by id so all cards and summaries stop relying on English fallback text.
- Build a dedicated Daily Wisdom detail route that rotates one unified item per day from Qur’an, Hadith, Seerah, and reflection sources.
- Add completion reflections for older journeys that still end on utility stages rather than a clear final synthesis moment.
- Introduce lightweight spaced-review prompts for Arabic words and recitation journeys based on recently completed stages.
