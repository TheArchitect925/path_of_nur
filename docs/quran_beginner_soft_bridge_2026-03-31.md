# Qur’an Beginner Soft Bridge

Date: 2026-03-31

## Executive Summary

This pass added a soft, welcoming first step to the existing `quran-beginner-starter` guided path without changing the path id, modifying the core Qur’an systems, or weakening canonical `/quran/*` ownership.

The main improvement was reducing abruptness. Instead of dropping the learner straight into a Qur’an surface, the path now begins with one calm bridge page that gives permission to start small and then guides into a deliberate canonical Qur’an entry point.

## Before

Previous Qur’an Beginner Path sequence:

1. `quran-beginner-summary` -> `quranSummaryPage`
2. `quran-beginner-daily` -> `quranDailyCompanion`
3. `quran-beginner-reader` -> `quranExplorer`
4. `quran-beginner-pathways` -> `quranLearningPaths`

Main issues:

- the first step opened a real Qur’an surface immediately
- the path assumed the learner was already ready to enter the Qur’an space
- there was no emotional softening or reassurance before the first handoff
- the first interaction could still feel serious or complex for hesitant beginners

## After

New Qur’an Beginner Path sequence:

1. `quran-beginner-summary` -> `learnQuranBeginnerSoftBridge`
2. `quran-beginner-daily` -> `quranSummaryPage`
3. `quran-beginner-reader` -> `quranExplorer`
4. `quran-beginner-pathways` -> `quranLearningPaths`

The soft bridge page then opens:

- `quranDailyCompanion`

## Bridge Reasoning

The bridge was designed to do only one job:

- reduce hesitation
- give permission to begin with a very small step
- remind the learner that understanding grows gradually
- guide into one calm canonical Qur’an surface

It intentionally does **not** recreate:

- the reader
- tafsir
- playback controls
- search
- a parallel Qur’an hub

## Chosen First Entry Point

The bridge sends the learner into:

- `quranDailyCompanion`

Reason:

- it is calmer than a broad explorer or full summary list
- it gives one ayah, one meaning cue, and one small next step
- it feels intentional rather than random
- it stays fully inside the canonical `/quran/*` ownership layer

## Canonical Ownership

Preserved:

- `/quran/*` remains canonical
- Learn still acts only as the orchestration layer
- the bridge exists under the guided-path Learn layer, but its actual Qur’an handoff is canonical

Not changed:

- reader ownership
- playback controller behavior
- audio stack
- mini player
- follow-ayah or resume logic

## Progress Safety

Preserved:

- Qur’an Beginner path id: `quran-beginner-starter`
- all existing step ids

This keeps existing guided-path progress compatible while improving the first step.

## Risks

- step 1 now represents emotional onboarding rather than direct Qur’an content, which is intentional but changes the meaning of that completion state
- the bridge page currently favors emotional safety over richer orientation; if future testing shows learners still hesitate, one tiny follow-up hint could be added later without changing ownership

## Follow-ups

- consider a later dedicated “how to begin with the Qur’an” micro-lesson only if product QA shows the bridge still feels too light
- decide whether the second path step should later point to a different canonical Qur’an surface if early user testing shows Summary is still broader than needed
- consider teaching personalization to prioritize this bridge more strongly for users with no prior Qur’an activity
