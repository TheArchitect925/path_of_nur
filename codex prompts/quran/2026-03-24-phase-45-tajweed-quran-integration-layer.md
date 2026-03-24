# Phase 45 Prompt — Tajweed ↔ Qur’an Integration Layer

PRIMARY OBJECTIVE === BUILDING A LIGHT TAJWEED-INTEGRATION LAYER THAT CONNECTS QUR’AN SNIPPETS TO BASIC PRONUNCIATION GUIDANCE AND TAJWEED LEARNING WITHOUT OVERWHELMING THE USER

You are working in the existing Flutter codebase for Path of Nūr.

This phase connects:
- Tajweed learning system
- Qur’an readiness bridge
- Arabic learning system

DO NOT build a full Tajweed engine. DO NOT introduce strict rules or scoring. Keep this beginner-friendly.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve Tajweed learning system
- Preserve Qur’an bridge
- Keep UX simple and calm
- No heavy rule overlays
- No scoring
- No destructive changes

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add Tajweed awareness to Qur’an snippets
2. Add light pronunciation hints
3. Link snippets to Tajweed lessons
4. Keep experience beginner-friendly

--------------------------------------------------
A. AUDIT CURRENT SYSTEMS
--------------------------------------------------

Inspect:
- Tajweed learning path
- Qur’an snippet system
- highlighting logic
- audio playback

Identify:
- where Tajweed can connect safely
- which rules are simplest and beginner-safe

--------------------------------------------------
B. DEFINE LIGHT TAJWEED HINTS
--------------------------------------------------

For snippets:

Add simple hints like:
- stretch sound
- clear pronunciation
- nasal sound (if safe)

Requirements:
- minimal text
- optional display
- no overload

--------------------------------------------------
C. ADD VISUAL HIGHLIGHTING
--------------------------------------------------

Enhance snippet highlighting:

- highlight relevant letters
- optionally color-code simple patterns

Requirements:
- consistent with existing highlighting
- not distracting

--------------------------------------------------
D. LINK TO TAJWEED LESSONS
--------------------------------------------------

Allow:
- tap hint → open Tajweed lesson

Requirements:
- correct routing
- no confusion
- optional (not forced)

--------------------------------------------------
E. KEEP EXPERIENCE SIMPLE
--------------------------------------------------

Ensure:
- no clutter
- no long explanations
- no advanced terminology

--------------------------------------------------
F. DATA SAFETY
--------------------------------------------------

Preserve:
- all systems
- routing
- progress

--------------------------------------------------
G. TESTING
--------------------------------------------------

Test:
- hints display correctly
- links work
- no regressions

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Integration summary
3. Hint system summary
4. Linking summary
5. Validation results
6. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Qur’an snippets include light Tajweed awareness
- users can connect pronunciation to text
- hints are helpful but not overwhelming
- Tajweed learning is connected
- no regressions introduced

--------------------------------------------------

“And recite the Qur’an with measured recitation.” — Qur’an 73:4

