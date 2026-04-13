# High-Impact WebP Reference Migration Backlog

1. Tighten the runtime PNG allowlist for `assets/images/backgrounds`, `assets/images/wudu`, and `assets/images/prophets` now that the live runtime owners have been migrated to sibling WebPs.
2. Re-run the full WebP migration audit so the repo-wide report reflects actual runtime usage instead of just on-disk conversion readiness.
3. Decide whether the explicit `pubspec.yaml` entry for `assets/images/backgrounds/bg_v1.png` should later be removed or updated, since `assets/images/` is already directory-declared and runtime ownership has moved to `bg_v1.webp`.
4. Decide whether the older `assets/images/prophets/1_prophet_adam_card.webp` should remain as a separate asset or be normalized in a later cleanup pass now that `1. AdamAS.webp` exists and is the active runtime path.
5. After the policy and audit passes are updated, run a verified legacy cleanup pass to remove only PNGs whose runtime references have been fully migrated and QA'd.
