# Navigation System Stabilization Backlog

Date: 2026-03-23
Task: Phase V4 navigation system stabilization

## Completed

- Split the oversized Learn route registry into focused route-builder files under `lib/app/routes/learn/`.
- Kept `buildLearnRoutes()` as the composition entry point so existing `app_router.dart` wiring stayed stable.
- Preserved canonical route names and compatibility aliases for Learn, Qur'an, and Journey.
- Extracted shared router policy helpers for child-learning restrictions and Qur'an tab detection.
- Extracted onboarding and shared-device launch redirect helpers inside `app_router.dart` so guard behavior is easier to audit.
- Added a concise route ownership summary doc at `docs/navigation_system_stabilization_audit.md`.

## Enhancement Options

- Add explicit unit tests for redirect query forwarding on `learn/browse`, `learn/hub/quran/learning`, and `learn/section/prophets`.
- Decide whether `/learn/legacy` should later become a redirect, contained state, or archived compatibility surface once hidden catalog references are resolved.
- Continue trimming `learnLegacy` route targets from hidden Learn metadata and Learning Journey tool links once route ownership is finalized.
- Consider a future split of `core_support_routes.dart` if another routing pass expands settings/support/profile compatibility logic further.
