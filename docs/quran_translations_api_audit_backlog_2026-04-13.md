# Quran Translations API Audit Backlog

Last updated: 2026-04-13

## Purpose

Follow-up backlog from the audit of the current Qur'an translations implementation against the desired Quran.com API v4 multi-translation architecture.

## Recommended Enhancement Options

1. Add a dedicated Quran.com translations catalog service that syncs `/resources/translations` into a typed local catalog instead of hardcoding translation options in `quran_translation_registry.dart`.
2. Introduce a translation-preferences model that stores selected translation IDs as a list, plus a primary translation ID for single-column fallback surfaces.
3. Replace the single-string `QuranAyah.translation` contract with a translation collection model keyed by translation ID while keeping a temporary compatibility accessor during migration.
4. Split the current `QuranRepository` into clearer layers:
   - Arabic/base verse source
   - translation source service
   - reader-facing repository/composer
5. Add offline-first persistent caching for translation payloads by `chapter + translationIds` with cache metadata such as source, fetchedAt, and version.
6. Normalize all reader/search/quote-content consumers to request a translation set rather than a single `translationCode`.
7. Add a small compatibility adapter so existing single-translation UI can continue rendering during migration while multi-translation data is introduced underneath.
8. Extend search indexing so translation search can index one or more selected translation IDs without rebuilding a separate search system.
9. Define a clear handling policy for Quran.com verse pagination and partial-cache hydration before live API rollout.
10. Add focused repository and migration tests around verse composition, translation fallback, per-translation cache keys, and reader preference restoration.

## Suggested Order

1. Catalog sync and ID-based preferences
2. Verse/translation model redesign with compatibility adapter
3. Offline cache layer
4. Reader/search integration
5. API rollout and hardening

## Notes

- This backlog is audit-only and does not implement the migration.
- Search/indexing will be affected later because current search is keyed to one selected translation.
- Localization work is not changed in this audit pass because no new user-facing strings were added.
