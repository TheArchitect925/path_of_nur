===== QURAN READER MODES AUDIT PROMPT — WHAT EACH READING MODE SHOULD SHOW / DO =====

PRIMARY OBJECTIVE === AUDITING QURAN READER MODES AND DEFINING WHAT EACH MODE SHOULD SHOW / DO

You are working in the existing Flutter codebase for Path of Nūr.

Your task is to run a full audit of the current Qur’an reader modes and determine:

1. what reading/view modes already exist
2. what each mode currently shows
3. what each mode currently does
4. what each mode should ideally show/do
5. what is missing, unclear, duplicated, or poorly surfaced
6. what should be cleaned up, merged, renamed, or enhanced

IMPORTANT:
This is an audit-first prompt.
Do not rebuild the reader.
Do not randomly rename or delete modes without first proving what exists and what is safe.
Do not remove working features for no reason.

This pass is about:
- clarity
- product structure
- clean user experience
- making every reading mode meaningful

We want to know exactly:
- what modes do we currently have
- what should each mode contain
- how should each mode behave
- whether we have too many overlapping modes
- whether related content, study content, and playback content are placed in the right mode

CRITICAL SAFETY RULES
- Audit first before changing anything.
- Do not go haywire and remove/delete records or logic for no reason.
- Do not rebuild the Qur’an page from scratch.
- Preserve working playback, highlight, notes, bookmarks, memorization, downloads, and session behavior.
- Make recommendations based on the real implementation, not guesses.
- If a mode exists only partially, say so clearly.
- If related content is not surfaced anywhere, identify that explicitly.

==================================================
STEP 1 — AUDIT THE CURRENT READER MODES
==================================================

First inspect the full Qur’an reader implementation and identify every reading/view mode, including but not limited to:

- default reading mode
- translation mode
- transliteration mode
- memorization mode
- playback / listening mode
- study mode if any
- focus mode if any
- tafsir / details / related content mode if any
- any ayah expansion/detail sheet behavior
- any alternate layout mode
- any settings-driven display combinations that behave like modes even if not named as modes

For each mode or pseudo-mode, report:
- internal name / enum / flag / setting
- where it is defined
- where it is toggled
- where it is rendered
- whether it is actually user-visible
- whether it is complete or partial

==================================================
STEP 2 — MAP WHAT EACH MODE CURRENTLY SHOWS
==================================================

For every discovered mode, list exactly what it currently shows.

Examples of possible surfaces:
- Arabic text
- translation
- transliteration
- word highlight
- ayah highlight
- play controls
- memorization reveal/hide
- notes
- bookmarks
- tafsir
- related lessons
- hadith links
- topic/theme tags
- signs/reflections
- word meanings
- reciter info
- download state
- follow mode
- study widgets
- quiz / review entry points

Be precise.
Do not assume something is shown just because data exists somewhere else.

==================================================
STEP 3 — MAP WHAT EACH MODE CURRENTLY DOES
==================================================

For every discovered mode, list exactly what behavior it enables or changes.

Examples:
- changes what text is visible
- changes playback controls
- changes scroll/follow behavior
- enables memorization hide/reveal
- enables word tapping
- changes ayah actions
- changes what appears inline vs in sheet/detail view
- changes what related content is accessible
- changes focus/distraction level
- changes visual density

Call out whether a mode is truly behaviorally distinct, or whether it is just a display toggle pretending to be a mode.

==================================================
STEP 4 — IDENTIFY UX OVERLAP / CONFUSION
==================================================

Audit whether the current mode system is confusing, overlapping, or fragmented.

Specifically identify:
- modes that overlap too much
- toggles that should be grouped together
- features that are hidden in the wrong place
- “modes” that are actually just simple display options
- display options that should perhaps become a proper mode
- study content that is not surfaced clearly
- related content that exists in planning/data but is not visible in the reader
- memorization functions that are mixed awkwardly into standard reading
- playback-specific behavior that should be separated from reading/study behavior

==================================================
STEP 5 — DETERMINE THE IDEAL READER MODE STRUCTURE
==================================================

