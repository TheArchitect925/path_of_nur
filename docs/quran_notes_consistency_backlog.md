# Qur'an Notes Consistency Backlog

Date: 2026-03-22

## Audit Summary

Current note-taking behavior is fragmented across the app:

- Qur'an ayah notes use `quranNotesProvider` from the reader and preserve `surahNumber` / `ayahNumber`.
- Qur'an reflections use `quranReflectionsProvider` and a separate private-note model.
- Journal creation uses its own journal-entry flow.
- Divine Life Lessons, Spiritual Growth, Prayer, Salah, and other reflection surfaces store notes separately.

This phase only standardized the Qur'an-origin note path safely. Broader cross-app note unification is still deferred.

## Safe Improvements Shipped In This Pass

- New ayah notes now default to the `Quran` folder/category.
- New ayah notes are prefilled with useful tags:
  - `Quran`
  - `Surah Name`
  - `surah:ayah`
- Surah and ayah source context remains preserved in the existing note model.
- Duplicate tags are normalized away on save.

## Next Enhancement Options

- Add a shared note-entry helper/widget for title, body, category, tags, and source preview.
- Standardize note metadata across Qur'an notes, reflections, journal prompts, and worship reflections.
- Introduce a shared source-metadata contract for note origin:
  - feature area
  - route/page
  - structured reference
- Add cross-feature note filtering by:
  - category
  - tags
  - source type
- Add lightweight migration rules only after the target shared note model is approved.

## Recommended Order

1. Define the canonical shared note metadata shape.
2. Extract a reusable add-note composer UI.
3. Migrate new note entry points feature-by-feature.
4. Add cross-feature filtering/search on top of the unified metadata.
