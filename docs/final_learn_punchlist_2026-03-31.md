# Final Learn Punchlist

Date: 2026-03-31

## Critical issues

- None found in this final audit pass.

## Medium issues

- Character Path still needs a targeted hardening pass.
  - Owner: Learn curriculum
  - Risk: medium
  - Dependency: preserve existing path id and route ownership
- Salah Path still opens with a broader hub-like first step than the best hardened paths.
  - Owner: Learn curriculum / Worship
  - Risk: medium
  - Dependency: keep `/learn/salah` canonical and preserve guided path progress
- Manual QA is still needed for child profile + large text + locale fallback combinations on `/learn`.
  - Owner: QA / product review
  - Risk: medium
  - Dependency: current build

## Low polish issues

- Explore still contains deeper legacy-backed content debt even though top-level discovery is much cleaner.
- Personalization secondary suggestions should be watched for repetition fatigue.
- Some completion flows are stronger than others; Character is the thinnest of the main guided lanes.

## Recommended order

1. Character Path hardening
2. Salah Path first-step polish
3. Manual QA sweep across child/adult profile contexts
4. Telemetry review for alias usage and path drop-off after launch candidate builds

## Do-not-break notes

- Do not change `/quran/*` ownership.
- Do not break kids route-family ownership.
- Do not rename guided path ids casually.
- Do not remove compatibility aliases before telemetry review.
- Do not create a second search or recommendation system.

## Pre-launch blockers vs post-launch candidates

### Pre-launch blockers

- none confirmed in this audit

### Better before launch if time allows

- Character Path hardening
- Salah Path first-step polish
- manual QA sweep

### Safe post-launch candidates

- telemetry-led legacy route retirement review
- deeper related-content graph tuning
- recommendation fine-tuning
- additional completion-copy refinement
