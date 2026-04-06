# Layered Glass Card Rollout Backlog

Date: 2026-04-05

## Completed in this pass
- Extracted a reusable layered card owner based on the Home salah timings recipe.
- Applied the recipe through `PremiumCard` for broad non-sacred card adoption.
- Updated Home local `_HomeNoorCardShell` to use the shared layered card owner.
- Preserved dense sanctuary behavior for sacred/devotional `PremiumCard` consumers.

## Enhancement options
- Audit bespoke `NoorGlassCard` and manual `BoxDecoration` card owners that still sit outside `PremiumCard` and decide which should migrate to the shared layered shell.
- Add a dedicated sacred layered shell variant only if a future non-sanctuary/sanctuary split needs stronger structural reuse without flattening the devotional distinction.
- Tune `AppLayeredSectionGlassCard` radius behavior by variant (`card`, `panel`, `island`) if some screens look too rounded after broad rollout.
- QA high-density pages like Onboarding, Accounts Sync, Creation Explorer, and Celestial Explorer for any cards that now feel too heavy with the layered treatment.
- Decide whether `includeShadow` should control the outer shell intensity as well, not just the sanctuary fallback path.
