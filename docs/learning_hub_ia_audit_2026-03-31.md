# Learning Hub IA Audit

Date: 2026-03-31
Scope: Learn / Learning Hub / learning-related routes, islands, pages, entry points, aliases, and overlap with Qur'an-owned learning surfaces
Mode: Audit-first, non-destructive

## Executive Summary

Path of Nur's Learning experience is already partway toward a calmer journey-led structure, but the current implementation still exposes several competing front doors:

- `/learn` is now a guided landing page (`LearningSectionLandingPage`)
- `/learn/legacy` still exposes the older broad library (`LearnPage`)
- `/learn/journey-home`, `/learn/learning-journey`, `/learn/island/:id`, and `/learn/journey/:id` form a second journey-first stack
- `/learn/explore`, `/learn/category/:categoryId`, `/learn/games`, `/learn/quizzes`, `/learn/duas`, `/learn/faq`, `/learn/hub/*`, and dedicated content-domain pages all remain active
- top-level `/quran/*` owns the strongest Qur'an learning surfaces, while older Learn-side aliases still exist

The result is not a broken system. It is a **multi-owner IA** where several structures are individually valid but collectively compete:

1. journey/island guidance
2. category taxonomy
3. legacy catalog/library
4. dedicated content domains
5. top-level Qur'an ownership
6. kids-first learning stack
7. quizzes/games stack

### Closeness To Target

Estimated closeness to the proposed simplified structure: **68%**

What is already aligned:

- `/learn` already emphasizes guided discovery over a flat library
- "Continue learning" already exists
- "Explore all" already exists
- games already has its own island
- major content clusters already exist and can be regrouped without deleting content
- Qur'an is already moving toward a distinct main owner

What still conflicts:

- too many top-level choices still have equal or near-equal weight
- multiple hub systems coexist
- Qur'an learning is split between top-level `/quran/*` and Learn-side language
- kids learning exists both as a category and as its own route family
- quizzes, trivia, and games overlap semantically and structurally
- some content feels grouped by implementation history rather than learner mental model

## Audit Inputs

Primary route ownership files scanned:

- `lib/app/routes/learn_routes.dart`
- `lib/app/routes/learn/learn_core_routes.dart`
- `lib/app/routes/learn/learn_hub_and_quiz_routes.dart`
- `lib/app/routes/learn/learn_content_domain_routes.dart`
- `lib/app/routes/learn/learn_kids_routes.dart`

Primary Learn IA/page owners scanned:

- `lib/features/learn/presentation/pages/learning_section_landing_page.dart`
- `lib/features/learn/presentation/learn_page.dart`
- `lib/features/learn/presentation/pages/learning_journey_island_hub_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_home_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_island_page.dart`
- `lib/features/learn/presentation/pages/learn_explore_all_knowledge_page.dart`
- `lib/features/learn/presentation/pages/learn_category_page.dart`
- `lib/features/learn/presentation/pages/games_island_page.dart`
- `lib/features/learn/presentation/pages/learn_quizzes_hub_page.dart`
- `lib/features/learn/presentation/pages/learn_quran_hub_page.dart`
- `lib/features/learn/content/presentation/learn_notes_landing_page.dart`

Primary data/index owners scanned:

- `lib/features/learn/presentation/data/learn_category_catalog.dart`
- `lib/features/learn/presentation/data/learn_hub_taxonomy.dart`
- `lib/features/learn/presentation/application/learn_hub_providers.dart`
- `lib/features/learn/journey/data/learning_journey_registry.dart`
- `lib/features/learn/presentation/models/learn_hub_models.dart`

Related cross-entry inspection:

- `lib/features/home/presentation/home_page.dart`
- route targets and named navigation references across `lib/features/home`, `lib/features/learn`, and `lib/shared`

## Current Top-Level Learning Experience

### Canonical current top-level Learn owner

`/learn` -> `LearningSectionLandingPage`

This is the current guided Learn landing, and it currently shows:

- search
- continue learning
- top actions:
  - Journey Islands
  - Explore All
  - Games
