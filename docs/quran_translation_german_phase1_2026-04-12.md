# German Qur'an Translation Phase 1

Date: 2026-04-12

## Completed in this pass

- Added a source-aware Qur'an translation registry so translation choices are no longer modeled only as a flat local code list.
- Preserved the currently enabled bundled translations as the active user-facing allowlist.
- Reserved a non-user-facing German candidate lane for a future reviewed Quran Foundation translation resource.
- Locked the first German candidate translator choice to `Frank Bubenheim and Nadeem Elyas`, pending exact Quran Foundation resource identification.

## Why German is not user-enabled yet

- Quran Foundation content APIs require approved resource selection and access setup.
- The app should not expose a German Qur'an translation until:
  - the exact German translation resource is chosen from a trusted source
  - the translator or edition is reviewed
  - access or import workflow is ready
  - German QA is completed

## German candidate chosen for Phase 2

- Translator: `Frank Bubenheim and Nadeem Elyas`
- Status: chosen as the first German candidate to ingest and QA
- Remaining blocker: exact Quran Foundation translation resource metadata and access path still need to be confirmed before runtime enablement

## Recommended next steps

1. Identify the exact German Quran Foundation translation resource and translator metadata.
2. Add a German-only ingestion/import boundary for one reviewed resource.
3. Compare imported German text against current reader rendering, search, daily verse, and quote surfaces before enabling it in settings.