Based on the audit, propose the ideal production-ready mode structure for the Qur’an reader.

Do not propose 10 messy modes.
Keep it clean and elegant.

A likely good target may be something like:
- Read Mode
- Listen Mode
- Study Mode
- Memorize Mode
- Details / Related Content panel
- Reader display toggles inside settings

But do not force this if the real implementation suggests something better.

For each recommended mode, define:
- purpose
- who it is for
- what it should show
- what it should do
- what actions are available
- what should stay hidden to reduce clutter
- how it should connect to ayah-level details

==================================================
STEP 6 — DEFINE WHAT EACH MODE SHOULD SHOW / DO
==================================================

For the final recommended structure, produce a clean product spec table/list for each mode:

For each mode include:
1. Mode name
2. Primary purpose
3. What should be visible
4. What interactions should be enabled
5. What ayah actions should be available
6. What should be hidden or minimized
7. Whether playback is primary/secondary/hidden
8. Whether related content should show inline or in a detail sheet
9. Whether memorization tools belong there
10. Whether translation/transliteration are default/optional/hidden

Examples of things to explicitly decide:
- In Read Mode, should related content be inline or only behind an info button?
- In Listen Mode, should ayah cards be simplified and highlight playback strongly?
- In Study Mode, should related links, tafsir, hadith, signs, themes, and lessons appear?
- In Memorize Mode, should translation be hidden by default?
- Should transliteration be a separate mode or just a display toggle?
- Should “related content” be its own mode or an ayah detail surface available from all modes?

==================================================
STEP 7 — RELATED CONTENT AUDIT
==================================================

Specifically audit the “related links and information” problem.

Investigate:
- does the app already have related content data linked to ayahs?
- if yes, where is it stored?
- if yes, where is it surfaced?
- if not surfaced, what is missing: UI, routing, mapping, or data plumbing?
- is there already an ayah detail sheet/page?
- should related content live inside Study Mode, inside an Ayah Details sheet, or both?

Provide a recommendation for the cleanest UX.

Target outcome:
The user should be able to easily access related content for an ayah without cluttering the normal reading experience.

==================================================
STEP 8 — AUDIT SETTINGS VS MODES
==================================================

Identify which things should remain simple toggles/settings rather than full modes.

Examples:
- show/hide translation
- show/hide transliteration
- font size
- line spacing
- theme
- follow mode
- word highlight
- reciter selection

Do not turn every setting into a mode.
Separate:
- true reading modes
- display toggles
- playback controls
- ayah actions

==================================================
STEP 9 — RECOMMEND SAFE IMPLEMENTATION PLAN
==================================================

After the audit, propose the safest implementation plan.

Break it into:
- what can remain as is
- what should be renamed
- what should be merged
- what should be surfaced better
- what new UI surface is needed
- what should be deferred

Prioritize minimal disruption.
Do not recommend large rewrites unless truly necessary.

==================================================
STEP 10 — TESTING / VALIDATION AUDIT
==================================================

Audit whether current tests cover mode behavior.

Identify missing tests for:
- switching modes
- toggling translation/transliteration
- memorization mode behavior
- playback mode behavior
- study mode / related content visibility
- ayah detail panel behavior
- no-regression mode switching while playback is active

If safe and useful, add targeted tests for the clarified mode system.

==================================================
STEP 11 — FINAL DELIVERABLE
==================================================

At the end, provide:

1. Audit summary before changes
2. All current reader modes found
3. What each current mode shows
4. What each current mode does
5. What is overlapping / confusing / missing
6. Recommended final reader mode structure
7. For each recommended mode: exactly what it should show/do
8. Recommended handling for related links / ayah information
9. Which things should be modes vs simple toggles
10. Files changed, if any
11. Recommended next implementation phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, provide one consolidated summary of:
- what modes currently exist
- what each mode should ideally become
- where related ayah content should live
- what UI surface is missing today
- what should be built next

Do not go haywire.
Do not delete or remove working logic for no reason.
Audit first, understand the real reader mode system, then define the clean production-ready structure.

===== END PROMPT =====
