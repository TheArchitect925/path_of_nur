# Hadith Content Transliteration Audit Backlog

Date: 2026-04-11

## Follow-up options

1. Add a trusted-source transliteration ingestion lane to the Hadith pipeline instead of hand-writing transliteration into runtime data.
2. Define a transliteration QA rubric and acceptance gate before any enrichment lands, including style choice, narrator handling, and punctuation rules.
3. Start enrichment with the highest-traffic user-facing lanes first:
   - Riyad as-Salihin
   - 40 Essential Hadith
   - Beginner Set
4. Normalize duplicate-reference ownership before transliteration rollout so one canonical transliteration can feed all derivative theme/collection entries safely.
5. Audit the orphaned `heart_softening` collection id against seeded collection definitions before future content enrichment so collection-level reporting stays canonical.
