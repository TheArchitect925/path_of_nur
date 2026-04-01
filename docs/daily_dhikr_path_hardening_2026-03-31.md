# Daily Dhikr Path Hardening

Date: 2026-03-31

## Executive Summary

This pass hardened the existing `daily-dhikr-starter` guided path into a meaning-first, habit-building lane without changing the path id, touching the core dhikr counter logic, or changing route ownership.

The main fix was removing the early tool-first behavior. The path now teaches what dhikr is, starts very small, builds a sustainable rhythm, and only then introduces the dhikr tool through a dedicated handoff surface.

## Before

Previous Daily Dhikr Path sequence:

1. `dhikr-intro-dua-hub` -> `learnDuaHub`
2. `dhikr-counter` -> `worshipDhikrPage`
3. `dhikr-after-salah` -> `learnSalahHub`
4. `dhikr-routine` -> `learnJourneyDetail(daily-dhikr)`

Main issues:

- the path opened a broad dua hub immediately
- the dhikr tool appeared too early
- the first steps felt like utilities instead of learning
- the path lacked clear “start small” habit framing
- the final step still pointed to a broader journey owner rather than a clear next action

## After

New Daily Dhikr Path sequence:

1. `dhikr-intro-dua-hub` -> `learnJourneyStage(daily-dhikr / dhikr-what-is)`
2. `dhikr-counter` -> `learnJourneyStage(daily-dhikr / dhikr-morning-adhkar)`
3. `dhikr-after-salah` -> `learnJourneyStage(daily-dhikr / dhikr-simple-routine)`
4. `dhikr-routine` -> `learnDailyDhikrNextSteps`

Updated visible step framing:

1. What is dhikr?
2. Start with one simple remembrance
3. Build a simple daily rhythm
4. Use the dhikr tool and continue

## Reasoning By Step

### Step 1

- moved from a broad hub into the existing lesson-backed `dhikr-what-is` stage
- gives emotional and spiritual framing before any utility exposure

### Step 2

- changed from direct counter access to the existing `dhikr-morning-adhkar` stage
- keeps the barrier low by starting with one simple remembrance instead of a full tool

### Step 3

- changed from the Salah hub to the `dhikr-simple-routine` stage
- keeps the focus on consistency, not volume
- builds habit before asking the learner to navigate other systems

### Step 4

- replaced a broad journey-detail handoff with a dedicated next-step surface
- introduces the dhikr tool intentionally
- gives clear next-path options instead of leaving the learner at a generic journey page

## Tool-First Fix

The hardening strategy was:

- keep the dhikr counter intact
- stop using it as the first meaningful step
- introduce it only after the learner understands:
  - what dhikr is
  - why it matters
  - how to begin with a small sustainable rhythm

The tool is now introduced on a dedicated page rather than as an abrupt early jump.

## New Handoff Surface

Added a new page at:

- `learnDailyDhikrNextSteps`
- route path: `/learn/paths/daily-dhikr/next`

Purpose:

- introduce the dhikr tool calmly
- explain that the tool supports the habit rather than replacing its meaning
- guide the learner into one nearby next lane

Current next actions:

- open the dhikr tool
- continue with Character Path
- continue with Salah Path

## Reward / Route / Progress Safety

Preserved:

- Daily Dhikr path id: `daily-dhikr-starter`
- all existing Daily Dhikr step ids
- core dhikr tool route ownership
- guided-path completion model

The dhikr tool itself still owns its real usage and reward behavior. This pass changed when the user reaches the tool, not how the tool works.

## Risks

- step ids were preserved but the meaning of those steps is now stronger than before, so historic completions may correspond to improved destinations rather than the original weaker routing
- the path currently uses only four steps, so some richer `daily-dhikr` journey stages remain outside this starter lane on purpose

## Follow-ups

- consider a later second-stage Dhikr path that brings in `dhikr-after-salah`, `dhikr-istighfar`, and `dhikr-salawat`
- decide whether the personalized Learn layer should elevate “Open dhikr tool” more strongly after this path is completed
- if needed, add one very small “keep it small” micro-lesson later, but only if product QA still shows overwhelm after this pass
