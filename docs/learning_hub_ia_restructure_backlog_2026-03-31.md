# Learning Hub IA Restructure Backlog

Date: 2026-03-31
Scope: follow-up implementation backlog for the Learning Hub IA audit

## Phase A — Inventory And Route Safety

### Task A1

- Task: mark every Learn route as `primary`, `secondary`, or `compatibility alias` in one internal mapping source
- Risk: Low
- Dependencies: audit complete
- Do not break: existing deep links, named routes, redirect aliases
- Route compatibility notes: keep `/learn/legacy`, `/learn/browse`, `/learn/hub/*`, `/learn/section/*`
- Localization impact: none expected unless surfaced in UI

### Task A2

- Task: create a canonical ownership note for Qur'an-related learning destinations
- Risk: Low
- Dependencies: audit complete
- Do not break: `/quran/*` ownership, reader entry points, Qur'an tab routing
- Route compatibility notes: Learn-side Qur'an aliases remain
- Localization impact: none expected

### Task A3

- Task: annotate hub pages vs content pages in internal docs or comments where useful
- Risk: Low
- Dependencies: A1
- Do not break: current page behavior
- Route compatibility notes: none
- Localization impact: none

## Phase B — Main Island Consolidation

### Task B1

- Task: redesign `/learn` landing so the visible top-level structure becomes:
  - Continue Your Journey
  - Daily Learning
  - Foundations
  - Qur'an
  - Worship
  - Character
  - Stories
  - Games
  - Explore All
- Risk: Medium
- Dependencies: A1-A2
- Do not break: continue learning card, current search, current route targets
- Route compatibility notes: old pages remain reachable
- Localization impact: new section titles/subtitles and helper copy likely required

### Task B2

- Task: remove FAQ, Notes, Tools & Explore, Arabic Language, and Kids Learning from equal-weight top-level placement on `/learn`
- Risk: Medium
- Dependencies: B1
- Do not break: discoverability of notes, FAQ, kids, and Arabic
- Route compatibility notes: keep direct routes alive
- Localization impact: update any visible category copy

### Task B3

- Task: decide whether kids should appear as:
  - an audience-aware section inside `/learn`
  - or a reduced secondary module under Explore All / Stories / Games
- Risk: High
- Dependencies: B1-B2
- Do not break: child profile behavior, kids parent dashboards, kids progression
- Route compatibility notes: all `/learn/kids/*` routes remain canonical
- Localization impact: possible new section labels

## Phase C — Subpage Regrouping

### Task C1

- Task: map current category pages and subcategories into the final target buckets without deleting physical pages
- Risk: Medium
- Dependencies: B1
- Do not break: `LearnHubKnowledgeIndexProvider`, subcategory search, route targets
- Route compatibility notes: `learnHubCategory` route can remain while visible grouping changes
- Localization impact: category copy updates

### Task C2

- Task: split current `Quran & Hadith` visible bucket into:
  - Qur'an as a main island
  - Hadith nested under Foundations, Character, or Stories depending on final decision
- Risk: High
- Dependencies: A2, B1
- Do not break: `learnHadithLanding`, `quranLearningHub`, `/quran/*`
- Route compatibility notes: keep current named routes
- Localization impact: strong visible copy updates

### Task C3

- Task: regroup `Prophets & Stories`, `Seerah`, kids stories, and history archive into a consistent Stories hierarchy
- Risk: Medium
- Dependencies: B1
- Do not break: prophet detail pages, kids stories, seerah journeys
- Route compatibility notes: keep all story routes stable
- Localization impact: section subtitles and cross-link copy

### Task C4

- Task: regroup worship surfaces under one Worship island
- Risk: Medium
- Dependencies: B1
- Do not break: salah trainer, wudu trainer, dua hub, quiz links
- Route compatibility notes: keep `learnSalahHub`, `learnDuaHub`, wudu routes
- Localization impact: likely moderate

### Task C5

- Task: decide where Arabic belongs in the final IA
- Risk: Medium
- Dependencies: A2, B1
- Do not break: `/quran/arabic/*`, kids Arabic routes
- Route compatibility notes: no route removals
- Localization impact: visible bucket labels may change

## Phase D — Explore / Browse Cleanup

### Task D1

