# Codex Prompt Archive

Date: 2026-03-21
Source: current working thread
Scope: consolidated archive of the feature/build/audit prompts used so far in this thread

## Notes

- This file groups prompts by feature area so they remain reviewable.
- The wording below preserves the intent and core instruction structure from the prompts used in this thread.
- This archive is a working reference, not a substitute for backlog or product docs.

---

## Qur'an

### Qur'an “Learn More” Toggle in Surah Settings

Primary objective:
- Allow the user to enable or disable the “Learn More” feature in the Qur’an section.

Requirements included:
- enabled by default
- add it to the Qur’an settings area in the Surah section at the top
- reuse the existing settings/state/storage/UI infrastructure
- preserve localization and existing reader behavior
- persist the setting and wire it to actual feature visibility

### Quran Top Words Page Redesign

Primary objective:
- Redesign the Quran Top Words page so each word presents:
  1. Arabic text
  2. transliteration
  3. translation

Requirements included:
- audit first
- reuse trusted Qur’anic source/data path
- remove the checkbox-heavy UX
- keep supporting metadata where useful
- preserve localization and layout readability

### Quran Top Words Example Ayah and Ayah Usage List

Primary objective:
- Expand Quran Top Words so each word also shows:
  1. Arabic word
  2. transliteration
  3. translation
  4. example ayah using the word
  5. a way to view the list of ayahs where the word appears

Requirements included:
- use real ayah data only
- reuse shared Qur’an rendering/navigation systems
- keep the main page readable
- support a clean “see all ayahs” interaction

### Quran Top Words V2 (Word Study System)

Primary objective:
- Evolve Quran Top Words from a simple list into a structured word study system.

V2 requirements included:
- dedicated word detail page
- example ayah enhancement
- full ayah usage list
- learned/saved state
- basic filtering
- future-ready structure for quizzes/audio/root expansion/progress

### Qur’an Reader Playback Recovery (Disable Auto-Bismillah for Now)

Primary objective:
- Restore stable Qur’an reader playback by temporarily disabling the forced auto-Bismillah behavior.

Requirements included:
- audit current playback flow
- do not redesign the whole Bismillah system
- restore stable first-play, resume, selected-ayah playback, and surah switching
- leave a concise follow-up note for future Bismillah work

---

## Prayer / Worship / Notifications

### Jumu‘ah Time, Tracking, and Dhuhr Suppression Logic

Primary objective:
- Improve Friday behavior so the app handles Jumu‘ah separately from normal Dhuhr behavior.

Required behavior:
- on Friday, show Jumu‘ah time as 1:30 PM
- hide the Dhuhr checkbox and show a Jumu‘ah checkbox
- if Jumu‘ah is marked offered, suppress the Dhuhr notification for that Friday

### Moonrise and Moonset Notifications (Shared Celestial Source)

Primary objective:
- Add moonrise and moonset notifications.

Requirements included:
- enabled by default
- controls in Settings → Notifications
- must reuse the existing celestial calculation system and shared location source
- no new celestial calculations or duplicate logic

### Daily Reflection Notification Actions and Deep Link

Primary objective:
- Improve the daily reflection notification so tapping it deep-links to the reflection page and the notification includes useful actions.

Recommended actions:
- Write Reflection
- Remind me in 10 min
- Dismiss

Requirements included:
- reuse existing notification architecture and prayer-action patterns where practical
- avoid duplicate reminder spam
- preserve localization and routing

---

## Home / Celestial UI

### Sunrise and Sunset Card Color Enhancement

Primary objective:
- Visually distinguish the Sunrise and Sunset cards on the homepage using subtle tinted glass while preserving the shared glass system.

### Sunrise and Sunset Dynamic Gradient Cards

Primary objective:
- Make the Sunrise and Sunset homepage cards dynamically tint based on current time relative to sunrise and sunset.

Requirements included:
- reuse existing sunrise/sunset data already shown on the homepage
- preserve blur/translucency/borders/shared glass shell
- keep the gradients subtle and readable

### Homepage Moon Phase Image Placement

Primary objective:
- Add the moon phase image currently used in the Salah Times tab to the homepage under the Moon Phase / next-event section.

Requirements included:
- reuse the same component/data source as Salah Times
- do not create a second moon-phase rendering system
- preserve layout balance and consistency

---

## Learn / Navigation / Information Architecture

### Stories of the Prophets Route to Prophets Overview Fix

