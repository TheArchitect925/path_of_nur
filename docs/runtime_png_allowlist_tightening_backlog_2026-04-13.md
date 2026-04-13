# Runtime PNG Allowlist Tightening Backlog

1. Completed 2026-04-13: Removed the broad runtime PNG allowlist prefixes for `assets/images/backgrounds/`, `assets/images/prophets/`, and `assets/images/wudu/` now that those high-impact folders have sibling WebPs and migrated live runtime references.
2. Completed 2026-04-13: Narrowed the runtime allowlist to the true explicit high-impact holdout `assets/images/backgrounds/Loading.png` while preserving the existing app-icon and kids dua story PNG exceptions.
3. Completed 2026-04-13: Upgraded the runtime PNG policy check so migrated legacy PNGs can remain on disk temporarily without allowlisting only when a sibling `.webp` exists and no live runtime source still references the `.png`.
4. Completed 2026-04-13: Removed the redundant explicit `assets/images/backgrounds/bg_v1.png` asset declaration from `pubspec.yaml`, allowing the tightened policy to pass without re-broadening exemptions.

## Notes

- Native/platform PNG handling remains unchanged; iOS, Android, macOS, web, and tvOS packaging assets are still approved through the native path logic rather than the runtime allowlist.
- The tightened policy now distinguishes between explicit exceptions and migrated legacy PNGs, which makes CI reflect actual migration progress instead of broad folder shielding.
- `assets/images/backgrounds/Loading.png` remains intentionally on PNG pending a separate visual review.

## Validation

- `bash tooling/scripts/check_runtime_png_policy.sh` passes after tightening with `approved_exceptions=27`, `approved_migrated_legacy=53`, and `violations=0`.
- A temporary probe PNG added under `assets/images/wudu/` without a sibling `.webp` correctly triggered a policy violation, confirming the narrower guardrail is active.
- `flutter pub get` was run because `pubspec.yaml` changed, but it is currently blocked by an existing localization issue in `lib/l10n/app_bn.generated.arb` where the locale cannot be determined.

## Enhancement Options

- Phase 9: rerun the full WebP migration audit now that the tightened policy reflects real migrated usage.
- Phase 10: remove verified legacy PNGs from the migrated folders only after the post-tightening audit stays green.
- Phase 11: repeat the same convert -> reference migrate -> tighten policy pattern for the next heaviest runtime PNG folders outside this high-impact wave.
