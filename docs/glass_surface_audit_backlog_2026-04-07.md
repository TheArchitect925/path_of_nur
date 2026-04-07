# Glass Surface Audit Backlog

Date: 2026-04-07

Context: Shared layered glass audit to keep the base layer as transparent regular glass and move the text-bearing upper layer to the loading-screen `AppHeroGlassShell` recipe.

## Enhancement options

1. Add a dedicated shared `AppTwoLayerGlassSectionShell` so custom stacks do not keep re-encoding the same transparent-base plus hero-shell pattern.
2. Audit custom non-`PremiumCard` glass surfaces such as `AppSalahHeroCard` and any remaining `NoorGlassCard`-composed feature shells to decide whether they are intentionally single-layer or should join the shared two-layer pattern.
3. Add a widget-level regression test for `AppLayeredSectionGlassCard` so future surface refactors preserve the transparent base layer and the loading-screen-style upper shell.
4. Run visual QA on the highest-traffic `PremiumCard` surfaces with large text and dense content to confirm the new upper-shell treatment does not create cramped vertical spacing.