Primary objective:
- Make “Stories of the Prophets” open the existing Prophets overview page with images.

### Duas Route to Existing Dua Page Fix

Primary objective:
- Make “Duas” open the existing main Dua page instead of the wrong surface.

### Islamic Trivia Move to Quizzes Section

Primary objective:
- Move Islamic Trivia into the Quizzes section so quiz-based experiences are grouped together.

### Character & Adab Direct Page Routing Fix

Primary objective:
- Make “Character & Adab” go directly to its actual content page instead of first going to an intermediate subcategory page.

### Kids Learning Redundant Island Cleanup

Primary objective:
- Remove the redundant “Kids Learning” island that appears inside the Kids Learning section/page.

### Kids Profile Learning Scope Isolation

Primary objective:
- When the active profile is a kids profile, show only Kids Learning content in the Learning area.

Requirements included:
- hide adult learning paths/categories/journeys/discovery surfaces
- gate at the source of truth where possible
- keep valid kids destinations working

### Islamic FAQ Direct Routing + Browse All Option

Primary objective:
- Make “Islamic FAQ” open the main FAQ page directly and add a separate “Browse All” option for broader browsing.

### Explore All Knowledge Move to Main Learning Page

Primary objective:
- Remove “Explore All Knowledge” from Tools and make it a main Learning page island using the existing destination.

### Baby Names Discoverability Fix

Primary objective:
- Make Baby Names discoverable from:
  - Tools
  - Explore / Explore All Knowledge

Requirements included:
- reuse the existing Baby Names destination
- no duplicate routes/pages

---

## Appearance / Settings

### Colored Glass Toggle in Appearance Settings

Primary objective:
- Let users disable colored/tinted glass globally while keeping glass itself enabled.

Requirements included:
- add a persisted setting near the existing glass settings
- route behavior through the shared surface/theme layer
- do not patch pages one by one if central handling is possible

---

## History / On This Day / Linking / Journeys

### Build a new "On This Day" historical calendar system

Primary objective:
- Build a new “On This Day” historical calendar system with:
  1. a lightweight card/surface for today’s date
  2. a reusable backend-driven historical calendar/archive

Requirements included:
- historical event model
- seeded local dataset
- Gregorian and Hijri matching
- event detail page
- today matches page
- archive page
- future-safe architecture

### Historical Dataset Expansion

Primary objective:
- Expand and structure the historical dataset system for the On This Day feature.

Requirements included:
- 40 to 100 curated events
- primarily Islamic history
- category coverage
- date coverage
- data integrity validation
- no UI refactor unless required for data support

### Contextual Linking Engine

Primary objective:
- Build a reusable linking system that connects:
  - historical events
  - learning hub content
  - Qur’an / Hadith
  - future growth systems

Phase 1 scope:
- historical events → related content
- learning content → related content where structured
- simple deterministic linking based on tags, categories, entities, and manual overrides

### Guided Journey System (V1)

Primary objective:
- Create a Guided Journey system allowing users to:
  - follow structured learning paths
  - progress step-by-step
  - track completion
  - resume where they left off
  - earn XP and drops from learning

Requirements included:
- journey model
- lesson model
- journey progress tracking
- unlock logic
- journey UI
- XP + drops integration
- seeded journey dataset

### Targeted implementation audit and build-on-top pass

Primary objective:
- Audit what already exists for:
  1. On This Day / Historical Calendar
  2. Historical Dataset Expansion
  3. Contextual Linking Engine
  4. Guided Journey System

Requirements included:
- inspect first
- classify complete/partial/missing/broken
- implement missing pieces on top of existing code
- avoid unnecessary rewrites

### Final product-wide audit and stabilization pass

Primary objective:
- Run a broad end-to-end audit of Path of Nūr and improve the app toward a cleaner, more consistent, more production-ready state.

Audit domains included:
- Navigation / IA
- UI / styling consistency
- Localization
- Content integrity / data quality
- Feature completeness
- Learning hub / knowledge flows
- Reward / progression integrity
- Performance / code hygiene
- Testing / safety coverage

---

## Repo Workflow / Agent Instructions

### Add prompt-archive rule to AGENTS.md

Primary objective:
- Add an instruction to `AGENTS.md` that prompts should be saved into a folder called `codex prompts`, organized by feature such as Qur’an reader, journeys, and similar areas.

### Audit and pull all prompts so far into a file

Primary objective:
- Gather the prompts from this thread so far and place them into an archive file.

Outcome:
- this file