- then category actions from `LearnHubTaxonomy`
- then suggested items

### Parallel top-level or near-top-level Learn owners still active

- `/learn/legacy` -> `LearnPage`
- `/learn/journey-home` -> `LearningJourneyHomePage`
- `/learn/learning-journey` -> `LearningJourneyIslandHubPage`
- `/learn/explore` -> `LearnExploreAllKnowledgePage`
- `/learn/games` -> `GamesIslandPage`
- `/learn/quizzes` -> `LearnQuizzesHubPage`

### Top-level Qur'an owner that overlaps Learn

- `/quran`
- `/quran/learning`
- `/quran/summary`
- `/quran/paths`
- `/quran/insights`
- `/quran/arabic`
- more `/quran/*` learning routes

These are not secondary anymore. In practice they are major primary learning owners and should be treated as such in any future restructuring.

## Current Main Learning Islands / Categories Found

### Learn landing surface (`/learn`)

Main choices currently exposed:

- Continue Learning
- Journey Islands
- Explore All
- Games
- Foundations
- Qur'an & Hadith
- Prophets & Stories
- Worship & Practice
- Character & Adab
- Arabic Language
- Kids Learning
- Quizzes & Challenges
- FAQ
- Notes
- Tools & Explore

### Journey island registry

Current journey islands in `LearningJourneyRegistry`:

- Core Knowledge
- Practice & Ibadah
- Understanding Islam
- Arabic Learning
- Discovery
- Kids Learning
- Browse All
- Tools & Other
- Legacy Learning

These are conceptually useful, but they do not match the desired final simplified top-level island set.

### Category taxonomy on `/learn`

Current Learn hub taxonomy categories:

- Foundations
- Quran & Hadith
- Prophets & Stories
- Worship & Practice
- Character & Adab
- Arabic Language
- Kids Learning
- Quizzes & Challenges
- FAQ
- Notes
- Tools & Explore

### Legacy library categories in `/learn/legacy`

Active catalog items include:

- Holy Quran
- Qur'an Learning
- Learn Qur'anic Arabic
- Islamic Trivia
- Hadith
- Divine Life Lessons
- World & Creation
- Knowledge Constellation
- Stories of the Prophets
- Seerah Journey
- Glossary
- 99 Names of Allah
- Quizzes
- Duas
- Salah Trainer
- Notes
- Character & Adab
- Daily Wisdom
- FAQ

Hidden but still structurally present items:

- Islamic Guidance Hub
- Baby Names
- Becoming a Muslim
- Guidance for New Muslims
- Aqeedah Essentials
- The Five Pillars
- Ramadhan and Fasting
- Zakah & Sadaqah
- Jummah
- Hajj
- Umrah
- Eid
- Funeral
- Fiqh Basic

## Current Route Inventory

### Guided Learn / core hub routes

- `/learn`
- `/learn/legacy`
- `/learn/journey-home`
- `/learn/learning-journey`
- `/learn/island/:islandId`
- `/learn/journey/:journeyId`
- `/learn/journey/:journeyId/stage/:stageId`
- `/learn/explore`
- `/learn/browse` -> alias to `/learn/explore`
- `/learn/category/:categoryId`
- `/learn/games`
- `/learn/games/browse`
- `/learn/games/:sectionId`
- `/learn/family`
- `/learn/glossary`
- `/learn/guides`
- `/learn/guides/quran-lessons-mapping`
- `/learn/history`
- `/learn/history/today`
- `/learn/history/event/:slug`

### Learn hub / quizzes / worship / dua / FAQ routes

