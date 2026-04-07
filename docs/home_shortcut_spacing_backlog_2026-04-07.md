# Home Shortcut Spacing Backlog

Date: 2026-04-07
Area: Home / shortcut pill spacing

## Finding

- Home was positioning its floating shortcut pill inside a page-level `SafeArea`, while the shared section pages position their floating pills through `AppPageScaffold`.
- That made Home effectively sit higher above the bottom shell on devices with a bottom inset.

## Enhancement options

- Consider moving Home onto the same shared scaffold positioning path as the other top-level pages if we want to remove this spacing exception entirely.
- Run a small-device visual QA pass with the mini player visible to confirm the Home shortcut, mini player, and bottom nav never crowd each other.
