===== PHASE X PROMPT — HOME SCREEN CRASH STABILIZATION =====

PRIMARY OBJECTIVE === BUILDING A STABLE IPHONE HOME SCREEN

You are working in the existing Flutter codebase for Path of Nūr.

Task type:
Targeted production-safe crash stabilization.

Context:
The Home screen has a likely iPhone-only scroll crash associated with an earlier semantics assertion:
`!semantics.parentDataDirty`

Audit findings strongly suggest the highest-confidence root cause is the floating Home shortcut overlay architecture, not the lower content cards.

Highest-risk area:
- Home currently uses a page-local `Stack`
- main content is a `SingleChildScrollView`
- floating shortcuts are rendered above it with `Positioned`
- shortcut subtree mutates with `setState` during expand/collapse
- this combination is the strongest crash candidate

Files of interest:
- lib/features/home/presentation/home_page.dart
- lib/shared/widgets/main_page_shortcut_stack.dart
- lib/shared/widgets/app_shortcut_pill.dart
- lib/shared/widgets/app_layered_glass_pill_button.dart
- lib/features/celestial/presentation/widgets/celestial_cycle_card.dart

IMPORTANT RULES
1. Audit first before editing.
2. Fix the highest-confidence crash source first.
3. Do NOT redesign the app.
4. Preserve existing theme, localization, navigation, and card styling.
5. Keep the patch production-ready, minimal-risk, and reversible.
6. Do not delete records or unrelated logic.
7. Run analyzer on changed files and summarize results.
8. At the very end, provide one full audit summary.

IMPLEMENTATION PLAN

A. Remove the Home floating shortcut overlay as the first stabilization step
- In `home_page.dart`, remove the page-local floating shortcut overlay architecture from Home.
- Specifically remove the top-level `Stack` + `Positioned` usage for Home shortcuts.
- Do not leave dead layout wrappers behind.
- Keep Home content rendering normally without the floating pill cluster.

B. Reintroduce shortcuts in the safest temporary form
- If Home still needs shortcuts present, place them inline inside the scroll content near the top of the page.
- Use a non-overlay layout.
- They must not sit in a separate positioned interactive layer above the scroll view.
- Keep alignment visually clean and consistent with existing design.

C. Keep the shortcut implementation stable
- If `MainPageShortcutStack` is only useful for floating overlay behavior, do not force Home to keep using it.
- Prefer a simplified, inline, non-overlay presentation for Home.
- Preserve behavior for other pages unless Home shares the same risk pattern and there is an obvious safe common fix.

D. Harden Home layout structure
- After removing the floating overlay, assess whether `home_page.dart` can be made structurally safer with minimal risk.
- If feasible without a large rewrite, reduce unnecessary top-level nesting.
- Do NOT do a broad redesign in this pass.
- Only do the smallest structural cleanup that improves stability.

E. Fix side effects inside `CelestialCycleCard` build
- In `celestial_cycle_card.dart`, remove any state mutation or post-frame scheduling that occurs from inside `build` / inside the `when(data:)` render branch.
- Move the “mark opened” or equivalent side effect to a safer lifecycle/event seam.
- Preserve functional behavior.
- Do not trigger repeated side effects during rebuild.

F. Validation
Confirm:
1. Home no longer uses the page-local floating overlay stack for shortcuts.
2. Home renders and scrolls normally.
3. Inline shortcuts, if retained, still navigate correctly.
4. No state mutation remains inside `CelestialCycleCard` build path.
5. Analyzer passes on changed files.

DELIVERABLES
Provide:
1. files changed
2. exact root-cause judgment for this pass
3. what was removed/reworked on Home
4. whether shortcuts were temporarily inlined
5. what changed in `CelestialCycleCard`
6. analyzer results
7. final audit summary with any remaining secondary risks

IMPORTANT
Do NOT jump straight to a full Home sliver rewrite unless necessary for this pass.
This pass is about stabilizing the highest-confidence crash candidate first, then making the smallest safe supporting fixes.
