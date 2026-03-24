# Phase 40 Prompt — Qur’an Readiness Bridge (Arabic Learning → Beginner Qur’an Recognition)

PRIMARY OBJECTIVE === BUILDING A GENTLE QUR’AN READINESS BRIDGE THAT CONNECTS SHARED ARABIC LEARNING (LETTERS, WORDS, PHRASES, AUDIO) TO VERY SHORT REAL QUR’AN SNIPPETS WITH GUIDED HIGHLIGHTING AND BEGINNER-FRIENDLY RECOGNITION

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready bridge phase built on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio foundation
- shared words/phrases foundation
- Kids Arabic and Adult Arabic learning systems
- Qur’an learning surfaces and reader/player foundations

DO NOT rebuild the Qur’an reader. DO NOT merge Arabic learning into the full reader UI. DO NOT introduce strict recitation scoring. Build a calm, beginner-friendly bridge from Arabic learning into real Qur’anic recognition.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve Kids Arabic, Adult Arabic, and Qur’an reader systems
- Keep the bridge experience separate from the full Qur’an reader where appropriate
- Use real Qur’anic text/snippets only
- Keep snippets short, confidence-building, and beginner-safe
- Do not overload with advanced tajweed/tafsir/study features in this phase
- Reuse shared Arabic foundations where useful
- Reuse Qur’an audio/highlighting behavior only where safe and lightweight
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create a beginner-friendly Qur’an readiness bridge
2. Connect learned Arabic letters/words/phrases to very short real Qur’anic snippets
3. Add guided highlighting / recognition support
4. Add audio playback suitable for beginner recognition
5. Keep the experience calm, real, and confidence-building

--------------------------------------------------
A. AUDIT CURRENT ARABIC + QUR’AN CONNECTION POINTS
--------------------------------------------------

Inspect:
- shared Arabic alphabet/word/phrase foundations
- Kids Arabic reading mode
- Adult Arabic reading helpers
- Qur’an learning pages
- Qur’an reader/player audio/highlighting capabilities
- any existing short-surah / beginner Qur’an surfaces
- any existing “Qur’an for Kids” or beginner Qur’an entry points

Audit these questions:
- What beginner Qur’an surfaces already exist?
- Are there already short snippets or short surah entry points that can be reused safely?
- What highlighting/audio behavior can be reused without dragging in full reader complexity?
- Which shared Arabic words/phrases already overlap meaningfully with Qur’anic text?
- Where should the bridge live in Kids and Adults flows?
- What is the smallest real Qur’an surface that feels meaningful and production-safe?

--------------------------------------------------
B. DEFINE THE QUR’AN BRIDGE CONTENT SET
--------------------------------------------------

Create a curated set of very short Qur’anic snippets suitable for beginner recognition.

Requirements:
- use real Qur’anic text only
- keep snippets very short
- choose material that is beginner-friendly and high-recognition
- prefer content that supports confidence and recognition rather than overload

Examples of acceptable scope:
- very short phrases from familiar surahs
- tiny, high-recognition segments
- beginner-level snippets that connect well to previously learned Arabic forms

Do NOT make this a broad curriculum explosion.

Document in the final summary:
- which snippets were selected
- why they were selected
- how they connect to the Arabic learning path

--------------------------------------------------
C. CREATE A BEGINNER QUR’AN READINESS SURFACE
--------------------------------------------------

Create a dedicated beginner bridge experience, for example:
- Qur’an Readiness
- First Qur’an Reading
- Arabic to Qur’an Bridge
or similar product-safe naming

Requirements:
- separate from the full Qur’an reader UI
- clean and confidence-building
- supports both Kids and Adults through shared content with different presentation if needed
- makes it obvious that this is a beginner bridge into Qur’anic recognition

Possible placements:
- a dedicated island in Arabic learning
- a bridge card in Kids Arabic and Adult Arabic
- a Qur’an learning beginner entry surface

--------------------------------------------------
D. ADD GUIDED HIGHLIGHTING / RECOGNITION SUPPORT
--------------------------------------------------

Provide lightweight guided highlighting for the selected snippets.

Possible behaviors:
- highlight the full snippet during playback
- highlight word-by-word if already safe
- visually connect familiar letters/words/forms

Requirements:
- keep it simple
- do not port the entire full-reader highlighting complexity unless it is already safely reusable
- use highlighting to build recognition confidence, not overwhelm the learner

Goal:
- help the learner see “I recognize this”

