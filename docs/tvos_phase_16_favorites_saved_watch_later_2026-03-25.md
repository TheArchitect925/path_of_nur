# tvOS Phase 16: Favorites, Playlists, Saved Items, and Watch-Later Flow

Date: 2026-03-25

## Scope shipped

- Added a new native tvOS `Saved` route under Qur'an ownership.
- Kept the route remote-first and read-first instead of porting mobile-style save management.
- Promoted `/quran/bookmarks` into the shared tvOS parity, release-policy, and content-registry layers.

## Native tvOS outcome

- Sidebar now includes a `Saved` destination.
- The route presents:
  - saved-lane selection
  - resume-ready saved items
  - watch-later and playlist continuity guidance
- Focus restore now remembers the primary lane, saved-item shelf, and support shelf independently for the route.

## Shared tvOS foundation outcome

- `TVOSSurfaceId.favorites` is now an active mirrored adaptation surface.
- `/quran/bookmarks` is now enabled for the current `testflight` stage.
- New Phase 16 section/module keys:
  - `favorites.primaryPaths`
  - `favorites.savedItems`
  - `favorites.watchLater`

## Product direction captured

- tvOS uses `Saved` as the visible route label, while the shared canonical parity route remains `/quran/bookmarks`.
- This is an intentional tvOS adaptation for readability and family-room clarity, not a separate product fork.
- Editing, deep sorting, and large playlist management remain deferred to iPhone/iPad.

## Verification

- Passed: `flutter test test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_content_parity_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- Passed: `flutter analyze lib/features/tvos test/features/tvos/tvos_foundation_registry_test.dart test/features/tvos/tvos_feature_flags_test.dart test/features/tvos/tvos_content_registry_test.dart`
- Passed: `xcodebuild -project ios/Runner.xcodeproj -target PathOfNurTV -configuration Release -sdk appletvos -destination generic/platform=tvOS build CODE_SIGNING_ALLOWED=NO CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase16_modulecache`

## Follow-up themes

- Replace seeded saved items with shared bookmark/reflection/listening continuity payloads when the native bridge exists.
- Add household-aware saved-state continuity when the profiles/session phase lands.
- Keep future save actions remote-light; avoid reintroducing dense library management on tvOS.
