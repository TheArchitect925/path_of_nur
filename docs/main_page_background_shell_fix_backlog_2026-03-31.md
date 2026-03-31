# Main Page Background Shell Fix Backlog

Date: 2026-03-31

## Audit summary

- Home is the known-good reference because it relies on the shell-owned scenic background and places only content inside its page tree.
- Learn, Qur'an hub, Growth home, Worship home, and Worship section pages were structurally different because they route through `AppPageScaffold`, which previously owned another full-page `GlobalBackground` inside the page subtree.
- That meant the scenic layer for those pages was attached to the inner page stack rather than owned exclusively by the outer shell.

## Completed in this pass

- Added an explicit `ownsBackground` flag to `AppPageScaffold`, `SectionHubScaffold`, and `LearnHubPageScaffold`.
- Standardized the audited main pages to use shell-owned background by setting `ownsBackground: false` on:
  - Learn root
  - Qur'an root hub
  - Growth home
  - Worship home
  - Worship section hub pages including Dhikr/Prayer/Fasting/Tracking/Reminders
- Left unrelated page content and card logic intact.

## Enhancement options

- Extend the same shell-owned background pattern to any other root-like shared pages if product wants all major hubs to match Home exactly.
- Add a small widget or golden test around the shared scaffold flags so future shell/page background ownership regressions are easier to catch.