--------------------------------------------------
E. ADD AUDIO PLAYBACK FOR THE SNIPPETS
--------------------------------------------------

Add clean playback for the selected Qur’an snippets.

Requirements:
- tap-to-hear
- replay
- calm and responsive
- use existing Qur’an audio infrastructure if safe
- do not drag the whole reader/player control stack into this bridge if unnecessary

Optional if safe:
- slow/normal playback if already consistent with Arabic learning audio controls

--------------------------------------------------
F. CONNECT TO SHARED ARABIC FOUNDATIONS
--------------------------------------------------

Where useful, connect the snippets to:
- shared letter ids
- shared word/phrase data
- shared positional forms
- shared audio expectations

Requirements:
- do not over-engineer a full parsing engine
- only connect what is product-useful and safe
- maintain one shared source of truth where practical

Possible helpful features:
- indicate which familiar word/phrase appears in the snippet
- lightly link known forms to recognized text

--------------------------------------------------
G. KEEP KIDS AND ADULTS DISTINCT IN PRESENTATION
--------------------------------------------------

Kids presentation may be:
- simpler
- more guided
- more visual
- more encouraging

Adult presentation may be:
- calmer
- cleaner
- more direct
- slightly more explanation-friendly

Requirements:
- shared bridge concept, distinct presentation
- do not flatten into one generic UI
- do not send Kids into adult-heavy flows or Adults into cartoon-heavy flows

--------------------------------------------------
H. KEEP THE FULL QUR’AN READER SEPARATE
--------------------------------------------------

The full Qur’an reader remains its own real product surface.

Requirements:
- this bridge should not become a second full reader
- use the bridge to build confidence and handoff readiness
- if useful, allow a safe “Open in Qur’an Learning” or “Continue in Reader” path later, but do not overload Phase 40 with that transition

--------------------------------------------------
I. LIGHTWEIGHT PROGRESSION / CONTINUITY
--------------------------------------------------

Integrate the bridge with the shared continuity/resume system where safe.

Requirements:
- a user can resume the next beginner snippet
- continuity remains mode-correct (Kids vs Adult)
- no duplicated “continue” surfaces fighting each other
- bridge progress should feel connected to Arabic learning, not isolated

--------------------------------------------------
J. EMPTY / FIRST-TIME / COMPLETED STATES
--------------------------------------------------

Handle:
- first-time users who just finished basic Arabic learning
- users with no eligible readiness progress yet
- users who have completed the current snippet set

Requirements:
- first-time state should explain the purpose simply
- no broken or vague empty states
- completed users can gently review or continue into existing Qur’an learning surfaces

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic progress
- Qur’an reader/player continuity
- shared foundations
- audio behavior
- routing integrity

Requirements:
- no destructive migrations
- no reset of progress
- no breaking of reader behavior
- no misuse of canonical ids or shared metadata

--------------------------------------------------
L. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- selected Qur’an bridge snippets render correctly
- guided highlighting works as intended for the bridge surface
- audio playback works correctly
- Kids and Adult entry points reach the correct bridge surface or presentation
- continuity/resume works safely if integrated
- no regressions are introduced into Arabic learning or full Qur’an surfaces

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Arabic/Qur’an connection points
   - reusable infrastructure found
   - chosen bridge placement and scope

3. Qur’an bridge summary
   - snippets selected
   - why they were selected
   - how they support beginner recognition

4. Highlighting/audio summary
   - what behavior was added
   - what was reused from existing systems
   - what intentionally remained out of scope

5. Shared-foundation integration summary
   - how the bridge uses shared Arabic learning foundations
   - what remains local to Qur’an surfaces

6. Data safety summary
   - confirmation that no progress/state/routing integrity was lost

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- there is a real beginner Qur’an readiness bridge
- Arabic learning now connects to very short real Qur’anic snippets
- highlighting/audio make recognition easier
- Kids and Adults both have a suitable bridge path with distinct presentation
- the full Qur’an reader remains separate and unaffected
- no regressions are introduced into Arabic learning, routing, audio, or Qur’an systems
- learners can feel a real “I can recognize Qur’an now” moment

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the full Qur’an reader
- merge Arabic learning into the main reader UI
- introduce strict recitation scoring
- explode this into a full tafsir/study/memorization system
- flatten Kids and Adults into one generic bridge UI
- introduce destructive migrations or routing changes outside the bridge scope

Stay focused on a gentle Qur’an readiness bridge from shared Arabic learning into real Qur’anic recognition.
