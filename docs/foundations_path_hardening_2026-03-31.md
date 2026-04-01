# Foundations Path Hardening

Date: 2026-03-31

## Executive Summary

This pass hardened the existing `foundations-starter` guided path into a calmer, more beginner-safe entry lane without changing the path id, breaking stored progress, or changing route ownership.

The main improvement was removing the early hub-first behavior. Instead of dropping learners into broad Learn surfaces, the Foundations Path now starts with three focused beginner journey stages and ends with a clear guided handoff into the next appropriate path.

## Before

Previous Foundations Path sequence:

1. `foundations-overview` -> `learnHubCategory(foundations)`
2. `foundations-daily-duas` -> `learnDuaHub`
3. `foundations-salah-basics` -> `learnSalahHub`
4. `foundations-hadith-essentials` -> `learnHadithLanding`

Main issues:

- the first three steps routed into multi-purpose hubs
- the path assumed the learner could self-curate from broad surfaces
- the sequence mixed belief, daily duas, salah, and hadith too early
- the path had no calm “what next?” transition at the end
- the step labels described navigation more than learning

## After

New Foundations Path sequence:

1. `foundations-overview` -> `learnJourneyStage(islam-foundations / islam-what-is-islam)`
2. `foundations-daily-duas` -> `learnJourneyStage(islam-foundations / islam-who-is-allah)`
3. `foundations-salah-basics` -> `learnJourneyStage(islam-foundations / islam-five-pillars)`
4. `foundations-hadith-essentials` -> `learnFoundationsNextSteps`

Updated visible step framing:

1. What is Islam?
2. Who is Allah?
3. The five pillars
4. Choose your next step

## Reasoning By Step

### Step 1

- moved from a broad category hub to a focused first lesson
- gives a soft, text-first opening instead of a wall of choices

### Step 2

- changed from a dua/tool-first step into a belief-first bridge
- reduces beginner confusion by grounding practice in knowledge of Allah first

### Step 3

- changed from a full Salah hub to a compact lesson on the five pillars
- prepares the learner for prayer without sending them into a full practice system too early

### Step 4

- replaced a hadith landing handoff with a dedicated next-step chooser
- avoids ending the path in another broad owner surface
- gives a clear, calm transition into the next appropriate guided path

## New Handoff Surface

Added a new page at:

- `learnFoundationsNextSteps`
- route path: `/learn/paths/foundations/next`

Purpose:

- finish the Foundations Path without a dead end
- recommend one next guided path instead of a generic browse surface
- keep the handoff intentional and beginner-safe

Current recommended next paths:

- Salah Path
- Qur’an Beginner Path
- Daily Dhikr Path

## Progress Safety

Preserved:

- Foundations path id: `foundations-starter`
- all existing Foundations step ids

This keeps existing user progress stable even though the route targets and visible copy were improved.

## Canonical Ownership Notes

- no route paths were removed
- `/quran/*` remains canonical
- the Foundations Path still orchestrates into existing owners rather than duplicating content
- Learn remains the front door, not a duplicate content owner

## Risks

- users who previously completed a Foundations step may now have that completion attached to a better step destination than before, but the step ids remain stable by design
- Step 4 is now a guided handoff rather than a hadith step, so hadith is no longer part of the narrow beginner starter lane

## Follow-ups

- add one deeper “first steady steps” lesson after the five pillars if Foundations needs a slightly longer bridge later
- review whether Daily Dhikr should receive a similar non-tool-first hardening pass next
- later, consider adding a lightweight “Why we pray” bridge if product testing shows learners still need one extra step before Salah Path
