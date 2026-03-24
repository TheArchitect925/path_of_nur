===== PHASE 53 PROMPT — QUR’AN BRIDGE ADVANCED PROGRESSION =====

PRIMARY OBJECTIVE === BUILDING A STRONGER, STEP-BY-STEP QUR’AN READING BRIDGE THAT MOVES LEARNERS FROM VERY SHORT SNIPPETS AND SHORT SURAHS INTO SLIGHTLY LONGER, STILL-BEGINNER-FRIENDLY PASSAGES WITH CONFIDENCE, AUDIO, HIGHLIGHTING, AND CLEAR CONTINUITY

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready progression phase built on top of:
- Qur’an readiness bridge
- short surah bridge
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared words/phrases foundation
- Kids Arabic and Adult Arabic learning systems
- Tajweed ↔ Qur’an integration layer
- unified continuity/resume layer
- shared gentle review layer
- offline-first Arabic bundle

DO NOT rebuild the full Qur’an reader. DO NOT merge this bridge into the full reader UI. DO NOT introduce strict recitation scoring. Build a calm, progressive bridge from short snippets and short surahs into slightly longer guided reading passages.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the existing bridge and short-surah behavior
- Keep bridge surfaces distinct from the full Qur’an reader
- Use real Qur’anic text only
- Keep progression confidence-building and beginner-safe
- Reuse shared audio/highlighting where safe
- Avoid overloading users with advanced tajweed/tafsir/study features
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Expand the Qur’an bridge beyond very short snippets and very short complete surahs

2. Introduce slightly longer guided passages in a structured beginner progression

3. Improve continuity so learners always know:
   - where they are
   - what comes next
   - what to review

4. Keep the bridge calm, readable, and clearly separate from the full reader

--------------------------------------------------
A. AUDIT CURRENT BRIDGE PROGRESSION
--------------------------------------------------

Inspect:
- current snippet progression
- short-surah progression
- continuity/resume behavior
- highlighting/audio consistency
- existing bridge entry points from Kids and Adults
- overlap with Qur’an learning pages and full reader

Audit these questions:
- Where does the current bridge progression feel too abrupt?
- Are there gaps between snippets and short surahs?
- Which current bridge items are strongest?
- Which slightly longer passages would be a natural next step?
- What progression structure is already implied by current content?
- What is the safest scope for a stronger next stage without overwhelming learners?

--------------------------------------------------
B. DEFINE AN ADVANCED BEGINNER PASSAGE SET
--------------------------------------------------

Create a curated set of slightly longer beginner-friendly Qur’anic passages.

Requirements:
- use real Qur’anic text only
- keep passages short enough to remain approachable
- choose passages that feel like a natural step after snippets/short surahs
- prioritize confidence, familiarity, and readability
- do not explode into broad curriculum scope

Document in the final summary:
- which passages were selected
- why they were selected
- how they fit into the progression ladder

--------------------------------------------------
C. DEFINE A CLEAR PROGRESSION LADDER
--------------------------------------------------

Organize the bridge into a clearer ladder, for example:

- Stage 1: very short recognition snippets
- Stage 2: very short complete surahs / very short passages
- Stage 3: slightly longer guided passages

You may adapt the naming, but requirements are:
- progression should feel real and easy to follow
- no hard over-locking
- clear next step
- simple revisit/review path
- compatible with shared continuity/resume

--------------------------------------------------
D. BUILD THE ADVANCED BRIDGE SURFACE
--------------------------------------------------

Create or expand the existing bridge UI so it can handle the new progression cleanly.

Requirements:
- still separate from the full Qur’an reader
- clear stage/group organization
- easy to browse and continue
- visually calm and beginner-safe
- no route sprawl
- should remain accessible from existing Arabic/Qur’an bridge pages

Do not turn this into a second full reader.

--------------------------------------------------
E. IMPROVE HIGHLIGHTING FOR LONGER PASSAGES
--------------------------------------------------

Refine highlighting behavior for slightly longer passages.

Requirements:
- consistent with earlier bridge phases
- readable and not visually noisy
- may use:
  - full-ayah/passsage highlighting
  - word-level highlighting if safe
- avoid importing full reader complexity unnecessarily

Goal:
- support recognition and flow, not overwhelm

