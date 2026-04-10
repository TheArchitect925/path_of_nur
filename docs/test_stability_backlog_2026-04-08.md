# Test Stability Backlog

- Add a shared non-permission prayer/location override to [test/test_helpers/app_test_harness.dart](/Users/shahabmansoor/Developer/path_of_nur/test/test_helpers/app_test_harness.dart) so controller tests do not need to stub prayer-derived journey activity individually.
- Add a dedicated test helper for tapping off-screen card/list rows through ancestor `InkWell` lookups plus `ensureVisible` to reduce repeated widget-test flakiness.
- Consider splitting long navigation regression tests like [test/app/quran_hub_regrouping_test.dart](/Users/shahabmansoor/Developer/path_of_nur/test/app/quran_hub_regrouping_test.dart) into smaller route-specific cases for faster failure isolation.
- Audit other controller/unit tests for direct plugin touchpoints such as haptics, permissions, or geolocation and add safe test seams before they become flaky.
