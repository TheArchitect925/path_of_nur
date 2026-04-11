# Qur'an Reader Performance Backlog

Date: 2026-04-11
Scope: Post-lazy-rendering performance hardening options for the canonical Qur'an reader

## Highest-Value Next Options

1. Optimize text and highlight span construction
- Cache or narrow recomputation of Arabic, translation, and transliteration highlight spans.
- Profile `quran_text_span.dart` and search-highlight helpers on long surahs with active search/highlight state.
- This is the strongest next candidate after lazy rendering because visible ayah cards still do a lot of span work.

2. Simplify ayah card paint cost without changing design direction
- Audit nested glass, shadow, border, and animated container usage inside the ayah card.
- Add targeted `RepaintBoundary` only after measuring real paint hotspots.
- Keep the current sacred-reading presentation intact.

3. Harden follow-mode scroll coordination
- Review repeated `ensureVisible`, retry loops, and coarse-scroll fallback behavior during playback.
- Focus on hitching under live recitation and "return to current ayah" scenarios.
- Keep this as a follow-up after measuring the lazy-list improvement, since it was not the first bottleneck.

## Medium Follow-Ups

4. Narrow more page-scope reads in `QuranReaderPage`
- Continue moving non-critical watches behind `select` or smaller leaf widgets.
- Especially review broader study-mode enrichment and recommendation surfaces.

5. Virtualization-friendly scroll targeting review
- Confirm long-surah targeting remains smooth for route focus, memorization review, and playback return behavior.
- If needed, add a more direct index-to-offset assist without changing user behavior.

6. Targeted profiler pass on real devices
- Capture frame timings for a long surah with:
  - playback off
  - playback on with follow mode
  - active search highlighting
- Use the result to rank text-span vs paint vs scroll-coordination work.

## Safe-To-Defer

7. Broader visual refactors
- Not needed for this performance pass.

8. Shared glass-system redesign
- Too wide in scope for the Qur'an-reader-only hardening task.

9. Follow-mode architecture rewrite
- Too risky until the current lazy rendering change has been validated in QA.
