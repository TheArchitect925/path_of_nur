# Phase 49 Prompt — Qur’an Bridge To Short Surah Readiness

PRIMARY OBJECTIVE === BUILDING A BEGINNER-FRIENDLY PATH FROM QUR’AN SNIPPETS TO VERY SHORT COMPLETE SURAHS WITH GUIDED HIGHLIGHTING, AUDIO, AND CONFIDENCE-FOCUSED FLOW

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- Qur’an readiness bridge (snippets)
- shared Arabic alphabet, positional forms, and audio foundations
- shared words/phrases foundation
- Kids Arabic and Adult Arabic learning systems
- Tajweed ↔ Qur’an integration layer
- continuity/resume and review layers
- offline-first bundle

DO NOT rebuild the full Qur’an reader. DO NOT introduce strict recitation scoring. Keep this as a gentle, beginner-ready bridge into real, short surah reading.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing Qur’an reader/player and Arabic learning flows
- Keep this surface separate from the full reader UI
- Use real Qur’anic text only
- Keep UX calm, clear, and confidence-building
- Reuse shared audio and (lightweight) highlighting where safe
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Introduce a curated set of very short complete surahs (or very short passages) for beginners

2. Provide guided reading with:
   - simple highlighting
   - clear audio playback
   - optional slow playback

3. Create a gentle progression from snippets → short surahs

4. Keep experience distinct from the full reader while enabling an optional handoff

--------------------------------------------------
A. AUDIT CURRENT BRIDGE AND QUR’AN SURFACES
--------------------------------------------------

Inspect:
- current snippet set and progression (Phase 44)
- highlighting/audio behavior used in the bridge
- Qur’an reader/player capabilities (audio, highlight, reciters)
- any existing short-surah or beginner Qur’an pages
- entry points from Kids and Adults

Audit questions:
- Which short surahs/passages are already available locally?
- What highlighting/audio can be reused safely without importing full reader complexity?
- Where should the short-surah bridge live?
- How should we transition from snippets to full surahs?

--------------------------------------------------
B. DEFINE A BEGINNER SHORT-SURAH SET
--------------------------------------------------

Create a small, curated set of very short surahs (or complete passages) suitable for beginners.

Requirements:
- use real Qur’anic text only
- keep surahs short and approachable
- high-recognition and commonly known
- small, high-quality set (no breadth for its own sake)

Document:
- which surahs/passages were chosen
- why they are suitable for beginners

--------------------------------------------------
C. CREATE A “SHORT SURAH READING” SURFACE
--------------------------------------------------

Build a dedicated beginner surface, e.g.:
- “Short Surahs”
- “First Surahs”
- “Beginner Qur’an Reading”

Requirements:
- separate from full reader UI
- simple layout
- clear navigation between surahs
- accessible from:
  - Arabic learning (Kids/Adults)
  - Qur’an bridge

--------------------------------------------------
D. ADD GUIDED HIGHLIGHTING
--------------------------------------------------

Implement lightweight highlighting for reading.

Options:
- whole-ayah highlight during playback
- word-level highlight if safe

Requirements:
- consistent with snippet highlighting
- avoid heavy reader complexity
- clear, readable, non-distracting

--------------------------------------------------
E. AUDIO PLAYBACK
--------------------------------------------------

Provide clean audio for each surah:

Requirements:
- tap-to-play
- replay
- optional slow/normal speed (if already supported)
- use existing audio infrastructure where safe

No heavy control panels.

--------------------------------------------------
F. PROGRESSION FROM SNIPPETS → SURAHS
--------------------------------------------------

Create a simple progression link:

- after snippets → suggest short surah reading
- within surahs → next surah
- allow revisit of previous surahs

Requirements:
- no strict locking
- clear next step
- integrate with continuity/resume

--------------------------------------------------
G. OPTIONAL TAJWEED AWARENESS (LIGHT)
--------------------------------------------------

Reuse Phase 45 lightly:

- subtle hints (optional)
- no heavy rules

Keep minimal and optional.

--------------------------------------------------
H. CONNECT TO SHARED FOUNDATIONS
--------------------------------------------------

Where useful, connect:
- known words/phrases inside surah
- shared audio behavior
- continuity/review

No heavy parsing system.

--------------------------------------------------
I. HANDOFF TO FULL QUR’AN READER (OPTIONAL)
--------------------------------------------------

Allow optional transition:

- “Open in Qur’an Reader”

Requirements:
- clean handoff
- not required for core flow
- preserve reader independence

--------------------------------------------------
J. HANDLE STATES
--------------------------------------------------

- First-time → simple explanation
- In-progress → resume last surah
- Completed → review or next step
- No progress → suggest starting point

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

Preserve:
- Arabic learning progress
- Qur’an reader integrity
- audio mappings
- shared foundations

No destructive changes.

--------------------------------------------------
L. TESTING
--------------------------------------------------

Test:
- surahs render correctly
- highlighting works
- audio works
- progression works
- continuity/resume works
- no regressions in reader or Arabic learning

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
3. Short-surah set summary
4. UI implementation summary
5. Highlighting/audio summary
6. Progression summary
7. Data safety summary
8. Validation results
9. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- users can read full short surahs in a beginner-friendly way
- progression from snippets is clear
- highlighting/audio support reading confidence
- Kids and Adults both have appropriate entry paths
- no regressions introduced
- learners feel “I can read a surah”
