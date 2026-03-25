# tvOS Phase 14

Date: 2026-03-25

Phase:
- Phase 14 — quizzes, games, and remote-friendly interactivity

Outcome:
- Added a new sidebar-enabled tvOS Games route at `/learn/games`.
- Kept Games under Learn ownership instead of creating a separate tvOS-only product branch.
- Shipped a remote-first interaction model built around large game-path cards, curated challenge cards, and single-choice answer flow with immediate feedback.

Native tvOS changes:
- Added `Games` shell routing, focus-section ownership, and navigation integration.
- Added `TVGamesViewModel` with seeded game paths, challenge state, and per-challenge answer selection.
- Added `TVGamesScreen.swift`, `TVGamesChallengeCard.swift`, and `TVGamesSupportCard.swift`.
- Added native localization strings for the new route, challenge flow, and support guidance.

Shared tvOS registry/policy changes:
- Promoted `TVOSSurfaceId.games` from later-phase staged status to an active mirrored adaptation surface.
- Enabled `/learn/games` in the shared release policy and sidebar surface list.
- Added stable module keys:
  - `games.primaryPaths`
  - `games.challenges`
  - `games.familyGuidance`
- Extended the shared tvOS content registry and onboarded-module providers for the new route.

Product direction:
- This is not a blind mobile port.
- The route favors:
  - single-remote group play
  - recognition-first challenge types
  - short sessions
  - lightweight explanation after each answer
- It intentionally avoids:
  - drag-and-drop interaction
  - typing-heavy quizzes
  - noisy reward loops
  - arcade-style speed pressure

Verification:
- Passed:
  - `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
  - `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- Native build note:
  - The repo-side `xcodebuild` tvOS validation in this sandbox is currently blocked by Xcode module-session write failure:
    - `error: unable to write module session file at 'org.llvm.clang/ModuleCache.noindex/Session.modulevalidation': unknown error`
  - After overriding module cache paths, the build progressed past the earlier environment-level derived-data failure, but the sandbox still prevented a clean unsigned compile verdict.

Search/indexing impact:
- No search UI was added in this phase.
- The route was structured under stable shared keys and reusable challenge metadata so shared discovery/indexing can attach later without inventing a separate tvOS-only search system.

Performance notes:
- Interaction state stays local to the tvOS Games view model and avoids unnecessary route-wide rebuild complexity.
- The route reuses existing tvOS card/layout primitives instead of introducing another visual system.

Follow-up:
- QA should next validate focus restore, option selection visibility, and left-edge navigation escape on Apple TV hardware.
