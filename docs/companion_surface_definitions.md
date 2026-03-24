# Companion Surface Definitions

Date: 2026-03-23
Phase: V9 companion surfaces definition

## Adjacent surfaces audited

### Seerah-adjacent

- [ProphetsPage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/prophets/presentation/prophets_page.dart)
  - strong narrative, timeline, map, and quiz owner for prophets broadly
  - not a true owner for the life of the Prophet Muhammad ﷺ specifically
- [HadithLandingPage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/hadith/presentation/hadith_landing_page.dart)
  - strong teaching/review owner for hadith collections, themes, paths, and daily reflection
  - not a Seerah owner
- [HistoryArchivePage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/history/presentation/history_archive_page.dart)
  - strong archive/timeline owner with category filters, including `seerah`
  - useful adjacent owner for historical browsing, not the main Seerah learning home
- Kids Seerah surfaces under [lib/features/kids/seerah](/Users/shahabmansoor/Developer/path_of_nur/lib/features/kids/seerah)
  - useful structural inspiration for story + stage + companion organization
  - not the owner for adult/main Learn Seerah

### Character / Adab-adjacent

- [LifeLandingPage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/life/presentation/life_landing_page.dart)
  - current visible Learn owner for the Character & Adab taxonomy entry
  - broad everyday-life curriculum, not a focused character/adab home
- [DivineLifeLessonsPage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart)
  - closest thematic overlap: reflection, character, grounded living
  - still too broad and not route-owned as the Character/Adab companion destination
- [HadithLandingPage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/hadith/presentation/hadith_landing_page.dart)
  - supports character-focused reflections and themes
  - should remain a supporting source, not the primary Character/Adab owner
- Qur'an insights already include character/adab themes
  - should remain supporting source material, not a separate character landing

### Daily Wisdom / Reflection-adjacent

- `daily-wisdom` Learning Journey already exists in [learning_journey_registry.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/journey/data/learning_journey_registry.dart)
  - useful product intent already exists
  - no dedicated owned page exists yet
- [LearnNotesLandingPage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/content/presentation/learn_notes_landing_page.dart)
  - broader notes/discovery owner
  - not the right daily wisdom owner
- [JournalTimelinePage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journal/presentation/journal_timeline_page.dart)
  - personal writing/timeline owner
  - not the right incoming daily-wisdom owner
- [QuranReflectionsPage](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reflections_page.dart)
  - Qur'an-specific reflection owner
  - too narrow to own cross-source daily wisdom

## What already exists vs what is missing

- Existing and reusable:
  - Prophets storytelling and navigation surfaces
  - Hadith theme/reflection surfaces
  - history archive browsing
  - Life / Divine Life lesson datasets
  - Qur'an learning and reflection surfaces
  - Learning Journey stage/journey structure
- Missing:
  - adult/main Seerah companion home
  - dedicated Character / Adab companion home
  - dedicated Daily Wisdom / Reflection companion page

## Surface definitions

### 1. Seerah companion surface

- Purpose:
  - own broad Seerah browsing plus direct companion entry for Hijrah, Madinah society, and other life-of-the-Prophet ﷺ journey actions
- Recommended canonical route:
  - `/learn/seerah`
- IA placement:
  - Learn
  - Core Knowledge
  - adjacent to Prophets and Hadith, but as its own owned destination
- V1 page structure:
  - hero: Seerah purpose and why it matters
  - journey resume / continue card
  - key periods rail:
    - Early life
    - Revelation
    - Makkah
    - Hijrah
    - Madinah society
    - Leadership and character
    - Final sermon
  - companion sources section:
    - linked Qur'an references
    - related hadith themes
    - history archive handoff
  - deeper exploration section:
    - “Open Seerah Journey”
    - “Browse historical context”
    - “Related Prophets context”
- Data/content ownership model:
  - primary owner should be a new companion-specific Seerah surface model
  - reuse existing adult Seerah journey stage metadata as the first structured backbone
  - enrich with history archive entries tagged `seerah`
  - optionally link to Prophets/Hadith/Qur'an, but do not make them the owner
- Scaffold created:
  - no

### 2. Character / Adab companion surface

- Purpose:
  - own the trait-based practical character path that sits between broad life lessons and hadith/Qur'an reference material
- Recommended canonical route:
  - `/learn/character`
- IA placement:
  - Learn
  - Character & Adab category
  - should later become the canonical taxonomy target instead of sending users straight to broad Life landing
- V1 page structure:
  - hero: beautiful character as lived Islam
  - core traits grid:
    - sincerity
    - patience
    - gratitude
    - humility
    - forgiveness
    - anger control
    - kindness
  - practical life section:
    - real-life scenarios
    - short action steps
    - reflection prompt
  - source support section:
    - related hadith themes
    - related Qur'an character/adab insights
    - related life/divine lesson handoffs
  - continue journey section:
    - beautiful-character journey handoff
- Data/content ownership model:
  - primary backbone should reuse the existing `beautiful-character` journey stages plus filtered Divine Life lessons
  - hadith reflections and Qur'an insights should support the page as source modules, not replace it
  - avoid introducing a second broad “life lessons” system
- Scaffold created:
  - no

### 3. Daily Wisdom / Reflection companion surface

- Purpose:
  - own one small daily reminder layer that can open a verse, hadith, prophetic example, or reflection prompt without turning into Journal or Notes
- Recommended canonical route:
  - `/learn/daily-wisdom`
- IA placement:
  - Learn
  - Discovery
  - should stay lightweight and should not become a second journaling system
- V1 page structure:
  - hero: today’s wisdom card
  - source chip:
    - Qur'an
    - Hadith
    - Prophetic example
    - Reflection prompt
  - short lesson block:
    - one explanation
    - one practical step
    - one return-later prompt
  - related route handoff:
    - open source owner
    - save to notes / journal only as secondary actions
  - recent rhythm strip:
    - last few opened wisdom items
- Data/content ownership model:
  - use a lightweight new daily-wisdom entry model
  - entries should reference existing source owners such as Qur'an, Hadith, Prophets, or Life content instead of duplicating them
  - keep it widget/home-card ready for later expansion
  - do not make Learn Notes or Journal the owner
- Scaffold created:
  - no

## Journey integration plan

- `seerah-journey`
  - later route to `/learn/seerah`
- `seerah-hijrah`
  - later route to `/learn/seerah` with a focused entry state or section anchor for Hijrah
- `seerah-madinah-society`
  - later route to `/learn/seerah` with a focused entry state or section anchor for Madinah society
- `beautiful-character`
  - later route to `/learn/character`
- `wisdom-daily-quote`
  - later route to `/learn/daily-wisdom`

## Recommended next build phase

- V10 should implement lightweight production-safe landing pages and routes for:
  - `/learn/seerah`
  - `/learn/character`
  - `/learn/daily-wisdom`
- That implementation should:
  - keep current visible fallbacks in place until each new surface is actually wired
  - reuse existing datasets first
  - add localized user-facing copy
  - only remap the corresponding fallback actions once each new page is safe and useful
