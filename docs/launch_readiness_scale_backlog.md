# Launch Readiness + Scale Backlog

## Next Enhancements

- Add a signed-build smoke test pass for iOS/iPadOS covering first launch, profile selection, reminder permissions, offline daily games, Qur'an playback, and backup/export.
- Add a lightweight startup diagnostics surface in debug mode so recent crash and bootstrap-fallback events can be reviewed without digging through storage.
- Add explicit storage-size auditing for seeded content, Qur'an assets, and audio manifests so future content growth stays measurable.
- Add widget or integration tests for the Daily Knowledge Challenge Hub and Games Island loading/error states.
- Evaluate whether large seeded catalogs should move to lazy decoded JSON imports once the new content-expansion pipeline is ready.
- Add privacy-first analytics consent wiring before any non-essential analytics leaves local storage.
- Run a full Qur'an and Hadith source-integrity pass over newly added game-linked content before public launch.
- Review remaining direct Ocean / XP award call sites and finish migration to canonical ledgers where safe.
- Add release-mode startup timing measurements for app bootstrap, router ready, and first interactive frame on mid-range devices.
