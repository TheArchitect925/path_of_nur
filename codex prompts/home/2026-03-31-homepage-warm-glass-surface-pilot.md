# PHASE X PROMPT — HOMEPAGE WARM GLASS SURFACE PILOT

PRIMARY OBJECTIVE === BUILDING HOMEPAGE WARM GLASS SURFACE PILOT

You are working in the existing Flutter codebase for Path of Nūr.

Goal:
Update the homepage container surfaces to match the earlier warm elegant glass style from the first app version, but ONLY on the homepage for now. Do not globalize the style yet. This is a controlled visual pilot. After the homepage looks correct, we will later promote it into a reusable global surface system.

CRITICAL RULES:
- Audit first before changing anything.
- Do not touch unrelated pages.
- Do not delete or rewrite existing shared theme systems unless absolutely necessary.
- Do not break layout, spacing, navigation, accessibility, or text readability.
- Do not mass-apply this style globally yet.
- Preserve all existing homepage functionality.
- Production-ready implementation only. No placeholders. No fake one-off hacks.
- If there is an existing shared surface/card component, extend safely without breaking existing consumers.
- At the end, run analyzer on changed files and provide a concise audit summary.

VISUAL TARGET:
Match the old Path of Nūr surface feeling shown in the reference:
- warm ivory / parchment translucent cards
- soft creamy glass look
- subtle blur/frosting
- soft muted gold-beige border
- gentle warm shadow
- reduced cold white / blue-grey tint
- elegant rounded corners
- readable dark brown text contrast
- soft premium spiritual tone

IMPORTANT:
The HOMEPAGE should become the pilot page for this warmer glass language.
Do NOT apply this as a global app-wide property yet.
Do NOT modify bottom nav styling unless required by homepage surface alignment.
Do NOT modify homepage information architecture unless a tiny adjustment is required for visual harmony.

TASKS

1. AUDIT CURRENT HOMEPAGE SURFACE OWNERSHIP
- Identify all homepage container/card/surface widgets.
- Identify whether the homepage currently uses:
  - shared card widgets
  - theme extension values
  - custom decorated containers
  - glass helpers
  - reusable panel widgets
- Identify where the current colder/lighter surface styling is coming from.

2. DEFINE A HOMEPAGE-ONLY WARM GLASS SURFACE STYLE
Implement a homepage-only visual style that includes:
- warm translucent cream/parchment fill
- subtle backdrop blur if already supported safely
- muted gold-beige border
- soft warm shadow
- slight inner highlight or sheen if appropriate
- consistent radius aligned with current Path of Nūr design
- text readability preserved over all homepage backgrounds

This may be done through one of these safe patterns:
- a new dedicated homepage card wrapper
- a new optional style variant added to an existing shared surface widget
- a homepage-local surface token set

Preferred approach:
Create a reusable but not-yet-globalized style variant such as:
- warmGlass
- legacyWarmGlass
- homepageWarmGlass

3. APPLY ONLY TO HOMEPAGE CONTAINERS
Update the homepage containers/cards/panels to use the new warm glass style.
This includes the main homepage surfaces that visually read as cards/panels.
Do not apply to other tabs/pages.

4. PRESERVE FUNCTIONALITY
Ensure the homepage still works fully:
- no broken tap targets
- no clipped content
- no reduced legibility
- no layout jumps
- no overflow
- no broken hero sections or scroll behavior

5. KEEP DESIGN REFINED
The end result should feel:
- calmer
- warmer
- more premium
- spiritually elegant
- less sterile than the current surface system

Avoid:
- heavy orange/yellow tint
- muddy brown surfaces
- excessive blur
- glossy or flashy iOS-style shine
- dark unreadable overlays
- thick borders

6. PREP FOR FUTURE GLOBALIZATION
Structure the implementation so this homepage pilot can later become a global shared surface option without rework.
However, do NOT actually switch the rest of the app yet.

7. VALIDATION
Confirm:
- homepage surfaces now visually match the warm glass direction
- readability is preserved
- spacing and layout remain stable
- only homepage surfaces changed
- no unrelated page regressions introduced
- analyzer passes on changed files

DELIVERABLES
After implementation, provide:
1. files changed
2. where the old homepage surface styling was owned
3. how the new warm glass styling is defined
4. what homepage components were switched
5. whether the implementation is ready to be promoted into a global shared surface later
6. analyzer results

FINAL REQUIRED STEP
Run a brief audit at the end and clearly state:
- what was changed
- what was intentionally NOT changed
- what the safest next step is for promoting this into a global property after homepage approval
