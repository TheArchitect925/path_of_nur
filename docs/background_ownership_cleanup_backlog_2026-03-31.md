# Background Ownership Cleanup Backlog

Date: 2026-03-31

## Completed in this pass

- Restored explicit background ownership: the shell owns the default wallpaper and shared pages no longer add a default scrim layer.
- Kept support for explicit page-owned backgrounds only when `AppPageScaffold` receives a custom asset path or overlay color.
- Preserved the earlier bottom-scroll spacing fix in `AppPageScaffold` because it is unrelated to background layering.

## Enhancement options

- Run a visual QA sweep across Home, Learn, Growth, Worship, and Qur'an root pages to confirm the single-background model looks consistent again.
- If any section still feels too visually busy after this cleanup, tune card opacity or section-specific surfaces instead of reintroducing a second page-wide background layer.
