# Bottom Content Gap Above Nav Bar Fix Backlog

Date: 2026-03-31

## Audit summary

- `AppShellScaffold` uses `extendBody: true`, so page content must reserve bottom space manually.
- `AppPageScaffold` was already reserving bottom space for the nav bar.
- `SectionHubScaffold` was also appending an extra bottom spacer for shortcut docks, which caused shared main pages to end too early and show an empty background band above the nav bar.
- `AppPageScaffold` was also adding `MediaQuery.padding.bottom` on top of `SafeArea`, duplicating device bottom inset handling.

## Completed in this pass

- Changed `AppPageScaffold` bottom content inset to a single nav-bar-aware value: nav bar height + content spacing.
- Removed the extra shortcut-dock bottom spacer from `SectionHubScaffold` so shared pages no longer double-reserve bottom clearance.
- Left the dedicated floating-bottom spacer intact for pages that truly render an additional floating overlay.

## Enhancement options

- If any floating-bottom page still feels tight, add an explicit scaffold-level extra inset parameter for those pages only instead of reintroducing blanket spacers.
- Add a small layout regression test for shared hub pages under `extendBody: true` with short content.
