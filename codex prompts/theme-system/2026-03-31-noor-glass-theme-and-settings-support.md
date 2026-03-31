# PHASE X PROMPT — ADD NEW NOOR GLASS THEME AND SETTINGS SUPPORT

PRIMARY OBJECTIVE === BUILDING A NEW MILKY SEE-THROUGH GLASS THEME

You are working in the existing Flutter codebase for Path of Nūr.

GOAL
Add a NEW selectable glass theme that matches the milky translucent frosted-glass look shown in the reference. This is NOT the same as the previously approved warm parchment glass. Keep the existing warm glass implementation intact. Introduce this as a separate theme/style option and wire it through settings safely.

IMPORTANT RULES
- Audit first before changing anything
- Do not remove or overwrite the existing warm glass treatment
- Do not force a global replacement of all surfaces
- Add this as a new supported glass/material style
- Ensure Settings exposes it properly
- Preserve production readiness
- Do not break current theme switching, custom themes, or surface resolution
- Do not delete records, stored settings, or existing options
- Build the feature completely, not as a placeholder
- End with a final audit summary

REFERENCE INTENT
The new theme should look like:
- milky translucent frosted glass
- visibly see-through
- softly blurred background behind cards
- luminous and airy
- less beige than warm parchment glass
- not fully white
- not cold blue
- not glossy or plastic

Suggested user-facing name:
- Noor Glass

Acceptable internal naming examples:
- noorGlass
- milkyGlass
- frostedMilkyGlass

STEP 1 — AUDIT CURRENT THEME / SETTINGS OWNERSHIP
Identify:
- where glass/surface styles are currently defined
- where theme mode or visual style preferences are stored
- where Settings exposes theme or appearance options
- how current homepage warm glass is represented
- how global/shared surface widgets resolve their active treatment
- whether there is already an appearance enum/model/provider suitable for adding this cleanly

Provide:
1. exact files owning theme/surface treatment
2. exact files owning appearance/settings selection
3. safest insertion point for the new glass theme option
4. migration risk, if any

STEP 2 — ADD A NEW GLASS THEME OPTION
Add a new material/surface treatment representing the milky frosted glass look.

This new treatment should have:
- higher translucency than warm parchment glass
- more visible backdrop blur/frosting
- soft milky ivory/pearl fill
- subtle luminous top sheen
- thin pearl/gold-beige border
- gentle soft shadow
- preserved text readability
- enough transparency that backgrounds remain visible through cards

The look should feel:
- spiritual
- clean
- luminous
- soft
- elegant

Avoid:
- heavy beige
- muddy cream
- strong yellow
- over-opaque white
- thick borders
- excessive shadow
- flashy glossy highlights

STEP 3 — INTEGRATE WITH SHARED SURFACE SYSTEM
Wire the new treatment into the existing shared surface resolver.
It must work through the normal card/container/surface system rather than one-off local hacks.

The implementation should support:
- panel surfaces
- pill/chip surfaces
- nested cards
- embedded dashboard cards

STEP 4 — ADD SETTINGS SUPPORT
Find the existing settings screen / appearance controls and add the new option cleanly.

Requirements:
- the user can explicitly select the new glass theme
- current saved settings continue to work
- old users do not lose preferences
- new option is labeled clearly in the UI
- localization readiness is preserved
- no hardcoded user-facing strings unless properly localized through the existing system

If the app has a theme style section, place it there.
If the app has a glass/material section, extend it there.
If the app has neither, add the new option in the most appropriate existing appearance/settings surface.

STEP 5 — APPLY SAFELY
Make sure the new glass theme actually affects the shared card surfaces when selected.

Validate on at least:
- Home
- Prayer
- one additional reusable card-heavy surface if already connected to the shared system

Do not force every page into bespoke redesign.
Only ensure the shared surface system responds correctly to the new theme selection.

STEP 6 — PROTECT EXISTING THEMES
Preserve:
- current default behavior
- the approved warm parchment glass
- any existing standard/default glass style
- dark mode / special manuscript theme compatibility

The new milky glass should be additive, not destructive.

STEP 7 — VISUAL TARGET TUNING
Tune the new theme until it reads clearly as:
- milky translucent frosted glass
- not parchment
- not flat beige
- actually see-through

The background should be perceptibly visible behind containers.

STEP 8 — VALIDATION
Run analyzer on changed files.
Validate:
- settings persist correctly
- no broken theme state
- no layout regressions
- no surface unreadability
- no broken nested cards/pills
- existing glass styles still work

DELIVERABLES
At the end provide:
1. audit summary
2. files changed
3. where the new glass theme is defined
4. where the new settings option is defined
5. what the user-facing setting label is
6. what existing themes/styles were preserved
7. analyzer results
8. any follow-up recommendation for applying or previewing this on additional pages

FINAL REQUIRED AUDIT
End with:
- what was added
- what was intentionally not changed
- how the new milky glass differs from the existing warm glass
- whether settings now fully support selecting it
