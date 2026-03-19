# Qur’an Integrity Follow-Up Backlog

## Next Enhancements

1. Migrate `celestial_verse_catalog.dart` to `QuranQuoteRef` plus repository hydration.
2. Migrate `creation_explorer_catalog.dart` to reference-only verse metadata.
3. Review `onboarding_page.dart` Arabic strings and classify each as Qur’an, dua, dhikr, or UI copy.
4. Review `wudu_content.dart` and other lesson seed data for embedded Qur’an text that should become reference-backed.
5. Unify `quran_reader_page.dart` audio loading behind `QuranContentRepository.resolveAudioSource(QuranAudioRef)` for stricter ownership consistency.
6. Audit tvOS seed content in `ios/PathOfNurTV/Data/TVSeedRepository.swift` and move it onto validated references or repository-backed content.
7. Add a broader repo scan CI guard once the remaining manual-review areas are migrated, so confirmed Qur’an presentation files cannot regress.
