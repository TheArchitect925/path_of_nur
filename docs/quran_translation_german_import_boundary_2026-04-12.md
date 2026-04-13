# German Qur'an Translation Import Boundary

Date: 2026-04-12

## Completed in this pass

- Added an import-bundle contract for non-bundled Qur'an translations.
- Wired the main Qur'an repository so it can resolve ayah translations from:
  - existing bundled package translations
  - future imported trusted translation bundles
- Added a German import placeholder bundle and a matching JSON import template for the selected German candidate.
- Chose strict failure behavior for imported translations:
  - no silent fallback to another translation
  - no partial missing-verse substitution

## Why the strict behavior matters

- Qur'an translation text should never quietly fall back to a different edition or language without review.
- If a trusted imported translation is incomplete, the app should fail during development or QA rather than expose mixed or misleading text.

## Next steps

1. Fill the German import bundle from the exact reviewed Quran Foundation resource.
2. Add a small import script that converts the reviewed German source export into the repo bundle shape.
3. Enable the German translation in the reader settings only after German QA confirms verse accuracy and search behavior.
