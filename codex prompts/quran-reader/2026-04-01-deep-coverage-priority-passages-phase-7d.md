# Phase 7D — Deep Coverage For Priority Ayahs, Long Surahs, And High-Value Study Passages

PRIMARY OBJECTIVE === BUILDING DEEP EXPLANATION COVERAGE FOR PRIORITY QURAN AYAHS

GOAL
- Expand `deepExplanation` selectively where extra context genuinely helps.
- Prioritize foundational belief ayahs, key worship and guidance passages, long-surah study anchors, and story ayahs with strong reflective value.
- Keep deep explanations richer than standard, but still concise and readable in-app.

IMPLEMENTATION DIRECTION
- Audit current deep coverage first.
- Reuse the existing explanation model, metadata, and validation pipeline.
- Preserve existing strong deep entries.
- Add only high-value, tafsir-grounded deep entries instead of forcing weak full-Qur'an depth.

VALIDATION
- Confirm deep coverage increases for priority ayahs.
- Confirm fallback remains sound.
- Run the explanation audit helper.
- Run analyzer on changed files.
