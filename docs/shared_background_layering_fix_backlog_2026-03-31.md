# Shared Background Layering Fix Backlog

Date: 2026-03-31

## Completed in this pass

- Fixed shared page background layering so `AppPageScaffold` no longer draws a second default wallpaper on top of the shell wallpaper.
- Kept support for explicit page-level background overrides by only rendering `GlobalBackground` when a custom asset path or overlay color is supplied.
- Verified the shared scaffold and shell compile cleanly after the fix.

## Enhancement options

- Run a visual QA sweep across the main tab roots and a few deep `AppPageScaffold` detail pages to confirm surface opacity now matches the intended single-background look.
- Consider documenting background ownership in the shared scaffold layer so future shell/page changes do not accidentally reintroduce duplicate wallpaper rendering.
- If any page truly needs a stronger local atmospheric treatment, prefer explicit `backgroundOverlayColor` overrides instead of a second default wallpaper pass.
