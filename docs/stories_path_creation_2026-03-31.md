# Stories Path Creation

## Executive Summary

This pass adds a dedicated `stories-starter` guided path on top of existing story owners instead of creating a new story system.

The path is designed as a beginner-friendly narrative lane:

1. brief intro
2. prophets entry
3. prophetic story arc
4. Seerah introduction
5. one key Seerah moment
6. story-to-character reflection
7. next-step handoff

## Audit Findings

The strongest existing story content already lived in three places:

- the Prophets journey/stories system
- the Seerah journey and companion surface
- the History archive

The best beginner-safe route targets were the lesson-backed Learning Journey stages, not the broad browse pages. The History archive is valuable, but it reads better as a supporting next step than as an early beginner step in the core path.

## Path Structure

- `stories-intro` -> `learnStoriesPathBridge`
- `stories-prophets-entry` -> `learnJourneyStage(prophets-journey / prophets-overview)`
- `stories-prophets-journey` -> `learnJourneyStage(prophets-journey / prophets-journey-map)`
- `stories-seerah-intro` -> `learnJourneyStage(seerah-journey / seerah-early-life)`
- `stories-seerah-key-moment` -> `learnJourneyStage(seerah-journey / seerah-hijrah)`
- `stories-reflection` -> `learnJourneyStage(seerah-journey / seerah-leadership-character)`
- `stories-next-steps` -> `learnStoriesPathNextSteps`

## Narrative Logic

- The intro explains why sacred stories matter before asking the learner to navigate them.
- The Prophets steps establish a broad story lane first.
- The Seerah steps then bring the learner closer to the life of the Prophet Muhammad ﷺ.
- The reflection step connects story to character so the journey ends in meaning rather than information only.

## Reflection Design

The reflection element is the `seerah-leadership-character` step. It was chosen because it turns story into lived qualities such as mercy, patience, courage, and truthfulness, which makes the overall lane feel spiritually useful rather than historical only.

## Completion / Handoff

The completion page gives three safe directions:

- Character Path
- Qur’an Beginner Path
- Islamic history archive

This avoids a dead end and keeps story learning connected to the wider Learn system.

## Route / Ownership Notes

- No route owners were replaced.
- No Prophets, Seerah, or History content was duplicated.
- `/learn` remains the front door.
- existing story owners remain canonical within their domains.

## Risks

- the path currently depends on the lesson-backed quality of the existing prophets and Seerah stages
- Islamic history is present as a next-step lane rather than a core mid-path lesson, which is a deliberate simplicity tradeoff for V1

## Follow-up Ideas

- add a deeper Stories continuation path later if the story lane grows beyond this starter journey
- add a stronger history-specific continuation after the main Stories Path if users want more chronological study
- add one dedicated stories-to-Qur’an reflection bridge later if the strongest narrative/story themes need explicit ayah handoff
