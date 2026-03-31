# Dua Hub Bottom Nav Scroll Fix Backlog

Date: 2026-03-31

## Completed in this pass

- Added shared bottom scroll clearance in `AppPageScaffold` so section hub pages can scroll fully above the persistent bottom navigator.
- Confirmed the Dua hub issue was caused by shared scaffold inset behavior rather than Dua-specific tag or chip layout logic.

## Enhancement options

- Validate other `AppPageScaffold` surfaces on smaller iPhones to confirm the new shared bottom inset feels balanced and not overly spacious.
- Consider centralizing shell overlay height constants so page scaffolds and the bottom navigation reserve the same documented spacing value.
- Add a lightweight visual regression checklist for bottom-of-page chip lists and sticky/floating controls on hub pages.
