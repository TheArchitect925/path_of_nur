===== PHASE X PROMPT — Global Glass + Theme Audit to Prepare Winning Variant Implementation =====

PRIMARY OBJECTIVE === AUDIT THE CURRENT GLOBAL APPEARANCE SYSTEM, ALL THEME OWNERS, AND ALL STANDALONE SURFACE OWNERS SO WE CAN IMPLEMENT THE WINNING GLASS STYLE CLEANLY

Repo: TheArchitect925/path_of_nur

Context:
We have already been testing temporary glass variants on the homepage. Before implementing the final winning variant across the app, I want a full architecture audit of the current theme/material/surface system so we know exactly:
- what is globally controlled
- what is settings-controlled
- what is shared/reusable
- what is page-local or standalone
- where the final winning glass style should actually be implemented
- what must NOT be touched when we do the final pass

Critical instruction:
Always check the repo first for what already exists before proposing new structure.
Do not invent a parallel theme system if the repo already has the right architecture.
Do not go haywire and delete or rewrite working systems for no reason.
Do not start implementing the final style in this phase.
This is an audit + mapping phase only.

What I need from this phase:
Produce a real code audit of the current appearance system and save the results in-repo so we can use it for the next implementation phase.

Audit goals:
1. Identify all GLOBAL appearance owners
2. Identify all SETTINGS-controlled appearance options
3. Identify all SHARED surface/material owners
4. Identify all BACKGROUND owners
5. Identify all NAVIGATION/BAR/BOTTOM-SHEET owners
6. Identify all HOMEPAGE-specific or page-specific visual overrides
7. Identify all LEARNING-HUB-style island owners
8. Identify all PREVIEW/DEMO/TEMPORARY style code
9. Identify where `liquid_glass_renderer` is installed and whether it is actually used
10. Identify the exact best insertion point for the final winning variant
11. Identify risks, duplication, legacy paths, and dead or half-retired theme logic

Specific things to inspect:
- theme root / app bootstrap
- profile/settings-based appearance state
- theme mode enums and legacy modes
- surface resolvers
- premium/shared cards
- shared scaffolds
- app background system
- homepage shared cards
- learning hub category islands
- settings appearance page and preview tiles
- navigation bar surfaces
- chip/pill/panel variants
- any standalone hardcoded color systems on important pages
- any temporary glass preview implementation added recently
- any wallpaper/background tint ownership
- any route/page-specific background ownership
- any dark theme / noor glass / manuscript-specific behavior

Deliverables I want created in the repo:
1. A main audit document:
   `docs/theme_glass_audit_2026-04-01.md`

2. A concise implementation prep backlog:
   `docs/theme_glass_implementation_backlog_2026-04-01.md`

3. The source prompt archived here:
   `codex prompts/theme/2026-04-01-global-glass-theme-audit.md`

What the audit document must contain:

SECTION 1 — Executive summary
- overall state of the theme/material architecture
- whether the app already has a valid central appearance system
- whether we should extend the current system or replace parts of it
- biggest strengths
- biggest weaknesses
- what is already good enough for the final implementation path

SECTION 2 — Global appearance ownership map
List the core files/classes/functions/providers that globally control appearance.
For each:
- file path
- symbol/class/provider/function
- what it controls
- why it matters
- whether it should be modified in final implementation

SECTION 3 — Settings ownership map
Document all settings that affect appearance.
Include:
- theme mode selection
- glass transparency controls
- colored glass toggle
- background toggle
- high contrast text
- reduce motion
- any other settings that influence visuals
For each:
- where state lives
- where UI lives
- how it flows into runtime theme resolution

SECTION 4 — Shared surface/material ownership map
Document shared reusable visual owners such as:
- premium card
- app surface resolver
- island/card/pill/panel/featureTile/navigationBar variants
- shared text/content color resolvers
For each:
- what it owns
- what is centralized
- what remains page-local
- whether it is the correct place for the winning glass variant logic

SECTION 5 — Background ownership map
Document:
- app background theme
- page scaffolds
- wallpaper/background tint behavior
- page-specific background ownership vs shared ownership
For each:
- where it is defined
- what modes it reacts to
- what would need to change for the winning variant

SECTION 6 — Island / category card ownership
Map the Learning Hub / Section Hub category island styling and how it is reused.
Need to know:
- where category islands are implemented
- whether their shape/material comes from shared surface logic
- where palette is still local
- how easy it is to standardize them later

SECTION 7 — Standalone or page-local visual owners
Find pages that still locally own important appearance behavior instead of using the shared global system.
Examples:
- custom preview tiles
- custom gradients
- hardcoded card decoration
- page-specific visual bands
- one-off islands or panels
For each:
- classify as acceptable local customization vs problematic drift
- recommend keep / refactor / leave alone

SECTION 8 — Temporary / demo / preview code
Identify any temporary homepage glass preview or comparison code currently in the repo.
For each:
- file path
- whether it is safe to remove later
- whether it is interfering with future implementation
- whether it should be removed before the winning variant phase

SECTION 9 — Liquid glass package audit
Audit `liquid_glass_renderer` specifically:
- where installed
- where imported
- where used
- if unused, say clearly unused
- whether it should be integrated at the shared surface layer or avoided
- whether current in-house surface system is already sufficient

SECTION 10 — Legacy / duplication / dead-path audit
Find:
- legacy theme modes
- remapped theme modes
- duplicate appearance logic
- preview-only style builders
- dead or mostly dead pathways
- anything that can create confusion in the final implementation phase
Classify each as:
- leave
- clean up first
- remove later
- merge into shared system

SECTION 11 — Final implementation recommendation
This is the most important section.
Based on the audit, recommend the best implementation strategy for the final winning glass style.

I want:
- exact files that SHOULD be modified
- exact files that MAY be modified if needed
- exact files that should preferably NOT be touched
- the correct order of implementation
- safest rollout strategy
- what to implement centrally vs locally
- whether homepage should be done first or entire shared surface system first
- how to avoid regressions

SECTION 12 — Final risk list
List concrete risks such as:
- breaking settings behavior
- over-styling page-local content
- conflicting background systems
- mismatch between islands and premium cards
- nav bar inconsistency
- demo code interfering with real rollout
- hidden legacy modes

Backlog document requirements:
Create a concise actionable backlog grouped like:
- Phase A — cleanup before final style
- Phase B — core shared surface implementation
- Phase C — page-level harmonization
- Phase D — QA / regression checks
Each task should include:
- title
- reason
- priority (high/med/low)
- files likely involved

Important constraints:
- Do NOT perform the final implementation in this phase
- Do NOT refactor broadly unless tiny cleanup is absolutely necessary for the audit deliverable itself
- Do NOT remove working code just because it looks old
- Do NOT make speculative statements without grounding them in code
- Prefer file-by-file evidence
- Be honest about uncertainty where needed

Output summary I want back after the audit:
At the end, provide a concise summary with:
- files inspected
- strongest global owners found
- biggest standalone owners found
- whether `liquid_glass_renderer` is actually used
- top recommended insertion point for the final winning variant
- what should be cleaned up before implementation
- what should stay as-is

Very important:
At the very end, do one final audit pass and provide one complete summary so we can work on fixing and implementing from that.
Do not stop at a shallow scan.
Do a proper repo audit and produce the saved docs.
