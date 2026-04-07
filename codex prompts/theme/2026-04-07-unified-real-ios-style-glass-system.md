review the noor glass and other settings and do this ===== PHASE X PROMPT — UNIFIED REAL IOS-STYLE GLASS SYSTEM =====

PRIMARY OBJECTIVE === REDESIGN THE CURRENT GLASS SYSTEM INTO ONE UNIFIED, PRODUCTION-READY, REAL IOS-STYLE GLASS RENDERER AND ELIMINATE THE VISIBLE OVERLAY / STRIPE / SEAM ARTIFACTS PERMANENTLY

You are working in the existing Flutter codebase for Path of Nūr.

CONTEXT
We are seeing visible glass artifacts on the UI, especially in the Salah Timings container and similar glass-heavy surfaces:
- vertical light bands / stripe overlays
- uneven blur/tint seams
- layered transparency artifacts
- inconsistent inner-glass vs outer-glass blending
- “weird overlay” effects that break the intended calm premium look

The current system appears to be suffering from one or more of these:
- stacked glass layers with overlapping transparency
- nested gradients inside glass cards
- inconsistent alpha values across parent/child glass surfaces
- clipping issues around blur/glass rendering
- duplicate tinting / duplicate reflective overlays
- mixed implementations across `NoorGlassCard`, `NoorLiquidGlass`, `PremiumCard`, and related wrappers

Product goal:
Create one unified, real iOS-style glass rendering system that:
- looks premium, soft, milky, and believable
- avoids visible stripe artifacts
- avoids double-glass layering issues
- is reusable across the app
- preserves the existing Path of Nūr visual identity
- is production-ready and maintainable

Important style direction:
- Keep the current app color palette and spiritual premium direction
- Do NOT redesign the entire app visually
- Do NOT make the glass look like generic neon glassmorphism
- Aim for:
  - soft translucent milky glass
  - subtle warmth
  - clean highlight structure
  - consistent edge treatment
  - believable inner light
  - no hard seams or odd reflection bars

References to align against:
- existing Path of Nūr UI direction
- current homepage / prayer / khusu / design references already in repo context
- attached screenshot of the Salah Timings artifact
- use the current app’s tone, not a totally new theme

MANDATORY EXECUTION RULES
1. Audit first before editing.
2. Identify the actual artifact sources in the current glass stack.
3. Do not patch just one screen.
4. Build one shared glass system and migrate the affected surfaces onto it.
5. Eliminate the artifact at the system level, not with per-screen hacks.
6. Preserve routing, localization, and business logic.
7. Keep the implementation production-ready.
8. Run analyzer on changed files and summarize results.
9. At the very end, include one full audit summary.

AUDIT TASKS

A. Audit the current glass system
Inspect all relevant shared surface / glass components, including at minimum:
- `NoorGlassCard`
- `NoorLiquidGlass`
- `PremiumCard`
- `AppLayeredGlassPill`
- `AppLayeredGlassPillButton`
- any shared surface theme / surface treatment code
- Salah Timings card and inner prayer timing pills
- any other shared wrappers participating in the artifact

Identify:
- which widget owns real blur / pseudo-blur / tint / overlay / border / shadow
- where glass is being double-layered
- where gradients are fighting each other
- where alpha values are inconsistent
- where clipping is missing or wrong
- whether some glass surfaces should not themselves contain child glass surfaces of the same treatment

B. Design one unified glass renderer
Create a single shared glass renderer / foundation that can support the app’s main glass surfaces.

Requirements:
- one canonical glass implementation for major surfaces
- supports:
  - background tint
  - soft inner light / highlight
  - consistent border
  - subtle shadow
  - optional depth variants (card / panel / pill / island)
- must avoid artifact-prone stacked overlays
- must clip correctly
- must not create directional banding or seam artifacts
- if blur is used, it must be clipped and applied safely
- if pseudo-glass is used instead of blur in some places, it must still share the same visual system and avoid layered inconsistencies

C. Normalize the glass visual language
Unify:
- surface alpha behavior
- border alpha behavior
- highlight treatment
- shadow treatment
- tint logic
- radius handling
- inner surface treatment

Avoid:
- multiple competing gradients within the same glass surface
- hard vertical reflective bars
- inconsistent warm/cool tint mixing inside one card
- child cards using the exact same heavy glass treatment as their parent if that causes muddy layering

D. Introduce clear surface levels
Create a clean glass hierarchy such as:
- primary glass card
- secondary inset/panel
- pill / chip glass
- optional fake glass fallback mode if needed

Each level should have:
- a defined opacity/tint/border behavior
- predictable visuals
- no artifact-prone overlap

E. Migrate the affected surfaces
At minimum, migrate and harden:
1. Salah Timings main container
2. inner prayer timing pills/cards
3. any shared glass wrappers those use
4. any other immediately affected homepage / learn / worship surfaces that still use the old artifact-prone path

The Salah Timings section should end up:
- visually clean
- premium
- soft
- consistent
- free of the stripe / overlay artifact

F. Clipping / rendering safety
Where blur/backdrop or other translucent effects are used:
- ensure proper clipping
- ensure border radius is honored
- avoid paint outside bounds
- avoid nested blur artifacts
- avoid parent + child heavy glass blur stacking unless explicitly safe

G. Keep performance reasonable
- avoid extremely expensive unnecessary blur stacks
- prefer one good shared effect over many layered ones
- keep scrolling surfaces stable

H. Cleanup old glass logic
- remove obsolete layering logic that causes artifacts
- remove duplicate gradient overlays where they are no longer needed
- keep naming clean and ownership clear

I. Do not do per-screen hacks
Do NOT just hide the stripe on one page.
This task must leave the app with a cleaner unified glass system.

VALIDATION REQUIREMENTS

After implementation, confirm:
1. the Salah Timings artifact is removed
2. the main glass cards no longer show visible stripe / seam overlays
3. child inner cards still look premium and distinct
4. the glass hierarchy is visually consistent across affected screens
5. clipping and rendering are stable
6. analyzer passes on changed files

OUTPUT FORMAT

## 1. Glass system audit findings
- root causes of the artifact
- which old components caused it

## 2. Files changed
- list of files

## 3. Unified glass system design
- how the new glass renderer works
- what surface levels now exist

## 4. What was migrated
- Salah Timings container
- inner prayer pills
- any other affected shared surfaces

## 5. Validation
- analyzer results
- remaining warnings if any

## 6. Residual follow-up
- any surfaces still worth migrating later

## 7. Final audit summary
- one concise production-ready summary

IMPORTANT RULES
- Audit first
- System-level fix, not one-off patch
- Keep Path of Nūr’s existing design language
- Production-ready only
- No placeholders
- At the very end provide one full audit summary

END GOAL
This pass should leave the app with a unified real iOS-style glass system that removes the visible overlay/seam artifacts permanently and makes the Salah Timings container and related glass surfaces look clean, premium, and consistent.
