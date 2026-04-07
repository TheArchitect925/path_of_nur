# Noor Glass Next Salah Standard Backlog

## Follow-Ups

- Audit custom panels that still use `AppSurfaceTheme.resolve(...)` directly for non-pill Noor surfaces and decide whether they should be promoted onto `AppHeroGlassShell` too.
- Revisit `AppSalahHeroCard` sub-panels separately if we want the location pill, primary panel, and stat cards to become reusable shared helpers instead of one-off local styling.
- Run real-device visual QA on dense cards and list-heavy pages to confirm the broader hero-shell default does not feel too padded on smaller phones.
