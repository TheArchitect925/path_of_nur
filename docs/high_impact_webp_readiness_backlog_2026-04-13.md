# High-Impact WebP Readiness Backlog

1. Install `cwebp` on the local machine so the planned conversion waves can run without weakening the current no-delete safety posture.
2. Execute Wave 1 first for `assets/images/backgrounds`, but keep `Loading.png` isolated for a manual visual spot-check because the image contains branded text.
3. Execute Wave 2 as a pure lossless batch for `assets/images/wudu` so instructional text and sharp cartoon edges stay crisp.
4. Execute Wave 3 for `assets/images/prophets` only after confirming how the existing `1_prophet_adam_card.webp` should coexist with or replace `1. AdamAS.png`.
5. After real `.webp` files land, rerun the Phase 2 reference migration narrowly against verified sibling pairs only.
6. After reference migration, shrink the runtime PNG allowlist folder by folder so CI starts enforcing the intended policy instead of grandfathering the full runtime asset set.
7. Consider adding an optional visual-review checklist for any branded or text-bearing art converted with non-lossless settings, starting with `Loading.png`.
