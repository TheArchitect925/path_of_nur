# Runtime Icon Unused PNG Cleanup Backlog

1. Completed 2026-04-13: Audited the remaining `assets/icons/*.png` files and confirmed eight of them had no live runtime references in `lib/`, `test/`, or `pubspec.yaml`.
2. Completed 2026-04-13: Tightened the runtime PNG allowlist so only the two launcher-icon source PNGs remain under `assets/icons/`.
3. Completed 2026-04-13: Archived and removed the eight unused runtime icon PNGs from the repo so they no longer inflate runtime asset policy counts or the built app footprint.

## Notes

- `assets/icons/app_iconv2.png` and `assets/icons/app_icondarkv2.png` remain intentionally because `flutter_launcher_icons` still points to them in `pubspec.yaml`.
- The deleted icon PNGs were not referenced by live runtime code, tests, or asset declarations beyond the temporary allowlist.
- The cleanup helper script is intentionally narrow and only targets this known dead icon set.

## Enhancement Options

1. Convert the two launcher source PNGs into a dedicated non-runtime tooling folder so `assets/icons/` can become fully runtime-clean.
2. Add a small CI assertion that flags unreferenced files under `assets/icons/` before they linger in the shipped asset bundle.
3. Re-run the final asset verification audit after the next content-fill pass so the remaining size report reflects both icon cleanup and missing-content resolution.
