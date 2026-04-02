# Global Frosted Glass Rollout Backlog — 2026-04-01

## Follow-up Enhancements

- Audit `SalahPage` for migration onto shared frosted/sanctuary surfaces where it still owns page-local card chrome.
- Add focused widget tests for `AppSurfaceTheme.resolve(...)` across `standard`, `homepageWarmGlass`, and `denseSanctuary`.
- Add one small visual regression check for `PremiumCard` under:
  - default mode
  - Noor Glass
  - Midnight Manuscript
  - disabled transparency
- Decide whether the Qur'an summary palette should partially consume the new sanctuary edge-light tokens instead of continuing with its own separate glow logic.
- Review whether `QuranAyahActionSection` should remain on frosted default long-term or gain a lighter devotional variant later.
- Remove the temporary homepage comparison section once the final chosen material direction no longer needs side-by-side review.

## Do Not Break

- existing profile appearance settings flow
- shared `PremiumCard` consumer role
- `NoorLiquidGlass` wrapper boundary
- current Qur'an reader and dua feature routing
