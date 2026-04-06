===== PHASE X PROMPT — QIBLA COMPASS BEHAVIOR + LAYOUT REWORK =====

PRIMARY OBJECTIVE === BUILDING QIBLA COMPASS INTERACTION REWORK

You are working in the existing Flutter codebase for “Path of Nūr”.

TASK
Update the existing Qibla finder so it keeps the CURRENT APP THEME exactly as-is:
- same colors
- same background styling
- same material treatment
- same glass/look and feel
- same typography system where already defined

Do NOT redesign the page visually into a new theme.

Instead, rework the Qibla screen so the COMPASS, DIRECTION MODEL, and ORIENTATION BEHAVIOR work like the attached reference:
- large centered compass behavior
- stable rotating compass presentation
- visible Qibla target placement
- Kaaba marker / pointer relationship similar to the mockup
- current heading shown clearly below
- Qibla direction shown below
- better live orientation logic
- intuitive “turn until aligned” experience

IMPORTANT
- Audit first before editing.
- Reuse the existing Path of Nūr visual system.
- Reuse existing working Qibla/location/heading logic wherever possible.
- Do not delete records, settings, routes, or unrelated UI.
- Do not introduce a new page theme.
- Production-ready only. No placeholders. No v1 shortcuts.

==================================================
PRIMARY GOAL
==================================================

Keep the screen looking like Path of Nūr.

Only modernize and correct:
1. compass layout
2. compass rotation behavior
3. qibla target rendering
4. heading math / normalization if needed
5. alignment feedback
6. degree readout structure
7. usability of direction finding

The end result should feel like:
- same Path of Nūr page
- but with the compass working like the reference

==================================================
AUDIT FIRST
==================================================

Before changing code, audit the existing Qibla feature and identify:

- route owner
- page widget owner
- current heading source
- current compass plugin/package/source
- qibla bearing calculation logic
- heading normalization logic
- location retrieval flow
- reverse geocoding / location label flow
- permission handling
- loading/error/calibration states
- whether current implementation rotates the ring, the needle, the target, or a combination

Document what already works and preserve it where correct.

==================================================
HARD REQUIREMENTS
==================================================

1. KEEP EXISTING THEME
Do not replace:
- global page colors
- app background style
- app surface style
- app visual language
- app icon style
unless absolutely required for the compass subcomponent only.

2. CHANGE ONLY THE COMPASS EXPERIENCE
The compass should now behave more like the mockup:
- a strong centered circular compass
- directional labels around the ring
- target marker placed meaningfully
- user orientation easy to understand
- large degree readout below
- qibla direction value below that

3. DO NOT BREAK EXISTING ARCHITECTURE
Keep routing, localization, providers, state flow, and permissions architecture intact.

==================================================
IMPLEMENTATION DETAILS
==================================================

A. PAGE LAYOUT
Keep the existing page shell/theme, but restructure the core content so it has:

- top area with current existing page controls
- centered compass as main focus
- heading + qibla info below
- existing bottom/location area preserved or refined within current styling

Make spacing feel more deliberate and centered like the reference.

B. COMPASS MODEL
Refactor the compass so it works like this:

Option preferred:
- the compass dial rotates relative to live device heading
- a fixed visual top indicator represents the user’s facing direction
- the Qibla target is rendered in the correct relative place on or inside the dial
- when the user turns physically, the relationship clearly updates

Or equivalent implementation if mathematically cleaner.

Key requirement:
The user should instantly understand:
- where they are facing now
- where Qibla is
- how much they need to turn

C. COMPASS VISUAL CONTENT
Within the existing app theme, implement a better compass composition:
- circular ring
- tick marks
- directional letters
- Qibla marker
- Kaaba indicator or Kaaba-related icon
- top-facing indicator
- optional subtle alignment highlight

Do not force the exact colors of the reference.
Use current theme colors.
Only the structural behavior/layout should resemble the reference.

D. DEGREE READOUTS
Below the compass:
- show current live heading prominently, e.g. 117°
- show Qibla direction as secondary text, e.g. Qibla Direction 55°

These should:
- use existing app text styles where possible
- be clearer and easier to scan
- update correctly and smoothly

E. HEADING + QIBLA MATH
Verify and fix if needed:
- heading normalization to 0–360
- qibla bearing calculation for current coordinates
- shortest-angle delta calculation
- target relative angle rendering
- true understanding of “turn left/right” relationship if such guidance exists

If the current code has math issues, correct them cleanly.

F. LIVE SMOOTHING
If the compass is jittery:
- add lightweight smoothing
- avoid laggy over-filtering
- keep motion stable and believable

Possible approaches:
- angle lerp with wraparound handling
- small debounce/filter window
- painter-only updates instead of full page rebuilds

Do not degrade responsiveness.

G. ALIGNMENT STATE
Add a subtle aligned state when the user is facing near the Qibla.
Examples:
- slight glow
- gentle emphasis on target
- small text such as “Facing Qibla”
- tolerance around 5–8 degrees, adjustable in a constant

Keep it restrained and elegant.

H. LOCATION LABEL
Keep the current location display style/theme, but ensure it supports:
- resolved location name if already available
- graceful fallback if unavailable
- existing refresh/settings flow if one already exists

Do not overbuild a new location system unless required.

I. STATES
Polish all states while keeping current theme:
- loading
- location permission denied
- compass unavailable
- calibration needed
- sensor unavailable
- location unavailable

These states should remain visually consistent with the rest of the existing page.

==================================================
TECHNICAL STRUCTURE
==================================================

Refactor toward clean ownership if needed:

Suggested separation:
- qibla_page.dart (page shell)
- qibla_compass_widget.dart (main compass)
- qibla_compass_painter.dart (ring/ticks/labels if painter is used)
- qibla_direction_math.dart or equivalent helper (only if needed)
- qibla_status_section.dart
- qibla_location_pill.dart

Only create files if this actually improves clarity.
Do not over-fragment.

==================================================
PERFORMANCE
==================================================

- Avoid rebuilding the full screen on each heading update
- Scope updates to the compass/readout only
- Use CustomPainter or isolated widgets if appropriate
- Keep animation fluid on mobile devices

==================================================
LOCALIZATION + ACCESSIBILITY
==================================================

- Preserve existing localization system
- Add ARB keys only where needed
- Keep semantics for major controls
- Ensure readable contrast within the existing theme
- Respect safe areas and small devices

==================================================
VALIDATION CHECKLIST
==================================================

After implementing, verify:

1. Existing Path of Nūr theme is preserved
2. Compass now behaves like the reference structurally
3. User can easily tell where to turn
4. Heading value updates correctly
5. Qibla direction value is accurate
6. Kaaba / target marker placement is correct
7. Alignment feedback works
8. No jitter or excessive lag
9. Permission and unavailable states still work
10. Analyzer passes on changed files

==================================================
DELIVERABLES
==================================================

At the end provide:
- audit summary
- files changed
- what existing logic was reused
- what compass math was corrected or preserved
- whether dial rotation, target rotation, or mixed strategy was used
- how smoothing was implemented
- any new localization keys
- analyzer results

END GOAL
A production-ready Qibla finder that keeps the exact existing Path of Nūr theme, while making the compass interaction, direction model, and usability work like the provided reference.
