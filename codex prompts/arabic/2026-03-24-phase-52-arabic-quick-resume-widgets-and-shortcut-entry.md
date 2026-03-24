===== PHASE 52 PROMPT — ARABIC QUICK RESUME WIDGETS AND SHORTCUT ENTRY =====

PRIMARY OBJECTIVE === BUILDING QUICK-ACCESS ENTRY POINTS (HOME SCREEN / LOCK SCREEN / IN-APP SHORTCUTS) SO USERS CAN RESUME ARABIC LEARNING IN ONE TAP USING THE SHARED CONTINUITY LAYER

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready accessibility phase built on top of:
- unified continuity/resume layer (Phase 37)
- shared review layer (Phase 38)
- Arabic search/filter (Phase 41)
- calm progress dashboards (Phase 42)
- Kids Arabic and Adult Arabic learning flows

DO NOT rebuild Arabic learning systems. DO NOT change progression logic. This phase focuses on fast, reliable entry points into the correct next action.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Use the shared continuity layer as the single source of truth
- Preserve Kids/Adult UX separation
- Keep entry points simple and fast
- No duplicated resume logic
- No destructive migrations
- Keep platform behavior safe (iOS/Android constraints)
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add quick resume entry points:
   - Home screen widgets
   - In-app shortcuts (Quick Actions)
   - Optional lock screen / dynamic surface (if already supported)

2. Allow one-tap entry into:
   - Continue Arabic Learning
   - Review Arabic
   - Resume last activity

3. Ensure all shortcuts resolve through the shared continuity layer

--------------------------------------------------
A. AUDIT CURRENT ENTRY POINTS
--------------------------------------------------

Inspect:
- existing home widgets (if any)
- dynamic island / live activities (if implemented)
- quick actions / app shortcuts
- deep links
- current navigation into Arabic learning
- continuity layer outputs

Audit questions:
- What entry points already exist?
- Are there any existing quick actions?
- How does routing currently handle deep links?
- What is the safest minimal set of entry points to add now?

--------------------------------------------------
B. DEFINE QUICK ACTION TYPES
--------------------------------------------------

Create a small set of actions:

- Continue Arabic
- Review Arabic
- Start Arabic (for first-time users)

Requirements:
- map all actions to shared continuity/review logic
- avoid adding too many actions
- keep naming clear and consistent

--------------------------------------------------
C. IMPLEMENT IN-APP SHORTCUTS
--------------------------------------------------

Add quick actions (e.g., long-press app icon / in-app shortcut menu):

Requirements:
- trigger correct route
- resolve target via continuity layer
- handle mode (kids/adult) correctly
- no duplicated routing logic

--------------------------------------------------
D. IMPLEMENT HOME SCREEN WIDGET(S)
--------------------------------------------------

Create a simple widget showing:
- “Continue Arabic”
- last item (e.g., “Resume Meem”)
- optional “Review”

Requirements:
- minimal UI
- fast load
- works offline using local data
- uses shared continuity output

Do not over-design widget.

--------------------------------------------------
E. OPTIONAL LOCK SCREEN / LIVE ENTRY (IF SUPPORTED)
--------------------------------------------------

If the app already supports:
- lock screen widgets
- live activities
- dynamic island

Then:
- add a minimal “Continue Arabic” entry

Requirements:
- optional
- safe
- non-blocking

--------------------------------------------------
F. ROUTING AND DEEP LINK SAFETY
--------------------------------------------------

Ensure all entry points:
- use canonical route targets
- resolve through continuity layer
- handle:
  - first-time users
  - completed users
  - missing data gracefully

No broken deep links.

--------------------------------------------------
G. OFFLINE SUPPORT
--------------------------------------------------

Ensure:
- widgets/shortcuts work offline
- use cached/local progress data
- no network dependency for core functionality

--------------------------------------------------
H. KEEP KIDS AND ADULTS DISTINCT
--------------------------------------------------

Kids:
- may show simpler labels (e.g., “Continue”)

Adults:
- clearer labels (e.g., “Resume Arabic”)

Same logic, different presentation where needed.

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- all progress
- routing
- shared foundations

No destructive changes.

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add/update tests for:
- quick actions resolve correctly
- widget data is correct
- deep links route correctly
- offline behavior works
- no regressions

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
3. Quick action summary
4. Widget implementation summary
5. Routing summary
6. Data safety summary
7. Validation results
8. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- users can resume Arabic learning in one tap
- entry points are fast and reliable
- continuity layer is the single source of truth
- offline support works
- no regressions introduced

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 52 PROMPT =====
