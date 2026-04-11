# Hadith Pipeline Enhancement Backlog

Date: 2026-04-11

## High-signal next enhancements

- Replace bootstrap-derived JSON inputs with independently maintained trusted-source exports so the pipeline no longer depends on the legacy seed Dart file for refreshes.
- Add a pipeline validation manifest for expected collection ids, grade labels, and taxonomy ids so accidental drift fails fast in CI.
- Add per-entry provenance details such as upstream file/source version and last-reviewed timestamp for stronger editorial traceability.
- Add a small relation-enrichment input file so Qur'an, Dua, and Learn links can be curated in the pipeline instead of only layered later in app code.
- Add a diff/report mode that prints newly added, changed, excluded, and removed Hadith entries between pipeline runs.
- Consider moving Hadith themes/collections bootstrap data into structured JSON so the remaining manual seed file can eventually become definitions-only or be retired.

## Do carefully

- Do not broaden the release gate without an explicit trust decision.
- Do not reintroduce runtime reads from raw/manual Hadith seed entries.
- Do not collapse editorial enrichment and trusted-source ingestion into one file; keeping them separate is safer for auditability.
