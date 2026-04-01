# Guided Learning Paths V1

Date: 2026-03-31

## Overview

Guided Learning Paths V1 adds a conservative orchestration layer on top of existing Learn content. It does not replace canonical owners, delete routes, or duplicate lesson systems. Instead, it gives `/learn` a calm "Start a Journey" entry point with resumable starter paths that route into existing surfaces.

## Domain model

Core models live under `lib/features/learn/guided_paths/domain/`:

- `GuidedLearningPath`
- `GuidedLearningPathStep`
- `GuidedLearningPathRouteTarget`
- `GuidedLearningPathProgress`
- `GuidedLearningPathsState`
- `GuidedLearningPathResumeSummary`

Important V1 properties:

- stable path ids
- stable step ids
- audience metadata
- bucket/category metadata
- route-backed step targets
- explicit completion mode
- lightweight reward metadata
- locally persisted progress state

## Starter paths

The V1 rollout includes six starter paths:

1. Foundations Path
2. Salah Path
3. Qur'an Beginner Path
4. Daily Dhikr Path
5. Character Path
6. Kids Starter Path

## Path-to-route mapping

### Foundations Path

- Foundations hub -> `learnHubCategory(categoryId: foundations)`
- Daily duas -> `learnDuaHub`
- Salah basics -> `learnSalahHub`
- Hadith essentials -> `learnHadithLanding`

### Salah Path

- Salah hub -> `learnSalahHub`
- Wudu guide -> `learnWuduGuide`
- Wudu trainer -> `learnWuduTrainer`
- Guided prayer -> `learnSalahGuidedPrayer(prayerId: fajr)`

### Qur'an Beginner Path

- Qur'an summary -> `quranSummaryPage`
- Daily Qur'an Companion -> `quranDailyCompanion`
- Qur'an reader/explorer -> `quranExplorer`
- Qur'an learning pathways -> `quranLearningPaths`

Note: `/quran/*` remains the canonical Qur'an owner. The Learn path only guides entry into those existing surfaces.

### Daily Dhikr Path

- Dua hub -> `learnDuaHub`
- Dhikr counter/page -> `worshipDhikrPage`
- After-Salah support -> `learnSalahHub`
- Daily dhikr journey detail -> `learnJourneyDetail(journeyId: daily-dhikr)`

### Character Path

- Character companion -> `learnCharacterCompanion`
- Life lessons -> `learnLifeLanding`
- Qur'an learning pathways -> `quranLearningPaths`
- Character journey detail -> `learnJourneyDetail(journeyId: beautiful-character)`

### Kids Starter Path

- Kids Qur'an -> `learnKidsQuran`
- Kids Arabic -> `learnKidsArabicLearning`
- Kids stories -> `kidsStoryLibrary`
- Kids games -> `learnKidsGames`

## Progress model

Progress is stored locally under:

- `learn.guided_paths.state.v1`

Per-path tracking includes:

- started state
- completed state
- completed step ids
- last active step id
- last updated timestamp
- completed timestamp

Derived progress includes:

- percentage complete
- next incomplete step
- active path resume summary

## Resume behavior

Guided paths integrate with the `/learn` continue section without rewriting the shared Learn engine.

Priority on `/learn`:

1. active guided path resume
2. existing unified Learn continue item
3. existing browse-guided-journeys fallback

This keeps risk low while still making guided paths feel first-class when a learner has started one.

## Completion behavior

V1 uses pragmatic explicit completion:

- opening a step marks the path started and sets the active step
- `Mark step complete` advances the stored progress
- a path completes when all seeded required steps are marked complete

No fragile LMS-style automatic completion was introduced in this pass.

## Reward integration

Reward integration stays modest and uses existing systems only:

- step completion can award Learn XP through the existing Journey XP controller
- step completion can award an Ocean Drop using the existing Ocean Drops service
- full path completion awards one completion drop and a small XP bonus

Safeguards:

- awards use stable source refs
- step completion is idempotent per step
- path completion is idempotent per path

## Learn landing integration

`/learn` now includes a "Start a Journey" section near the top of the landing page.

Behavior:

- shows six starter path cards in standard mode
- shows only the kids-safe starter path in child mode
- shows a continue card for the active guided path when one exists

## Localization impact

Guided path titles, descriptions, step titles, step subtitles, progress labels, and action labels were added through the generated localization system. No path copy is hardcoded in the UI.

## Search and indexing impact

No new search/indexing system was introduced.

- existing Learn search/index metadata remains unchanged
- guided paths are currently a guided dashboard layer, not a new searchable corpus
- the path data model is structured so indexing can be added later without rewriting the path system

## Risks and follow-ups

- step completion is manual where automatic detection is not safely available
- some route targets are broad owner surfaces rather than deep content nodes
- richer adaptive ordering and automatic progress inference should remain future work

## Future extension recommendations

- add richer automatic completion where the destination surface already exposes trustworthy completion events
- add seasonal paths such as Ramadan or Hajj prep
- add analytics around path starts, drop-off, and completion
- expose guided paths inside more domain owners where it improves continuity without creating duplicate ownership
