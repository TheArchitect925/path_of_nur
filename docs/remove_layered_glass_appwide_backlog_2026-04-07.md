# Remove Layered Glass Appwide Backlog

Date: 2026-04-07
Scope: Shared content-card glass wrappers and remaining direct layered shells

## Enhancement options

- Audit the remaining direct `NoorGlassCard` content surfaces that do not flow through `PremiumCard` or `AppLayeredSectionGlassCard` and decide which should also become single-shell `AppHeroGlassShell` surfaces.
- Run a focused visual QA pass on dense Qur'an and dua surfaces to confirm the single-shell treatment still feels readable with their existing content density.
- Consider renaming `AppLayeredSectionGlassCard` in a future cleanup pass so the shared widget name matches its new single-shell behavior.
- Review mirrored tvOS content surfaces in the next parity pass and align any old layered treatments that still diverge from the mobile direction.
