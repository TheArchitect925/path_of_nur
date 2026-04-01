# Foundations Path Hardening Backlog

Date: 2026-03-31

## Enhancement Options

### High Impact / Low Risk

1. Add a compact “First steady steps” bridge lesson after the five pillars if beginner testing still shows abruptness before the next-path handoff.
2. Add a calm completion card inside the Foundations path detail page when the final step is completed, so the user sees the next recommended path without needing to reopen the handoff page.
3. Add richer progress hints on the new next-step chooser, such as “already started” emphasis for paths the learner has begun.

### Medium Impact / Low Risk

1. Add a short “Why we pray” bridge lesson that sits between the five pillars and Salah Path if learners need a softer emotional handoff.
2. Add a simple completion reflection prompt for Foundations so the path ends with a clearer sense of closure.
3. Teach the personalization layer to elevate the Foundations completion handoff more strongly when the learner pauses after finishing the path.

### Medium Impact / Medium Risk

1. Re-sequence Daily Dhikr so the next-path recommendations from Foundations feel equally gentle across all three choices.
2. Add a more explicit beginner explanation of key Islamic terms inside the first three Foundations stages if content feedback shows terminology friction.

## Do Not Break

- keep `foundations-starter` path id stable
- keep existing Foundations step ids stable unless a real migration plan is added
- preserve `/quran/*` as canonical
- keep guided paths as orchestration rather than duplicating core domain owners
- do not reintroduce broad hub-first steps at the start of Foundations

## Recommended Next Pass

If continuing curriculum hardening in order, the safest next pass is:

1. Daily Dhikr Path hardening
2. Qur’an Beginner bridge hardening
3. Kids Starter Path progression hardening