- `/learn/prophets`
- `/learn/hub/prophets` -> alias
- `/learn/section/prophets` -> alias
- `/learn/quizzes`
- `/learn/quizzes/trivia`
- `/learn/quizzes/daily-challenge`
- `/learn/quizzes/crossword`
- `/learn/quizzes/crossword/pack/:packId`
- `/learn/quizzes/crossword/daily`
- `/learn/quizzes/crossword/puzzle/:puzzleId`
- `/learn/quizzes/word-search`
- `/learn/quizzes/word-search/pack/:packId`
- `/learn/quizzes/word-search/daily`
- `/learn/quizzes/word-search/puzzle/:puzzleId`
- `/learn/quizzes/matching`
- `/learn/quizzes/matching/pack/:packId`
- `/learn/quizzes/matching/daily`
- `/learn/quizzes/matching/puzzle/:puzzleId`
- `/learn/quizzes/ayah-completion`
- `/learn/quizzes/ayah-completion/pack/:packId`
- `/learn/quizzes/ayah-completion/daily`
- `/learn/quizzes/ayah-completion/puzzle/:puzzleId`
- `/learn/quizzes/hadith-reflection`
- `/learn/quizzes/hadith-reflection/pack/:packId`
- `/learn/quizzes/hadith-reflection/daily`
- `/learn/quizzes/hadith-reflection/puzzle/:puzzleId`
- `/learn/hub/quizzes` -> alias
- `/learn/section/quizzes` -> alias
- `/learn/duas`
- `/learn/hub/duas` -> alias
- `/learn/section/duas` -> alias
- `/learn/hub/trivia` -> redirects to trivia home
- `/learn/hub/trivia/paths`
- `/learn/hub/trivia/paths/:pathId`
- `/learn/hub/trivia/paths/:pathId/stages/:stageId`
- `/learn/hub/trivia/session`
- `/learn/hub/trivia/results`
- `/learn/hub/trivia/review`
- `/learn/hub/trivia/stats`
- `/learn/hub/salah`
- `/learn/salah/prayer/:prayerId`
- `/learn/salah/guided/:prayerId`
- `/learn/salah/surah/:surahId`
- `/learn/salah/wudu`
- `/learn/salah/wudu/trainer`
- `/learn/salah/wudu/quiz`
- `/learn/faq`
- `/learn/section/faq` -> alias
- `/learn/faq/category/:categoryId`
- `/learn/faq/item/:faqId`
- `/learn/duas/:duaId`

### Dedicated content-domain routes

- `/learn/life`
- `/learn/life/theme/:themeId`
- `/learn/life/subcategory/:subcategoryId`
- `/learn/life/lesson/:lessonId`
- `/learn/life/reflection`
- `/learn/life/family/baby-names...`
- `/learn/world`
- `/learn/world/theme/:themeId`
- `/learn/world/subcategory/:subcategoryId`
- `/learn/world/lesson/:lessonId`
- `/learn/world/creation/category/:categoryName`
- `/learn/world/creation/lesson/:lessonId`
- `/learn/world/explore-creation`
- `/learn/world/signs-explorer`
- `/learn/world/cosmic-scale`
- `/learn/world/deep-ocean`
- `/learn/world/atmosphere-layers`
- `/learn/world/reflection-mode`
- `/learn/world/muslim-scientists`
- `/learn/hadith`
- `/learn/hadith/theme/:themeId`
- `/learn/hadith/subcategory/:subcategoryId`
- `/learn/hadith/lesson/:lessonId`
- `/learn/hadith/important`
- `/learn/hadith/path/:pathId`
- `/learn/hadith/path/:pathId/chapter/:chapterId/quiz`
- `/learn/hadith/review/quiz`
- `/learn/hadith/important/:number`
- `/learn/notes`
- `/learn/notes/browse`
- `/learn/content/:category/:topicId`
- `/learn/seerah`
- `/learn/character`
- `/learn/daily-wisdom`
- `/learn/quran/universe`
- `/learn/quran/constellation`

### Qur'an-owned learning routes still in Learn route files

- `/quran/learning`
- `/quran/insights`
- `/quran/knowledge-search`
- `/quran/insights/paths`
- `/quran/insights/paths/:pathId`
- `/quran/insights/:domainId`
- `/quran/daily`
- `/quran/summary`
- `/quran/summary/:surahNumber`
- `/quran/paths`
- `/quran/paths/:pathId`
- `/quran/paths/:pathId/stops/:stopId`
- `/quran/arabic`
- `/quran/arabic/module/:moduleId`
- `/quran/arabic/module/:moduleId/lesson/:lessonId`
- `/quran/arabic/words`
- `/quran/arabic/review`
- `/quran/arabic/readiness`
- `/quran/arabic/short-surahs`
- `/quran/arabic/guided-passages`
- `/quran/arabic/practice`

