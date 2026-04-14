# Launcher Icon Source Relocation Backlog

1. Completed 2026-04-13: Moved the launcher-source PNGs out of `assets/icons/` into a dedicated tooling-owned source folder so they no longer count as runtime PNG assets.
2. Completed 2026-04-13: Updated `flutter_launcher_icons` in `pubspec.yaml` to point at the tooling-owned icon source files.
3. Completed 2026-04-13: Removed the launcher-source PNG exceptions from the runtime PNG allowlist and revalidated the asset policy.

## Notes

- `tooling/app_icon_sources/` is now the canonical home for the PNGs used by `flutter_launcher_icons`.
- Keeping launcher-generator source files outside `assets/` makes the runtime PNG policy more truthful and keeps `assets/icons/` focused on actual shipped runtime imagery.
- The generated native app icons remain under platform-native paths and are still intentionally preserved as PNG where Apple, Android, and web packaging require them.

## Enhancement Options

1. Add a short note to the asset policy doc explaining that launcher icon source PNGs belong under `tooling/app_icon_sources/`, not `assets/`.
2. Add a tiny CI assertion that fails if new PNGs are reintroduced under `assets/icons/` without a runtime justification.
3. Run a signed archive after the next icon refresh so App Store-targeted icon assets are validated again alongside the current runtime asset cleanup.
