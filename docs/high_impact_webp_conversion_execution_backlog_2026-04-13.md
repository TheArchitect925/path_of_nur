# High-Impact WebP Conversion Execution Backlog

1. Run Phase 7 next to migrate only verified sibling runtime asset references that now have on-disk `.webp` matches.
2. Resolve whether `assets/images/backgrounds/Loading.png` should eventually stay PNG, move to lossless WebP, or remain a manual branded exception after visual QA.
3. Decide whether the old Adam card WebP should be kept as a separate asset or normalized once runtime references move to sibling WebP files.
4. Tighten the runtime PNG allowlist immediately after reference migration so CI starts protecting the newly converted folders.
5. Re-run the full migration audit after Phase 7 to capture real repo-wide storage savings and any remaining runtime PNG exceptions.
6. Plan a later verified cleanup pass to remove legacy PNGs only after all references are migrated and visual QA is complete.
