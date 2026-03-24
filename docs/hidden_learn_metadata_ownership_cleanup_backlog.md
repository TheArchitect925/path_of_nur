# Hidden Learn Metadata Ownership Cleanup Backlog

Date: 2026-03-23

## Normalized in V6

- Hidden Learn catalog items with clear route-backed owners were moved off `learnLegacy`:
  - `becoming-muslim` -> `learnContentDetail(new-muslim-path)`
  - `guidance-new-muslims` -> `learnContentDetail(revert-support-growth)`
  - `aqeedah-essentials` -> `learnJourneyDetail(foundations-of-faith)`
  - `five-pillars` -> `learnJourneyStage(islam-five-pillars)`
  - `ramadhan-fasting` -> `learnJourneyDetail(ramadan-foundations)`
  - `zakah-sadaqah` -> `learnJourneyStage(fiqh-zakat-basics)`
  - `hajj` -> `learnContentDetail(hajj-full-journey)`
  - `umrah` -> `learnContentDetail(umrah-full-journey)`
  - `fiqh-basic` -> `learnJourneyDetail(fiqh-basics)`

## Intentionally retained

- Hidden catalog items still on `learnLegacy`:
  - `jummah`
  - `eid`
  - `funeral`
- Learning Journey metadata fallback tools:
  - `_legacyLearnTool`
  - `_legacyLearningIslandTool`
  - `_lessonLegacyLearnTool`

These were retained because they still act as broad library fallbacks and do not yet have one-to-one canonical replacements.

## Deferred follow-up

- Audit whether `jummah`, `eid`, and `funeral` now have specific route-backed owners or should remain broad library fallback entries.
- Audit visible Learning Journey lesson/detail pages that still surface `Legacy Learning Material` and replace only the clearly route-specific cases.
- Decide whether the hidden `legacy-learning` island should continue to exist as a documented migration bucket or be archived once its remaining tool links are re-owned.
