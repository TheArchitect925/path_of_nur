# Build Stability Enhancement Backlog

Date: 2026-03-22
Topic: localization and compile-safety follow-up after iOS build regression fix

## Recommended next improvements

- Move the new runtime-only English localization helpers into real ARB-backed keys so all supported locales can translate them properly.
- Add a CI gate that runs `flutter analyze` and a simulator build before merges to catch missing `AppLocalizations` accessors earlier.
- Add a small lint/check script that compares `l10n` usage in Dart files against generated localization members and known extension layers.
- Consolidate domain localization helpers into clearer feature barrels so test files and presentation files import them consistently.
- Review the kids Arabic and Qur'an reflection copy for product tone consistency and complete multi-locale translation coverage.
- Add a focused regression test that boots the main navigational hubs and verifies no unresolved localization members remain on the affected routes.

## Notes

- Current fix uses extension-based localization compatibility layers for missing accessors.
- This restored build stability quickly, but those strings are still English-only until they are moved into locale resources.