### Learn-to-Qur'an compatibility routes

- `/learn/hub/quran` -> `/quran`
- `/learn/hub/quran/learning` -> `/quran/learning`
- `/learn/hub/quranic-arabic` -> `/quran/arabic`

### Kids learning routes

Major kids hubs:

- `/learn/kids/games`
- `/learn/kids/fun-learning`
- `/learn/kids/quran`
- `/learn/kids/quran-insights`
- `/learn/kids/hadith`
- `/learn/kids/hadith-stories`
- `/learn/kids/prophet-stories`
- `/learn/kids/stories`
- `/learn/kids/seerah`
- `/learn/kids/dua`
- `/learn/kids/arabic`
- `/learn/kids/arabic-learning`

The kids route family is broad and valid, but it currently lives as both:

- a standalone route family
- a subcategory under the broader Learn taxonomy

## Hub Pages Vs Content Pages

### Hub pages

- `LearningSectionLandingPage` (`/learn`)
- `LearnPage` (`/learn/legacy`)
- `LearningJourneyHomePage`
- `LearningJourneyIslandHubPage`
- `LearnExploreAllKnowledgePage`
- `LearnCategoryPage`
- `GamesIslandPage`
- `LearnQuizzesHubPage`
- `LearnQuranHubPage`
- `LearnSalahHubPage`
- `DuaHubPage`
- `FaqLandingPage`
- `HadithLandingPage`
- `WorldLandingPage`
- `DivineLifeLessonsPage`
- `LearnNotesLandingPage`
- `KidsArabicHomePage`
- `KidsQuranPage`
- `KidsDuaLandingPage`
- `KidsStoryLibraryPage`
- `KidsSeerahJourneysPage`

### Content or detail pages

- journey detail/stage pages
- hadith lesson/theme/subcategory/path/detail pages
- life lesson/theme/subcategory/detail pages
- world lesson/theme/subcategory/detail pages
- trivia path/stage/session/results/review/stats
- crossword/word-search/matching/ayah-completion/hadith-reflection pack/puzzle pages
- dua detail pages
- FAQ category/detail pages
- notes browse/detail-related pages
- kids story detail/quiz/memory pages
- kids dua lesson/story/drawing/practice/rewards pages
- kids Arabic lesson/word/review/practice/progress/reward pages
- Qur'an summary/detail/topic/path/reflection/Arabic readiness pages

## Duplicate / Overlapping Entry Point Findings

### 1. Learn has three broad front doors

- `/learn`
- `/learn/legacy`
- `/learn/journey-home` and `/learn/learning-journey`

These are not just variants. They present different mental models:

- guided section landing
- legacy library/catalog
- dedicated journey-first system

### 2. Qur'an learning is exposed from multiple owners

- `/quran`
- `/quran/learning`
- `/learn/hub/quran`
- `/learn/hub/quran/learning`
- `/learn/quran/universe`
- `/learn/quran/constellation`
- `LearnCategoryCatalog` also still contains `Holy Quran`, `Qur'an Learning`, and `Learn Qur'anic Arabic`

This is the biggest cross-section overlap.

### 3. Quizzes, trivia, and games overlap

- `/learn/games`
- `/learn/quizzes`
- `/learn/quizzes/trivia`
- `/learn/hub/trivia`
- `/learn/quizzes/*` individual game hubs
- taxonomy category `Quizzes & Challenges`
- `/learn` top action `Games`

These are conceptually adjacent but currently split across separate discovery stacks.

### 4. Worship surfaces are split across several doors

- `/learn/hub/salah`
- `/learn/duas`
- taxonomy `Worship & Practice`
- journey island `Practice & Ibadah`
- hidden guidance items in legacy catalog

This content can be grouped cleanly later, but currently it competes across multiple owners.

