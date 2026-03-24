# Arabic Audio Manifest Unification Backlog

Date: 2026-03-24
Primary task: Phase 33 shared Arabic audio manifest unification

## Enhancement options

1. Expand the shared Arabic audio foundation beyond letters only if word and phrase coverage become stable enough to justify one canonical manifest without forcing sparse or experimental content into shared ownership.
2. Add widget-level coverage for one Kids letter replay surface and one adult letter-audio surface so future refactors cannot silently bypass the shared letter-audio manifest.
3. Consider a small shared pronunciation metadata layer for heavy/light and throat-letter replay hints only if a real adult or kids teaching surface needs it.
4. Evaluate whether bundled child-safe letter audio should supplement the current Kids TTS path while keeping the new shared manifest as the canonical lookup source.
5. Decide whether adult listen-only packs should later derive more letter/harakah entries from structured shared audio helpers rather than continuing to seed those asset paths locally.

## Notes

- This pass intentionally unified letter-audio ownership first.
- Word, harakah, and phrase audio remain local to adult teaching content for now because that coverage is broader and still feature-specific.
