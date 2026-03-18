# Prompt Starters

Last updated: 2026-03-17

Use these as concise starting prompts for future Codex runs.

## Continue existing feature work

Continue the existing work on `<feature>` in this repository. Use the local Codex Context Engine memory first, especially `.codex_memory/session_start_guide.md`, `.codex_memory/feature_inventory.md`, `.codex_memory/route_map.md`, and `.codex_memory/continuation_backlog.md`. Extend current ownership instead of creating a parallel surface.

## Fix a bug without reviving legacy code

Fix the bug in `<area>` using the existing local engine memory first. Read `.codex_memory/session_start_guide.md`, `.codex_memory/do_not_rebuild.md`, `.codex_memory/route_map.md`, and the relevant inventory file before changing code. Do not recreate removed legacy Profile, Learn placeholder, Journey, or Worship patterns.

## Localize a feature

Localize `<feature/screen>` using the current localization system. Read `.codex_memory/session_start_guide.md`, `.codex_memory/settings_inventory.md` or the relevant feature inventory, `LOCALIZATION_INTEGRITY_BACKLOG.md`, and the relevant ARB files first. Do not hardcode user-facing strings. Report new keys and locale files updated.

## Clean up duplicated ownership

Clean up duplicated ownership in `<area>` using the local engine memory first. Read `.codex_memory/session_start_guide.md`, `.codex_memory/route_map.md`, `.codex_memory/feature_inventory.md`, `.codex_memory/learn_inventory.md` if relevant, and `.codex_memory/do_not_rebuild.md`. Prefer consolidation into canonical routes and current owners instead of adding another abstraction layer.

## Add tests for an existing surface

Add or strengthen tests for `<surface>` using the existing engine memory first. Read `.codex_memory/session_start_guide.md`, `.codex_memory/continuation_backlog.md`, and the relevant inventory file. Focus on the current live surface and current route ownership, not removed legacy versions.

## Prepare a launch-readiness pass

Prepare a launch-readiness pass for this repository using the local engine memory first. Read `.codex_memory/session_start_guide.md`, `.codex_memory/platform_inventory.md`, `.codex_memory/continuation_backlog.md`, `RELEASE_READINESS_CHECKLIST.md`, and `docs/release_target_readiness.md`. Keep claims aligned with validated iOS/iPadOS-first release posture.