### 5. Stories are split across prophets, seerah, discovery, and kids

- `/learn/prophets`
- `/learn/seerah`
- taxonomy `Prophets & Stories`
- journey island `Discovery`
- kids stories / prophet stories / bedtime stories / kids seerah

The story-based content exists, but its grouping is inconsistent between adult and kids surfaces.

### 6. Notes / journal / Qur'an reflections overlap as a single mental model

- `/learn/notes`
- `/learn/notes/browse`
- `/journal/*`
- `/quran/notes`
- `/quran/reflections`
- `/quran/bookmarks`

These should likely stay physically separate for now, but conceptually they already behave like a single "saved insights / notes / reflection" family.

### 7. Kids learning is both a bucket and a parallel product lane

- `Kids Learning` is a taxonomy category under `/learn`
- the route family under `/learn/kids/*` is much broader than a single category

This is not wrong, but it means the current IA is mixing "audience mode" and "content type" in the same top-level structure.

## Weakly Connected Or Orphan-Risk Surfaces

These are reachable but easy to miss in a future restructure if not explicitly preserved:

- `/learn/legacy`
- `/learn/guides`
- `/learn/guides/quran-lessons-mapping`
- `/learn/history`
- `/learn/world/*` extended creation subroutes
- `/learn/quran/universe`
- `/learn/quran/constellation`
- `/learn/daily-wisdom`
- `/learn/family`
- kids support dashboards:
  - kids Arabic parent
  - kids Arabic parent settings
  - kids Dua parent
  - kids bedtime parent/family/companion
  - kids progression
- internal or low-visibility game routes

## Current IA Pressure Points

### Equal-weight overload

Current `/learn` presents too many peer choices:

- journeys
- explore all
- games
- 11 taxonomy categories

This creates more scanning than the target calmer structure.

### Mixed grouping logic

Current categories mix:

- topic buckets: Foundations, Worship, Character
- content domains: Qur'an & Hadith, Prophets & Stories
- audience buckets: Kids Learning
- utility/reference buckets: Notes, FAQ, Tools & Explore
- skill/method buckets: Arabic Language, Quizzes & Challenges

### Naming inconsistency

Current naming examples:

- "Quran & Hadith" vs target separate Qur'an + possible Stories/Worship placement
- "Prophets & Stories" vs "Stories"
- "Worship & Practice" vs "Worship"
- "Quizzes & Challenges" vs target "Games"
- "Tools & Explore" vs target lower-priority "Explore All"

### Route hierarchy vs UI hierarchy mismatch

Examples:

- UI treats Qur'an as a category within Learn, but routing treats top-level `/quran` as primary
- UI has "Journey Islands" and "Explore All", while dedicated route families still behave as their own hubs
- category pages can deep-link into dedicated routes instead of actually grouping items inside the category page

## Mapping Current Structure To Proposed Target

