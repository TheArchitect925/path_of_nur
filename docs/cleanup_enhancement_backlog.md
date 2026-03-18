# Cleanup enhancement backlog

Conservative follow-up items after the dead-code cleanup pass:

1. Replace remaining user-visible placeholder copy such as:
   - `profileVersionPlaceholder`
   - `journeyUnlockFuture`
   - `quranTranslationPickthallPlaceholder`
   after confirming product wording.

2. Productize or delete the remaining `learnLegacy` placeholder catalog entries once the replacement learning surfaces are ready.

3. Revisit `growth_extension_points.dart` after future platform/pack work:
   - the adapters are in use today,
   - but some no-op implementations may eventually deserve real feature modules or removal.

4. Add a small asset-audit script if asset churn increases, so orphan image/audio files can be detected more systematically.