--------------------------------------------------
F. IMPROVE AUDIO FOR LONGER PASSAGES
--------------------------------------------------

Ensure slightly longer passages have strong playback support.

Requirements:
- play / replay
- optional slow playback if already safely supported
- smooth behavior across passages
- use existing audio infrastructure where safe
- no heavy playback control panel

Goal:
- hearing the passage should support confidence and repetition

--------------------------------------------------
G. INTEGRATE LIGHT TAJWEED AWARENESS WHERE HELPFUL
--------------------------------------------------

Reuse the Tajweed ↔ Qur’an integration lightly and only where it helps.

Requirements:
- optional, subtle hints
- no heavy rule overlays
- no dense terminology
- only where it meaningfully improves confidence

This remains a reading bridge, not a formal tajweed course.

--------------------------------------------------
H. STRENGTHEN CONTINUITY / REVIEW
--------------------------------------------------

Integrate the expanded progression with the shared continuity/review system.

Requirements:
- resume last active passage
- suggest next passage when appropriate
- suggest gentle review when appropriate
- no duplicate or conflicting continue cards
- continuity logic should remain shared and centralized

--------------------------------------------------
I. ENTRY POINTS MUST USE EXISTING PAGES
--------------------------------------------------

Ensure the expanded progression is accessible through existing pages and discovery flows.

Examples where appropriate:
- Kids Arabic bridge entry
- Adult Arabic bridge entry
- Qur’an readiness bridge page
- short-surah bridge page
- Continue Arabic Learning / Resume Arabic
- search/filter where relevant

Requirements:
- do not strand new content behind obscure routes
- do not require users to know a hidden page exists
- new progression must feel integrated into the existing product structure

--------------------------------------------------
J. HANDLE FIRST-TIME / MID-PROGRESS / COMPLETED STATES
--------------------------------------------------

Handle:
- first-time bridge users
- users who completed snippets but not short surahs
- users who completed short surahs and are ready for longer passages
- users who completed the currently available bridge set

Requirements:
- calm, clear states
- simple explanation of where they are
- useful next step
- no vague empty states

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

Preserve:
- Arabic learning progress
- bridge progress
- short-surah continuity
- Qur’an reader integrity
- shared foundations
- audio behavior
- route integrity

Requirements:
- no destructive migrations
- no reset of progress
- no breaking of full reader behavior
- no misuse of canonical ids/shared metadata

--------------------------------------------------
L. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- advanced beginner passages render correctly
- progression ladder resolves correctly
- highlighting/audio work for longer passages
- continuity/resume works for the expanded bridge
- entry points route correctly from existing pages
- no regressions are introduced into snippets, short surahs, Arabic learning, or full Qur’an systems

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current bridge strengths/gaps
   - progression weaknesses found
   - chosen advanced passage scope

3. Progression summary
   - updated ladder/stages
   - what new stage was added
   - how next-step logic works

4. Passage set summary
   - passages selected
   - why they were chosen
   - how they support beginner confidence

5. Highlighting/audio summary
   - what was improved
   - what was reused
   - what intentionally remained out of scope

6. Accessibility/integration summary
   - which existing pages now surface the advanced bridge progression
   - how hidden/orphan routes were avoided

7. Data safety summary
   - confirmation that no progress/state/routing/shared-foundation integrity was lost

8. Validation
   - analyzer/tests run
   - results

9. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- the Qur’an bridge now has a stronger progression beyond snippets and very short surahs
- slightly longer guided passages are available
- continuity makes the next step clear
- highlighting/audio remain calm and supportive
- all new bridge content is accessible through existing pages and flows
- the full Qur’an reader remains separate and unaffected
- no regressions are introduced into Arabic learning, bridge flows, routing, audio, or Qur’an systems
- learners feel a stronger, more realistic “I can keep reading” progression

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the full Qur’an reader
- merge the bridge into the full reader UI
- introduce strict recitation scoring
- explode this into a full tafsir/study/memorization system
- create isolated new pages that are not surfaced through existing discovery flows
- introduce destructive migrations or broad route changes outside the bridge scope

Stay focused on expanding the beginner Qur’an progression safely and keeping all new content easy to access through the current product structure.

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 53 PROMPT =====
