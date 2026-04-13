# German Qur'an Translation Rollout Progress

Date: 2026-04-12

## Completed in this pass

### Source lock and import contract
- Preserved the source-aware translation registry for the German lane.
- Kept the selected translator metadata as `Frank Bubenheim and Nadeem Elyas`.
- Preserved the strict product policy for this lane:
  - no auto-translation
  - no mixed-source fallback
  - no silent downgrade to English

### German bundle ingestion hardening
- Added `imported_quran_translation_ingestion.dart` to parse reviewed import documents into the canonical imported translation bundle contract.
- Supported two ingestion shapes:
  - canonical `versesByVerseKey`
  - row-based `verses` imports for pre-normalized review workflows
- Added duplicate verse-key rejection for row-based imports.
- Added `tool/import_quran_translation_bundle.dart` so reviewed source files can be normalized and validated before being committed as bundled app data.
- Added `imported_quran_translation_dart_generator.dart` and a generated data file path so the validated German bundle can be emitted directly as a Dart source file instead of being hand-edited into the repo.
- Moved the app-facing bundle map to `generated_imported_quran_translation_bundles.dart`, which is now the single replaceable target for the reviewed German data drop.

### Repository integration hardening
- Added `imported_quran_translation_validator.dart` for verse-level completeness checks against the full Qur'an verse inventory.
- Taught the translation registry to expose imported translations only when:
  - the resource is enabled, and
  - the imported bundle validates as complete
- Preserved the repository's strict runtime behavior:
  - imported translations must exist
  - missing verses throw
  - empty imported translations are invalid

### Consumer rollout safeguards
- German remains intentionally hidden from reader settings because the current placeholder imported bundle is incomplete.
- This keeps all current Qur'an consumers stable while ensuring the German lane can be enabled cleanly once the vetted source bundle is added.

### QA and regression hardening
- Added tests covering:
  - duplicate verse-key rejection during import parsing
  - missing/empty verse validation failures
  - hidden-until-valid registry behavior for German
  - imported German ayah resolution
  - imported German daily verse resolution
  - imported German search indexing
  - runtime failure on incomplete imported bundles

## Remaining blocker

The only remaining blocker to a true live German rollout is the reviewed German verse text itself.

What is still needed:
- the exact approved German source resource metadata from the trusted provider
- the full vetted German ayah text for all 6,236 verses
- a reviewed import file to run through `tool/import_quran_translation_bundle.dart`

## Ready handoff path

Once the reviewed German source file is available, the intended flow is:

1. Prepare the reviewed German JSON in the canonical import shape.
2. Run:
   - `dart run tool/import_quran_translation_bundle.dart <reviewed-input.json> lib/features/learn/quran/data/generated_imported_quran_translation_bundles.dart`
3. Confirm validation passes.
4. Change the German resource runtime status from planned to enabled.
5. Re-run analyze and German QA.

## Release posture

This pass makes the German lane implementation-ready but not yet user-visible.

That is intentional:
- German will not appear in settings early
- no user can enter a partial German state
- once the reviewed German bundle is added and validated, the same path becomes the reusable template for future trusted translation languages
