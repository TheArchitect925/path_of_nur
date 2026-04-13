# German Qur'an Translation Rollout Enhancement Backlog

Date: 2026-04-12

## Highest-value next options

1. Add the reviewed German source bundle
- Best next move once the vetted source export is available.
- Run it through `tool/import_quran_translation_bundle.dart` targeting `generated_imported_quran_translation_bundles.dart`.
- Commit the generated bundled file and enable the German resource.

2. Lock the exact source resource metadata
- Record the final provider resource ID or canonical source reference for the chosen German edition.
- This closes the audit loop and makes future re-imports safer.

3. Add a generated Dart bundle step
- Convert the validated German JSON bundle into a generated Dart constant map for faster startup and smaller runtime parsing surface.
- Useful if future imported translation languages grow.

4. Add release QA fixtures for known German verses
- Create a small reviewer checklist around a trusted set of spot-check verses.
- Good for preventing accidental source drift in future refreshes.

5. Add a reusable import report artifact
- Emit a machine-readable validation report after bundle import.
- Helpful once multiple trusted translation languages are managed in parallel.

## Recommendation

The strongest next step is `Option 1`: add the reviewed German source bundle and run the validator/import tool.

That will unlock the real enablement step while keeping the source-governance model intact.
