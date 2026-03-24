===== PHASE 39 PROMPT — SHARED PHRASE AUDIO AND PRONUNCIATION POLISH =====

PRIMARY OBJECTIVE === BUILDING A CONSISTENT, HIGH-QUALITY ARABIC PRONUNCIATION EXPERIENCE FOR LETTERS, WORDS, AND PHRASES WITH SHARED AUDIO CONTROL, PLAYBACK MODES, AND UX CONSISTENCY ACROSS KIDS AND ADULTS

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest (Phase 33)
- shared words/phrases foundation (Phase 35)
- Kids Arabic tracing/reading/audio layer (Phase 27)
- Adult Arabic reading helpers (Phase 36)
- unified continue flow (Phase 37)
- shared review layer (Phase 38)

DO NOT rebuild audio systems from scratch. DO NOT break tracing, reading, routing, or progress. This phase focuses on **audio quality, consistency, and usability**.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing audio playback behavior
- Use the shared audio manifest as the source of truth
- Do not introduce voice recording or pronunciation scoring
- Keep UX calm and child-friendly
- Maintain Kids vs Adult presentation differences
- Avoid duplicated audio logic across pages
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Standardize pronunciation audio across:
   - letters
   - words
   - phrases

2. Improve playback experience:
   - consistent timing
   - consistent volume
   - consistent feedback

3. Add simple playback controls:
   - normal speed
   - slow speed (for learning)

4. Ensure audio UX feels consistent across Kids and Adults

5. Remove audio drift and duplication in lookup/usage

--------------------------------------------------
A. AUDIT CURRENT AUDIO EXPERIENCE
--------------------------------------------------

Inspect:
- shared Arabic audio manifest
- Kids audio usage (letters, words, phrases)
- Adult audio usage
- playback helpers/services
- audio asset consistency (volume, length, silence)
- tap-to-play UI behavior
- any repeated or duplicated audio logic

Audit these questions:
- Are all letter audio files consistent in length and volume?
- Are word and phrase audio consistent?
- Are there delays or playback inconsistencies?
- Is slow playback currently supported?
- Are there multiple playback implementations?
- Is feedback (highlight/pulse) consistent?
- Are some pages bypassing the shared audio layer?

--------------------------------------------------
B. STANDARDIZE AUDIO PLAYBACK
--------------------------------------------------

Ensure all audio playback goes through a shared mechanism.

Requirements:
- single playback helper/service
- consistent invocation across Kids and Adults
- no page-local audio hacks
- predictable start/stop behavior
- safe interruption handling

--------------------------------------------------
C. ADD SPEED CONTROL (NORMAL / SLOW)
--------------------------------------------------

Implement simple playback speed control.

Requirements:
- normal (default)
- slow (for learning clarity)
- applied consistently across letters, words, phrases
- toggle must be simple and unobtrusive
- persist user preference if safe

Do NOT add complex playback controls.

--------------------------------------------------
D. IMPROVE AUDIO FEEDBACK UX
--------------------------------------------------

When audio plays:

Add:
- subtle highlight of text
- gentle pulse/glow
- visual indication that sound is active

Requirements:
- consistent across all Arabic learning surfaces
- not distracting
- child-friendly for Kids
- clean for Adults

--------------------------------------------------
E. HANDLE AUDIO CONSISTENCY ISSUES
--------------------------------------------------

If inconsistencies exist:

Normalize:
- volume levels
- silence trimming (start/end)
- playback responsiveness

Requirements:
- no clipping
- no long delays
- no inconsistent loudness

Do NOT regenerate all assets unless necessary; adjust playback layer if possible.

--------------------------------------------------
F. ALIGN KIDS AND ADULT AUDIO BEHAVIOR
--------------------------------------------------

Ensure:

Kids:
- more guided playback
- optional autoplay in some flows
- softer feedback

Adults:
- manual tap-to-play
- cleaner UI
- no forced autoplay

Both:
- same underlying audio source
- same playback quality

--------------------------------------------------
G. IMPROVE PHRASE AUDIO FLOW
--------------------------------------------------

For phrases:

- ensure full phrase plays clearly
- allow replay
- optional segmented replay (future-ready, not required now)

Keep it simple:
- tap → play
- replay available

--------------------------------------------------
H. CONNECT TO SHARED FOUNDATIONS
--------------------------------------------------

Ensure audio uses:
- canonical ids from shared alphabet
- shared word/phrase ids
- shared manifest

No duplication.

--------------------------------------------------
I. HANDLE MISSING AUDIO GRACEFULLY
--------------------------------------------------

If audio missing:

- safe fallback (no crash)
- optional UI hint
- do not break flow

--------------------------------------------------
J. LIGHTWEIGHT UX SWEEP
--------------------------------------------------

Check:
- consistent audio icons/buttons
- consistent spacing and placement
- no duplicate controls
- no disclosure arrows on containers (if rule enforced)

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

Preserve:
- progress
- XP system
- routing
- shared foundations

No destructive changes.

--------------------------------------------------
L. TESTING
--------------------------------------------------

Add/update tests:

- audio plays correctly for letters
- audio plays correctly for words/phrases
- speed toggle works
- no regression in playback
- no crash on missing audio
- shared audio layer is used everywhere

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audio audit findings
3. Playback standardization summary
4. Speed control implementation
5. UX feedback improvements
6. Data safety summary
7. Validation results
8. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- consistent audio playback across Kids and Adults
- speed control works (normal/slow)
- audio feedback is clear and subtle
- no duplicated audio logic
- no regressions introduced
- Arabic learning feels smoother and more immersive

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 39 PROMPT =====