- Task: make `/learn/explore` the clear secondary "Explore All" owner
- Risk: Medium
- Dependencies: B1
- Do not break: search/filter behavior, category filters, content type filters
- Route compatibility notes: keep `/learn/browse`
- Localization impact: likely title/subtitle updates only

### Task D2

- Task: move lower-priority utilities into Explore All entry clusters
- Candidates:
  - FAQ
  - Notes
  - Baby Names
  - Knowledge Constellation
  - Qur'an Universe
  - Islamic Guides
  - History
  - Family management
- Risk: Medium
- Dependencies: D1
- Do not break: direct access and shortcuts
- Route compatibility notes: no route removals
- Localization impact: helper labels and grouping text

### Task D3

- Task: decide whether category pages should remain visible or become mostly compatibility/search destinations
- Risk: Medium
- Dependencies: C1, D1
- Do not break: `learnHubCategory` route
- Route compatibility notes: keep slug compatibility until migration stabilizes
- Localization impact: maybe none if hidden from primary nav

## Phase E — Copy And Naming Cleanup

### Task E1

- Task: normalize main visible labels to final simplified language
- Replace:
  - `Quran & Hadith`
  - `Prophets & Stories`
  - `Worship & Practice`
  - `Quizzes & Challenges`
  - `Tools & Explore`
- Risk: Low
- Dependencies: B1-C1
- Do not break: semantic meaning and localization structure
- Route compatibility notes: labels can change without changing routes
- Localization impact: yes, new strings likely required

### Task E2

- Task: audit home cards, shortcuts, and Learn cross-links for stale hierarchy wording
- Risk: Low
- Dependencies: E1
- Do not break: cross-feature navigation
- Route compatibility notes: preserve existing named routes
- Localization impact: yes, likely targeted string updates

### Task E3

- Task: audit kids vs adult naming consistency
- Risk: Low
- Dependencies: B3
- Do not break: child profile messaging
- Route compatibility notes: none
- Localization impact: likely moderate

## Phase F — Optional Guided Path Enhancements

### Task F1

- Task: unify continue/resume behavior across `/learn`, journey home, and key domain surfaces
- Risk: Medium
- Dependencies: B1
- Do not break: current progress providers and analytics/progress hooks
- Route compatibility notes: none
- Localization impact: maybe minor helper copy

### Task F2

- Task: create a stronger "Daily Learning" aggregator across:
  - journeys
  - Qur'an daily companion
  - prophet daily learning
  - daily challenge
  - daily wisdom where appropriate
- Risk: Medium
- Dependencies: B1, A2
- Do not break: existing daily modules
- Route compatibility notes: daily routes stay canonical
- Localization impact: likely yes

### Task F3

- Task: add guided handoffs between Foundations -> Worship -> Qur'an -> Character -> Stories -> Games
- Risk: Medium
- Dependencies: C1-C4
- Do not break: page autonomy
- Route compatibility notes: additive only
- Localization impact: yes

## Recommended Order

1. Phase A route safety and ownership
2. Phase B `/learn` landing simplification
3. Phase D Explore All clarification
4. Phase C regrouping of subpages and visible buckets
5. Phase E copy/naming cleanup
6. Phase F guided enhancements

## Do-Not-Break Notes

- do not remove `/learn/legacy` until all hidden/legacy references are migrated
- do not create a second visible Qur'an owner inside Learn
- do not hide kids-only routes behind adult assumptions
- do not break `learnHubKnowledgeIndexProvider` searchability
- do not remove `/learn/hub/*` and `/learn/section/*` aliases without replacement
- do not drop notes/journal/reflection surfaces during simplification
- do not flatten story surfaces so much that prophets, seerah, and kids stories become indistinguishable

## Localization Impact Notes

Expected future localization work areas:

- main island titles/subtitles on `/learn`
- Explore All helper copy
- revised category labels
- revised section helper text
- possible kids/adult wording normalization

This audit pass itself added no localization keys.

## Enhancement Options

### Option 1

- Add a small "Why this is here" IA note to internal docs for every major Learn bucket after restructuring
- Benefit: prevents future duplicate front doors

### Option 2

- Add an internal route ownership test or lint-like snapshot for major Learn routes
- Benefit: protects compatibility aliases during future cleanup

### Option 3

- Add a dedicated "Kids Learning" toggle/rail on `/learn` instead of keeping Kids as a peer adult content island
- Benefit: cleaner adult IA without losing kids visibility

