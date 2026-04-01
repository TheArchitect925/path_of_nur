# Curriculum Hardening Backlog

Date: 2026-03-31

## Phase A — relabel / resequence only

### A1. Tighten Foundations Path order
- Impact: high
- Risk: low
- Task: replace broad first-step framing with a clearer bounded beginner entry point if a safe existing route can anchor it
- Dependency: audit exact route candidate among existing foundations/faith journeys
- Do-not-break: preserve path id and compatibility unless a migration plan is explicit

### A2. Re-sequence Daily Dhikr Path
- Impact: high
- Risk: low
- Task: move explanation and journey-backed teaching earlier; demote utility-only surfaces later in the path
- Dependency: confirm strongest `daily-dhikr` lesson-backed route targets
- Canonical note: keep worship Dhikr page as utility owner, not curriculum owner

### A3. Clarify Character Path step roles
- Impact: medium
- Risk: low
- Task: refine subtitles/order so each step has a distinct pedagogical job
- Dependency: none beyond copy review
- Localization impact: yes, path copy keys likely affected

### A4. Improve Kids Starter completion guidance
- Impact: medium
- Risk: low
- Task: add stronger next-lane handoff after completion without changing kids canonical ownership
- Dependency: choose best next kids lane mapping

## Phase B — add bridge lessons / pages

### B1. Foundations bridge lesson
- Impact: very high
- Risk: medium
- Task: add a short “start here” foundations bridge before broader hubs
- Dependency: choose existing owner or lightweight new owner
- Canonical note: avoid duplicating aqeedah/journey content if existing journey stage can be reused

### B2. Qur'an confidence bridge
- Impact: high
- Risk: medium
- Task: add a beginner-safe “how to begin with the Qur'an calmly” bridge
- Dependency: identify safest canonical `/quran/*` owner for this bridge
- Canonical note: must live under Qur'an ownership or route there clearly

### B3. Dhikr meaning bridge
- Impact: high
- Risk: medium
- Task: add an intro lesson for dhikr before utility-first steps
- Dependency: decide whether to reuse journey content or add a small owned intro page

### B4. Character practice bridge
- Impact: medium
- Risk: low
- Task: add one bounded practice-oriented step or completion closure for character growth

### B5. Kids continuation bridge
- Impact: medium
- Risk: low
- Task: add a post-starter decision surface that points into Arabic, stories, Qur'an, or duas based on progress

## Phase C — improve beginner intros

### C1. Foundations intro polish
- Impact: high
- Risk: low
- Task: improve beginner-facing copy and expectation setting across foundations entry surfaces

### C2. Qur'an beginner reassurance copy
- Impact: medium
- Risk: low
- Task: make the beginner Qur'an experience less intimidating without changing canonical ownership

### C3. Dhikr intro tone polish
- Impact: medium
- Risk: low
- Task: explain purpose, repetition, and habit-building more gently

## Phase D — fill true domain gaps

### D1. Stories starter path
- Impact: high
- Risk: medium
- Task: create a real Stories starter path using prophets, Seerah, and history owners
- Dependency: map the best beginner-safe story owner sequence
- Canonical note: do not invent a duplicate story system

### D2. Games reinforcement path
- Impact: medium
- Risk: medium
- Task: define games as reinforcement after learning, not just browse
- Dependency: choose safest quiz/challenge route sequence

### D3. Adult story-led transition pages
- Impact: medium
- Risk: medium
- Task: add bridges from stories to reflection / character / history where current handoffs are weak

## Phase E — improve kids progression

### E1. Enrich Kids Starter Path
- Impact: high
- Risk: medium
- Task: evaluate replacing or supplementing Kids Games with kids dua or kids hadith in starter flow
- Dependency: confirm the most beginner-safe and age-appropriate order

### E2. Kids next-best-lane personalization
- Impact: medium
- Risk: medium
- Task: use existing personalization layer to suggest the next kids lane after starter completion

### E3. Kids path depth audit follow-through
- Impact: medium
- Risk: low
- Task: review whether kids path steps should point to narrower destinations within Kids Arabic / stories / Qur'an

## Phase F — enrich stories / character depth

### F1. Character closure and weekly practice
- Impact: medium
- Risk: low
- Task: add a clearer practice summary and weekly next action

### F2. Story-to-reflection handoffs
- Impact: medium
- Risk: medium
- Task: improve transitions from prophets/Seerah/history into reflection and character lessons

### F3. Seerah integration review
- Impact: medium
- Risk: low
- Task: verify whether existing Seerah companion and kids Seerah journey should become more visible in future story paths

## Phase G — optional advanced paths later

### G1. Advanced Qur'an growth paths
- Impact: medium
- Risk: medium
- Task: add deeper Qur'an study ladders only after beginner flow is hardened

### G2. Seasonal curriculum packs
- Impact: medium
- Risk: medium
- Task: Ramadan and other seasonal guided sequences

### G3. Level-aware sequencing
- Impact: lower short-term
- Risk: medium
- Task: personalize by beginner/intermediate confidence after stronger curriculum coverage exists

## Duplicate / overlap cleanup candidates for later

Keep for now, but watch:
- Learn Qur'an Beginner Path vs canonical Qur'an beginner pathways
- Foundations Path vs `islam-foundations` vs `foundations-of-faith`
- Character companion vs beautiful-character journey vs life lessons
- dua hub vs daily dhikr journey vs dhikr utility
- Games island vs quizzes/trivia reinforcement framing

## Recommended implementation order

1. Foundations resequencing
2. Daily Dhikr resequencing
3. Qur'an beginner bridge
4. Kids Starter hardening
5. Stories starter path
6. Character closure improvements
7. Games reinforcement path

## Route / canonical ownership notes

- `/learn` remains the front door
- `/quran/*` remains canonical for Qur'an
- kids route family remains canonical for kids
- guided paths remain orchestration only
- avoid moving content ownership just to improve path sequencing

## Localization impact notes

Expected future work:
- path subtitles/descriptions
- bridge-page titles/subtitles/body copy
- completion guidance copy
- kids next-step guidance

No localization changes were made in this audit pass.

## Do-not-break notes

- do not delete content during hardening
- do not rewrite Qur'an internals casually
- do not orphan kids content
- do not regress Learn search/indexing
- do not change stable guided path ids unless compatibility is planned