| Current page/category | Proposed bucket | Why | Recommended level | Placement assessment |
|---|---|---|---|---|
| `/learn` guided landing | Learn shell | Should become the simplified top-level hub | Main hub | Already good base |
| Continue Learning | Continue Your Journey | Matches target exactly | Top-level module | Well placed |
| Daily learning surfaces on journey home and home cards | Daily Learning | Already conceptually present | Top-level module | Partially fragmented |
| `LearningJourneyRegistry` foundations/core journeys | Foundations | Beginner/core knowledge | Main island | Partially aligned |
| `LearnHubCategoryId.foundations` | Foundations | Clear direct match | Main island | Good |
| `/quran`, `/quran/learning`, `/quran/summary`, `/quran/paths`, `/quran/insights`, `/quran/arabic` | Qur'an | Strong dedicated Qur'an ownership | Main island | Well placed but duplicated via Learn |
| `Quran & Hadith` category | Split between Qur'an + Stories/Foundations | Combines too much | Should not stay a peer bucket unchanged | Misplaced as current mixed bucket |
| `/learn/hadith` | Foundations or Character or Explore All | Hadith is cross-cutting; best nested, not top peer island | Subpage/module | Acceptable as a domain route but not top-level island |
| `/learn/world` | Foundations or Explore All | Creation/signs content supports faith and reflection | Subpage/module | Currently overexposed as equal domain |
| `/learn/life` | Character | Guidance, growth, daily life | Subpage/module | Reasonable content, current placement too broad |
| `/learn/character` | Character | Direct match | Main island child | Well aligned |
| `/learn/seerah` | Stories | Narrative/history of the Prophet ﷺ | Subpage/module | Good content, better nested |
| `/learn/prophets` | Stories | Prophetic stories | Main island child | Well aligned |
| Kids prophet stories / bedtime stories / seerah stories | Stories | Narrative learning | Subpages under Stories or Kids mode | Split today |
| `/learn/hub/salah` + wudu routes | Worship | Direct match | Main island child | Well aligned |
| `/learn/duas` | Worship | Duas/adhkar/practice | Main island child | Well aligned |
| `99 Names of Allah` | Worship or Foundations | Reflection/dhikr-oriented | Subpage/module | Should not be top peer |
| `/learn/kids/arabic` and `/learn/kids/quran` | Foundations or Qur'an within Kids mode | Kids pedagogy, not a top adult hub | Kids-only nested lanes | Currently okay but mixed into main taxonomy |
| `/learn/quizzes`, `/learn/games`, puzzle routes | Games | Direct match | Main island | Strong candidate |
| `/learn/kids/games`, `/learn/kids/fun-learning` | Games | Kids game/activity cluster | Games child or Kids mode child | Reasonable |
| `/learn/explore`, `/learn/browse`, `/learn/category/*` | Explore All | Secondary browsing | Lower-priority browse surface | Good concept, too prominent today |
| `/learn/faq` | Explore All or Foundations | helpful reference, not core island | Secondary | Currently over-weighted |
| `/learn/notes`, `/journal`, `/quran/reflections` | Explore All with cross-links | saved/reference utility | Secondary tools family | Important but not core island |
| `Baby Names`, glossary, constellation, universe, guides, history | Explore All | valuable but secondary/discovery/reference | Secondary tools/discovery | Should remain accessible but deprioritized |
| `Arabic Language` category | Foundations or Qur'an | depends on audience/context | likely Foundations child and Qur'an child via cross-link | Too top-level today |
| `Kids Learning` category | Needs special audience treatment, not a normal peer content island | audience lane not content family | likely separate toggle/section, not equal peer island | Current top-level placement is awkward |

## Recommended Final Target Hierarchy

### Top level

1. Continue Your Journey
2. Daily Learning
3. Main Islands
   - Foundations
   - Qur'an
   - Worship
   - Character
   - Stories
   - Games
4. Explore All

### Suggested bucket content

#### Foundations

- What Is Islam?
- Who is Allah?
- Five pillars / core knowledge
- beginner hadith collections
- intro Arabic / reading basics
- glossary
- selected world/signs content
- guidance/new Muslim materials

#### Qur'an

- `/quran` home
- Qur'an learning
- summary
- topic/theme discovery
- pathways
- reflections
- reader-linked learning
- Qur'anic Arabic cross-links

#### Worship

- salah hub
- wudu guide/trainer/quiz
- duas
- adhkar-oriented support
- Names of Allah cross-link if retained here
- Ramadan / zakah / hajj / fiqh basics when surfaced

#### Character

- divine life lessons
- character companion
- daily wisdom
- emotional/spiritual growth themes

#### Stories

- prophets
- seerah
- kids stories
- kids prophet stories
- kids seerah
- history archive as secondary child

#### Games

- games island
- quizzes hub
- trivia
- daily challenge
- crossword
- word search
- matching
- ayah completion
- hadith reflection
- kids games / fun-learning cross-links

#### Explore All

- explore/browse/search
- notes
- journal-related entry points
- FAQ
- baby names
- constellation
- quran universe
- guides
- history
- family management
- parent dashboards
- lower-priority or experimental surfaces

## Biggest Collisions / Risks

### 1. Qur'an duplication risk

Future restructure must not accidentally create:

