# Shared Page Content Scrim Fix Backlog

Date: 2026-03-31

## Completed in this pass

- Added a soft shared content scrim in `AppPageScaffold` so shell wallpaper sits further back behind shared Learn/Worship/Qur'an pages.
- Kept Home unchanged because it does not use `AppPageScaffold`.
- Preserved explicit page-level background overrides while restoring calmer shared page readability.

## Enhancement options

- Run a quick visual QA sweep across Learn, Growth, Worship, and Qur'an hub pages to tune the scrim alpha if needed.
- If different sections need slightly different atmosphere, use documented shared overlay values per section instead of per-page ad hoc styling.
