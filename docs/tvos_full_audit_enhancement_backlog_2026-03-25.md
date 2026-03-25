# tvOS Audit Enhancement Backlog

Date: 2026-03-25

## Immediate fixes

1. Repair the stale Flutter analyzer failure in `test/features/learn/quran/quran_reader_playback_harness_test.dart` so repo-wide `flutter analyze` returns green.
2. Add Phase 27-style empty-state hardening to `TVDhikrScreen.swift`.
3. Add Phase 27-style empty-state hardening to `TVGamesScreen.swift`.
4. Add explicit empty-state and sparse-data handling to `TVQuranScreen.swift`.

## Release hardening

1. Run real Apple TV device QA for Home, Qur'an, Prayer, Dhikr, Learn, Kids, Arabic, Games, Saved, Profiles, and Settings.
2. Record signed archive and TestFlight upload proof in the shared launch-readiness contract.
3. Add a QA evidence attachment flow to the shared release-governance or launch-readiness layer.
4. Add route-by-route sparse-data QA so native tvOS surfaces are validated without depending on seeded happy paths.

## Medium-term improvements

1. Replace remaining native-seeded route assumptions with stronger shared parity/export signals as the Flutter-to-native bridge matures.
2. Add audit-safe empty-state coverage to Home and Prayer even if current seeds make those routes unlikely to fail today.
3. Add a machine-readable release report that merges focus QA, launch readiness, governance, and performance posture into one artifact.
4. Plan a controlled dependency-upgrade pass after release hardening, starting with low-risk package updates before major library jumps.