- a new Learn-owned Qur'an hub
- a second top-level Qur'an learning system
- broken compatibility for `/learn/hub/quran*`

### 2. Journey vs taxonomy conflict

If the future implementation promotes the six target islands, it must decide how journey islands and taxonomy categories relate. Right now both exist and partially overlap.

### 3. Kids IA risk

Kids is currently both:

- a major standalone route family
- a category within Learn

A restructure could accidentally bury kids routes or sever parent/dashboard flows if treated only as content instead of audience mode.

### 4. Utility/reference loss risk

Notes, glossary, baby names, guides, constellation, history, and family tools could disappear from the visible IA if "simplification" is implemented without an explicit Explore All/tools policy.

### 5. Route alias breakage risk

Routes that should remain as compatibility aliases even if UI changes:

- `/learn/legacy`
- `/learn/browse`
- `/learn/hub/quran`
- `/learn/hub/quran/learning`
- `/learn/hub/quranic-arabic`
- `/learn/hub/prophets`
- `/learn/section/prophets`
- `/learn/hub/quizzes`
- `/learn/section/quizzes`
- `/learn/hub/duas`
- `/learn/section/duas`
- `/learn/section/faq`
- `/learn/hub/trivia`

### 6. Search/indexing regression risk

The current learn knowledge index aggregates many knowledge items across subcategories. Any restructure must preserve or re-map:

- category IDs
- subcategory IDs
- search keywords
- route targets
- child-profile filtering behavior

## Safe Phased Restructure Plan

### Phase A: Inventory and route safety

- freeze canonical route inventory
- mark which routes are primary vs compatibility aliases
- mark which pages are hub pages vs content pages
- define which Learn routes are UI-visible vs compatibility-only
- document Qur'an-owned destinations explicitly so future Learn copy does not recreate duplicate ownership

### Phase B: Main island consolidation

- keep `/learn` as the only visible main Learn landing
- bring the six desired islands forward on `/learn`
- keep Continue Your Journey and Daily Learning above them
- demote FAQ, Notes, Tools, and category overload from equal-weight placement
- do not delete old routes yet

### Phase C: Subpage regrouping

- remap current taxonomy categories into:
  - Foundations
  - Qur'an
  - Worship
  - Character
  - Stories
  - Games
- move mixed buckets like `Quran & Hadith`, `Prophets & Stories`, `Worship & Practice`, `Quizzes & Challenges`, `Tools & Explore` into clearer ownership
- keep dedicated domain pages physically intact while re-homing their entry points

### Phase D: Explore / browse cleanup

- convert `/learn/explore` into the explicit secondary "Explore All" destination
- route lower-priority reference/tool pages from there
- keep compatibility access to `/learn/category/*` until category slugs are remapped or retired safely
- preserve learn-wide search and filtering index behavior

### Phase E: Copy and naming cleanup

- rename visible buckets to the final simplified labels
- remove mixed peer labels like `Quran & Hadith` and `Quizzes & Challenges`
- tighten CTA language so it reflects the new hierarchy
- audit home cards and shortcuts for duplicated or stale Learn/Qur'an wording

### Phase F: Optional guided path enhancements

- unify Continue Your Journey across `/learn`, journey pages, and selected cross-links
- add clearer "daily learning" aggregation
- improve recommendations from island to subpage destination
- optionally add audience-aware routing for kids mode without making Kids a conflicting main adult island

## Recommended Next Implementation Pass

Safest next pass:

1. keep all current routes/pages intact
2. simplify only the `/learn` landing choices
3. introduce the final six main visible islands there
4. move FAQ, Notes, Tools, and raw category overload behind Explore All
5. retain compatibility aliases and existing page owners

This would provide the biggest IA win with the lowest migration risk.

## Validation Notes

- all major Learn route families were scanned
- kids surfaces were included
- Qur'an-related learning surfaces were included, including top-level `/quran/*` overlap and Learn-side compatibility routes
- duplicate entry points were identified
- no destructive cleanup was performed
- this audit is detailed enough to support a future implementation pass without silently dropping built pages

